Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:17943 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbYHBKQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 06:16:00 -0400
Received: by nf-out-0910.google.com with SMTP id d3so537527nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 03:16:00 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH 17/19] orinoco: Send association events to userspace
Date: Sat,  2 Aug 2008 11:14:31 +0100
Message-Id: <1217672073-7094-18-git-send-email-kilroyd@gmail.com> (sfid-20080802_124548_049594_B7C5BC8C)
In-Reply-To: <1217672073-7094-17-git-send-email-kilroyd@gmail.com>
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
 <1217672073-7094-15-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-16-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-17-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/orinoco.c |   62 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 7054c80..300920e 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -1443,6 +1443,66 @@ static void orinoco_send_bssid_wevent(struct orinoco_private *priv)
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 }
 
+static void orinoco_send_assocreqie_wevent(struct orinoco_private *priv)
+{
+	struct net_device *dev = priv->ndev;
+	struct hermes *hw = &priv->hw;
+	union iwreq_data wrqu;
+	int err;
+	u8 buf[88];
+	u8 *ie;
+
+	if (!priv->has_wpa)
+		return;
+
+	err = hermes_read_ltv(hw, IRQ_BAP, HERMES_RID_CURRENT_ASSOC_REQ_INFO,
+			      sizeof(buf), NULL, &buf);
+	if (err != 0)
+		return;
+
+	ie = orinoco_get_wpa_ie(buf, sizeof(buf));
+	if (ie) {
+		int rem = sizeof(buf) - (ie - &buf[0]);
+		wrqu.data.length = ie[1] + 2;
+		if (wrqu.data.length > rem)
+			wrqu.data.length = rem;
+
+		if (wrqu.data.length)
+			/* Send event to user space */
+			wireless_send_event(dev, IWEVASSOCREQIE, &wrqu, ie);
+	}
+}
+
+static void orinoco_send_assocrespie_wevent(struct orinoco_private *priv)
+{
+	struct net_device *dev = priv->ndev;
+	struct hermes *hw = &priv->hw;
+	union iwreq_data wrqu;
+	int err;
+	u8 buf[88]; /* TODO: verify max size or IW_GENERIC_IE_MAX */
+	u8 *ie;
+
+	if (!priv->has_wpa)
+		return;
+
+	err = hermes_read_ltv(hw, IRQ_BAP, HERMES_RID_CURRENT_ASSOC_RESP_INFO,
+			      sizeof(buf), NULL, &buf);
+	if (err != 0)
+		return;
+
+	ie = orinoco_get_wpa_ie(buf, sizeof(buf));
+	if (ie) {
+		int rem = sizeof(buf) - (ie - &buf[0]);
+		wrqu.data.length = ie[1] + 2;
+		if (wrqu.data.length > rem)
+			wrqu.data.length = rem;
+
+		if (wrqu.data.length)
+			/* Send event to user space */
+			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, ie);
+	}
+}
+
 static void orinoco_send_wevents(struct work_struct *work)
 {
 	struct orinoco_private *priv =
@@ -1452,6 +1512,8 @@ static void orinoco_send_wevents(struct work_struct *work)
 	if (orinoco_lock(priv, &flags) != 0)
 		return;
 
+	orinoco_send_assocreqie_wevent(priv);
+	orinoco_send_assocrespie_wevent(priv);
 	orinoco_send_bssid_wevent(priv);
 
 	orinoco_unlock(priv, &flags);
-- 
1.5.4.5

