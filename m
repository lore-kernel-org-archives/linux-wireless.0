Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13606 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbJLIAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 04:00:31 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 36/41] staging: wilc1000: rename strHostIFpmkidAttr of union host_if_key_attr
Date: Mon, 12 Oct 2015 16:56:10 +0900
Message-ID: <1444636575-2486-36-git-send-email-tony.cho@atmel.com> (sfid-20151012_100038_418349_A2FB083F)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIFpmkidAttr of union host_if_key_attr to
pmkid to avoid CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 83818b8..3437d8c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -128,7 +128,7 @@ struct host_if_wep_attr {
 union host_if_key_attr {
 	struct host_if_wep_attr wep;
 	struct host_if_wpa_attr wpa;
-	struct host_if_pmkid_attr strHostIFpmkidAttr;
+	struct host_if_pmkid_attr pmkid;
 };
 
 /*!
@@ -2649,24 +2649,24 @@ _WPAPtk_end_case_:
 
 		PRINT_D(HOSTINF_DBG, "Handling PMKSA key\n");
 
-		pu8keybuf = kmalloc((pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
+		pu8keybuf = kmalloc((pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
 		if (pu8keybuf == NULL) {
 			PRINT_ER("No buffer to send PMKSA Key\n");
 			return -1;
 		}
 
-		pu8keybuf[0] = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid;
+		pu8keybuf[0] = pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.numpmkid;
 
-		for (i = 0; i < pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid; i++) {
+		for (i = 0; i < pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.numpmkid; i++) {
 
-			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + 1), pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, ETH_ALEN);
-			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, PMKID_LEN);
+			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + 1), pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
+			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
 		}
 
 		strWID.id = (u16)WID_PMKID_INFO;
 		strWID.type = WID_STR;
 		strWID.val = (s8 *)pu8keybuf;
-		strWID.size = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
+		strWID.size = (pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 					   get_id_from_handler(hif_drv));
@@ -4518,10 +4518,10 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
 
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.pmkid.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
 			    ETH_ALEN);
 
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.pmkid.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
 			    PMKID_LEN);
 	}
 
-- 
1.9.1

