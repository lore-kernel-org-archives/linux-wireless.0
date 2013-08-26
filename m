Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:53936 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700Ab3HZLsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 07:48:54 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 2/3] ath10k: update wal_dbg_tx_stats structure
Date: Mon, 26 Aug 2013 13:33:33 +0200
Message-ID: <1377516815-12660-3-git-send-email-bartosz.markowski@tieto.com> (sfid-20130826_134858_016474_A3963260)
In-Reply-To: <1377516815-12660-1-git-send-email-bartosz.markowski@tieto.com>
References: <1377516815-12660-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing parameters. It's very imporatant to keep
these structs up to date with FW abi, due to the arithmetic we
use while read the fw_stats.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1747631..6366600 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1767,6 +1767,9 @@ struct wal_dbg_tx_stats {
 	/* wal pdev resets  */
 	__le32 pdev_resets;
 
+	/* frames dropped due to non-availability of stateless TIDs */
+	__le32 stateless_tid_alloc_failure;
+
 	__le32 phy_underrun;
 
 	/* MPDU is more than txop limit */
-- 
1.7.10

