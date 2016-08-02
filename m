Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5618 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbcHBLn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:43:58 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 7/8] wil6210: prevent usage of incorrect TX hwtail
Date: Tue,  2 Aug 2016 14:42:11 +0300
Message-Id: <1470138132-18071-8-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160802_194940_822878_941892FA)
In-Reply-To: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

txdata->enabled is used in order to determine if the TX vring
is valid. As the data transmit is handled in a different context,
in case txdata->enabled is set before vring->hwtail is updated,
an old or corrupted vring->hwtail can be used.
Protect setting of txdata->enabled and vring->hwtail to prevent a
case where TX vring start handling TX packets before setting
vring->hwtail.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index f2f6a40..4c38520 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -873,9 +873,12 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 		rc = -EINVAL;
 		goto out_free;
 	}
-	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
 
+	spin_lock_bh(&txdata->lock);
+	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
 	txdata->enabled = 1;
+	spin_unlock_bh(&txdata->lock);
+
 	if (txdata->dot1x_open && (agg_wsize >= 0))
 		wil_addba_tx_request(wil, id, agg_wsize);
 
@@ -950,9 +953,11 @@ int wil_vring_init_bcast(struct wil6210_priv *wil, int id, int size)
 		rc = -EINVAL;
 		goto out_free;
 	}
-	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
 
+	spin_lock_bh(&txdata->lock);
+	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
 	txdata->enabled = 1;
+	spin_unlock_bh(&txdata->lock);
 
 	return 0;
  out_free:
-- 
1.9.1

