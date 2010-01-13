Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:35455 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932112Ab0AMLHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 06:07:33 -0500
Date: Wed, 13 Jan 2010 12:09:08 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, "Zhu, Yi" <yi.zhu@intel.com>
Subject: [PATCH] [2.6.33] iwmc3200wifi: Add UMAC wifi headers to the pmkid
 command
Message-ID: <20100113110907.GC5248@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Without this header, we can trigger a UMAC crash with debug enabled UMACs.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |    4 ++++
 drivers/net/wireless/iwmc3200wifi/commands.h |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 777584d..1e41ad0 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -973,6 +973,10 @@ int iwm_send_pmkid_update(struct iwm_priv *iwm,
 
 	memset(&update, 0, sizeof(struct iwm_umac_pmkid_update));
 
+	update.hdr.oid = UMAC_WIFI_IF_CMD_PMKID_UPDATE;
+	update.hdr.buf_size = cpu_to_le16(sizeof(struct iwm_umac_pmkid_update) -
+					  sizeof(struct iwm_umac_wifi_if));
+
 	update.command = cpu_to_le32(command);
 	if (pmksa->bssid)
 		memcpy(&update.bssid, pmksa->bssid, ETH_ALEN);
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.h b/drivers/net/wireless/iwmc3200wifi/commands.h
index 06af055..3dfd9f0 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.h
+++ b/drivers/net/wireless/iwmc3200wifi/commands.h
@@ -463,6 +463,7 @@ struct iwm_umac_cmd_stop_resume_tx {
 #define IWM_CMD_PMKID_FLUSH 3
 
 struct iwm_umac_pmkid_update {
+	struct iwm_umac_wifi_if hdr;
 	__le32 command;
 	u8 bssid[ETH_ALEN];
 	__le16 reserved;
-- 
1.6.3.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
