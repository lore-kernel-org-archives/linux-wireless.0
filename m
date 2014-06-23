Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54259 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbaFWSqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 14:46:54 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so5971206pdj.22
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 11:46:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XzDYA-YG4Q=cSWeLpMNbaGV5Gy3F85Q-zduubCn57kWw@mail.gmail.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-5-git-send-email-arik@wizery.com> <CAB=NE6XzDYA-YG4Q=cSWeLpMNbaGV5Gy3F85Q-zduubCn57kWw@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 23 Jun 2014 21:46:39 +0300
Message-ID: <CA+XVXfdu7gds1T3p=VFZeDoJKwEHDvnJfo8zmA=QgaBQ8Y=10A@mail.gmail.com> (sfid-20140623_204658_502736_C505D4BC)
Subject: Re: [PATCH 5/5] cfg80211: leave invalid channels on regdomain change
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2014 at 3:13 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> When the regulatory settings change, some channels might become invalid.
>> Disconnect interfaces acting on these channels, after giving userspace
>> code a grace period to leave them.
>>
>> Because of cfg80211 channel tracking limitations, only disconnect
>> STA/P2P_CL interfaces if their current center channel became disabled.
>>
>> Change-Id: I308cc02c06a11cfc30b206efaeabe64d67186228
>> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
>> Reviewed-on: https://gerrit.rds.intel.com/32422
>> Tested-by: IWL Jenkins
>> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
>
> I welcome this change, and thanks for the work! But I think we need to
> think about the cases where this really would be required. This should
> not be an issue drivers using the public wireless-regd completely
> given that the default world regulatory domain is a mathematical
> intersection, and as such its restrictive by nature and only
> world-allowed channels with the the minimum max EIRP would be allowed.
> For drivers using an initial custom world regdomain with custom apply
> API a change in regulatory would be permissive and as such we can lift
> some restrictions when we associate to an AP with a country IE
> specified. For the dynamic firmware juju that Intel wants to introduce
> this race is intrinsically unavoidable although the likelihood of it
> remains unclear.

It can happen if we're a connected AP/STA and are crossing some state
borders. Though I agree it's a corner case, they consider it mandatory
to certification.

>
> It should then be possible for some drivers to not have to use this
> sanity check. For example drivers that use ath properly (ath5k, ath9k,
> ath10k) could likely skip this stuff, unless I'm missing something.
> For drivers without regulatory data, that should also be the case as
> the public regdb would be used.

I think this should be useful for all drivers, no matter which
regulatory framework they use. If they defined the flags/settings
correctly, then everything should always be ok in the checks right?

But I agree it can expose bugs in a pretty nasty way (disconnections),
so maybe I'll add a new regulatory flag to enable this behavior?

Btw, we're also planning on adding tracking channel bandwidth, which
can also be disallowed in some circumstances. But that will probably
be handled within mac80211, since cfg80211 doesn't really know track
this info.

> It'd be interesting to see if that'
> not the case though so an informative print for now would be useful
> for the case where bailing out does happen, in fact perhaps it makes
> sense to issue a multicast nl80211 event for this so that userspace
> knows something has happened and why. Since we already have a reg
> change multicast event this seems then to provide a "safe" proactive
> measure for the loose cases, as perhaps an API can be added to let
> userspace acknowledge a regulatory change event -- that way upon
> receipt we should be able to cancel this work. Thoughts?v

The 60 second grace period is not accidental, it's enough time for
userspace to "move" the offending interfaces. In fact that's what the
Intel wpa_s does in the GO scenario - move it.
Upon a regulatory change it re-queries channels, and if the channel if
forbidden, ...

Therefore I don't really think there's a need for a more complicated
"ack" policy. We can always add it if the need arises?

>
>> ---
>>  net/wireless/reg.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 83 insertions(+), 1 deletion(-)

>> +
>> +               /* TODO: more elaborate tracking for wide channels */
>> +               ch = wdev->current_bss->pub.channel;
>> +               ret = !(ch->flags & IEEE80211_CHAN_DISABLED);
>
> That does not seem enough, the max EIRP could have changed too for
> example -- but the reg_notifier() should be used for ensuring changes
> to power requirements are respected, at least the Atheros shared ath
> module does this, that after all is one of the reasons for the
> reg_notifier(). Documenting as part of this change would be
> appreciated.

Not sure what kind of documentation you mean (that only channels are
tracked?), and where to put it.

>
>> +               break;
>> +       default:
>> +               /* others not implemented for now */
>> +               break;
>> +       }
>> +
>> +out:
>> +       wdev_unlock(wdev);
>> +       return ret;
>> +}
>> +
>> +static void reg_leave_invalid_chans(struct wiphy *wiphy)
>> +{
>> +       struct wireless_dev *wdev;
>> +       struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
>> +
>> +       ASSERT_RTNL();
>> +
>> +       list_for_each_entry(wdev, &rdev->wdev_list, list)
>> +               if (!reg_wdev_chan_valid(wiphy, wdev))
>> +                       cfg80211_leave(rdev, wdev);
>
> An informative print or multicast event and reason would be nice here.

I'll add a print.

Arik
