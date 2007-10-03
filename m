Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbXJCOmI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2007 10:42:08 -0400
Subject: [PATCH] libertas: problems setting wpa keys
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 10:37:45 -0400
Message-Id: <1191422265.15982.46.camel@localhost.localdomain> (sfid-20071003_154213_825798_901D66B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 88w8385 chip, using SDIO interface and firmware release 5.0.11p0,
has problems when both unicast and multicast WPA keys are set in one
command. This patch ensures the keys are set independently.

The original author of this patch is Marc Pignat <marc.pignat@hevs.ch>

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Dan Williams <dcbw@redhat.com>


diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 3131afc..d00cf78 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -372,15 +372,40 @@ static int assoc_helper_wpa_keys(wlan_private *priv,
                                  struct assoc_request * assoc_req)
 {
 	int ret = 0;
+	unsigned int flags = assoc_req->flags;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	ret = libertas_prepare_and_send_command(priv,
-				    CMD_802_11_KEY_MATERIAL,
-				    CMD_ACT_SET,
-				    CMD_OPTION_WAITFORRSP,
-				    0, assoc_req);
+	/* Work around older firmware bug where WPA unicast and multicast
+	 * keys must be set independently.  Seen in SDIO parts with firmware
+	 * version 5.0.11p0.
+	 */
 
+	if (test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags)) {
+		clear_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags);
+		ret = libertas_prepare_and_send_command(priv,
+					CMD_802_11_KEY_MATERIAL,
+					CMD_ACT_SET,
+					CMD_OPTION_WAITFORRSP,
+					0, assoc_req);
+		assoc_req->flags = flags;
+	}
+
+	if (ret)
+		goto out;
+
+	if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags)) {
+		clear_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags);
+
+		ret = libertas_prepare_and_send_command(priv,
+					CMD_802_11_KEY_MATERIAL,
+					CMD_ACT_SET,
+					CMD_OPTION_WAITFORRSP,
+					0, assoc_req);
+		assoc_req->flags = flags;
+	}
+
+out:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }

