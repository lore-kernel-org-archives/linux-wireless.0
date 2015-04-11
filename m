Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35188 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbbDKXr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Apr 2015 19:47:57 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] staging: vt6655: Fix TX retransmission race condition
Date: Sun, 12 Apr 2015 00:47:22 +0100
Message-Id: <1428796042-3390-1-git-send-email-tvboxspy@gmail.com> (sfid-20150412_014809_615097_5B193991)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With high tx flow the same buffer can transmit  more than
once and get stuck in loop.

Reset TCR to zero in device_tx_srv.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.19+
---
 drivers/staging/vt6655/device_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c5f8233..9b5d840 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -963,6 +963,9 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 			vnt_int_report_rate(pDevice, pTD->pTDInfo, byTsr0, byTsr1);
 
 			device_free_tx_buf(pDevice, pTD);
+
+			/* Done with TCR reset to avoid retransmission */
+			pTD->m_td1TD1.byTCR = 0;
 			pDevice->iTDUsed[uIdx]--;
 		}
 	}
-- 
2.1.0

