Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43988 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2LCS6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 13:58:53 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1242960bkw.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 10:58:52 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 3 Dec 2012 18:48:05 +0100
Subject: [PATCH] carl9170: explain why sta cannot be NULL for ampdus
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, dan.carpenter@oracle.com
Message-Id: <20121203185838.E2A80100286@blech.mobile> (sfid-20121203_195857_426662_57ABFDAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter reported that smatch detected a potential
problem with the code [1]:
 drivers/net/wireless/ath/carl9170/tx.c:1488 carl9170_op_tx()
  error: we previously assumed 'sta' could be null (see line 1482)

 drivers/net/wireless/ath/carl9170/tx.c
  1482  if (sta) {
           ^^^^^ New check.
  [...]
  1485  }
  1487  if (info->flags & IEEE80211_TX_CTL_AMPDU) {
  1488    run = carl9170_tx_ampdu_queue(ar, sta, skb);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   Old dereference of "sta" inside the call to carl9170_tx_ampdu_queue().

A range of solutions have been discussed in [2] and
we agreed on the following: "
> we might as well add a comment to carl9170_tx_ampdu_queue
> and explain the situation [in a way that's obvious to a
> human reader]. This way we can save the "if"... which is
> a small win since carl9170_op_tx is sort of a hot-path.
Putting a comment there is fine. Without the comment
it's easy for a human reader to get confused why the
check is there. So long as humans can read the code,
that's all that matters."

[1] <http://www.spinics.net/lists/linux-wireless/msg94526.html>
[2] <http://www.spinics.net/lists/linux-kernel-janitors/msg14953.html>

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/tx.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 6a86814..45c696b 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1485,6 +1485,13 @@ void carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+		/* to static code analyzers and reviewers:
+		 * mac80211 guarantees that a valid "sta"
+		 * reference is present, if a frame is to
+		 * be part of an ampdu. Hence any extra
+		 * sta == NULL checks are redundant in this
+		 * special case.
+		 */
 		run = carl9170_tx_ampdu_queue(ar, sta, skb);
 		if (run)
 			carl9170_tx_ampdu(ar);
-- 
1.7.10.4

