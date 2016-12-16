Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36634 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753341AbcLPH1p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 02:27:45 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBG7K65M003841
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 23:26:52 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 27bnjfdxk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 23:26:52 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/2] mwifiex: Enable dynamic bandwidth signalling
Date: Fri, 16 Dec 2016 12:55:45 +0530
Message-ID: <1481873145-5381-2-git-send-email-akarwar@marvell.com> (sfid-20161216_082750_531503_1097DAAF)
In-Reply-To: <1481873145-5381-1-git-send-email-akarwar@marvell.com>
References: <1481873145-5381-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable dynamic bandwidth signalling by setting the corresponding
bit in MAC control register.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h   | 1 +
 drivers/net/wireless/marvell/mwifiex/init.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index f48247c..55db158f 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -441,6 +441,7 @@ enum mwifiex_channel_flags {
 #define HostCmd_ACT_MAC_PROMISCUOUS_ENABLE    BIT(7)
 #define HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE  BIT(8)
 #define HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON BIT(13)
+#define HostCmd_ACT_MAC_DYNAMIC_BW_ENABLE     BIT(16)
 
 #define HostCmd_BSS_MODE_IBSS               0x0002
 #define HostCmd_BSS_MODE_ANY                0x0003
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 87cda4f..7569483 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -92,7 +92,8 @@ int mwifiex_init_priv(struct mwifiex_private *priv)
 	for (i = 0; i < ARRAY_SIZE(priv->wep_key); i++)
 		memset(&priv->wep_key[i], 0, sizeof(struct mwifiex_wep_key));
 	priv->wep_key_curr_index = 0;
-	priv->curr_pkt_filter = HostCmd_ACT_MAC_RX_ON | HostCmd_ACT_MAC_TX_ON |
+	priv->curr_pkt_filter = HostCmd_ACT_MAC_DYNAMIC_BW_ENABLE |
+				HostCmd_ACT_MAC_RX_ON | HostCmd_ACT_MAC_TX_ON |
 				HostCmd_ACT_MAC_ETHERNETII_ENABLE;
 
 	priv->beacon_period = 100; /* beacon interval */
-- 
1.9.1
