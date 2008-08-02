Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:8775 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbYHBKOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 06:14:52 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1578395ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 03:14:51 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
Date: Sat,  2 Aug 2008 11:14:15 +0100
Message-Id: <1217672073-7094-2-git-send-email-kilroyd@gmail.com> (sfid-20080802_121454_383664_94CBE31F)
In-Reply-To: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
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
index b047306..e9dca96 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -2989,6 +2989,11 @@ static int orinoco_ioctl_getiwrange(struct net_device *dev,
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
@@ -3958,6 +3963,7 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 {
 	struct orinoco_private *priv = netdev_priv(dev);
 	hermes_t *hw = &priv->hw;
+	struct iw_scan_req *si = (struct iw_scan_req *) extra;
 	int err = 0;
 	unsigned long flags;
 
@@ -4019,7 +4025,19 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
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
1.5.4.5

