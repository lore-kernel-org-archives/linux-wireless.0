Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:58253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759042AbYHUW2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:28:14 -0400
Received: by nf-out-0910.google.com with SMTP id d3so81281nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:28:13 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 01/19] orinoco: Add ESSID specific scanning for Agere fw
Date: Thu, 21 Aug 2008 23:27:46 +0100
Message-Id: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com> (sfid-20080822_002817_862023_E19D2409)
In-Reply-To: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass the ESSID to the card.

This allows 'iwlist eth1 scan essid <essid>' to work, and will help
with routers setup not to broadcast the ESSID.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/orinoco.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 1ebcafe..a60b459 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -2982,6 +2982,11 @@ static int orinoco_ioctl_getiwrange(struct net_device *dev,
 	range->min_r_time = 0;
 	range->max_r_time = 65535 * 1000;	/* ??? */
 
+	if (priv->firmware_type == FIRMWARE_TYPE_AGERE)
+		range->scan_capa = IW_SCAN_CAPA_ESSID;
+	else
+		range->scan_capa = IW_SCAN_CAPA_NONE;
+
 	/* Event capability (kernel) */
 	IW_EVENT_CAPA_SET_KERNEL(range->event_capa);
 	/* Event capability (driver) */
@@ -3951,6 +3956,7 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 {
 	struct orinoco_private *priv = netdev_priv(dev);
 	hermes_t *hw = &priv->hw;
+	struct iw_scan_req *si = (struct iw_scan_req *) extra;
 	int err = 0;
 	unsigned long flags;
 
@@ -4012,7 +4018,19 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 		}
 		break;
 		case FIRMWARE_TYPE_AGERE:
-			err = hermes_write_wordrec(hw, USER_BAP,
+			if (priv->scan_mode & IW_SCAN_THIS_ESSID) {
+				struct hermes_idstring idbuf;
+				size_t len = min(sizeof(idbuf.val),
+						 (size_t) si->essid_len);
+				idbuf.len = cpu_to_le16(len);
+				memcpy(idbuf.val, si->essid, len);
+
+				err = hermes_write_ltv(hw, USER_BAP,
+					       HERMES_RID_CNFSCANSSID_AGERE,
+					       HERMES_BYTES_TO_RECLEN(len + 2),
+					       &idbuf);
+			} else
+				err = hermes_write_wordrec(hw, USER_BAP,
 						   HERMES_RID_CNFSCANSSID_AGERE,
 						   0);	/* Any ESSID */
 			if (err)
-- 
1.5.6.4

