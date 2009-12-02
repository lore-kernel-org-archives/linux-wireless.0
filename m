Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65310 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbZLBOaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 09:30:15 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so217224bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 06:30:22 -0800 (PST)
Message-Id: <20091202142948.722150433@gmail.com>
References: <20091202142555.654873300@gmail.com>
Date: Wed, 02 Dec 2009 15:26:03 +0100
From: Holger Schurig <holgerschurig@googlemail.com>
To: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 08/10] libertas: remove priv->capability
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This variable was once set to WLAN_CAPABILITY_SHORT_PREAMBLE and
there's no code that could change the variable to something else.
Therefore it seems this is not necessary :-)

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---
v2: forgot to remove "capability" it from struct lbs_private

--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -175,7 +175,6 @@ struct lbs_private {
 	struct bss_descriptor *networks;
 	struct assoc_request * pending_assoc_req;
 	struct assoc_request * in_progress_assoc_req;
-	u16 capability;
 	uint16_t enablehwauto;
 	uint16_t ratebitmap;
 
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.c
+++ linux-wl/drivers/net/wireless/libertas/assoc.c
@@ -807,8 +807,7 @@ static int lbs_try_associate(struct lbs_
 	}
 
 	/* Use short preamble only when both the BSS and firmware support it */
-	if ((priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) &&
-	    (assoc_req->bss.capability & WLAN_CAPABILITY_SHORT_PREAMBLE))
+	if (assoc_req->bss.capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
 		preamble = RADIO_PREAMBLE_SHORT;
 
 	ret = lbs_set_radio(priv, preamble, 1);
@@ -939,8 +938,7 @@ static int lbs_adhoc_join(struct lbs_pri
 	}
 
 	/* Use short preamble only when both the BSS and firmware support it */
-	if ((priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) &&
-	    (bss->capability & WLAN_CAPABILITY_SHORT_PREAMBLE)) {
+	if (bss->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) {
 		lbs_deb_join("AdhocJoin: Short preamble\n");
 		preamble = RADIO_PREAMBLE_SHORT;
 	}
@@ -1049,7 +1047,7 @@ static int lbs_adhoc_start(struct lbs_pr
 	struct assoc_request *assoc_req)
 {
 	struct cmd_ds_802_11_ad_hoc_start cmd;
-	u8 preamble = RADIO_PREAMBLE_LONG;
+	u8 preamble = RADIO_PREAMBLE_SHORT;
 	size_t ratesize = 0;
 	u16 tmpcap = 0;
 	int ret = 0;
@@ -1057,11 +1055,6 @@ static int lbs_adhoc_start(struct lbs_pr
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	if (priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) {
-		lbs_deb_join("ADHOC_START: Will use short preamble\n");
-		preamble = RADIO_PREAMBLE_SHORT;
-	}
-
 	ret = lbs_set_radio(priv, preamble, 1);
 	if (ret)
 		goto out;
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -842,9 +842,6 @@ int lbs_set_radio(struct lbs_private *pr
 	if (priv->fwrelease < 0x09000000) {
 		switch (preamble) {
 		case RADIO_PREAMBLE_SHORT:
-			if (!(priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE))
-				goto out;
-			/* Fall through */
 		case RADIO_PREAMBLE_AUTO:
 		case RADIO_PREAMBLE_LONG:
 			cmd.control = cpu_to_le16(preamble);
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -839,7 +839,6 @@ static int lbs_init_adapter(struct lbs_p
 	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
 	priv->radio_on = 1;
 	priv->enablehwauto = 1;
-	priv->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
 	priv->psmode = LBS802_11POWERMODECAM;
 	priv->psstate = PS_STATE_FULL_POWER;
 	priv->is_deep_sleep = 0;

-- 
