Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55911 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873AbcDKOxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 10:53:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3BEpaLC002196
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 07:53:18 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 22718g553w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 07:53:18 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/5] mwifiex: add default setting for pcie firmware download
Date: Mon, 11 Apr 2016 07:52:39 -0700
Message-ID: <1460386361-29918-3-git-send-email-akarwar@marvell.com> (sfid-20160411_165401_410356_3D42F3C1)
In-Reply-To: <1460386361-29918-1-git-send-email-akarwar@marvell.com>
References: <1460386361-29918-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

This patch adds default setting for pcie firmware download name in
case that there are newer chipset version.

Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 3 +++
 drivers/net/wireless/marvell/mwifiex/pcie.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 1d888b5..0c7937e 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2830,6 +2830,8 @@ static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 			strcpy(adapter->fw_name, PCIE8897_B0_FW_NAME);
 			break;
 		default:
+			strcpy(adapter->fw_name, PCIE8897_DEFAULT_FW_NAME);
+
 			break;
 		}
 		break;
@@ -2855,6 +2857,7 @@ static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 				       PCIEUART8997_FW_NAME_Z);
 			break;
 		default:
+			strcpy(adapter->fw_name, PCIE8997_DEFAULT_FW_NAME);
 			break;
 		}
 	default:
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index bbabfb0..5770b43 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -30,8 +30,10 @@
 #include    "main.h"
 
 #define PCIE8766_DEFAULT_FW_NAME "mrvl/pcie8766_uapsta.bin"
+#define PCIE8897_DEFAULT_FW_NAME "mrvl/pcie8897_uapsta.bin"
 #define PCIE8897_A0_FW_NAME "mrvl/pcie8897_uapsta_a0.bin"
 #define PCIE8897_B0_FW_NAME "mrvl/pcie8897_uapsta.bin"
+#define PCIE8997_DEFAULT_FW_NAME "mrvl/pcieuart8997_combo_v2.bin"
 #define PCIEUART8997_FW_NAME_Z "mrvl/pcieuart8997_combo.bin"
 #define PCIEUART8997_FW_NAME_V2 "mrvl/pcieuart8997_combo_v2.bin"
 #define PCIEUSB8997_FW_NAME_Z "mrvl/pcieusb8997_combo.bin"
-- 
1.8.1.4

