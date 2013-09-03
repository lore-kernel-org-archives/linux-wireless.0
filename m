Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:63107 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759749Ab3ICIVh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 04:21:37 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v4 1/2] ath10k: update wal_dbg_tx_stats structure with missing parameter.
Date: Tue, 3 Sep 2013 10:21:20 +0200
Message-ID: <1378196481-13983-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20130903_102145_737086_4BAC44F9)
In-Reply-To: <1378196481-13983-1-git-send-email-bartosz.markowski@tieto.com>
References: <1378196481-13983-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The filed has been missing (missmatched with FW ABI)
since 1.0.0.629 firmware release.

It's very imporatant to keep these structs up to date with FW,
due to the arithmetic we use while read the fw_stats.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 08860c4..5b94707 100644
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

