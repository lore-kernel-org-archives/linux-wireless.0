Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53321 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbXLETA5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 14:00:57 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/3] iwlwifi: fix compliation warnings
Date: Wed,  5 Dec 2007 20:59:58 +0200
Message-Id: <1196881200305-git-send-email-tomas.winkler@intel.com> (sfid-20071205_190111_294399_9A8713FD)
In-Reply-To: <1196881199774-git-send-email-tomas.winkler@intel.com>
References: <1196881199774-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes compilation warnings introduced by 'fix ucode assertion
for RX queue overrun' patch

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 147ee5b..cbfbe90 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4163,7 +4163,7 @@ static void iwl3945_rx_allocate(struct iwl3945_priv *priv)
 /*
  * this should be called while priv->lock is locked
  */
-void __iwl3945_rx_replenish(void *data)
+static void __iwl3945_rx_replenish(void *data)
 {
 	struct iwl3945_priv *priv = data;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index ba85205..14fccd6 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4534,7 +4534,7 @@ static void iwl4965_rx_allocate(struct iwl4965_priv *priv)
 /*
  * this should be called while priv->lock is locked
 */
-void __iwl4965_rx_replenish(void *data)
+static void __iwl4965_rx_replenish(void *data)
 {
 	struct iwl4965_priv *priv = data;
 
@@ -6036,7 +6036,7 @@ static void iwl4965_dealloc_ucode_pci(struct iwl4965_priv *priv)
  * iwl4965_verify_inst_full - verify runtime uCode image in card vs. host,
  *     looking at all data.
  */
-static int iwl4965_verify_inst_full(struct iwl4965_priv *priv, __le32 * image,
+static int iwl4965_verify_inst_full(struct iwl4965_priv *priv, __le32 *image,
 				 u32 len)
 {
 	u32 val;
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
