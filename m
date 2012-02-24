Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17248 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab2BXGHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 01:07:52 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 3/3] ath9k: handle invalid/error in processing tx descriptors
Date: Fri, 24 Feb 2012 11:37:21 +0530
Message-ID: <1330063641-4524-3-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120224_070754_529935_A61AC4C5)
In-Reply-To: <1330063641-4524-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1330063641-4524-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

for EDMA based chipsets there are few more errors/invalid conditions to
be handled when processing tx descriptors apart from descriptor
processing incomplete.
based on the commit dcfcbd590d91e8385eb554aaed419bdebaf4c72a
ENOENT error happened in ad-hoc mode during the invocation of
drv_last_beacon

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c81304d..e5f366f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2341,6 +2341,9 @@ static int ath9k_tx_last_beacon(struct ieee80211_hw *hw)
 		if (status == -EINPROGRESS)
 			goto skip;
 
+		if (status == -EIO || status == -ENOENT)
+			goto skip;
+
 		sc->beacon.tx_processed = true;
 		sc->beacon.tx_last = !(ts.ts_status & ATH9K_TXERR_MASK);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3182408..8330a82 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2290,7 +2290,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 			break;
 
 		status = ath9k_hw_txprocdesc(ah, NULL, (void *)&ts);
-		if (status == -EINPROGRESS)
+		if (status == -EINPROGRESS || status == -ENOENT)
 			break;
 		if (status == -EIO) {
 			ath_dbg(common, XMIT, "Error processing tx status\n");
-- 
1.7.0.4

