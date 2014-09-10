Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31592 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaIJNfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:36 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Dedy Lansky <qca_dlansky@qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/22] wil6210: send connect request IEs to FW also for non-secure connection
Date: Wed, 10 Sep 2014 16:34:43 +0300
Message-ID: <1410356091-19219-15-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153541_300122_40F90D6D)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver is sending connect request IEs to FW only for secure connection and
ignores them for non-secure connection.
This is fixed by always sending the IEs to FW upon connect request

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 22 +++++++++++-----------
 drivers/net/wireless/ath/wil6210/wmi.c      |  2 ++
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index c8c9852..c1ff330 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -379,22 +379,22 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 				sme->ie_len);
 			goto out;
 		}
-		/*
-		 * For secure assoc, send:
-		 * (1) WMI_DELETE_CIPHER_KEY_CMD
-		 * (2) WMI_SET_APPIE_CMD
-		 */
+		/* For secure assoc, send WMI_DELETE_CIPHER_KEY_CMD */
 		rc = wmi_del_cipher_key(wil, 0, bss->bssid);
 		if (rc) {
 			wil_err(wil, "WMI_DELETE_CIPHER_KEY_CMD failed\n");
 			goto out;
 		}
-		/* WMI_SET_APPIE_CMD */
-		rc = wmi_set_ie(wil, WMI_FRAME_ASSOC_REQ, sme->ie_len, sme->ie);
-		if (rc) {
-			wil_err(wil, "WMI_SET_APPIE_CMD failed\n");
-			goto out;
-		}
+	}
+
+	/* WMI_SET_APPIE_CMD. ie may contain rsn info as well as other info
+	 * elements. Send it also in case it's empty, to erase previously set
+	 * ies in FW.
+	 */
+	rc = wmi_set_ie(wil, WMI_FRAME_ASSOC_REQ, sme->ie_len, sme->ie);
+	if (rc) {
+		wil_err(wil, "WMI_SET_APPIE_CMD failed\n");
+		goto out;
 	}
 
 	/* WMI_CONNECT_CMD */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index c3682c3a..789c316 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -972,6 +972,8 @@ int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie)
 
 	if (!cmd)
 		return -ENOMEM;
+	if (!ie)
+		ie_len = 0;
 
 	cmd->mgmt_frm_type = type;
 	/* BUG: FW API define ieLen as u8. Will fix FW */
-- 
1.9.1

