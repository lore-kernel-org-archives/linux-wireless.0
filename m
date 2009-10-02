Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:12657 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758177AbZJBUts (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org
Subject: [PATCH 01/13 v2.6.31, v2.6.32 and w-t] iwlwifi: incorrect method used for finding valid OTP blocks
Date: Fri,  2 Oct 2009 13:43:55 -0700
Message-Id: <1254516247-4085-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

The address stored in the next link address is a word address but when
reading the OTP blocks, a byte address is used. Also if the blocks are
full and the last link pointer is not zero, then none of the blocks are
valid so return an error.

The algorithm is simply valid blocks have a next address and that
address's contents is zero.

Using the wrong address for the next link address gets arbitrary data,
obviously. In cases seen, the first block is considered valid when it is not.

If the block has in fact been invalidated there may be old data or
there may be no data, bad data, or partial data, there is no way of
telling. Without this patch it is possible that a device with valid OTP data
is unable to work.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: stable@kernel.org
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 3d2b93a..e14c995 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -410,7 +410,6 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
 					u16 *validblockaddr)
 {
 	u16 next_link_addr = 0, link_value = 0, valid_addr;
-	int ret = 0;
 	int usedblocks = 0;
 
 	/* set addressing mode to absolute to traverse the link list */
@@ -430,29 +429,29 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
 		 * check for more block on the link list
 		 */
 		valid_addr = next_link_addr;
-		next_link_addr = link_value;
+		next_link_addr = link_value * sizeof(u16);
 		IWL_DEBUG_INFO(priv, "OTP blocks %d addr 0x%x\n",
 			       usedblocks, next_link_addr);
 		if (iwl_read_otp_word(priv, next_link_addr, &link_value))
 			return -EINVAL;
 		if (!link_value) {
 			/*
-			 * reach the end of link list,
+			 * reach the end of link list, return success and
 			 * set address point to the starting address
 			 * of the image
 			 */
-			goto done;
+			*validblockaddr = valid_addr;
+			/* skip first 2 bytes (link list pointer) */
+			*validblockaddr += 2;
+			return 0;
 		}
 		/* more in the link list, continue */
 		usedblocks++;
-	} while (usedblocks < priv->cfg->max_ll_items);
-	/* OTP full, use last block */
-	IWL_DEBUG_INFO(priv, "OTP is full, use last block\n");
-done:
-	*validblockaddr = valid_addr;
-	/* skip first 2 bytes (link list pointer) */
-	*validblockaddr += 2;
-	return ret;
+	} while (usedblocks <= priv->cfg->max_ll_items);
+
+	/* OTP has no valid blocks */
+	IWL_DEBUG_INFO(priv, "OTP has no valid blocks\n");
+	return -EINVAL;
 }
 
 /**
-- 
1.5.6.3

