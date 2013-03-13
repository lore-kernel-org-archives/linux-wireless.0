Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20103 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab3CMMNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:17 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/14] wil6210: Fix garbage sent to the FW with wmi_set_ie()
Date: Wed, 13 Mar 2013 14:12:42 +0200
Message-ID: <1363176771-10082-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131323_501247_DF8EA7BA)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extra reference was taken by mistake.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index d636ff4..aa642df 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -877,7 +877,7 @@ int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie)
 	/* BUG: FW API define ieLen as u8. Will fix FW */
 	cmd->ie_len = cpu_to_le16(ie_len);
 	memcpy(cmd->ie_info, ie, ie_len);
-	rc = wmi_send(wil, WMI_SET_APPIE_CMDID, &cmd, len);
+	rc = wmi_send(wil, WMI_SET_APPIE_CMDID, cmd, len);
 	kfree(cmd);
 
 	return rc;
-- 
1.7.10.4

