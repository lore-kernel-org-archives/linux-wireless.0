Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40709 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab0KJSBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/16] iwlwlifi: update rx write pointer w/o request mac access in the CAM mode
Date: Wed, 10 Nov 2010 09:56:42 -0800
Message-Id: <1289411810-23093-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

In iwl_rx_queue_update_write_ptr function
replace iwl_write_direct32 with iwl_write32 when not in power save mode.
We don't have to go through grab nic access as the NIC is already awake.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index f436270..baca4cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -153,7 +153,7 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q
 	} else {
 		/* Device expects a multiple of 8 */
 		q->write_actual = (q->write & ~0x7);
-		iwl_write_direct32(priv, rx_wrt_ptr_reg, q->write_actual);
+		iwl_write32(priv, rx_wrt_ptr_reg, q->write_actual);
 	}
 
 	q->need_update = 0;
-- 
1.7.0.4

