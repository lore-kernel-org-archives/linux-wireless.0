Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:51856 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZKZLrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 06:47:07 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH, v2] libertas: remove priv->capability
Date: Thu, 26 Nov 2009 12:46:56 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
References: <200911261241.46405.holgerschurig@gmail.com>
In-Reply-To: <200911261241.46405.holgerschurig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911261246.56786.holgerschurig@gmail.com>
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
http://www.holgerschurig.de
