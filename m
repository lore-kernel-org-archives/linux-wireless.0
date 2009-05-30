Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56827 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763392AbZE3Rhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:46 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so6938274ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:48 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 13/23] orinoco: Change set_tkip to use orinoco_private instead of hermes_t
Date: Sat, 30 May 2009 18:36:47 +0100
Message-Id: <1243705017-8784-14-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hw.h does not include hermes.h, and none of the other functions
requires types from that file. Also hermes_t is a (discouraged) typedef
so we can't add a forward declaration. Therefore change this function to
use orinoco_private.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hw.c   |    5 +++--
 drivers/net/wireless/orinoco/hw.h   |    4 ++--
 drivers/net/wireless/orinoco/wext.c |    3 +--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 4a26d68..eaa89d3 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -677,8 +677,8 @@ int __orinoco_hw_setup_enc(struct orinoco_private *priv)
  * rsc must be 8 bytes
  * tsc must be 8 bytes or NULL
  */
-int __orinoco_hw_set_tkip_key(hermes_t *hw, int key_idx, int set_tx,
-			      u8 *key, u8 *rsc, u8 *tsc)
+int __orinoco_hw_set_tkip_key(struct orinoco_private *priv, int key_idx,
+			      int set_tx, u8 *key, u8 *rsc, u8 *tsc)
 {
 	struct {
 		__le16 idx;
@@ -688,6 +688,7 @@ int __orinoco_hw_set_tkip_key(hermes_t *hw, int key_idx, int set_tx,
 		u8 rx_mic[MIC_KEYLEN];
 		u8 tsc[IW_ENCODE_SEQ_MAX_SIZE];
 	} __attribute__ ((packed)) buf;
+	hermes_t *hw = &priv->hw;
 	int ret;
 	int err;
 	int k;
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index 89277de..84c108c 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -35,8 +35,8 @@ int orinoco_hw_get_act_bitrate(struct orinoco_private *priv, int *bitrate);
 int __orinoco_hw_set_wap(struct orinoco_private *priv);
 int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv);
 int __orinoco_hw_setup_enc(struct orinoco_private *priv);
-int __orinoco_hw_set_tkip_key(hermes_t *hw, int key_idx, int set_tx,
-			      u8 *key, u8 *rsc, u8 *tsc);
+int __orinoco_hw_set_tkip_key(struct orinoco_private *priv, int key_idx,
+			      int set_tx, u8 *key, u8 *rsc, u8 *tsc);
 int orinoco_clear_tkip_key(struct orinoco_private *priv, int key_idx);
 int __orinoco_hw_set_multicast_list(struct orinoco_private *priv,
 				    struct dev_addr_list *mc_list,
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 3f08142..74fdfce 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -1079,7 +1079,6 @@ static int orinoco_ioctl_set_encodeext(struct net_device *dev,
 
 		case IW_ENCODE_ALG_TKIP:
 		{
-			hermes_t *hw = &priv->hw;
 			u8 *tkip_iv = NULL;
 
 			if (!priv->has_wpa ||
@@ -1094,7 +1093,7 @@ static int orinoco_ioctl_set_encodeext(struct net_device *dev,
 			if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID)
 				tkip_iv = &ext->rx_seq[0];
 
-			err = __orinoco_hw_set_tkip_key(hw, idx,
+			err = __orinoco_hw_set_tkip_key(priv, idx,
 				 ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY,
 				 (u8 *) &priv->tkip_key[idx],
 				 tkip_iv, NULL);
-- 
1.6.0.6

