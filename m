Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9029 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761AbbA3ImV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 03:42:21 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0U8ccgf006600
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 00:42:21 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1s7fgab5j3-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 00:42:21 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/4] mwifiex: disable UAPSD mode when AP starts
Date: Fri, 30 Jan 2015 00:40:07 -0800
Message-ID: <1422607207-15229-4-git-send-email-akarwar@marvell.com> (sfid-20150130_094224_146088_9C931683)
In-Reply-To: <1422607207-15229-1-git-send-email-akarwar@marvell.com>
References: <1422607207-15229-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When AP is started, firmware exits power save mode. This
means power save manager of AP takes priority over station.
Firmware stop sending periodic AWAKE events to host.

We may have UAPSD enabled on station which buffers data
packets until AWAKE event from firmware. Data path is
unnecessarily blocked in this case. This patch disables
UAPSD mode to reenable transmit data path.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 39f3176..5f8da59 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1105,6 +1105,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_UAP_SYS_CONFIG:
 		break;
 	case HostCmd_CMD_UAP_BSS_START:
+		adapter->tx_lock_flag = false;
+		adapter->pps_uapsd_mode = false;
+		adapter->delay_null_pkt = false;
 		priv->bss_started = 1;
 		break;
 	case HostCmd_CMD_UAP_BSS_STOP:
-- 
1.8.1.4

