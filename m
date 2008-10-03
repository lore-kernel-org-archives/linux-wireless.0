Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:48608 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbYJCTVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 15:21:32 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH] p54: fix memory management
Date: Fri, 3 Oct 2008 21:25:27 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
References: <1237110305@web.de>
In-Reply-To: <1237110305@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810032125.27454.chunkeey@web.de> (sfid-20081003_212138_025891_7FFA5983)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 October 2008 16:16:32 Chunkeey@web.de wrote:
> >
> > Note, the "tainted" flag is false. No closed-source drivers have been
> > loaded.
> >
> > The oops occurs in the following inline routine:
> >
> > static inline void __skb_queue_after(struct sk_buff_head *list,
> >                                      struct sk_buff *prev,
> >                                      struct sk_buff *newsk)
> > {
> >         __skb_insert(newsk, prev, prev->next, list);
> > }
> >
> > and is called from p54_assign_addresses() in the following region:
> >
> >        if (skb) {
> >                 struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> >                 struct memrecord *range = (void *)info->driver_data;
> >                 range->start_addr = target_addr;
> >                 range->end_addr = target_addr + len;
> >                 range->dev = dev;
> >                 __skb_queue_after(&priv->tx_queue, target_skb, skb);
> >                 if (largest_hole < priv->rx_mtu + priv->headroom +
> >                                    priv->tailroom +
> >                                    sizeof(struct p54_control_hdr))
> >                         ieee80211_stop_queues(dev);
> >         }
> >
> > Larry
>
> Hmm, just a guess:
>
> according to skbuff.h
> the callback buffer in every skb is about;
> char                    cb[48];
>
>
> now, when we look at what mac80211 puts inside it
> struct ieee80211_tx_info {
> u32 flags;
> u8 band;
> s8 tx_rate_idx;
> u8 antenna_sel_tx;
>
> /* 1 byte hole => 8 bytes so far */
>
> union {
> struct {
> struct ieee80211_vif *vif; // another 8 byte on 64bit cpus => 16
> struct ieee80211_key_conf *hw_key; // + 8 bytes => 24
> struct ieee80211_sta *sta; // + 8 bytes => 32
> unsigned long jiffies; // + 8 bytes => 40
> s8 rts_cts_rate_idx, alt_retry_rate_idx; // + 2
> u8 retry_limit; // + 1
> u8 icv_len; // + 1
> u8 iv_len; // + 1
> } control;
> [...]
>
> = 45 Bytes (without alignment, with it it's probably 48) out of 48...
> If this is true, we have a serious problem on x64 since the memrecord
> struct is about 8 bytes in the old code, but with this patch it's 16...
> well I am not sure, can I put the extra ieee80211_hw* thing into skb->dev.
> It would be nice, but of course net_device isn't exactly ieee80211_hw, as
> far as I can see.

Ahh, that's garbage. driver_data is a member of the union, so it has about 40 
bytes which is plenty. sorry for the noise.

Regards,
	Chr.
