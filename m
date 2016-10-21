Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41753 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934238AbcJUPQb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 11:16:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9LFFntw021094
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 08:16:30 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 265pbxn1wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 08:16:30 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/2] mwifiex: ignore calibration data failure
Date: Fri, 21 Oct 2016 20:45:48 +0530
Message-ID: <1477062948-8558-2-git-send-email-akarwar@marvell.com> (sfid-20161021_171634_254442_CB2E1D82)
In-Reply-To: <1477062948-8558-1-git-send-email-akarwar@marvell.com>
References: <1477062948-8558-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware may reject calibration data from host for certain OTP
settings. In that case, we should continue initialisation ignoring
the failure.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 2a162c3..638d30a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -2228,19 +2228,13 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 				adapter->hs_cfg.gpio = data;
 			}
 
-			ret = mwifiex_dnld_dt_cfgdata(priv, adapter->dt_node,
-						      "marvell,caldata");
-			if (ret)
-				return -1;
+			mwifiex_dnld_dt_cfgdata(priv, adapter->dt_node,
+						"marvell,caldata");
 		}
 
-		if (adapter->cal_data) {
-			ret = mwifiex_send_cmd(priv, HostCmd_CMD_CFG_DATA,
-					       HostCmd_ACT_GEN_SET, 0, NULL,
-					       true);
-			if (ret)
-				return -1;
-		}
+		if (adapter->cal_data)
+			mwifiex_send_cmd(priv, HostCmd_CMD_CFG_DATA,
+					 HostCmd_ACT_GEN_SET, 0, NULL, true);
 
 		/* Read MAC address from HW */
 		ret = mwifiex_send_cmd(priv, HostCmd_CMD_GET_HW_SPEC,
-- 
1.9.1
