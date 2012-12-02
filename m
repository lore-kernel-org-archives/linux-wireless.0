Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51055 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab2LBUZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 15:25:09 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] carl9170: remove unneeded NULL check
Date: Sun, 2 Dec 2012 21:24:53 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20121202104238.GB16078@elgon.mountain> <201212021449.21267.chunkeey@googlemail.com> <20121202165153.GC6517@mwanda>
In-Reply-To: <20121202165153.GC6517@mwanda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201212022124.53838.chunkeey@googlemail.com> (sfid-20121202_213311_313752_38A322B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, December 02, 2012 05:51:53 PM Dan Carpenter wrote:
> On Sun, Dec 02, 2012 at 02:49:20PM +0100, Christian Lamparter wrote:
> > On Sunday 02 December 2012 11:42:38 Dan Carpenter wrote:
> > > The "sta" variable is not checked for NULL consistently and it makes the
> > > static checkers complain.  I asked Christian Lamparter about this and
> > > it turns out the check is not needed.  "In fact, in order to set up a
> > > ampdu session, the stack would call the driver's op_ampdu_action
> > > callback which always needs a station."
> > 
> > that would be from the thread:
> > <http://www.spinics.net/lists/linux-wireless/msg94526.html>
> >  
> > > I have removed the check.
> > I think this will bug for multicast and injected frames.
> >  
> > It is not possible for the sta(tion) pointer to be NULL if
> > the frame has the IEEE80211_TX_CTL_AMPDU flag set. So the
> > sta == NULL check can be avoided when calling 
> > carl9170_tx_ampdu_queue. This is because mac80211 tracks
> > all aggregation sessions within the station struct.
> > Of course, this is something that the checker tool can't
> > possibly deduce, but it has a point and we can add a check
> > like this [see attached draft patch]:
> > 
> > What do you think [or more to the point: what does the
> > checker say?]
> > 
> 
> So we wouldn't apply my patch, we would apply that one instead?
We could, but that's up for debate (no, I don't think we are done
just yet).

> I think that's great.  My static checker doesn't understand bit
> flags yet so it would complain but it would be obvious to a human
> reader.
then we might as well add a comment to carl9170_tx_ampdu_queue
and explain the situation [in a way that's obvious to a
human reader]. This way we can save the "if"... which is a small
win since carl9170_op_tx is sort of a hot-path.
 
> Could you just resend that patch with a signed-off-by?
Once we know what to do... yes :)
I have attached another patch. With this patch the checker
should be able to read the code without throwing any
warnings.

Regards,
	Chr
---
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 84377cf..6c83328 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1463,13 +1463,16 @@ void carl9170_op_tx(struct ieee80211_hw *hw,
 	struct ar9170 *ar = hw->priv;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sta *sta = control->sta;
-	bool run;
+	bool run, aggr;
 
 	if (unlikely(!IS_STARTED(ar)))
 		goto err_free;
 
 	info = IEEE80211_SKB_CB(skb);
 
+	aggr = !!(info->flags & IEEE80211_TX_CTL_AMPDU) &&
+		!WARN_ON_ONCE(!sta);
+
 	if (unlikely(carl9170_tx_prepare(ar, sta, skb)))
 		goto err_free;
 
@@ -1484,7 +1487,7 @@ void carl9170_op_tx(struct ieee80211_hw *hw,
 		atomic_inc(&stai->pending_frames);
 	}
 
-	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+	if (aggr) {
 		run = carl9170_tx_ampdu_queue(ar, sta, skb);
 		if (run)
 			carl9170_tx_ampdu(ar);
