Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47781 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933377AbbLPMYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 07:24:12 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBGCMtuG029731
	for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 04:24:12 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yu7wpr03f-2
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 04:24:12 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/4] mwifiex: add missing check for PCIe8997 chipset
Date: Wed, 16 Dec 2015 04:21:44 -0800
Message-ID: <1450268505-2682-3-git-send-email-akarwar@marvell.com> (sfid-20151216_132415_462613_584155D7)
In-Reply-To: <1450268505-2682-1-git-send-email-akarwar@marvell.com>
References: <1450268505-2682-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch ensures mwifiex_pcie_txbd_empty() does take care
of 8997 chipset.

Fixes: 6d85ef00d9dfe ("mwifiex: add support for 8997 chipset")
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 7db46ee..347ba45 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -342,6 +342,7 @@ mwifiex_pcie_txbd_empty(struct pcie_service_card *card, u32 rdptr)
 			return 1;
 		break;
 	case PCIE_DEVICE_ID_MARVELL_88W8897:
+	case PCIE_DEVICE_ID_MARVELL_88W8997:
 		if (((card->txbd_wrptr & reg->tx_mask) ==
 		     (rdptr & reg->tx_mask)) &&
 		    ((card->txbd_wrptr & reg->tx_rollover_ind) ==
-- 
1.8.1.4

