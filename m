Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51609 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1AFVqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:46:48 -0500
Received: by fxm20 with SMTP id 20so16441982fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 13:46:47 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [RFC PATCH 10/17] zd1211rw: implement beacon fetching and handling ieee80211_get_buffered_bc()
Date: Thu, 6 Jan 2011 22:46:37 +0100
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
References: <20110104234745.25309.72030.stgit@fate.lan> <20110104234910.25309.19235.stgit@fate.lan>
In-Reply-To: <20110104234910.25309.19235.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101062246.38932.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 January 2011 00:49:10 Jussi Kivilinna wrote:
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
> index aace010..a3c7e8f 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -958,16 +958,46 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
>  	return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
>  }
>  
> +static void zd_beacon_done(struct zd_mac *mac)
> +{

this is an interesting one...

Since zd_beacon_done also uploads the next beacon so long in advance,
there could be an equally long race between the outdated state of the
next beacon's DTIM broadcast traffic indicator (802.11-2007 7.3.2.6)
which -in your case- was uploaded almost a beacon interval ago and
the xmit of ieee80211_get_buffered_bc *now*.

The dtim bc/mc bit might be not set, when a mc/bc arrived after the
beacon was uploaded, but before the "beacon done event" from the
hardware. So, dozing stations don't expect the broadcast traffic
and of course, they might miss it completely.

It's probably better to fix this in mac80211 (see the attached hack).
> +	/*
> +	 * Send out buffered broad- and multicast frames.
> +	 */
> +	while (!ieee80211_queue_stopped(mac->hw, 0)) {
> +		skb = ieee80211_get_buffered_bc(mac->hw, mac->vif);
> +		if (!skb)
> +			break;
> +		zd_op_tx(mac->hw, skb);
> +	}
> +
> +	/*
> +	 * Fetch next beacon so that tim_count is updated.
> +	 */
> +	beacon = ieee80211_beacon_get(mac->hw, mac->vif);
> +	if (!beacon)
> +		return;

Ideally, you should assign a proper sequence # to beacon frames too.
(802.11-2007 7.1.3.4.1)

But as before, the long time between the upload and the actual beacon
xmit by the hardware make things really difficult. If you just call
"create_tx_desc_seq" right now, "theoretically" you have to buffer
all management and other Non-QoS data frames until the beacon was sent.

However, no one would do that :D. Either the hardware/firmware
controls the sequence counter or it's simply not implemented
(and nobody cares ;) ).




In fact, you could just as well drop "[09/17] zd1211rw: implement
seq_num for IEEE80211_TX_CTL_ASSIGN_SEQ"... unless of course, I'm
an idiot and there is a really clever way around these issues.

Regards,
	Chr
---

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c47d7c0..f71ed31 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -225,6 +225,7 @@ struct ieee80211_if_ap {
 	struct sk_buff_head ps_bc_buf;
 	atomic_t num_sta_ps; /* number of stations in PS mode */
 	int dtim_count;
+	bool dtim_bc_mc;
 };
 
 struct ieee80211_if_wds {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5950e3a..26b688b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2178,6 +2178,8 @@ static void ieee80211_beacon_add_tim(struct ieee80211_if_ap *bss,
 	if (bss->dtim_count == 0 && !skb_queue_empty(&bss->ps_bc_buf))
 		aid0 = 1;
 
+	bss->dtim_bc_mc = aid0 == 1;
+
 	if (have_bits) {
 		/* Find largest even number N1 so that bits numbered 1 through
 		 * (N1 x 8) - 1 in the bitmap are 0 and number N2 so that bits
@@ -2540,7 +2542,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	if (sdata->vif.type != NL80211_IFTYPE_AP || !beacon || !beacon->head)
 		goto out;
 
-	if (bss->dtim_count != 0)
+	if (bss->dtim_count != 0 || !bss->dtim_bc_mc)
 		goto out; /* send buffered bc/mc only after DTIM beacon */
 
 	while (1) {
