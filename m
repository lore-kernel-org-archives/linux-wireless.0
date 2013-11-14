Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53866 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab3KNKRm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 05:17:42 -0500
Message-ID: <21124.41527.258721.952015@gargle.gargle.HOWL> (sfid-20131114_111745_398008_49F00E13)
Date: Thu, 14 Nov 2013 15:43:11 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH] ath9k: fix SC_OP_INVALID test in ath9k_tx99_init()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

SC_OP_INVALID is zero so the test is always false.  We're supposed to be
testing the lowest bit instead.

Fixes: 89f927af7f33 ('ath9k: add TX99 support')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/ath/ath9k/tx99.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index 6668197..c65c37f 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -99,7 +99,7 @@ static int ath9k_tx99_init(struct ath_softc *sc)
 	struct ath_tx_control txctl;
 	int r;
 
-	if (sc->sc_flags & SC_OP_INVALID) {
+	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
 		ath_err(common,
 			"driver is in invalid state unable to use TX99");
 		return -EINVAL;
-- 
1.8.4.2

