Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49213 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaCXICQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 04:02:16 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so5080035pab.22
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 01:02:15 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath10k: update wal_dbg_tx_stats structure with missing parameter
Date: Mon, 24 Mar 2014 16:02:02 +0800
Message-Id: <1395648122-2125-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140324_090221_705511_F7D8B916)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is introduced by Bartosz Markowski but never upstream.
By using this patch, 636 firmware is able to print out the peer
stats correctly and have caused no regression to the latest AP
firmware as well.

The original patch from Bartosz Markowski can be found at:
http://lists.infradead.org/pipermail/ath10k/2013-September/000318.html

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 2b2f0b7..d1275a3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2685,6 +2685,9 @@ struct wal_dbg_tx_stats {
 	/* wal pdev resets  */
 	__le32 pdev_resets;
 
+	/* frames dropped due to non-availability of stateless TIDs */
+	__le32 stateless_tid_alloc_failure;
+
 	__le32 phy_underrun;
 
 	/* MPDU is more than txop limit */
-- 
1.7.9.5

