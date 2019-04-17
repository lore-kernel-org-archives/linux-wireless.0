Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C695C10F12
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE7B42073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:32:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hEvrVQTW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CcniLq6a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbfDQIcY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 04:32:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60948 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729039AbfDQIcX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 04:32:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6E3A360907; Wed, 17 Apr 2019 08:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555489942;
        bh=QY3hiOgqRuodPvXPRstmBwnhroHWWkcTpEAtjS5jZNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEvrVQTWVmR4W7UYwLBDmjyul7C8DcDxnTeEeybIQk0XHwZ40syLdwUN022ApLtPr
         bByZwdH4oaG9vNJAsrpp9wZKr9BnPy7dBVS6UyeA/ck9hEg2rPhJwuKMcpwQlkbqlh
         mjvARsjt84jTra9pKBrPXYIw8LQ8OVZNyq7fghug=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 241A56118C;
        Wed, 17 Apr 2019 08:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555489938;
        bh=QY3hiOgqRuodPvXPRstmBwnhroHWWkcTpEAtjS5jZNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcniLq6aoumBzoyOQ+m4FrlIiF06bOjl3b9/ZcBfW2FTYw65SyMQSyJeWMcQOWKXn
         KpOonLhyNKEQIvc++AQoDFTAcLs/394N0N7/4kEtLVhzsvth2SmaXUmJ5b3pwaBPJ8
         sZJDMHeL74Ynwl82LSNvQSVpjgPxGCRXr2v3rp0g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 241A56118C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH 2/3] ath10k: Do not send probe response template for mesh
Date:   Wed, 17 Apr 2019 14:01:46 +0530
Message-Id: <1555489907-30117-3-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1555489907-30117-1-git-send-email-svishnoi@codeaurora.org>
References: <1555489907-30117-1-git-send-email-svishnoi@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently mac80211 do not support probe response template for
mesh point. When WMI_SERVICE_BEACON_OFFLOAD is enabled, host
driver tries to configure probe response template for mesh, but
it fails because the interface type is not NL80211_IFTYPE_AP but
NL80211_IFTYPE_MESH_POINT.

To avoid this failure, skip sending probe response template to
firmware for mesh point.

Tested HW: WCN3990/QCA6174/QCA9984

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b73c23d..3eceb67 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1630,6 +1630,10 @@ static int ath10k_mac_setup_prb_tmpl(struct ath10k_vif *arvif)
 	if (arvif->vdev_type != WMI_VDEV_TYPE_AP)
 		return 0;
 
+	 /* For mesh, probe response and beacon share the same template */
+	if (ieee80211_vif_is_mesh(vif))
+		return 0;
+
 	prb = ieee80211_proberesp_get(hw, vif);
 	if (!prb) {
 		ath10k_warn(ar, "failed to get probe resp template from mac80211\n");
-- 
1.9.1

