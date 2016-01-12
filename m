Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2582 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934549AbcALNpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 08:45:47 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u0CDXjSV023925
	for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2016 05:45:46 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 20d0t3r8dc-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2016 05:45:46 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: fix power state out of sync problem
Date: Tue, 12 Jan 2016 05:43:16 -0800
Message-ID: <1452606196-9582-1-git-send-email-akarwar@marvell.com> (sfid-20160112_144551_415862_EC329E95)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

It's been observed that driver's power state goes out
of sync with firmware in some corner cases. When this
happens, driver tries to download the data to firmware
assuming it's awake which causes Tx data timeout.

Main thread will process interrupt as soon as interrupt
handler fills 'int_status' variable.

This patch fixes the race issue by updating 'int_status'
at the end of mwifiex_interrupt_status().

Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 5e15464..918e049 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2116,11 +2116,6 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter,
 		}
 	}
 
-	spin_lock_irqsave(&adapter->int_lock, flags);
-	adapter->int_status |= pcie_ireg;
-	spin_unlock_irqrestore(&adapter->int_lock, flags);
-	mwifiex_dbg(adapter, INTR, "ireg: 0x%08x\n", pcie_ireg);
-
 	if (!adapter->pps_uapsd_mode &&
 	    adapter->ps_state == PS_STATE_SLEEP &&
 	    mwifiex_pcie_ok_to_access_hw(adapter)) {
@@ -2132,6 +2127,11 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter,
 		adapter->pm_wakeup_fw_try = false;
 		del_timer(&adapter->wakeup_timer);
 	}
+
+	spin_lock_irqsave(&adapter->int_lock, flags);
+	adapter->int_status |= pcie_ireg;
+	spin_unlock_irqrestore(&adapter->int_lock, flags);
+	mwifiex_dbg(adapter, INTR, "ireg: 0x%08x\n", pcie_ireg);
 }
 
 /*
-- 
1.8.1.4

