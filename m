Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:56777 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbYLIV6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 16:58:08 -0500
Received: by nf-out-0910.google.com with SMTP id d3so45811nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2008 13:58:06 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 2/2] orinoco: Fix inappropriate use of IRQ_BAP
Date: Tue,  9 Dec 2008 21:46:29 +0000
Message-Id: <1228859189-12867-2-git-send-email-kilroyd@googlemail.com> (sfid-20081209_225813_407860_83A5D347)
In-Reply-To: <1228859189-12867-1-git-send-email-kilroyd@googlemail.com>
References: <1228859189-12867-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This hardware buffer should only be used from an interrupt. The
wireless event generation functions are called from a workqueue, so use
USER_BAP instead.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/orinoco.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 40f662e..b33e13f 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -1753,7 +1753,7 @@ static void orinoco_send_bssid_wevent(struct orinoco_private *priv)
 	union iwreq_data wrqu;
 	int err;
 
-	err = hermes_read_ltv(hw, IRQ_BAP, HERMES_RID_CURRENTBSSID,
+	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENTBSSID,
 			      ETH_ALEN, NULL, wrqu.ap_addr.sa_data);
 	if (err != 0)
 		return;
@@ -1776,7 +1776,7 @@ static void orinoco_send_assocreqie_wevent(struct orinoco_private *priv)
 	if (!priv->has_wpa)
 		return;
 
-	err = hermes_read_ltv(hw, IRQ_BAP, HERMES_RID_CURRENT_ASSOC_REQ_INFO,
+	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_ASSOC_REQ_INFO,
 			      sizeof(buf), NULL, &buf);
 	if (err != 0)
 		return;
@@ -1806,7 +1806,7 @@ static void orinoco_send_assocrespie_wevent(struct orinoco_private *priv)
 	if (!priv->has_wpa)
 		return;
 
-	err = hermes_read_ltv(hw, IRQ_BAP, HERMES_RID_CURRENT_ASSOC_RESP_INFO,
+	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_ASSOC_RESP_INFO,
 			      sizeof(buf), NULL, &buf);
 	if (err != 0)
 		return;
-- 
1.5.6.4

