Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:21779 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbYF1Sjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 14:39:32 -0400
Received: by nf-out-0910.google.com with SMTP id d3so259538nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 11:39:31 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [RFC PATCH 14/19] orinoco: Split wevent work thread from wevent sending
Date: Sat, 28 Jun 2008 19:38:20 +0100
Message-Id: <1214678305-7057-15-git-send-email-kilroyd@gmail.com> (sfid-20080628_210813_761139_32EAAFCE)
In-Reply-To: <1214678305-7057-14-git-send-email-kilroyd@gmail.com>
References: <1214678305-7057-1-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-2-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-3-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-4-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-5-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-6-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-7-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-8-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-9-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-10-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-11-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-12-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-13-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-14-git-send-email-kilroyd@gmail.com>
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
index 2cd144e..1ae78b0 100644
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

