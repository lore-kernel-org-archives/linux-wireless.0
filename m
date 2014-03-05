Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520AbaCEMLA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:11:00 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: [RFC/RFT 2/9] iwlegacy: use CMD_COPY_PKT on il3945_get_measurement
Date: Wed,  5 Mar 2014 13:13:27 +0100
Message-Id: <1394021614-11514-3-git-send-email-sgruszka@redhat.com> (sfid-20140305_131104_925824_65DF0B36)
In-Reply-To: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
References: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index dc1d20c..f7a58f5 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -668,13 +668,18 @@ il3945_get_measurement(struct il_priv *il,
 	struct il_host_cmd cmd = {
 		.id = C_SPECTRUM_MEASUREMENT,
 		.data = (void *)&spectrum,
-		.flags = CMD_WANT_SKB,
+		.flags = CMD_COPY_PKT,
 	};
 	u32 add_time = le64_to_cpu(params->start_time);
 	int rc;
 	int spectrum_resp_status;
 	int duration = le16_to_cpu(params->duration);
 
+	pkt = kmalloc(sizeof(*pkt), GFP_KERNEL);
+	if (!pkt)
+		return -ENOMEM;
+	cmd.pkt_ptr = pkt;
+
 	if (il_is_associated(il))
 		add_time =
 		    il_usecs_to_beacons(il,
@@ -708,12 +713,12 @@ il3945_get_measurement(struct il_priv *il,
 
 	rc = il_send_cmd_sync(il, &cmd);
 	if (rc)
-		return rc;
+		goto out;
 
-	pkt = (struct il_rx_pkt *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
 		IL_ERR("Bad return from N_RX_ON_ASSOC command\n");
 		rc = -EIO;
+		goto out;
 	}
 
 	spectrum_resp_status = le16_to_cpu(pkt->u.spectrum.status);
@@ -733,8 +738,8 @@ il3945_get_measurement(struct il_priv *il,
 		break;
 	}
 
-	il_free_pages(il, cmd.reply_page);
-
+out:
+	kfree(pkt);
 	return rc;
 }
 
-- 
1.7.11.7

