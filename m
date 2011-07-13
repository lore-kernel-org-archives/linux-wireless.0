Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3928 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1GME3P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 00:29:15 -0400
Subject: Re: [PATCH 06/24] ath6kl: add core.h
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
In-Reply-To: <20110713013355.8517.6083.stgit@localhost6.localdomain6>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713013355.8517.6083.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 21:29:14 -0700
Message-ID: <1310531354.1143.27.camel@Joe-Laptop> (sfid-20110713_062918_051490_776A72DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 04:33 +0300, Kalle Valo wrote: 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
[] 
> +/* Pkt log info */
> +struct pkt_log {
> +	struct info {
> +		__le16 st;
> +		__le16 end;
> +		__le16 cur;
> +	} info[4096];
> +	__le16 last_idx;
> +} __packed;

pretty big struct.

> +struct skb_hold_q {
> +	struct sk_buff *skb;
> +	bool is_amsdu;
> +	u16 seq_no;
> +};

Maybe all the structs could be inspected for alignment
and possible packing appropriateness?

struct sk_buff *skb;
u16 seq_no;
bool is_amsdu;
?

> +struct ath6kl_sta {
> +	u16 sta_flags;
> +	u8 mac[ETH_ALEN];
> +	u8 aid;
> +	u8 keymgmt;
> +	u8 ucipher;
> +	u8 auth;
> +	u8 wpa_ie[IEEE80211_MAX_IE];
> +	struct sk_buff_head psq;
> +	spinlock_t psq_lock;
> +};

> +struct target_stats {
[] 
> +	s32 tx_ucast_rate;
> +	s32 rx_ucast_rate;
> +
> +	u32 lq_val;
> +
> +	u32 wow_pkt_dropped;
> +	u16 wow_evt_discarded;
> +
> +	s16 noise_floor_calib;
> +	s16 cs_rssi;
> +	s16 cs_ave_beacon_rssi;
[] aligned OK 
> +	u8 cs_ave_beacon_snr;
> +	u8 cs_last_roam_msec;
> +	u8 cs_snr;
> +
> +	u8 wow_host_pkt_wakeups;
> +	u8 wow_host_evt_wakeups;
> +

typically pad is inserted here.

> +	u32 arp_received;
> +	u32 arp_matched;
> +	u32 arp_replied;
> +};

maybe move the u32's up after lq_val?

etc.



