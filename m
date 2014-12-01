Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12961 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaLANgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 08:36:24 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 7/9] wil6210: Rate limit "ring full" error message
Date: Mon, 1 Dec 2014 15:36:03 +0200
Message-ID: <1417440963-27304-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141201_143627_700257_5AFD6422)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the wil_tx_ring, error message printed when tx attempted
while vring has no space to accommodate all fragments of frame.
Normally, such situation handled by stopping tx queue.
But, if tx queue is by-passed (like pktgen does), this error
will be triggered at high rate and dmesg will be flooded with
this message. Whole system may become unstable and hang with
no possible recover except power cycle.

Rate-limit it to prevent dmesg flooding.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index c3a5489..405ede6 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -928,8 +928,9 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	wil_dbg_txrx(wil, "%s()\n", __func__);
 
 	if (avail < 1 + nr_frags) {
-		wil_err(wil, "Tx ring full. No space for %d fragments\n",
-			1 + nr_frags);
+		wil_err_ratelimited(wil,
+				    "Tx ring full. No space for %d fragments\n",
+				    1 + nr_frags);
 		return -ENOMEM;
 	}
 	_d = &vring->va[i].tx;
-- 
2.1.0

