Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38821 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932981AbbJIL1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 07:27:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t99BKBD9004491
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2015 04:27:20 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 1xaehjnyfa-2
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2015 04:27:20 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Ganapathi Bhat <gbhat@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/3] mwifiex: fix AP VHT behaviour
Date: Fri, 9 Oct 2015 04:26:33 -0700
Message-ID: <1444389995-4869-1-git-send-email-akarwar@marvell.com> (sfid-20151009_132733_711763_AF4F7AAC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

Even if hostapd configuration file contains VHT parameters,
they were not getting reflected in beacons. The reason is
we are resetting them before starting AP. This patch removes
redundant BSS_STOP and SYS_RESET firmware commands before
starting AP to fix the problem.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_cmd.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 4d5a6e3..759a6ad 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -846,22 +846,6 @@ int mwifiex_config_start_uap(struct mwifiex_private *priv,
 {
 	enum state_11d_t state_11d;
 
-	if (mwifiex_del_mgmt_ies(priv))
-		mwifiex_dbg(priv->adapter, ERROR,
-			    "Failed to delete mgmt IEs!\n");
-
-	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
-			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
-		mwifiex_dbg(priv->adapter, ERROR, "Failed to stop the BSS\n");
-		return -1;
-	}
-
-	if (mwifiex_send_cmd(priv, HOST_CMD_APCMD_SYS_RESET,
-			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
-		mwifiex_dbg(priv->adapter, ERROR, "Failed to reset BSS\n");
-		return -1;
-	}
-
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
 			     HostCmd_ACT_GEN_SET,
 			     UAP_BSS_PARAMS_I, bss_cfg, false)) {
-- 
1.8.1.4

