Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:38198 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3GHWFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 18:05:18 -0400
Received: by mail-lb0-f177.google.com with SMTP id 10so4102498lbf.22
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jul 2013 15:05:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1372768095-26053-4-git-send-email-ilan.peer@intel.com>
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com> <1372768095-26053-4-git-send-email-ilan.peer@intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 8 Jul 2013 15:04:56 -0700
Message-ID: <CAB=NE6VQXQPRK9_Q-Nh+ripRa+PdCd=4_EZvPxeghBjc32ejyQ@mail.gmail.com> (sfid-20130709_000521_547062_6B7D8520)
Subject: Re: [PATCH 3/3] [RFC] cfg80211: Enable GO operation on additional channels
To: Ilan Peer <ilan.peer@intel.com>
Cc: David Spinadel <david.spinadel@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 2, 2013 at 5:28 AM, Ilan Peer <ilan.peer@intel.com> wrote:
> From: David Spinadel <david.spinadel@intel.com>
>
> Allow GO operation on a channel marked with
> IEEE80211_CHAN_INDOOR_ONLY or IEEE80211_CHAN_GO_CONCURRENT
> iff there is an active station interface that is associated to
> an AP operating on this channel.
>
> Note that this is a permissive approach to the FCC definitions,
> that require a clear assessment that either the platform device
> is an indoor device, or the device operating the AP is an indoor
> device, i.e., AC powered.
> It is assumed that these restrictions are enforced by user space.
> Furthermore, it is assumed, that if the conditions that allowed for
> the operation of the GO on such a channel change, it is the
> responsibility of user space to evacuate the GO from the channel.

In the context of strict regulatory data we currently do not
differentiate specifically between a device that can initiate
radiation between AP and Group Owner (GO) but in your earlier patches
you proposed a way to do that. I reviewed feedback on that patch
there. It may make sense however to define clearly what you mean by
why the flag is being introduced by documenting the use case, ie what
you describe here. Other regulatory bodies may follow and it helps to
provide context here.

My review below.

> Signed-off-by: David Spinadel <david.spinadel@intel.com>
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> ---
>  include/net/cfg80211.h |    4 +-
>  net/mac80211/ibss.c    |    2 +-
>  net/wireless/Kconfig   |   10 +++++
>  net/wireless/chan.c    |   98 ++++++++++++++++++++++++++++++++++++++++++++----
>  net/wireless/mesh.c    |    2 +-
>  net/wireless/nl80211.c |    8 ++--
>  net/wireless/trace.h   |   11 ++++--
>  7 files changed, 118 insertions(+), 17 deletions(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index f0badeb..17d693d 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -4070,12 +4070,14 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
>   * cfg80211_reg_can_beacon - check if beaconing is allowed
>   * @wiphy: the wiphy
>   * @chandef: the channel definition
> + * @p2p_go: if the interface type is a P2P GO
>   *
>   * Return: %true if there is no secondary channel or the secondary channel(s)
>   * can be used for beaconing (i.e. is not a radar channel etc.)
>   */
>  bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
> -                            struct cfg80211_chan_def *chandef);
> +                            struct cfg80211_chan_def *chandef,
> +                            bool p2p_go);
>
>  /*
>   * cfg80211_ch_switch_notify - update wdev channel and notify userspace
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index ea7b9c2..1e0fac1 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -82,7 +82,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>         sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
>
>         chandef = ifibss->chandef;
> -       if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
> +       if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef, false)) {
>                 chandef.width = NL80211_CHAN_WIDTH_20;
>                 chandef.center_freq1 = chan->center_freq;
>         }
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index de76078..d9e2be7 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -102,6 +102,16 @@ config CFG80211_REG_CELLULAR_HINTS
>           This option adds support for drivers that can receive regulatory
>           hints from cellular base stations
>
> +config CFG80211_REG_SOFT_CONFIGURATIONS
> +       bool "cfg80211 support for GO operation on additional channels"
> +       depends on CFG80211 && CFG80211_CERTIFICATION_ONUS
> +       ---help---
> +         This option enables the operation of a P2P Group Owner on
> +         additional channels, if there is a clear assessment that
> +         the platform device operates in an indoor environment or
> +         in case that there is an additional BSS interface which is
> +         connected to an AP which is an indoor device.
> +

I like this approach, indeed this is great work and reflects usage of
the onus kconfig option appropriately in this case due dilligence
required more in part on userspace / other components for full
regulatory compliance.

>  config CFG80211_DEFAULT_PS
>         bool "enable powersave by default"
>         depends on CFG80211
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 50f6195..92d9e3c 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -457,18 +457,102 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
>  }
>  EXPORT_SYMBOL(cfg80211_chandef_usable);
>
> +#ifdef CPTCFG_CFG80211_REG_SOFT_CONFIGURATIONS
> +static int cfg80211_get_unii_band(int freq)
> +{
> +       /* UNII-1 */
> +       if (freq >= 5150 && freq <= 5250)
> +               return 0;
> +
> +       /* UNII-2 */
> +       if (freq > 5250 && freq <= 5350)
> +               return 1;
> +
> +       /* UNII-2E */
> +       if (freq >= 5470 && freq <= 5725)
> +               return 2;
> +
> +       /* UNII-3 */
> +       if (freq > 5725 && freq <= 5825)
> +               return 3;
> +
> +       WARN_ON(1);
> +       return -EINVAL;
> +}
> +#endif

#else?

Are you aware of UNII-1, UNII-2, UNII-2E, UNII-3 are specific world
regulatory language bands? When I last tried to look for a clear
definition I could not find a clear definition of them and its why on
the ath module on for QCA modules I state "we call these" in reference
to the UNII nomenclature. If we can get a clear resource for its
definition that would help here.

> +
> +/* For GO only, check if the channel can be used under permissive conditions
> + * mandated by the FCC, i.e., the channel is marked as:

Ah -- note - FCC, you are making an FCC specific rule global, that
doesn't seems right. The implementation should reflect that *some*
regulatory bodies are implicating software requirements for GO
operation and in that case this tries to implement such known current
interpretations.

Hope is that regulatory bodies will stick to this singular
interpretation / preference when required.

So my point: your code treats this appropriately as agnostic to the
regulatory body but your comments do not, just modify the comments
more to make it more agnostic.

> + * 1. Indoor only: a GO can be operational on such a channel, iff there is
> + *    clear assessment that the platform device is indoor.
> + * 2. Concurrent GO: a GO can be operational on such a channel, iff there is an
> + *    additional station interface connected to an AP on this channel.
> + *
> + * TODO: The function is too permissive, as it does not verify the platform
> + * device type is indeed indoor, or that the AP is indoor/AC powered.

So to do this properly we need an eventual userspace API to throw to
kernelspace if we are AC powered? We'll need this to enhance this
routine here?

> + */
> +static bool cfg80211_can_go_use_chan(struct cfg80211_registered_device *rdev,
> +                                    struct ieee80211_channel *chan)
> +{
> +#ifdef CPTCFG_CFG80211_REG_SOFT_CONFIGURATIONS
> +       struct wireless_dev *wdev_iter;
> +
> +       ASSERT_RTNL();
> +
> +       if (!(chan->flags & (IEEE80211_CHAN_INDOOR_ONLY |
> +                            IEEE80211_CHAN_GO_CONCURRENT)))
> +               return false;
> +
> +       if (chan->band == IEEE80211_BAND_60GHZ)
> +               return false;
> +
> +       list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
> +               struct ieee80211_channel *other_chan = NULL;
> +
> +               if (wdev_iter->iftype != NL80211_IFTYPE_STATION ||
> +                   (!netif_running(wdev_iter->netdev)))
> +                               continue;
> +
> +
> +               wdev_lock(wdev_iter);
> +               if (wdev_iter->current_bss)
> +                       other_chan = wdev_iter->current_bss->pub.channel;
> +               wdev_unlock(wdev_iter);
> +
> +               if (!other_chan)
> +                       continue;
> +
> +               if (chan == other_chan)
> +                       return true;
> +               else if ((chan->band == IEEE80211_BAND_5GHZ) &&
> +                        (cfg80211_get_unii_band(chan->center_freq) ==
> +                         cfg80211_get_unii_band(other_chan->center_freq)))
> +                       return true;
> +       }
> +#endif
> +       return false;
> +}

Please wrap code as follows:

#ifdef FOO
static int foo(void)
{
  return true;
}
#else
static int foo(void)
  return false;
}
#endif

In the meantime, while you get all your patch sets properly developed
I'd recommend to define the code returning false there strictly or
perhaps for any flag on the channel requiring DFS / no-ibss, or
passive scan. The stricter case, defining false always, seems to be
what you are suggesting here.

Do you have a white list that can exclude some channels for now
globally or somehow as all this lines up?

  Luis
