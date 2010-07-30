Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0G3ENB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 00:13:01 -0400
Subject: [wt PATCH 3/5] libertas: better association request debugging
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280470034.14523.4.camel@dcbw.foobar.com>
References: <1280470034.14523.4.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 23:14:33 -0700
Message-ID: <1280470473.14523.11.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bring back the comment about FW v5 status codes from the pre-cfg80211
driver, and let through status codes that aren't remapped by the
firmware.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cfg.c |   37 +++++++++++++++++++++++++++-------
 1 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index c7da6c0..a9647e6 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1071,7 +1071,7 @@ static int lbs_associate(struct lbs_private *priv,
 	pos += lbs_add_common_rates_tlv(pos, bss);
 
 	/* add auth type TLV */
-	if (priv->fwrelease >= 0x09000000)
+	if (MRVL_FW_MAJOR_REV(priv->fwrelease) >= 9)
 		pos += lbs_add_auth_type_tlv(pos, sme->auth_type);
 
 	/* add WPA/WPA2 TLV */
@@ -1082,6 +1082,9 @@ static int lbs_associate(struct lbs_private *priv,
 		(u16)(pos - (u8 *) &cmd->iebuf);
 	cmd->hdr.size = cpu_to_le16(len);
 
+	lbs_deb_hex(LBS_DEB_ASSOC, "ASSOC_CMD", (u8 *) cmd,
+			le16_to_cpu(cmd->hdr.size));
+
 	/* store for later use */
 	memcpy(priv->assoc_bss, bss->bssid, ETH_ALEN);
 
@@ -1089,14 +1092,28 @@ static int lbs_associate(struct lbs_private *priv,
 	if (ret)
 		goto done;
 
-
 	/* generate connect message to cfg80211 */
 
 	resp = (void *) cmd; /* recast for easier field access */
 	status = le16_to_cpu(resp->statuscode);
 
-	/* Convert statis code of old firmware */
-	if (priv->fwrelease < 0x09000000)
+	/* Older FW versions map the IEEE 802.11 Status Code in the association
+	 * response to the following values returned in resp->statuscode:
+	 *
+	 *    IEEE Status Code                Marvell Status Code
+	 *    0                       ->      0x0000 ASSOC_RESULT_SUCCESS
+	 *    13                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
+	 *    14                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
+	 *    15                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
+	 *    16                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
+	 *    others                  ->      0x0003 ASSOC_RESULT_REFUSED
+	 *
+	 * Other response codes:
+	 *    0x0001 -> ASSOC_RESULT_INVALID_PARAMETERS (unused)
+	 *    0x0002 -> ASSOC_RESULT_TIMEOUT (internal timer expired waiting for
+	 *                                    association response from the AP)
+	 */
+	if (MRVL_FW_MAJOR_REV(priv->fwrelease) <= 8) {
 		switch (status) {
 		case 0:
 			break;
@@ -1118,11 +1135,16 @@ static int lbs_associate(struct lbs_private *priv,
 			break;
 		default:
 			lbs_deb_assoc("association failure %d\n", status);
-			status = WLAN_STATUS_UNSPECIFIED_FAILURE;
+			/* v5 OLPC firmware does return the AP status code if
+			 * it's not one of the values above.  Let that through.
+			 */
+			break;
+		}
 	}
 
-	lbs_deb_assoc("status %d, capability 0x%04x\n", status,
-		      le16_to_cpu(resp->capability));
+	lbs_deb_assoc("status %d, statuscode 0x%04x, capability 0x%04x, "
+		      "aid 0x%04x\n", status, le16_to_cpu(resp->statuscode),
+		      le16_to_cpu(resp->capability), le16_to_cpu(resp->aid));
 
 	resp_ie_len = le16_to_cpu(resp->hdr.size)
 		- sizeof(resp->hdr)
@@ -1142,7 +1164,6 @@ static int lbs_associate(struct lbs_private *priv,
 			netif_tx_wake_all_queues(priv->dev);
 	}
 
-
 done:
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
 	return ret;
-- 
1.7.2


