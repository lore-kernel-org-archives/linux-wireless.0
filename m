Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43131 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2K0IVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 03:21:23 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Fix buffer overflow error
Date: Tue, 27 Nov 2012 13:51:32 +0530
Message-ID: <1354004492-369-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121127_092127_975951_88F92068)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k: stomp audio profiles on weak signal
strength" failed to take care of new stomp type while
programming concurrent tx priority. That leads to array
index out of bounds access.

drivers/net/wireless/ath/ath9k/btcoex.c:414
        ath9k_hw_btcoex_set_concur_txprio()
               error: buffer overflow 'stomp_txprio' 4 <= 4

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 706378e..5c02702 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -257,8 +257,9 @@ static void ath_mci_set_concur_txprio(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_mci_profile *mci = &btcoex->mci;
-	u8 stomp_txprio[] = { 0, 0, 0, 0 }; /* all, low, none, low_ftp */
+	u8 stomp_txprio[ATH_BTCOEX_STOMP_MAX];
 
+	memset(stomp_txprio, 0, sizeof(stomp_txprio));
 	if (mci->num_mgmt) {
 		stomp_txprio[ATH_BTCOEX_STOMP_ALL] = ATH_MCI_INQUIRY_PRIO;
 		if (!mci->num_pan && !mci->num_other_acl)
-- 
1.8.0.1

