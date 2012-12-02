Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54182 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2LBNt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 08:49:27 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] carl9170: remove unneeded NULL check
Date: Sun, 2 Dec 2012 14:49:20 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20121202104238.GB16078@elgon.mountain>
In-Reply-To: <20121202104238.GB16078@elgon.mountain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201212021449.21267.chunkeey@googlemail.com> (sfid-20121202_144933_267265_7B30969D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 02 December 2012 11:42:38 Dan Carpenter wrote:
> The "sta" variable is not checked for NULL consistently and it makes the
> static checkers complain.  I asked Christian Lamparter about this and
> it turns out the check is not needed.  "In fact, in order to set up a
> ampdu session, the stack would call the driver's op_ampdu_action
> callback which always needs a station."

that would be from the thread:
<http://www.spinics.net/lists/linux-wireless/msg94526.html>
 
> I have removed the check.
I think this will bug for multicast and injected frames.
 
It is not possible for the sta(tion) pointer to be NULL if
the frame has the IEEE80211_TX_CTL_AMPDU flag set. So the
sta == NULL check can be avoided when calling 
carl9170_tx_ampdu_queue. This is because mac80211 tracks
all aggregation sessions within the station struct.
Of course, this is something that the checker tool can't
possibly deduce, but it has a point and we can add a check
like this [see attached draft patch]:

What do you think [or more to the point: what does the
checker say?]

Regards,
	Chr
---
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 84377cf..e09d293 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1470,6 +1470,9 @@ void carl9170_op_tx(struct ieee80211_hw *hw,
 
 	info = IEEE80211_SKB_CB(skb);
 
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && WARN_ON_ONCE(!sta))
+		goto err_free;
+
 	if (unlikely(carl9170_tx_prepare(ar, sta, skb)))
 		goto err_free;
 

