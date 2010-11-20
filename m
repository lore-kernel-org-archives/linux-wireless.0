Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47287 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab0KTQpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 11:45:15 -0500
Received: by qyk1 with SMTP id 1so585743qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 08:45:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101112030035.28522.75318.stgit@localhost6.localdomain6>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
	<20101112030035.28522.75318.stgit@localhost6.localdomain6>
Date: Sat, 20 Nov 2010 11:45:13 -0500
Message-ID: <AANLkTik_mQJNSn1v9i-EJvm5XaMdUZE6YMKRoxGdtNRe@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
From: Brian Prodoehl <bprodoehl@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: br1@thinktube.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 10:00 PM, Bruno Randolf <br1@einfach.org> wrote:
> Extend nl80211 to report an exponential weighted moving average (EWMA) of the
> signal value. Since the signal value usually fluctuates between different
> packets, an average can be more useful than the value of the last packet.
>
> This uses the recently added generic EWMA library function.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  include/linux/nl80211.h |    2 ++
>  include/net/cfg80211.h  |    4 ++++
>  net/mac80211/Kconfig    |    1 +
>  net/mac80211/cfg.c      |    3 ++-
>  net/mac80211/rx.c       |    1 +
>  net/mac80211/sta_info.c |    2 ++
>  net/mac80211/sta_info.h |    3 +++
>  net/wireless/nl80211.c  |    3 +++
>  8 files changed, 18 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index fb877b5..0ceb552 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1132,6 +1132,7 @@ enum nl80211_rate_info {
>  * @__NL80211_STA_INFO_AFTER_LAST: internal
>  * @NL80211_STA_INFO_MAX: highest possible station info attribute
>  * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
> + * @NL80211_STA_INFO_SIGNAL_AVG: signal strength average (u8, dBm)
>  * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
>  *     containing info as possible, see &enum nl80211_sta_info_txrate.
>  * @NL80211_STA_INFO_RX_PACKETS: total received packet (u32, from this station)
> @@ -1149,6 +1150,7 @@ enum nl80211_sta_info {
>        NL80211_STA_INFO_PLID,
>        NL80211_STA_INFO_PLINK_STATE,
>        NL80211_STA_INFO_SIGNAL,
> +       NL80211_STA_INFO_SIGNAL_AVG,
>        NL80211_STA_INFO_TX_BITRATE,
>        NL80211_STA_INFO_RX_PACKETS,
>        NL80211_STA_INFO_TX_PACKETS,
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index e5702f5..f21f701 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -424,6 +424,7 @@ struct station_parameters {
>  * @STATION_INFO_TX_RETRIES: @tx_retries filled
>  * @STATION_INFO_TX_FAILED: @tx_failed filled
>  * @STATION_INFO_RX_DROP_MISC: @rx_dropped_misc filled
> + * @STATION_INFO_SIGNAL_AVG: @signal_avg filled
>  */
>  enum station_info_flags {
>        STATION_INFO_INACTIVE_TIME      = 1<<0,
> @@ -439,6 +440,7 @@ enum station_info_flags {
>        STATION_INFO_TX_RETRIES         = 1<<10,
>        STATION_INFO_TX_FAILED          = 1<<11,
>        STATION_INFO_RX_DROP_MISC       = 1<<12,
> +       STATION_INFO_SIGNAL_AVG         = 1<<13,
>  };
>
>  /**
> @@ -485,6 +487,7 @@ struct rate_info {
>  * @plid: mesh peer link id
>  * @plink_state: mesh peer link state
>  * @signal: signal strength of last received packet in dBm
> + * @signal_avg: signal strength average in dBm
>  * @txrate: current unicast bitrate to this station
>  * @rx_packets: packets received from this station
>  * @tx_packets: packets transmitted to this station
> @@ -505,6 +508,7 @@ struct station_info {
>        u16 plid;
>        u8 plink_state;
>        s8 signal;
> +       s8 signal_avg;
>        struct rate_info txrate;
>        u32 rx_packets;
>        u32 tx_packets;
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index 4d6f865..798d9b9 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -6,6 +6,7 @@ config MAC80211
>        select CRYPTO_ARC4
>        select CRYPTO_AES
>        select CRC32
> +       select AVERAGE
>        ---help---
>          This option enables the hardware independent IEEE 802.11
>          networking stack.
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 18bd0e5..d327918 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -343,8 +343,9 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>
>        if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
>            (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
> -               sinfo->filled |= STATION_INFO_SIGNAL;
> +               sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
>                sinfo->signal = (s8)sta->last_signal;
> +               sinfo->signal_avg = (s8) -ewma_get(&sta->avg_signal);
>        }
>
>        sinfo->txrate.flags = 0;
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 902b03e..34bcc84 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1158,6 +1158,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
>        sta->rx_fragments++;
>        sta->rx_bytes += rx->skb->len;
>        sta->last_signal = status->signal;
> +       ewma_add(&sta->avg_signal, -status->signal);
>
>        /*
>         * Change STA power saving mode only at the end of a frame
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 6d8f897..bed23e1 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -241,6 +241,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>        sta->local = local;
>        sta->sdata = sdata;
>
> +       ewma_init(&sta->avg_signal, 1000, 8);
> +
>        if (sta_prepare_rate_control(local, sta, gfp)) {
>                kfree(sta);
>                return NULL;
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 9265aca..84062e2 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -13,6 +13,7 @@
>  #include <linux/types.h>
>  #include <linux/if_ether.h>
>  #include <linux/workqueue.h>
> +#include <linux/average.h>
>  #include "key.h"
>
>  /**
> @@ -224,6 +225,7 @@ enum plink_state {
>  * @rx_fragments: number of received MPDUs
>  * @rx_dropped: number of dropped MPDUs from this STA
>  * @last_signal: signal of last received frame from this STA
> + * @avg_signal: moving average of signal of received frames from this STA
>  * @last_seq_ctrl: last received seq/frag number from this STA (per RX queue)
>  * @tx_filtered_count: number of frames the hardware filtered for this STA
>  * @tx_retry_failed: number of frames that failed retry
> @@ -291,6 +293,7 @@ struct sta_info {
>        unsigned long rx_fragments;
>        unsigned long rx_dropped;
>        int last_signal;
> +       struct ewma avg_signal;
>        __le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
>
>        /* Updated from TX status path only, no locking requirements */
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 4e78e3f..660987d 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1841,6 +1841,9 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
>        if (sinfo->filled & STATION_INFO_SIGNAL)
>                NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
>                           sinfo->signal);
> +       if (sinfo->filled & STATION_INFO_SIGNAL_AVG)
> +               NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL_AVG,
> +                          sinfo->signal_avg);
>        if (sinfo->filled & STATION_INFO_TX_BITRATE) {
>                txrate = nla_nest_start(msg, NL80211_STA_INFO_TX_BITRATE);
>                if (!txrate)
>

Someone's probably already on this, but these signal averaging patches
have broken compat-wireless.  Seeing as how this is a compat-wireless
issue, I trimmed the recipients.  compat-wireless-2010-11-19 under
2.6.32.23 fails with the following error:

In file included from
compat-wireless-2010-11-19/drivers/net/wireless/ath/ath5k/caps.c:24:
compat-wireless-2010-11-19/drivers/net/wireless/ath/ath5k/ath5k.h:28:27:
error: linux/average.h: No such file or directory
In file included from
compat-wireless-2010-11-19/drivers/net/wireless/ath/ath5k/caps.c:24:
compat-wireless-2010-11-19/drivers/net/wireless/ath/ath5k/ath5k.h:1106:
error: field ‘ah_beacon_rssi_avg’ has incomplete type
