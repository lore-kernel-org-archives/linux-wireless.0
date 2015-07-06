Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33757 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbbGFLtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 07:49:41 -0400
Received: by wgck11 with SMTP id k11so137944677wgc.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2015 04:49:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1430918911-14715-1-git-send-email-arik@wizery.com>
References: <1430918911-14715-1-git-send-email-arik@wizery.com>
Date: Mon, 6 Jul 2015 13:49:40 +0200
Message-ID: <CALhHN=oq2WK+YHoW7UG2eLuDPEcxusZ8mpUC3DLyVDJyNhkdzg@mail.gmail.com> (sfid-20150706_134946_458337_7C12D845)
Subject: Re: [PATCH v2] cfg80211: change GO_CONCURRENT to IR_CONCURRENT for STA
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 May 2015 at 15:28, Arik Nemtsov <arik@wizery.com> wrote:
> The GO_CONCURRENT regulatory definition can be extended to station
> interfaces requesting to IR as part of TDLS off-channel operations.
> Rename the GO_CONCURRENT flag to IR_CONCURRENT and allow the added
> use-case.
>
> Change internal users of GO_CONCURRENT to use the new definition.
>
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |  2 +-
>  include/net/cfg80211.h                       |  4 +--
>  include/uapi/linux/nl80211.h                 | 28 +++++++++++---------
>  net/wireless/chan.c                          | 38 ++++++++++++++++------------
>  net/wireless/nl80211.c                       |  4 +--
>  net/wireless/reg.c                           |  4 +--
>  6 files changed, 45 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
> index 83903a5..0b5a81d 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
> @@ -248,7 +248,7 @@ static u32 iwl_get_channel_flags(u8 ch_num, int ch_idx, bool is_5ghz,
>          */
>         if ((nvm_flags & NVM_CHANNEL_GO_CONCURRENT) &&
>             (flags & IEEE80211_CHAN_NO_IR))
> -               flags |= IEEE80211_CHAN_GO_CONCURRENT;
> +               flags |= IEEE80211_CHAN_IR_CONCURRENT;
>
>         return flags;
>  }
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index f8d6813..d63ecec 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -111,7 +111,7 @@ enum ieee80211_band {
>   *     This may be due to the driver or due to regulatory bandwidth
>   *     restrictions.
>   * @IEEE80211_CHAN_INDOOR_ONLY: see %NL80211_FREQUENCY_ATTR_INDOOR_ONLY
> - * @IEEE80211_CHAN_GO_CONCURRENT: see %NL80211_FREQUENCY_ATTR_GO_CONCURRENT
> + * @IEEE80211_CHAN_IR_CONCURRENT: see %NL80211_FREQUENCY_ATTR_IR_CONCURRENT
>   * @IEEE80211_CHAN_NO_20MHZ: 20 MHz bandwidth is not permitted
>   *     on this channel.
>   * @IEEE80211_CHAN_NO_10MHZ: 10 MHz bandwidth is not permitted
> @@ -129,7 +129,7 @@ enum ieee80211_channel_flags {
>         IEEE80211_CHAN_NO_80MHZ         = 1<<7,
>         IEEE80211_CHAN_NO_160MHZ        = 1<<8,
>         IEEE80211_CHAN_INDOOR_ONLY      = 1<<9,
> -       IEEE80211_CHAN_GO_CONCURRENT    = 1<<10,
> +       IEEE80211_CHAN_IR_CONCURRENT    = 1<<10,
>         IEEE80211_CHAN_NO_20MHZ         = 1<<11,
>         IEEE80211_CHAN_NO_10MHZ         = 1<<12,
>  };
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 241220c..c0ab6b0 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2620,16 +2620,17 @@ enum nl80211_band_attr {
>   *     an indoor surroundings, i.e., it is connected to AC power (and not
>   *     through portable DC inverters) or is under the control of a master
>   *     that is acting as an AP and is connected to AC power.
> - * @NL80211_FREQUENCY_ATTR_GO_CONCURRENT: GO operation is allowed on this
> + * @NL80211_FREQUENCY_ATTR_IR_CONCURRENT: IR operation is allowed on this
>   *     channel if it's connected concurrently to a BSS on the same channel on
>   *     the 2 GHz band or to a channel in the same UNII band (on the 5 GHz
> - *     band), and IEEE80211_CHAN_RADAR is not set. Instantiating a GO on a
> - *     channel that has the GO_CONCURRENT attribute set can be done when there
> - *     is a clear assessment that the device is operating under the guidance of
> - *     an authorized master, i.e., setting up a GO while the device is also
> - *     connected to an AP with DFS and radar detection on the UNII band (it is
> - *     up to user-space, i.e., wpa_supplicant to perform the required
> - *     verifications)
> + *     band), and IEEE80211_CHAN_RADAR is not set. Instantiating a GO or TDLS
> + *     off-channel on a channel that has the IR_CONCURRENT attribute set can be
> + *     done when there is a clear assessment that the device is operating under
> + *     the guidance of an authorized master, i.e., setting up a GO or TDLS
> + *     off-channel while the device is also connected to an AP with DFS and
> + *     radar detection on the UNII band (it is up to user-space, i.e.,
> + *     wpa_supplicant to perform the required verifications). Using this
> + *     attribute for IR is disallowed for master interfaces (IBSS, AP).
>   * @NL80211_FREQUENCY_ATTR_NO_20MHZ: 20 MHz operation is not allowed
>   *     on this channel in current regulatory domain.
>   * @NL80211_FREQUENCY_ATTR_NO_10MHZ: 10 MHz operation is not allowed
> @@ -2641,7 +2642,7 @@ enum nl80211_band_attr {
>   * See https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn=528122
>   * for more information on the FCC description of the relaxations allowed
>   * by NL80211_FREQUENCY_ATTR_INDOOR_ONLY and
> - * NL80211_FREQUENCY_ATTR_GO_CONCURRENT.
> + * NL80211_FREQUENCY_ATTR_IR_CONCURRENT.
>   */
>  enum nl80211_frequency_attr {
>         __NL80211_FREQUENCY_ATTR_INVALID,
> @@ -2659,7 +2660,7 @@ enum nl80211_frequency_attr {
>         NL80211_FREQUENCY_ATTR_NO_160MHZ,
>         NL80211_FREQUENCY_ATTR_DFS_CAC_TIME,
>         NL80211_FREQUENCY_ATTR_INDOOR_ONLY,
> -       NL80211_FREQUENCY_ATTR_GO_CONCURRENT,
> +       NL80211_FREQUENCY_ATTR_IR_CONCURRENT,
>         NL80211_FREQUENCY_ATTR_NO_20MHZ,
>         NL80211_FREQUENCY_ATTR_NO_10MHZ,
>
> @@ -2672,6 +2673,8 @@ enum nl80211_frequency_attr {
>  #define NL80211_FREQUENCY_ATTR_PASSIVE_SCAN    NL80211_FREQUENCY_ATTR_NO_IR
>  #define NL80211_FREQUENCY_ATTR_NO_IBSS         NL80211_FREQUENCY_ATTR_NO_IR
>  #define NL80211_FREQUENCY_ATTR_NO_IR           NL80211_FREQUENCY_ATTR_NO_IR
> +#define NL80211_FREQUENCY_ATTR_GO_CONCURRENT \
> +                                       NL80211_FREQUENCY_ATTR_IR_CONCURRENT
>
>  /**
>   * enum nl80211_bitrate_attr - bitrate attributes
> @@ -2830,7 +2833,7 @@ enum nl80211_sched_scan_match_attr {
>   * @NL80211_RRF_AUTO_BW: maximum available bandwidth should be calculated
>   *     base on contiguous rules and wider channels will be allowed to cross
>   *     multiple contiguous/overlapping frequency ranges.
> - * @NL80211_RRF_GO_CONCURRENT: See &NL80211_FREQUENCY_ATTR_GO_CONCURRENT
> + * @NL80211_RRF_IR_CONCURRENT: See &NL80211_FREQUENCY_ATTR_IR_CONCURRENT
>   * @NL80211_RRF_NO_HT40MINUS: channels can't be used in HT40- operation
>   * @NL80211_RRF_NO_HT40PLUS: channels can't be used in HT40+ operation
>   * @NL80211_RRF_NO_80MHZ: 80MHz operation not allowed
> @@ -2847,7 +2850,7 @@ enum nl80211_reg_rule_flags {
>         NL80211_RRF_NO_IR               = 1<<7,
>         __NL80211_RRF_NO_IBSS           = 1<<8,
>         NL80211_RRF_AUTO_BW             = 1<<11,
> -       NL80211_RRF_GO_CONCURRENT       = 1<<12,
> +       NL80211_RRF_IR_CONCURRENT       = 1<<12,
>         NL80211_RRF_NO_HT40MINUS        = 1<<13,
>         NL80211_RRF_NO_HT40PLUS         = 1<<14,
>         NL80211_RRF_NO_80MHZ            = 1<<15,
> @@ -2859,6 +2862,7 @@ enum nl80211_reg_rule_flags {
>  #define NL80211_RRF_NO_IR              NL80211_RRF_NO_IR
>  #define NL80211_RRF_NO_HT40            (NL80211_RRF_NO_HT40MINUS |\
>                                          NL80211_RRF_NO_HT40PLUS)
> +#define NL80211_RRF_GO_CONCURRENT      NL80211_RRF_IR_CONCURRENT
>
>  /* For backport compatibility with older userspace */
>  #define NL80211_RRF_NO_IR_ALL          (NL80211_RRF_NO_IR | __NL80211_RRF_NO_IBSS)
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 5bcffdb..915b328 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -698,19 +698,20 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
>  EXPORT_SYMBOL(cfg80211_chandef_usable);
>
>  /*
> - * For GO only, check if the channel can be used under permissive conditions
> - * mandated by the some regulatory bodies, i.e., the channel is marked with
> - * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station interface
> + * Check if the channel can be used under permissive conditions mandated by
> + * some regulatory bodies, i.e., the channel is marked with
> + * IEEE80211_CHAN_IR_CONCURRENT and there is an additional station interface
>   * associated to an AP on the same channel or on the same UNII band
>   * (assuming that the AP is an authorized master).
> - * In addition allow the GO to operate on a channel on which indoor operation is
> + * In addition allow operation on a channel on which indoor operation is
>   * allowed, iff we are currently operating in an indoor environment.
>   */
> -static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
> +static bool cfg80211_ir_permissive_chan(struct wiphy *wiphy,
> +                                       enum nl80211_iftype iftype,
>                                         struct ieee80211_channel *chan)
>  {
>         struct wireless_dev *wdev;
> -       struct wiphy *wiphy = wiphy_idx_to_wiphy(rdev->wiphy_idx);
> +       struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
>
>         ASSERT_RTNL();
>
Seems after this patch we hit ASSERT_RTNL() when setup ibss (seems
same for MONITOR)
Simplest solution is move this assert after  if (iftype !=
NL80211_IFTYPE_P2P_GO && ...) check, but I am not sure this is the
best solution :)
Anyway cfg80211_reg_can_beacon() need clear description about RTNL
locking while drivers could call this ...

Assert we hit:
[ 5189.411964] wlan11: Trigger new scan to find an IBSS to join
[ 5191.401219] wlan11: Creating new IBSS network, BSSID be:6f:19:45:ea:14
[ 5191.401247] RTNL: assertion failed at net/wireless/chan.c (716)
[ 5191.401254] CPU: 3 PID: 3110 Comm: kworker/u16:2 Tainted: G
  O    4.1.0-rc7-wl-ath+
[ 5191.401258] Hardware name: LENOVO 23443SG/23443SG, BIOS G1ET91WW
(2.51 ) 01/09/2013
[ 5191.401295] Workqueue: phy1 ieee80211_iface_work [mac80211]
[ 5191.401300]  00000000 00000000 f3bcbd54 c16df17d ee90c5c0 f3bcbd7c
f8a39d55 f8a629d4
[ 5191.401313]  f8a64434 000002cc 00000001 ef1d8240 ee90c5c0 ee09f800
ef1d8560 f3bcbde0
[ 5191.401324]  f8ab28fb 00000246 00000002 ee015df0 c199d150 f3bcbda8
c109731c ee015df0
[ 5191.401336] Call Trace:
[ 5191.401346]  [<c16df17d>] dump_stack+0x48/0x60
[ 5191.401384]  [<f8a39d55>] cfg80211_reg_can_beacon+0x455/0x490 [cfg80211]
[ 5191.401412]  [<f8ab28fb>] __ieee80211_sta_join_ibss+0x15b/0x1090 [mac80211]
[ 5191.401419]  [<c109731c>] ? __lock_is_held+0x3c/0x60
[ 5191.401474]  [<f8aff5f6>] ? __sdata_info+0x186/0x1b0 [mac80211]
[ 5191.401507]  [<f8ab3e54>] ieee80211_sta_create_ibss+0xa4/0x120 [mac80211]
[ 5191.401544]  [<f8ab707f>] ieee80211_ibss_work+0x5af/0x630 [mac80211]
[ 5191.401551]  [<c10967ab>] ? trace_hardirqs_on+0xb/0x10
[ 5191.401556]  [<c15bc8a9>] ? skb_dequeue+0x49/0x60
[ 5191.401579]  [<f8ab8b89>] ieee80211_iface_work+0x2c9/0x3e0 [mac80211]
[ 5191.401584]  [<c109731c>] ? __lock_is_held+0x3c/0x60
[ 5191.401591]  [<c1066ec3>] process_one_work+0x1b3/0x6f0
[ 5191.401596]  [<c1066e1a>] ? process_one_work+0x10a/0x6f0
[ 5191.401603]  [<c106751d>] worker_thread+0xed/0x3b0
[ 5191.401607]  [<c10967ab>] ? trace_hardirqs_on+0xb/0x10
[ 5191.401613]  [<c1067430>] ? process_scheduled_works+0x30/0x30
[ 5191.401618]  [<c106ce40>] kthread+0xa0/0xc0
[ 5191.401624]  [<c16e7741>] ret_from_kernel_thread+0x21/0x30
[ 5191.401628]  [<c106cda0>] ? __init_kthread_worker+0x60/0x60
[ 5191.486229] IPv6: ADDRCONF(NETDEV_CHANGE): wlan11: link becomes ready

BR
Janusz

> @@ -718,16 +719,22 @@ static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
>             !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR))
>                 return false;
>
> +       /* only valid for GO and TDLS off-channel (station/p2p-CL) */
> +       if (iftype != NL80211_IFTYPE_P2P_GO &&
> +           iftype != NL80211_IFTYPE_STATION &&
> +           iftype != NL80211_IFTYPE_P2P_CLIENT)
> +               return false;
> +
>         if (regulatory_indoor_allowed() &&
>             (chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
>                 return true;
>
> -       if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
> +       if (!(chan->flags & IEEE80211_CHAN_IR_CONCURRENT))
>                 return false;
>
>         /*
>          * Generally, it is possible to rely on another device/driver to allow
> -        * the GO concurrent relaxation, however, since the device can further
> +        * the IR concurrent relaxation, however, since the device can further
>          * enforce the relaxation (by doing a similar verifications as this),
>          * and thus fail the GO instantiation, consider only the interfaces of
>          * the current registered device.
> @@ -748,7 +755,8 @@ static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
>                  * GO_CONCURRENT is disconnected now. But then we must make sure
>                  * we're not outdoor on an indoor-only channel.
>                  */
> -               if (wdev->iftype == NL80211_IFTYPE_P2P_GO &&
> +               if (iftype == NL80211_IFTYPE_P2P_GO &&
> +                   wdev->iftype == NL80211_IFTYPE_P2P_GO &&
>                     wdev->beacon_interval &&
>                     !(chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
>                         other_chan = wdev->chandef.chan;
> @@ -793,7 +801,6 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
>                              struct cfg80211_chan_def *chandef,
>                              enum nl80211_iftype iftype)
>  {
> -       struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
>         bool res;
>         u32 prohibited_flags = IEEE80211_CHAN_DISABLED |
>                                IEEE80211_CHAN_RADAR;
> @@ -801,13 +808,12 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
>         trace_cfg80211_reg_can_beacon(wiphy, chandef, iftype);
>
>         /*
> -        * Under certain conditions suggested by the some regulatory bodies
> -        * a GO can operate on channels marked with IEEE80211_NO_IR
> -        * so set this flag only if such relaxations are not enabled and
> -        * the conditions are not met.
> +        * Under certain conditions suggested by some regulatory bodies a
> +        * GO/STA can IR on channels marked with IEEE80211_NO_IR. Set this flag
> +        * only if such relaxations are not enabled and the conditions are not
> +        * met.
>          */
> -       if (iftype != NL80211_IFTYPE_P2P_GO ||
> -           !cfg80211_go_permissive_chan(rdev, chandef->chan))
> +       if (!cfg80211_ir_permissive_chan(wiphy, iftype, chandef->chan))
>                 prohibited_flags |= IEEE80211_CHAN_NO_IR;
>
>         if (cfg80211_chandef_dfs_required(wiphy, chandef, iftype) > 0 &&
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 8a33bba..c264eff 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -639,8 +639,8 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
>                 if ((chan->flags & IEEE80211_CHAN_INDOOR_ONLY) &&
>                     nla_put_flag(msg, NL80211_FREQUENCY_ATTR_INDOOR_ONLY))
>                         goto nla_put_failure;
> -               if ((chan->flags & IEEE80211_CHAN_GO_CONCURRENT) &&
> -                   nla_put_flag(msg, NL80211_FREQUENCY_ATTR_GO_CONCURRENT))
> +               if ((chan->flags & IEEE80211_CHAN_IR_CONCURRENT) &&
> +                   nla_put_flag(msg, NL80211_FREQUENCY_ATTR_IR_CONCURRENT))
>                         goto nla_put_failure;
>                 if ((chan->flags & IEEE80211_CHAN_NO_20MHZ) &&
>                     nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_20MHZ))
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 0e347f8..d359e06 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -989,8 +989,8 @@ static u32 map_regdom_flags(u32 rd_flags)
>                 channel_flags |= IEEE80211_CHAN_NO_OFDM;
>         if (rd_flags & NL80211_RRF_NO_OUTDOOR)
>                 channel_flags |= IEEE80211_CHAN_INDOOR_ONLY;
> -       if (rd_flags & NL80211_RRF_GO_CONCURRENT)
> -               channel_flags |= IEEE80211_CHAN_GO_CONCURRENT;
> +       if (rd_flags & NL80211_RRF_IR_CONCURRENT)
> +               channel_flags |= IEEE80211_CHAN_IR_CONCURRENT;
>         if (rd_flags & NL80211_RRF_NO_HT40MINUS)
>                 channel_flags |= IEEE80211_CHAN_NO_HT40MINUS;
>         if (rd_flags & NL80211_RRF_NO_HT40PLUS)
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
