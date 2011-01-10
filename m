Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f66.google.com ([209.85.214.66]:47007 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab1AJTSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 14:18:53 -0500
Received: by bwz7 with SMTP id 7so7270059bwz.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 11:18:51 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Locking problem reported for mainline
Date: Mon, 10 Jan 2011 20:18:35 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <4D2A9309.7000500@lwfinger.net> <201101101913.17311.chunkeey@googlemail.com> <4D2B59EA.4000200@lwfinger.net>
In-Reply-To: <4D2B59EA.4000200@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101102018.35232.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 January 2011 20:11:38 Larry Finger wrote:
> On 01/10/2011 12:13 PM, Christian Lamparter wrote:
> > Does this patch help?
> > 
> > ---
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index a6701ed..8f13a83 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> 
> Did not compile. In ieee80211_release_reorder_frame at lines 552 and 554, rx is
> not defined.
> 
Oops,

you are right. Fixed the copy&paste error, so this one should compile.
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a6701ed..936b932 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -549,7 +549,9 @@ static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
 	tid_agg_rx->reorder_buf[index] = NULL;
 	status = IEEE80211_SKB_RXCB(skb);
 	status->rx_flags |= IEEE80211_RX_DEFERRED_RELEASE;
-	skb_queue_tail(&local->rx_skb_queue, skb);
+	spin_lock(&local->rx_skb_queue.lock);
+	__skb_queue_tail(&local->rx_skb_queue, skb);
+	spin_unlock(&local->rx_skb_queue.lock);
 
 no_frame:
 	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
@@ -780,7 +782,9 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 		return;
 
  dont_reorder:
-	skb_queue_tail(&local->rx_skb_queue, skb);
+	spin_lock(&local->rx_skb_queue.lock);
+	__skb_queue_tail(&local->rx_skb_queue, skb);
+	spin_unlock(&local->rx_skb_queue.lock);
 }
 
 static ieee80211_rx_result debug_noinline
