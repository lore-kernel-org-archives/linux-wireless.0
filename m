Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13266 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbcEPTYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 15:24:10 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 2/6] wil6210: guarantee safe access to rx descriptors shared memory
Date: Mon, 16 May 2016 22:23:31 +0300
Message-Id: <1463426615-15523-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160516_212438_428818_FAE17F59)
In-Reply-To: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add memory barrier after allocating new rx descriptors, before
updating the hwtail.
This will guarantee that all writes to descriptors (shared memory)
are done before committing them to HW.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index fa6ea24..3909af1 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -544,6 +544,12 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
 			break;
 		}
 	}
+
+	/* make sure all writes to descriptors (shared memory) are done before
+	 * committing them to HW
+	 */
+	wmb();
+
 	wil_w(wil, v->hwtail, v->swtail);
 
 	return rc;
-- 
1.8.5.2

