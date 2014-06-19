Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:55502 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaFSAOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 20:14:01 -0400
Received: by mail-la0-f46.google.com with SMTP id el20so945760lab.5
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2014 17:13:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402469724-22358-5-git-send-email-arik@wizery.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com> <1402469724-22358-5-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 18 Jun 2014 17:13:38 -0700
Message-ID: <CAB=NE6XzDYA-YG4Q=cSWeLpMNbaGV5Gy3F85Q-zduubCn57kWw@mail.gmail.com> (sfid-20140619_021412_801435_6C737B43)
Subject: Re: [PATCH 5/5] cfg80211: leave invalid channels on regdomain change
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
> When the regulatory settings change, some channels might become invalid.
> Disconnect interfaces acting on these channels, after giving userspace
> code a grace period to leave them.
>
> Because of cfg80211 channel tracking limitations, only disconnect
> STA/P2P_CL interfaces if their current center channel became disabled.
>
> Change-Id: I308cc02c06a11cfc30b206efaeabe64d67186228
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Reviewed-on: https://gerrit.rds.intel.com/32422
> Tested-by: IWL Jenkins
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>

I welcome this change, and thanks for the work! But I think we need to
think about the cases where this really would be required. This should
not be an issue drivers using the public wireless-regd completely
given that the default world regulatory domain is a mathematical
intersection, and as such its restrictive by nature and only
world-allowed channels with the the minimum max EIRP would be allowed.
For drivers using an initial custom world regdomain with custom apply
API a change in regulatory would be permissive and as such we can lift
some restrictions when we associate to an AP with a country IE
specified. For the dynamic firmware juju that Intel wants to introduce
this race is intrinsically unavoidable although the likelihood of it
remains unclear.

It should then be possible for some drivers to not have to use this
sanity check. For example drivers that use ath properly (ath5k, ath9k,
ath10k) could likely skip this stuff, unless I'm missing something.
For drivers without regulatory data, that should also be the case as
the public regdb would be used. It'd be interesting to see if that'
not the case though so an informative print for now would be useful
for the case where bailing out does happen, in fact perhaps it makes
sense to issue a multicast nl80211 event for this so that userspace
knows something has happened and why. Since we already have a reg
change multicast event this seems then to provide a "safe" proactive
measure for the loose cases, as perhaps an API can be added to let
userspace acknowledge a regulatory change event -- that way upon
receipt we should be able to cancel this work. Thoughts?v

> ---
>  net/wireless/reg.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 83 insertions(+), 1 deletion(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index d6b83f9..1d6afe6 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -221,6 +221,9 @@ struct reg_beacon {
>         struct ieee80211_channel chan;
>  };
>
> +static void reg_check_chans_work(struct work_struct *work);
> +static DECLARE_DELAYED_WORK(reg_check_chans, reg_check_chans_work);
> +
>  static void reg_todo(struct work_struct *work);
>  static DECLARE_WORK(reg_work, reg_todo);
>
> @@ -1520,6 +1523,80 @@ static void reg_call_notifier(struct wiphy *wiphy,
>                 wiphy->reg_notifier(wiphy, request);
>  }
>
> +static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
> +{
> +       struct ieee80211_channel *ch;
> +       bool ret = true;
> +
> +       wdev_lock(wdev);
> +
> +       if (!wdev->netdev || !netif_running(wdev->netdev))
> +               goto out;
> +
> +       switch (wdev->iftype) {
> +       case NL80211_IFTYPE_AP:
> +       case NL80211_IFTYPE_P2P_GO:
> +               if (!wdev->beacon_interval)
> +                       goto out;
> +
> +               ret = cfg80211_reg_can_beacon(wiphy,
> +                                             &wdev->chandef, wdev->iftype);
> +               break;
> +       case NL80211_IFTYPE_STATION:
> +       case NL80211_IFTYPE_P2P_CLIENT:
> +               if (!wdev->current_bss ||
> +                   !wdev->current_bss->pub.channel)
> +                       goto out;
> +
> +               /* TODO: more elaborate tracking for wide channels */
> +               ch = wdev->current_bss->pub.channel;
> +               ret = !(ch->flags & IEEE80211_CHAN_DISABLED);

That does not seem enough, the max EIRP could have changed too for
example -- but the reg_notifier() should be used for ensuring changes
to power requirements are respected, at least the Atheros shared ath
module does this, that after all is one of the reasons for the
reg_notifier(). Documenting as part of this change would be
appreciated.

> +               break;
> +       default:
> +               /* others not implemented for now */
> +               break;
> +       }
> +
> +out:
> +       wdev_unlock(wdev);
> +       return ret;
> +}
> +
> +static void reg_leave_invalid_chans(struct wiphy *wiphy)
> +{
> +       struct wireless_dev *wdev;
> +       struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
> +
> +       ASSERT_RTNL();
> +
> +       list_for_each_entry(wdev, &rdev->wdev_list, list)
> +               if (!reg_wdev_chan_valid(wiphy, wdev))
> +                       cfg80211_leave(rdev, wdev);

An informative print or multicast event and reason would be nice here.

  Luis
