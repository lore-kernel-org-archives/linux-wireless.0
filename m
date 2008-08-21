Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:58253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978AbYHUW3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:29:16 -0400
Received: by nf-out-0910.google.com with SMTP id d3so81281nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:29:16 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 14/19] orinoco: Split wevent work thread from wevent sending
Date: Thu, 21 Aug 2008 23:28:00 +0100
Message-Id: <bbb15e90927ee20492ec6d76000ee6b95ce69bd9.1219352676.git.kilroyd@gmail.com> (sfid-20080822_005043_417016_E8E0A495)
In-Reply-To: <09ee16c27766ca779c63a0e82df7e4aa723f4fdf.1219352676.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
 <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
 <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com>
 <ac0da2799e97f5256019ad669f5a6c461bd0d82a.1219352674.git.kilroyd@gmail.com>
 <d792f6b1d5853becf1b1488e6572a4c3244eb769.1219352674.git.kilroyd@gmail.com>
 <6c4f63d9cc1bec763719e18ea8282919b6604503.1219352674.git.kilroyd@gmail.com>
 <9a54acb1147a2c0a7c1cf9b07b9ac756366d0877.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <347f1ce011aaeeb9b4d8f805fdfb6eb58fc467ca.1219352675.git.kilroyd@gmail.com>
 <5e42f22bf794bbefae50fa2a3e5b4ff6e36c7096.1219352675.git.kilroyd@gmail.com>
 <dc5df8328be19728aec203304d9c265368c2b876.1219352675.git.kilroyd@gmail.com>
 <09ee16c27766ca779c63a0e82df7e4aa723f4fdf.1219352676.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
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
index b853ba0..21bed6c 100644
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
1.5.6.4

