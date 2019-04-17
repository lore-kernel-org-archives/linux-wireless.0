Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E7DC10F12
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF8A52073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BMlb2VRn";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eEtD6TgL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbfDQIca (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 04:32:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33130 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbfDQIc3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 04:32:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E5A1B619AD; Wed, 17 Apr 2019 08:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555489949;
        bh=7nKtRDKLymvzW1W/Ec0+tfw/W1MC7GDUJB/Kt34SHsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMlb2VRnOUg0UjyggCow+mdRl6vreZq3gxg4bHbby0t1/ZK8xyX/oYKn8qtTfZaGL
         lAcl8R2TC1TS51/Jm7dQcGYv11t7rw6c4jA7focaRv55UKj8Gbdk1RTnkvTPM0ZPv7
         U3NVzmnb5I0ti/rSfZqSTtJ/revyOzuAU5UV0yWQ=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0379619AD;
        Wed, 17 Apr 2019 08:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555489948;
        bh=7nKtRDKLymvzW1W/Ec0+tfw/W1MC7GDUJB/Kt34SHsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEtD6TgLeXc61ukbEqjDSXqbjtXKyAuzJaDdapjE283DakXMDbK+Ny/ddtY9jd9sP
         /9G6VBnYjllXGK3O00dsGUoi84xEpomIN+4My4QHURO54VRNNWSHJoT5tTgt3BXJAC
         gLfykwOhi6ffEY+qJD6EKZV9wouXdUbuN3/otkK0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0379619AD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH 3/3] ath10k: Add wmi tlv service map for mesh 11s
Date:   Wed, 17 Apr 2019 14:01:47 +0530
Message-Id: <1555489907-30117-4-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1555489907-30117-1-git-send-email-svishnoi@codeaurora.org>
References: <1555489907-30117-1-git-send-email-svishnoi@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 firmware advertises the service WMI_TLV_SERVICE_MESH_11S
for mesh 11s. Map this wmi tlv service to enable mesh 11s
for WCN3990.

Tested HW: WCN3990

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 55da01f..bc3198b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1567,6 +1567,8 @@ enum wmi_tlv_service {
 	       WMI_SERVICE_SAP_AUTH_OFFLOAD, len);
 	SVCMAP(WMI_TLV_SERVICE_MGMT_TX_WMI,
 	       WMI_SERVICE_MGMT_TX_WMI, len);
+	SVCMAP(WMI_TLV_SERVICE_MESH_11S,
+	       WMI_SERVICE_MESH_11S, len);
 }
 
 static inline void
-- 
1.9.1

