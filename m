Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54076 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959Ab0FCJSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 05:18:32 -0400
Received: by wwb28 with SMTP id 28so3610681wwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jun 2010 02:18:30 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1275544803.2091.30386.camel@rchatre-DESK>
References: <1275395142.14385.6.camel@maxim-laptop>
	<1275404221.2839.2.camel@maxim-laptop>
	<AANLkTinmjlukRABwWWVuO6VRHrULcqB7Zk_HQZSDicKr@mail.gmail.com>
	<1275419000.5225.0.camel@abhi-desktop>
	<AANLkTimRt-8d5RkBtGVyReASZqBFIjSzOHPFV6RVjYlV@mail.gmail.com>
	<1275544803.2091.30386.camel@rchatre-DESK>
Date: Thu, 3 Jun 2010 11:18:30 +0200
Message-ID: <AANLkTinDduWj_BbLINeMmF3hChf4x2znxDLhWDDJzQqY@mail.gmail.com>
Subject: Re: IWL3945 problems in 2.6.35-rc1
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The good news at first:
Your patch applies against 2.6.35-rc1 vanilla (tested with linux-2.6 GIT).

BUT....
This patch should be renamed to "iwl3945-fix-internal-scan-2.6.35-rc1.patch".

It differs from the one in iwiwifi-2.6 (see below).
Thus, I said to myself let's dig deeper into it.

First, here is my GIT workflow (I use linux-2.6 rcX, later pull in
wireless-2.6 and finally iwlwifi-2.6 master GIT)

[CODE]
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

$ git reset --hard v2.6.35-rc1

$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
master:wireless-2.6

$ git pull http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
master:iwlwifi-2.6
[/CODE]

If I do so, I get NON-iwlwifi related stuff pulled in and that should
not be the case?
I am not a git tool expert, there might be some magic tricks I do not know.
Thanks for any hints on git tool :-).

It would be very helpfull (if you want people to follow iwlwifi
development) to have something similiar like in linux-wireless GIT
trees - just a proposal:

iwlwifi-2.6 -> wireless-2.6 -> net-2.6 -> linux-2.6
iwlwifi-next-2.6 -> wireless-next-2.6 -> net-next-2.6 -> linux-next
iwlwifi-testing -> wireless-testing

As I said I am no git expert, so I don't know if you want to setup 3
diverse GIT repsoitories (as John did for wireless-* trees) or have 3
different GIT branches within existing iwlwifi-2.6 GIT repository as
in drm-2.6 [1].
Me thinks your (re)base in development should be the counterpart in
wireless GIT tree (see above).

Just my two coins.

Kind Regards,
- Sedat -

[1] "drm git branches revisited"
http://article.gmane.org/gmane.comp.video.dri.devel/40626

[ GIT PULL iwlwifi-2.6 master ]
...
Merge made by recursive.
 Documentation/feature-removal-schedule.txt      |   20 +
 drivers/net/wireless/ath/ath9k/ar5008_phy.c     |    2 +
 drivers/net/wireless/iwlwifi/Kconfig            |    6 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c         |    2 +
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c |   28 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c         |  198 +-------
 drivers/net/wireless/iwlwifi/iwl-4965.c         |   87 +++-
 drivers/net/wireless/iwlwifi/iwl-5000.c         |   60 ++-
 drivers/net/wireless/iwlwifi/iwl-6000.c         |  345 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c  |   91 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c     |   26 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c      |  255 +++-------
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c       |   72 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c    |  123 +++++
 drivers/net/wireless/iwlwifi/iwl-agn.c          |  635 +++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-agn.h          |   34 ++
 drivers/net/wireless/iwlwifi/iwl-commands.h     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-core.c         |  301 +++++------
 drivers/net/wireless/iwlwifi/iwl-core.h         |   25 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c      |   94 ++---
 drivers/net/wireless/iwlwifi/iwl-dev.h          |   84 ++--
 drivers/net/wireless/iwlwifi/iwl-helpers.h      |   27 +
 drivers/net/wireless/iwlwifi/iwl-rx.c           |   63 ++--
 drivers/net/wireless/iwlwifi/iwl-scan.c         |   40 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c          |   76 ++--
 drivers/net/wireless/iwlwifi/iwl-sta.h          |   29 +
 drivers/net/wireless/iwlwifi/iwl-tx.c           |   17 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c     |  195 +++----
 drivers/net/wireless/libertas_tf/main.c         |    1 -
 drivers/net/wireless/rt2x00/rt2800usb.c         |    2 +-
 localversion-wireless                           |    1 +
 net/mac80211/scan.c                             |    1 +
 32 files changed, 1782 insertions(+), 1161 deletions(-)
 create mode 100644 localversion-wireless

$ diff -Naur iwl3945-fix-internal-scan-2.6.35-rc1.patch
iwl3945-fix-internal-scan-from-iwlwifi-2.6.patch
--- iwl3945-fix-internal-scan-2.6.35-rc1.patch	2010-06-03
10:13:25.000000000 +0200
+++ iwl3945-fix-internal-scan-from-iwlwifi-2.6.patch	2010-06-03
10:41:08.435292314 +0200
@@ -1,27 +1,4 @@
-From patchwork Thu Jun  3 06:00:03 2010
-Content-Type: text/plain; charset="utf-8"
-MIME-Version: 1.0
-Content-Transfer-Encoding: 7bit
-Subject: IWL3945 problems in 2.6.35-rc1
-Date: Thu, 03 Jun 2010 06:00:03 -0000
-From: reinette chatre <reinette.chatre@intel.com>
-X-Patchwork-Id: 104010
-Message-Id: <1275544803.2091.30386.camel@rchatre-DESK>
-To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
-Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
-	Maxim Levitsky <maximlevitsky@gmail.com>,
-	linux-wireless <linux-wireless@vger.kernel.org>,
-	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
-
-On Wed, 2010-06-02 at 01:35 -0700, Sedat Dilek wrote:
-> This patch seems to be done against iwlwifi-2.6 GIT master.
->
-> Can you please offer a patch against vanilla 2.6.35-rc1 as requested
-> so we can try and give feedback?
-
-Sorry that you did not get this. Please try this patch:
-
->From 364614af1fbabe2989bb3e1434d50255a631546b Mon Sep 17 00:00:00 2001
+From 364614af1fbabe2989bb3e1434d50255a631546b Mon Sep 17 00:00:00 2001
 From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
 Date: Wed, 2 Jun 2010 21:15:10 -0700
 Subject: [PATCH] iwl3945: fix internal scan
@@ -34,9 +11,8 @@

 Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
 Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
-
 ---
-drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   30 +-------------
+ drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   30 +-------------
  drivers/net/wireless/iwlwifi/iwl-core.c     |   39 ++++++++++++++++++
  drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
  drivers/net/wireless/iwlwifi/iwl3945-base.c |   56 +++++++++++++++++++++++++-
@@ -152,9 +128,9 @@
  int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch);
 +u8 iwl_get_single_channel_number(struct iwl_priv *priv,
 +				  enum ieee80211_band band);
- void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
- u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
- 			 struct ieee80211_sta_ht_cap *sta_ht_inf);
+ void iwl_set_flags_for_band(struct iwl_priv *priv,
+ 			    enum ieee80211_band band,
+ 			    struct ieee80211_vif *vif);
 diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
 index a527895..2366394 100644
 --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -229,3 +205,6 @@

  	if (scan->channel_count == 0) {
  		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
+--
+1.7.1
+

--- EOT ---

On Thu, Jun 3, 2010 at 8:00 AM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Wed, 2010-06-02 at 01:35 -0700, Sedat Dilek wrote:
>> This patch seems to be done against iwlwifi-2.6 GIT master.
>>
>> Can you please offer a patch against vanilla 2.6.35-rc1 as requested
>> so we can try and give feedback?
>
> Sorry that you did not get this. Please try this patch:
>
> >From 364614af1fbabe2989bb3e1434d50255a631546b Mon Sep 17 00:00:00 2001
> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Date: Wed, 2 Jun 2010 21:15:10 -0700
> Subject: [PATCH] iwl3945: fix internal scan
>
> Port of internal scan to iwl3945 missed introduction
> of iwl3945_get_single_channel_for_scan.
>
> Fix the following bug by introducing the iwl3945_get_single_channel_for_scan
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2208
>
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   30 +-------------
>  drivers/net/wireless/iwlwifi/iwl-core.c     |   39 ++++++++++++++++++
>  drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |   56 +++++++++++++++++++++++++-
>  4 files changed, 96 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> index 59aeb2e..ac4031e 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> @@ -1031,10 +1031,9 @@ static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
>                                           struct iwl_scan_channel *scan_ch)
>  {
>        const struct ieee80211_supported_band *sband;
> -       const struct iwl_channel_info *ch_info;
>        u16 passive_dwell = 0;
>        u16 active_dwell = 0;
> -       int i, added = 0;
> +       int added = 0;
>        u16 channel = 0;
>
>        sband = iwl_get_hw_mode(priv, band);
> @@ -1049,32 +1048,7 @@ static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
>        if (passive_dwell <= active_dwell)
>                passive_dwell = active_dwell + 1;
>
> -       /* only scan single channel, good enough to reset the RF */
> -       /* pick the first valid not in-use channel */
> -       if (band == IEEE80211_BAND_5GHZ) {
> -               for (i = 14; i < priv->channel_count; i++) {
> -                       if (priv->channel_info[i].channel !=
> -                           le16_to_cpu(priv->staging_rxon.channel)) {
> -                               channel = priv->channel_info[i].channel;
> -                               ch_info = iwl_get_channel_info(priv,
> -                                       band, channel);
> -                               if (is_channel_valid(ch_info))
> -                                       break;
> -                       }
> -               }
> -       } else {
> -               for (i = 0; i < 14; i++) {
> -                       if (priv->channel_info[i].channel !=
> -                           le16_to_cpu(priv->staging_rxon.channel)) {
> -                                       channel =
> -                                               priv->channel_info[i].channel;
> -                                       ch_info = iwl_get_channel_info(priv,
> -                                               band, channel);
> -                                       if (is_channel_valid(ch_info))
> -                                               break;
> -                       }
> -               }
> -       }
> +       channel = iwl_get_single_channel_number(priv, band);
>        if (channel) {
>                scan_ch->channel = cpu_to_le16(channel);
>                scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
> index 3ed3dbf..11b20ba 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -855,6 +855,45 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
>  }
>  EXPORT_SYMBOL(iwl_set_rxon_chain);
>
> +/* Return valid channel */
> +u8 iwl_get_single_channel_number(struct iwl_priv *priv,
> +                                 enum ieee80211_band band)
> +{
> +       const struct iwl_channel_info *ch_info;
> +       int i;
> +       u8 channel = 0;
> +
> +       /* only scan single channel, good enough to reset the RF */
> +       /* pick the first valid not in-use channel */
> +       if (band == IEEE80211_BAND_5GHZ) {
> +               for (i = 14; i < priv->channel_count; i++) {
> +                       if (priv->channel_info[i].channel !=
> +                           le16_to_cpu(priv->staging_rxon.channel)) {
> +                               channel = priv->channel_info[i].channel;
> +                               ch_info = iwl_get_channel_info(priv,
> +                                       band, channel);
> +                               if (is_channel_valid(ch_info))
> +                                       break;
> +                       }
> +               }
> +       } else {
> +               for (i = 0; i < 14; i++) {
> +                       if (priv->channel_info[i].channel !=
> +                           le16_to_cpu(priv->staging_rxon.channel)) {
> +                                       channel =
> +                                               priv->channel_info[i].channel;
> +                                       ch_info = iwl_get_channel_info(priv,
> +                                               band, channel);
> +                                       if (is_channel_valid(ch_info))
> +                                               break;
> +                       }
> +               }
> +       }
> +
> +       return channel;
> +}
> +EXPORT_SYMBOL(iwl_get_single_channel_number);
> +
>  /**
>  * iwl_set_rxon_channel - Set the phymode and channel values in staging RXON
>  * @phymode: MODE_IEEE80211A sets to 5.2GHz; all else set to 2.4GHz
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
> index 87dd573..244d163 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.h
> @@ -347,6 +347,8 @@ int iwl_check_rxon_cmd(struct iwl_priv *priv);
>  int iwl_full_rxon_required(struct iwl_priv *priv);
>  void iwl_set_rxon_chain(struct iwl_priv *priv);
>  int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch);
> +u8 iwl_get_single_channel_number(struct iwl_priv *priv,
> +                                 enum ieee80211_band band);
>  void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
>  u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
>                         struct ieee80211_sta_ht_cap *sta_ht_inf);
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index a527895..2366394 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -1785,6 +1785,49 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
>  #endif
>  }
>
> +static int iwl3945_get_single_channel_for_scan(struct iwl_priv *priv,
> +                                              struct ieee80211_vif *vif,
> +                                              enum ieee80211_band band,
> +                                              struct iwl3945_scan_channel *scan_ch)
> +{
> +       const struct ieee80211_supported_band *sband;
> +       u16 passive_dwell = 0;
> +       u16 active_dwell = 0;
> +       int added = 0;
> +       u8 channel = 0;
> +
> +       sband = iwl_get_hw_mode(priv, band);
> +       if (!sband) {
> +               IWL_ERR(priv, "invalid band\n");
> +               return added;
> +       }
> +
> +       active_dwell = iwl_get_active_dwell_time(priv, band, 0);
> +       passive_dwell = iwl_get_passive_dwell_time(priv, band, vif);
> +
> +       if (passive_dwell <= active_dwell)
> +               passive_dwell = active_dwell + 1;
> +
> +
> +       channel = iwl_get_single_channel_number(priv, band);
> +
> +       if (channel) {
> +               scan_ch->channel = channel;
> +               scan_ch->type = 0;      /* passive */
> +               scan_ch->active_dwell = cpu_to_le16(active_dwell);
> +               scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
> +               /* Set txpower levels to defaults */
> +               scan_ch->tpc.dsp_atten = 110;
> +               if (band == IEEE80211_BAND_5GHZ)
> +                       scan_ch->tpc.tx_gain = ((1 << 5) | (3 << 3)) | 3;
> +               else
> +                       scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
> +               added++;
> +       } else
> +               IWL_ERR(priv, "no valid channel found\n");
> +       return added;
> +}
> +
>  static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
>                                         enum ieee80211_band band,
>                                     u8 is_active, u8 n_probes,
> @@ -2935,9 +2978,16 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>        /* select Rx antennas */
>        scan->flags |= iwl3945_get_antenna_flags(priv);
>
> -       scan->channel_count =
> -               iwl3945_get_channels_for_scan(priv, band, is_active, n_probes,
> -                       (void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)], vif);
> +       if (priv->is_internal_short_scan) {
> +               scan->channel_count =
> +                       iwl3945_get_single_channel_for_scan(priv, vif, band,
> +                               (void *)&scan->data[le16_to_cpu(
> +                               scan->tx_cmd.len)]);
> +       } else {
> +               scan->channel_count =
> +                       iwl3945_get_channels_for_scan(priv, band, is_active, n_probes,
> +                               (void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)], vif);
> +       }
>
>        if (scan->channel_count == 0) {
>                IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
> --
> 1.7.0.4
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
