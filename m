Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:56499 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbaGGLsb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 07:48:31 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [ath9k-devel] [RFC 03/10] ath9k: add dynamic ack timeout estimation
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1404725506-9571-4-git-send-email-lorenzo.bianconi83@gmail.com>
Date: Mon, 7 Jul 2014 13:41:02 +0200
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <0D7AC98D-7356-44BC-8DBC-2916DF58F41F@net.t-labs.tu-berlin.de> (sfid-20140707_134835_617042_FE0857CB)
References: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com> <1404725506-9571-4-git-send-email-lorenzo.bianconi83@gmail.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lorenzo,

My comments are inline.


> Add dynamic ack timeout estimation algorithm based on ack frame RX timestamp,
> TX frame timestamp and frame duration.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> ---
> drivers/net/wireless/ath/ath.h          |   2 +
> drivers/net/wireless/ath/ath9k/ath9k.h  |   3 +
> drivers/net/wireless/ath/ath9k/dynack.c | 293 ++++++++++++++++++++++++++++++++
> drivers/net/wireless/ath/ath9k/dynack.h |  81 +++++++++
> drivers/net/wireless/ath/ath9k/hw.c     |   2 +
> drivers/net/wireless/ath/ath9k/hw.h     |   3 +
> 6 files changed, 384 insertions(+)
> create mode 100644 drivers/net/wireless/ath/ath9k/dynack.c
> create mode 100644 drivers/net/wireless/ath/ath9k/dynack.h
> 
> diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
> index fd9e530..4e51072 100644
> --- a/drivers/net/wireless/ath/ath.h
> +++ b/drivers/net/wireless/ath/ath.h
> @@ -234,6 +234,7 @@ void ath_printk(const char *level, const struct ath_common *common,
>  *	AR9462.
>  * @ATH_DBG_DFS: radar datection
>  * @ATH_DBG_WOW: Wake on Wireless
> + * @ATH_DBG_DYNACK: dynack handling
>  * @ATH_DBG_ANY: enable all debugging
>  *
>  * The debug level is used to control the amount and type of debugging output
> @@ -261,6 +262,7 @@ enum ATH_DEBUG {
> 	ATH_DBG_MCI		= 0x00008000,
> 	ATH_DBG_DFS		= 0x00010000,
> 	ATH_DBG_WOW		= 0x00020000,
> +	ATH_DBG_DYNACK		= 0x00040000,
> 	ATH_DBG_ANY		= 0xffffffff
> };
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 11b5e4d..65a2587 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -272,6 +272,9 @@ struct ath_node {
> 	struct ath_rx_rate_stats rx_rate_stats;
> #endif
> 	u8 key_idx[4];
> +
> +	u32 ackto;
> +	struct list_head list;
> };
> 
> struct ath_tx_control {
> diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
> new file mode 100644
> index 0000000..50297e7
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/dynack.c
> @@ -0,0 +1,293 @@
> +/*
> + * Copyright 2014, Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include "ath9k.h"
> +#include "hw.h"
> +#include "dynack.h"
> +
> +#define COMPUTE_TO		(5 * HZ)
> +#define LATEACK_DELAY		(10 * HZ)
> +#define LATEACK_TO		256
> +#define MAX_DELAY		300
> +#define EWMA_LEVEL		75
> +#define DYNACK_EWMA(old, new)	\
> +	(((new) * (100 - EWMA_LEVEL) + (old) * EWMA_LEVEL) / 100)
> +

You could change this EWMA calculation as we did it in Minstrel to use powers of two as the calculation speed increased.
This would change :
- EWMA_DIV   from 100 to 2^7
- EWMA_LEVEL from 75 (/EWMA_DIV=100) to 2^6 + 2^5 (/EWMA_DIV=128)

Note that this changes EWMA_DIV - EWMA_LEVEL from 25 to 2^5 and keeps
EWMA_LEVEL / EWMA_DIV == 0.75.

Something like this:

+#define EWMA_LEVEL	96	/* ewma weighting factor [/EWMA_DIV] */
+#define EWMA_DIV	128

static inline int
dynack_ewma(int old, int new, int weight)
{
+	return (new * (EWMA_DIV - weight) + old * weight) / EWMA_DIV;
}


> +/**
> + * ath_dynack_get_sifs - get sifs time based on phy used
> + * @ah: ath hw
> + * @phy: phy used
> + */
> +static inline u32 ath_dynack_get_sifs(struct ath_hw *ah, int phy)
> +{
> +	u32 sifs = CCK_SIFS_TIME;
> +
> +	if (phy == WLAN_RC_PHY_OFDM) {
> +		if (IS_CHAN_QUARTER_RATE(ah->curchan))
> +			sifs = OFDM_SIFS_TIME_QUARTER;
> +		else if (IS_CHAN_HALF_RATE(ah->curchan))
> +			sifs = OFDM_SIFS_TIME_HALF;
> +		else
> +			sifs = OFDM_SIFS_TIME;
> +	}
> +	return sifs;
> +}
> +
> +static inline bool ath_dynack_bssidmask(struct ath_hw *ah, const u8 *mac)
> +{
> +	int i;
> +	struct ath_common *common = ath9k_hw_common(ah);
> +
> +	for (i = 0; i < ETH_ALEN; i++) {
> +		if ((common->macaddr[i] & common->bssidmask[i]) !=
> +		    (mac[i] & common->bssidmask[i]))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +/**
> + * ath_dynack_set_ackto - compute ack timeout based on sta timeout
> + * @ah: ath hw
> + *
> + * should be called while holding qlock
> + */
> +static void ath_dynack_compute_ackto(struct ath_hw *ah)

The function name does not match the name in the comment above (ath_dynack_set_ackto != ath_dynack_compute_ackto).

> +{
> +	struct ath_node *an;
> +	u32 to = 0;
> +	struct ath_dynack *da = &ah->dynack;
> +	struct ath_common *common = ath9k_hw_common(ah);
> +

> +	list_for_each_entry(an, &da->nodes, list)
> +		if (an->ackto > to)
> +			to = an->ackto;
> +

This list parsing would probably need rcu protection like:
	
	rcu_read_lock();
	list_for_each_entry(an, &da->nodes, list)
		if (an->ackto > to)
			to = an->ackto;
	rcu_read_unlock();

I am not sure that you need to call the entire function with spin_lock as you do it now.

> +	if (to && da->ackto != to) {
> +		u32 slottime;
> +
> +		slottime = (to - 3) / 2;

Should the case to < 3 be covered or is it safe to have potentially slottime = 0 ?

> +		da->ackto = to;
> +		ath_dbg(common, DYNACK, "ack timeout %u slottime %u\n",
> +			da->ackto, slottime);
> +		ath9k_hw_setslottime(ah, slottime);
> +		ath9k_hw_set_ack_timeout(ah, da->ackto);
> +		ath9k_hw_set_cts_timeout(ah, da->ackto);
> +	}
> +}
> +
> +/**
> + * ath_dynack_compute_to - compute ack timeout
> + * @ah: ath hw
> + *
> + * should be called while holding qlock
> + */
> +static void ath_dynack_compute_to(struct ath_hw *ah)
> +{
> +	u32 ackto, ack_ts;
> +	u8 *dst, *src;
> +	struct ieee80211_sta *sta;
> +	struct ath_node *an;
> +	struct ts_info *st_ts;
> +	struct ath_dynack *da = &ah->dynack;
> +
> +	rcu_read_lock();
> +
> +	while (da->st_rbf.h_rb != da->st_rbf.t_rb &&
> +	       da->ack_rbf.h_rb != da->ack_rbf.t_rb) {
> +		ack_ts = da->ack_rbf.tstamp[da->ack_rbf.h_rb];
> +		st_ts = &da->st_rbf.ts[da->st_rbf.h_rb];
> +		dst = da->st_rbf.addr[da->st_rbf.h_rb].h_dest;
> +		src = da->st_rbf.addr[da->st_rbf.h_rb].h_src;
> +
> +		ath_dbg(ath9k_hw_common(ah), DYNACK,
> +			"ack_ts %u st_ts %u st_dur %u [%u-%u]\n",
> +			ack_ts, st_ts->tstamp, st_ts->dur,
> +			da->ack_rbf.h_rb, da->st_rbf.h_rb);
> +
> +		if (ack_ts > st_ts->tstamp + st_ts->dur) {
> +			ackto = ack_ts - st_ts->tstamp - st_ts->dur;
> +
> +			if (ackto < MAX_DELAY) {
> +				sta = ieee80211_find_sta_by_ifaddr(ah->hw, dst,
> +								   src);
> +				if (sta) {
> +					an = (struct ath_node *)sta->drv_priv;
> +					an->ackto = DYNACK_EWMA((u32)ackto,
> +								an->ackto);
> +					ath_dbg(ath9k_hw_common(ah), DYNACK,
> +						"%pM to %u\n", dst, an->ackto);
> +					if (time_is_before_jiffies(da->lto)) {
> +						ath_dynack_compute_ackto(ah);
> +						da->lto = jiffies + COMPUTE_TO;
> +					}
> +				}
> +				INCR(da->ack_rbf.h_rb, ATH_DYN_BUF);
> +			}
> +			INCR(da->st_rbf.h_rb, ATH_DYN_BUF);
> +		} else {
> +			INCR(da->ack_rbf.h_rb, ATH_DYN_BUF);
> +		}
> +	}
> +
> +	rcu_read_unlock();

I think it is sufficient to have the rcu_read_unlock just around  ieee80211_find_sta_by_ifaddr(). So the lock does not need to
include the whole while loop under lock.


Greetings Thomas

> +}
> +
> +/**
> + * ath_dynack_sample_tx_ts - status ts sampling method
> + * @ah: ath hw
> + * @skb: socket buffer
> + * @ts: tx status info
> + *
> + */
> +void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
> +			     struct ath_tx_status *ts)
> +{
> +	u8 ridx;
> +	struct ieee80211_hdr *hdr;
> +	struct ath_dynack *da = &ah->dynack;
> +	struct ath_common *common = ath9k_hw_common(ah);
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +
> +	if ((info->flags & IEEE80211_TX_CTL_NO_ACK) || da->fix_to)
> +		return;
> +
> +	spin_lock_bh(&da->qlock);
> +
> +	hdr = (struct ieee80211_hdr *)skb->data;
> +
> +	/* late ack */
> +	if (ts->ts_status & ATH9K_TXERR_XRETRY) {
> +		if (ieee80211_is_assoc_req(hdr->frame_control) ||
> +		    ieee80211_is_assoc_resp(hdr->frame_control)) {
> +			ath_dbg(common, DYNACK, "late ack\n");
> +			ath9k_hw_setslottime(ah, (LATEACK_TO - 3) / 2);
> +			ath9k_hw_set_ack_timeout(ah, LATEACK_TO);
> +			ath9k_hw_set_cts_timeout(ah, LATEACK_TO);
> +			da->lto = jiffies + LATEACK_DELAY;
> +		}
> +
> +		spin_unlock_bh(&da->qlock);
> +		return;
> +	}
> +
> +	ridx = ts->ts_rateindex;
> +
> +	da->st_rbf.ts[da->st_rbf.t_rb].tstamp = ts->ts_tstamp;
> +	da->st_rbf.ts[da->st_rbf.t_rb].dur = ts->duration[ts->ts_rateindex];
> +	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1);
> +	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2);
> +
> +	if (!(info->status.rates[ridx].flags & IEEE80211_TX_RC_MCS)) {
> +		u32 phy, sifs;
> +		const struct ieee80211_rate *rate;
> +		struct ieee80211_tx_rate *rates = info->status.rates;
> +
> +		rate = &common->sbands[info->band].bitrates[rates[ridx].idx];
> +		if (info->band == IEEE80211_BAND_2GHZ &&
> +		    !(rate->flags & IEEE80211_RATE_ERP_G))
> +			phy = WLAN_RC_PHY_CCK;
> +		else
> +			phy = WLAN_RC_PHY_OFDM;
> +
> +		sifs = ath_dynack_get_sifs(ah, phy);
> +		da->st_rbf.ts[da->st_rbf.t_rb].dur -= sifs;
> +	}
> +
> +	ath_dbg(common, DYNACK, "{%pM} tx sample %u [dur %u][h %u-t %u]\n",
> +		hdr->addr1, da->st_rbf.ts[da->st_rbf.t_rb].tstamp,
> +		da->st_rbf.ts[da->st_rbf.t_rb].dur, da->st_rbf.h_rb,
> +		(da->st_rbf.t_rb + 1) % ATH_DYN_BUF);
> +
> +	INCR(da->st_rbf.t_rb, ATH_DYN_BUF);
> +	if (da->st_rbf.t_rb == da->st_rbf.h_rb)
> +		INCR(da->st_rbf.h_rb, ATH_DYN_BUF);
> +
> +	ath_dynack_compute_to(ah);
> +
> +	spin_unlock_bh(&da->qlock);
> +}
> +EXPORT_SYMBOL(ath_dynack_sample_tx_ts);
> +
> +/**
> + * ath_dynack_sample_ack_ts - ack ts sampling method
> + * @ah: ath hw
> + * @skb: socket buffer
> + * @ts: rx timestamp
> + *
> + */
> +void ath_dynack_sample_ack_ts(struct ath_hw *ah, struct sk_buff *skb,
> +			      u32 ts)
> +{
> +	struct ath_dynack *da = &ah->dynack;
> +	struct ath_common *common = ath9k_hw_common(ah);
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +
> +	if (!ath_dynack_bssidmask(ah, hdr->addr1) || da->fix_to)
> +		return;
> +
> +	spin_lock_bh(&da->qlock);
> +	da->ack_rbf.tstamp[da->ack_rbf.t_rb] = ts;
> +
> +	ath_dbg(common, DYNACK, "rx sample %u [h %u-t %u]\n",
> +		da->ack_rbf.tstamp[da->ack_rbf.t_rb],
> +		da->ack_rbf.h_rb, (da->ack_rbf.t_rb + 1) % ATH_DYN_BUF);
> +
> +	INCR(da->ack_rbf.t_rb, ATH_DYN_BUF);
> +	if (da->ack_rbf.t_rb == da->ack_rbf.h_rb)
> +		INCR(da->ack_rbf.h_rb, ATH_DYN_BUF);
> +
> +	ath_dynack_compute_to(ah);
> +
> +	spin_unlock_bh(&da->qlock);
> +}
> +EXPORT_SYMBOL(ath_dynack_sample_ack_ts);
> +
> +/**
> + * ath_dynack_reset - reset dynack processing
> + * @ah: ath hw
> + *
> + */
> +void ath_dynack_reset(struct ath_hw *ah)
> +{
> +	/* ackto = slottime + sifs + air delay */
> +	u32 ackto = ATH9K_SLOT_TIME_9 + 16 + 64;
> +	struct ath_dynack *da = &ah->dynack;
> +
> +	da->lto = jiffies;
> +	da->ackto = ackto;
> +
> +	da->st_rbf.t_rb = 0;
> +	da->st_rbf.h_rb = 0;
> +	da->ack_rbf.t_rb = 0;
> +	da->ack_rbf.h_rb = 0;
> +
> +	/* init acktimeout */
> +	ath9k_hw_setslottime(ah, (ackto - 3) / 2);
> +	ath9k_hw_set_ack_timeout(ah, ackto);
> +	ath9k_hw_set_cts_timeout(ah, ackto);
> +}
> +EXPORT_SYMBOL(ath_dynack_reset);
> +
> +/**
> + * ath_dynack_init - init dynack data structure
> + * @ah: ath hw
> + *
> + */
> +void ath_dynack_init(struct ath_hw *ah)
> +{
> +	struct ath_dynack *da = &ah->dynack;
> +
> +	memset(da, 0, sizeof(struct ath_dynack));
> +
> +	spin_lock_init(&da->qlock);
> +	INIT_LIST_HEAD(&da->nodes);
> +
> +	ath_dynack_reset(ah);
> +}
> +
> diff --git a/drivers/net/wireless/ath/ath9k/dynack.h b/drivers/net/wireless/ath/ath9k/dynack.h
> new file mode 100644
> index 0000000..386f176
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/dynack.h
> @@ -0,0 +1,81 @@
> +/*
> + * Copyright 2014, Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef DYNACK_H
> +#define DYNACK_H
> +
> +#define ATH_DYN_BUF	64
> +
> +struct ath_hw;
> +
> +/**
> + * ath_dyn_rxbuf - ack frame ring buffer
> + */
> +struct ath_dyn_rxbuf {
> +	u16 h_rb, t_rb;
> +	u32 tstamp[ATH_DYN_BUF];
> +};
> +
> +struct ts_info {
> +	u32 tstamp;
> +	u32 dur;
> +};
> +
> +struct haddr_pair {
> +	u8 h_dest[ETH_ALEN];
> +	u8 h_src[ETH_ALEN];
> +};
> +/**
> + * ath_dyn_txbuf - tx frame ring buffer
> + */
> +struct ath_dyn_txbuf {
> +	u16 h_rb, t_rb;
> +	struct haddr_pair addr[ATH_DYN_BUF];
> +	struct ts_info ts[ATH_DYN_BUF];
> +};
> +
> +/**
> + * ath_dynack - dyn ack processing info
> + * @fix_to: use static ack timeout
> + * @ackto: current ack timeout
> + * @lto: last ack timeout computation
> + * @nodes: ath_node linked list
> + * @qlock: ts queue spinlock
> + * @ack_rbf: ack ts ring buffer
> + * @st_rbf: status ts ring buffer
> + */
> +struct ath_dynack {
> +	bool fix_to;
> +	int ackto;
> +	unsigned long lto;
> +
> +	struct list_head nodes;
> +
> +	/* protect timestamp queue access */
> +	spinlock_t qlock;
> +	struct ath_dyn_rxbuf ack_rbf;
> +	struct ath_dyn_txbuf st_rbf;
> +};
> +
> +#if defined(CONFIG_ATH9K_DYNACK)
> +void ath_dynack_reset(struct ath_hw *ah);
> +void ath_dynack_init(struct ath_hw *ah);
> +void ath_dynack_sample_ack_ts(struct ath_hw *ah, struct sk_buff *skb, u32 ts);
> +void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
> +			     struct ath_tx_status *ts);
> +#else
> +static inline void ath_dynack_reset(struct ath_hw *ah) {}
> +static inline void ath_dynack_init(struct ath_hw *ah) {}
> +static inline void ath_dynack_sample_ack_ts(struct ath_hw *ah,
> +					    struct sk_buff *skb, u32 ts) {}
> +static inline void ath_dynack_sample_tx_ts(struct ath_hw *ah,
> +					   struct sk_buff *skb,
> +					   struct ath_tx_status *ts) {}
> +#endif
> +
> +#endif /* DYNACK_H */
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index e88896c..9a6b113 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -647,6 +647,8 @@ int ath9k_hw_init(struct ath_hw *ah)
> 		return ret;
> 	}
> 
> +	ath_dynack_init(ah);
> +
> 	return 0;
> }
> EXPORT_SYMBOL(ath9k_hw_init);
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index f36d971..b9eef33 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -29,6 +29,7 @@
> #include "reg.h"
> #include "phy.h"
> #include "btcoex.h"
> +#include "dynack.h"
> 
> #include "../regd.h"
> 
> @@ -924,6 +925,8 @@ struct ath_hw {
> 	int (*external_reset)(void);
> 
> 	const struct firmware *eeprom_blob;
> +
> +	struct ath_dynack dynack;
> };
> 
> struct ath_bus_ops {
> -- 
> 1.9.1
> 
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel

