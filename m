Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E91C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 14:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0422620675
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 14:50:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FHVXPDpH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FHVXPDpH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388184AbfCAOuJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:50:09 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbfCAOuJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 09:50:09 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C156C60CF0; Fri,  1 Mar 2019 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551451808;
        bh=gWOD/FO1FYGQyJfklSyR5LXbc5FXS4AUzjGbbUxY3NY=;
        h=From:To:Cc:Subject:Date:From;
        b=FHVXPDpHWb39i5q2yfIqYN5OQ0GENlZX7zHQTHd+d+BC2jld2AjjhFCBPNVfRjavV
         e9zuYI9DjcUSOQXgilNtpOVwBHMDHnO0nVMsSQO7oEgJySoWDa8EJpkKu2nR+Wgzq4
         mgLW8wr3Upky75EA0xEmTrXtk+tfT/a6/R9rwZLs=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B852760128;
        Fri,  1 Mar 2019 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551451808;
        bh=gWOD/FO1FYGQyJfklSyR5LXbc5FXS4AUzjGbbUxY3NY=;
        h=From:To:Cc:Subject:Date:From;
        b=FHVXPDpHWb39i5q2yfIqYN5OQ0GENlZX7zHQTHd+d+BC2jld2AjjhFCBPNVfRjavV
         e9zuYI9DjcUSOQXgilNtpOVwBHMDHnO0nVMsSQO7oEgJySoWDa8EJpkKu2nR+Wgzq4
         mgLW8wr3Upky75EA0xEmTrXtk+tfT/a6/R9rwZLs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B852760128
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH] ath10k: Move board id and fw version logging to info level
Date:   Fri,  1 Mar 2019 20:20:00 +0530
Message-Id: <20190301145000.22624-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Board id and fw version is not printed by default in qmi
cap response message. Move board id and fw version logging
to info level for default logging.

[   34.005399] ath10k_snoc a000000.wifi: qmi chip_id 0x30b chip_family 0x4001 board_id 0xff soc_id 0x40070000
[   34.005432] ath10k_snoc a000000.wifi: qmi fw_version 0x3106836b fw_build_timestamp 2019-02-13 10:24 fw_build_id QC_IMAGE_VERSION_STRING=WLAN.HL.3.1-00875-QCAHLSWMTPL-1

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 54f783ceb147..2b086fa16040 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -523,6 +523,7 @@ static int ath10k_qmi_cap_send_sync_msg(struct ath10k_qmi *qmi)
 	struct wlfw_cap_resp_msg_v01 *resp;
 	struct wlfw_cap_req_msg_v01 req = {};
 	struct ath10k *ar = qmi->ar;
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 	struct qmi_txn txn;
 	int ret;
 
@@ -577,13 +578,13 @@ static int ath10k_qmi_cap_send_sync_msg(struct ath10k_qmi *qmi)
 		strlcpy(qmi->fw_build_id, resp->fw_build_id,
 			MAX_BUILD_ID_LEN + 1);
 
-	ath10k_dbg(ar, ATH10K_DBG_QMI,
-		   "qmi chip_id 0x%x chip_family 0x%x board_id 0x%x soc_id 0x%x",
-		   qmi->chip_info.chip_id, qmi->chip_info.chip_family,
-		   qmi->board_info.board_id, qmi->soc_info.soc_id);
-	ath10k_dbg(ar, ATH10K_DBG_QMI,
-		   "qmi fw_version 0x%x fw_build_timestamp %s fw_build_id %s",
-		   qmi->fw_version, qmi->fw_build_timestamp, qmi->fw_build_id);
+	if (!test_bit(ATH10K_SNOC_FLAG_REGISTERED, &ar_snoc->flags)) {
+		ath10k_info(ar, "qmi chip_id 0x%x chip_family 0x%x board_id 0x%x soc_id 0x%x",
+			    qmi->chip_info.chip_id, qmi->chip_info.chip_family,
+			    qmi->board_info.board_id, qmi->soc_info.soc_id);
+		ath10k_info(ar, "qmi fw_version 0x%x fw_build_timestamp %s fw_build_id %s",
+			    qmi->fw_version, qmi->fw_build_timestamp, qmi->fw_build_id);
+	}
 
 	kfree(resp);
 	return 0;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

