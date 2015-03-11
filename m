Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:41107 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbbCKNj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 09:39:28 -0400
Received: by lbvp9 with SMTP id p9so8873622lbv.8
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2015 06:39:27 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: protect driver from unsolicited htc ep0 events
Date: Wed, 11 Mar 2015 14:37:11 +0100
Message-Id: <1426081031-15296-1-git-send-email-michal.kazior@tieto.com> (sfid-20150311_143932_194398_2819BC8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some firmware revisions (tested with qca6174
rm2.0-00088) deliver unsolicited unknown (kind of
garbled) HTC ep0 event to host in some cases.

This issue was mainly observed with both qca988x
and qca6174 being installed on a single host
system. During driver probing if qca6174 booting
sequences were somehow deferred (e.g. by qca988x
implicitly making some resources busy presumably)
the unsolicited event would came around 1s after
ATH10K_HTC_MSG_READY_ID was delivered to host for
qca6174.

The unsolicited event would confuse driver and
cause HTT initialization (and subsequently
driver probing) to fail.

Make the ep0 event processing more robust. The
event will still be caught but instead will
only generate a warning now.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 2fd9e18..d33d5c4 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -414,7 +414,8 @@ static int ath10k_htc_rx_completion_handler(struct ath10k *ar,
 		struct ath10k_htc_msg *msg = (struct ath10k_htc_msg *)skb->data;
 
 		switch (__le16_to_cpu(msg->hdr.message_id)) {
-		default:
+		case ATH10K_HTC_MSG_READY_ID:
+		case ATH10K_HTC_MSG_CONNECT_SERVICE_RESP_ID:
 			/* handle HTC control message */
 			if (completion_done(&htc->ctl_resp)) {
 				/*
@@ -438,6 +439,10 @@ static int ath10k_htc_rx_completion_handler(struct ath10k *ar,
 			break;
 		case ATH10K_HTC_MSG_SEND_SUSPEND_COMPLETE:
 			htc->htc_ops.target_send_suspend_complete(ar);
+			break;
+		default:
+			ath10k_warn(ar, "ignoring unsolicited htc ep0 event\n");
+			break;
 		}
 		goto out;
 	}
-- 
1.8.5.3

