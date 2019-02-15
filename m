Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5FFC4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 07:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9745C21872
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 07:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ef4yWWJM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E9o3JglA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390576AbfBOHtG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 02:49:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33448 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfBOHtG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 02:49:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D32686090F; Fri, 15 Feb 2019 07:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550216942;
        bh=Z2EpzF0Lc0xCZ2EFFITN9+be0blzKuz/jFGUqGJfx9M=;
        h=From:To:Cc:Subject:Date:From;
        b=ef4yWWJM0ui1hS+Pd9mi+dUpUaF4jfDrC2eZpThy4XXE4RmI1gUuw7BE/Bm0Rctrb
         aTb+Nf8XW4pMgHfsMRLm5DJyrMRCsKz3fvQRmkUSr4HFVEERXoo6Jxcw9vq5ahrWfX
         Z8kSwJDhPWMyvNgFHZF7R/ofkyS/pfSDLC/7zSE0=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4B8576020A;
        Fri, 15 Feb 2019 07:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550216909;
        bh=Z2EpzF0Lc0xCZ2EFFITN9+be0blzKuz/jFGUqGJfx9M=;
        h=From:To:Cc:Subject:Date:From;
        b=E9o3JglAJjC/yLBLG6Wv0/nMDPccSJcS5PF/oWdf8zgNB6h55CcEH5Qez+wfCd2oZ
         xs4kdm/V/caBa4eWCjTy0Xy2/jTJsIJcoFMbp6e9qP7RPnWbgWK7K3em7SawZyBhIA
         vc268f01wh44bUh03cYHkmwVAu1Y+5wDcbdTsro0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4B8576020A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Enhance logging for vdev pdev & peer set param
Date:   Fri, 15 Feb 2019 13:18:06 +0530
Message-Id: <1550216886-23045-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently after enabling the WMI debug logging,
there is no detail printed about the param id
and the param value for the pdev, vdev and
peer params which are set.

Enhance the WMI logging to print the param id
and the param value for pdev, vdev and peer set
param wmi commands.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01387-QCAHLSWMTPLZ-1
		WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 90617e1..98d8992 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1576,7 +1576,8 @@ ath10k_wmi_tlv_op_gen_pdev_set_param(struct ath10k *ar, u32 param_id,
 	cmd->param_id = __cpu_to_le32(param_id);
 	cmd->param_value = __cpu_to_le32(param_value);
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv pdev set param\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv pdev set param %d value 0x%x\n",
+		   param_id, param_value);
 	return skb;
 }
 
@@ -2046,7 +2047,8 @@ ath10k_wmi_tlv_op_gen_vdev_set_param(struct ath10k *ar, u32 vdev_id,
 	cmd->param_id = __cpu_to_le32(param_id);
 	cmd->param_value = __cpu_to_le32(param_value);
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv vdev set param\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv vdev %d set param %d value 0x%x\n",
+		   vdev_id, param_id, param_value);
 	return skb;
 }
 
@@ -2360,7 +2362,9 @@ ath10k_wmi_tlv_op_gen_peer_set_param(struct ath10k *ar, u32 vdev_id,
 	cmd->param_value = __cpu_to_le32(param_value);
 	ether_addr_copy(cmd->peer_macaddr.addr, peer_addr);
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv peer set param\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi tlv vdev %d peer %pM set param %d value 0x%x\n",
+		   vdev_id, peer_addr, param_id, param_value);
 	return skb;
 }
 
-- 
2.7.4

