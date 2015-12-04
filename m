Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17894 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbbLDOOj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 09:14:39 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tB4E9UKx029053
	for <linux-wireless@vger.kernel.org>; Fri, 4 Dec 2015 06:14:39 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 1yk5tpa12s-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2015 06:14:39 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/6] mwifiex: handle start AP error paths correctly
Date: Fri, 4 Dec 2015 06:13:03 -0800
Message-ID: <1449238387-27396-2-git-send-email-akarwar@marvell.com> (sfid-20151204_151448_851993_6DE681F2)
In-Reply-To: <1449238387-27396-1-git-send-email-akarwar@marvell.com>
References: <1449238387-27396-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been observed that even if firmware returns an error
for a configuration command, we go ahead and start AP.

This patch changes the command type from async to sync
so that threads waits for command response and return
failure start AP.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/ie.c      | 2 +-
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/ie.c b/drivers/net/wireless/marvell/mwifiex/ie.c
index abf52d2..c488c30 100644
--- a/drivers/net/wireless/marvell/mwifiex/ie.c
+++ b/drivers/net/wireless/marvell/mwifiex/ie.c
@@ -140,7 +140,7 @@ mwifiex_update_autoindex_ies(struct mwifiex_private *priv,
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP)
 		return mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
 					HostCmd_ACT_GEN_SET,
-					UAP_CUSTOM_IE_I, ie_list, false);
+					UAP_CUSTOM_IE_I, ie_list, true);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index 759a6ad..e791166 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -848,9 +848,9 @@ int mwifiex_config_start_uap(struct mwifiex_private *priv,
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
 			     HostCmd_ACT_GEN_SET,
-			     UAP_BSS_PARAMS_I, bss_cfg, false)) {
+			     UAP_BSS_PARAMS_I, bss_cfg, true)) {
 		mwifiex_dbg(priv->adapter, ERROR,
-			    "Failed to set the SSID\n");
+			    "Failed to set AP configuration\n");
 		return -1;
 	}
 
@@ -865,7 +865,7 @@ int mwifiex_config_start_uap(struct mwifiex_private *priv,
 	}
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_START,
-			     HostCmd_ACT_GEN_SET, 0, NULL, false)) {
+			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "Failed to start the BSS\n");
 		return -1;
-- 
1.8.1.4

