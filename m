Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34526 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751076AbdJ0KGG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 06:06:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9RA5pbP015635
        for <linux-wireless@vger.kernel.org>; Fri, 27 Oct 2017 03:06:06 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2duuy3spyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 27 Oct 2017 03:06:05 -0700
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: do not transmit in 11N rates when connected in TKIP security
Date: Fri, 27 Oct 2017 15:32:49 +0530
Message-ID: <1509098569-19307-1-git-send-email-gbhat@marvell.com> (sfid-20171027_120703_866438_E34D0DE0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver is transmitting in 11N rates, when connected to an AP in
TKIP security mode. Add a check to disable_11n to fix the issue.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 6b765f3..13cd58e9 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -225,7 +225,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define IS_11N_ENABLED(priv) ((priv->adapter->config_bands & BAND_GN || \
 			priv->adapter->config_bands & BAND_AN) && \
-			priv->curr_bss_params.bss_descriptor.bcn_ht_cap)
+			priv->curr_bss_params.bss_descriptor.bcn_ht_cap && \
+			!priv->curr_bss_params.bss_descriptor.disable_11n)
 #define INITIATOR_BIT(DelBAParamSet) (((DelBAParamSet) &\
 			BIT(DELBA_INITIATOR_POS)) >> DELBA_INITIATOR_POS)
 
-- 
1.9.1
