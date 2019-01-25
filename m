Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94284C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 04:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65C7421872
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 04:10:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bvGqD2rv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IajE4x1t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfAYEKc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 23:10:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43246 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbfAYEKc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 23:10:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8AA3260878; Fri, 25 Jan 2019 04:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548389431;
        bh=HrOlc1zDUKyWWGyVPxiCU5kL9TUiMteTJrdVtojkMnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvGqD2rvmBiO9uygM16H3QQ7ZyVvlt4S1z5JBj5h5D1YlgCKZT8ORCgIJH2I4GPNf
         72j7bVRAUh7CtMRXe5D4zZ4XE+tRjMp+Edk/SGPz5f3yfnvUbSq7aPg3zHsN0zzBSS
         JU46HOe5Vxi6ccXz9ZHITrIJtufxJMm172zdKeE8=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 83449605A5;
        Fri, 25 Jan 2019 04:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548389430;
        bh=HrOlc1zDUKyWWGyVPxiCU5kL9TUiMteTJrdVtojkMnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IajE4x1tAHwJw6gebmSVSwJiwDsS8ygWeZhubnK+adcv7PvpOR8qP755gTymwDbF1
         droVbLMRvogES1yNiM6dcGW9n5rUlHJOulUxDVPNJjzugf9K+unhGws4Y4PgK2q0Z7
         xNJ3eLuNiPrbZF29Ngx0NmgJ6I8GvHz7F18ScAEg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 83449605A5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH v2 2/2] ath10k: Enable bundle tx compl for management frames in WCN3990
Date:   Fri, 25 Jan 2019 09:40:02 +0530
Message-Id: <1548389402-10083-3-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548389402-10083-1-git-send-email-pillair@codeaurora.org>
References: <1548389402-10083-1-git-send-email-pillair@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 sends tx completion of multiple management
frames bundled together in a single event, if the
host driver exposes the support to handle this
bundled tx completion event. This reduces the number
of WMI events which are sent to the host driver by
the target.

Set the BUNDLE_TX_COMPL flag in the host capability
flags when host sends the wmi init command, to indicate
the host capability to handle bundled tx completion for
management frames.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index e85d6be..e6f62bb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1688,7 +1688,7 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->num_ocb_vdevs = __cpu_to_le32(0);
 	cfg->num_ocb_channels = __cpu_to_le32(0);
 	cfg->num_ocb_schedules = __cpu_to_le32(0);
-	cfg->host_capab = __cpu_to_le32(0);
+	cfg->host_capab = __cpu_to_le32(WMI_TLV_FLAG_MGMT_BUNDLE_TX_COMPL);
 
 	ath10k_wmi_put_host_mem_chunks(ar, chunks);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 5941961..298d917 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1593,6 +1593,8 @@ struct chan_info_params {
 	u32 mac_clk_mhz;
 };
 
+#define WMI_TLV_FLAG_MGMT_BUNDLE_TX_COMPL	BIT(9)
+
 struct wmi_tlv_mgmt_tx_compl_ev {
 	__le32 desc_id;
 	__le32 status;
-- 
2.7.4

