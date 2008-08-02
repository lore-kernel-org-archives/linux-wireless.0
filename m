Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:8775 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbYHBKPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 06:15:47 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1578395ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 03:15:47 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH 14/19] orinoco: Split wevent work thread from wevent sending
Date: Sat,  2 Aug 2008 11:14:28 +0100
Message-Id: <1217672073-7094-15-git-send-email-kilroyd@gmail.com> (sfid-20080802_124544_221355_39BE7817)
In-Reply-To: <1217672073-7094-14-git-send-email-kilroyd@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-3-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-4-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-5-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-6-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-7-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-8-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-9-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-10-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-11-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-12-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-13-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-14-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to send more wevents from the work thread. We will need
to do this to support WPA.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/orinoco.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 013af6e..b91b6cb 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -1424,34 +1424,38 @@ static void orinoco_join_ap(struct work_struct *work)
 }
 
 /* Send new BSSID to userspace */
-static void orinoco_send_wevents(struct work_struct *work)
+static void orinoco_send_bssid_wevent(struct orinoco_private *priv)
 {
-	struct orinoco_private *priv =
-		container_of(work, struct orinoco_private, wevent_work);
 	struct net_device *dev = priv->ndev;
 	struct hermes *hw = &priv->hw;
 	union iwreq_data wrqu;
 	int err;
-	unsigned long flags;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return;
 
 	err = hermes_read_ltv(hw, IRQ_BAP, HERMES_RID_CURRENTBSSID,
 			      ETH_ALEN, NULL, wrqu.ap_addr.sa_data);
 	if (err != 0)
-		goto out;
+		return;
 
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 
 	/* Send event to user space */
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+}
+
+static void orinoco_send_wevents(struct work_struct *work)
+{
+	struct orinoco_private *priv =
+		container_of(work, struct orinoco_private, wevent_work);
+	unsigned long flags;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return;
+
+	orinoco_send_bssid_wevent(priv);
 
- out:
 	orinoco_unlock(priv, &flags);
 }
 
-
 static inline void orinoco_clear_scan_results(struct orinoco_private *priv,
 					      unsigned long scan_age)
 {
-- 
1.5.4.5

