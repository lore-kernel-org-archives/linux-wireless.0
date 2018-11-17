Return-Path: <SRS0=ZKB3=N4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4021BC43441
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 00:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C164220869
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 00:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Zjr1+/E2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C164220869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbeKQLCK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Nov 2018 06:02:10 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41530 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729714AbeKQLCK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Nov 2018 06:02:10 -0500
Received: by mail-pl1-f196.google.com with SMTP id u6so1005803plm.8
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2018 16:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eczDJ1A4qkf45Bs0wOnk/rDy3wjhFbHOSL/aGqD5uuI=;
        b=Zjr1+/E2VlsfRuEaN5Irqy/RKlHGOsIyf6ZeyzaLAA4UOtAFZUnuVmAxs6Ae1MEwXJ
         nUmW4vQ50QyrFVXQiiSkgh/K+6rDiUplQ1KmxGM3ivlgf44BO1fFigVQkJP6Ymqnluke
         MzSo0Jc/uFSNxkQK24sdZPwXZG1xvmjw1hguo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eczDJ1A4qkf45Bs0wOnk/rDy3wjhFbHOSL/aGqD5uuI=;
        b=RPsbsf626VJi5yaYzEv+vQerCgB/VXTcN2cLqJU3fmDZJKFnY8Ieq+WdbHVw028AQF
         sg3Ug6vhd8R7tkItP0y3d29OkLT759/c2dlLD9235dOYUwhefGkTyonRUuAFIFvc7Q6H
         Yuj0ZuyqeH38UAcHje1H+tM0ZI8mz0YwCFTKCkJPbs5W4qLLulUz3iOZXfDObOVh4Nd4
         G4YHM5VJnVrxmBP5qyOvKwVpH7R3lpfg1gLKJC7SqlvKRsOjihrXPbv/N+paclAFU9MI
         y2if9jCaWuUSAsps9QL0Def26qz/qCUi+15HCRoV1Se6GvgY+cdqunPqhHf1yaSJ+Pc2
         +dZw==
X-Gm-Message-State: AGRZ1gK3YjBseFD4ISgw5+TDORUCQ4VvMxWNbU9u12WtFFkwk9/Bm5UL
        aHzvMNrQ3ZCUo6gqo/DkHGxLzWCrxVU=
X-Google-Smtp-Source: AJdET5f2q8+xfD5R6YLTJp7P6Q/YgEXcLCaCrcPn60mQoMaktdZ9Pb2qNUAFUbGNjFOo4zNco4sWiA==
X-Received: by 2002:a17:902:704c:: with SMTP id h12mr13124032plt.78.1542415651921;
        Fri, 16 Nov 2018 16:47:31 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id x184-v6sm22331649pfx.42.2018.11.16.16.47.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Nov 2018 16:47:30 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     qca-linux-team@qca.qualcomm.com
Cc:     <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] qca-swiss-army-knife: ath10k-fwencoder: add new 'single-chan-info-per-channel'
Date:   Fri, 16 Nov 2018 16:47:20 -0800
Message-Id: <20181117004720.205811-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.19.1.1215.g8438c0b245-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
This ancient Wifi still tells me I can send patches here, though I
haven't seen that much :)

https://github.com/mcgrof/qca-swiss-army-knife/wiki

 tools/scripts/ath10k/ath10k-fwencoder | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/scripts/ath10k/ath10k-fwencoder b/tools/scripts/ath10k/ath10k-fwencoder
index be1e7844345d..848e92054ff5 100755
--- a/tools/scripts/ath10k/ath10k-fwencoder
+++ b/tools/scripts/ath10k/ath10k-fwencoder
@@ -63,7 +63,8 @@ ATH10K_FW_FEATURE_ALLOWS_MESH_BCAST = 16
 ATH10K_FW_FEATURE_NO_PS = 17
 ATH10K_FW_FEATURE_MGMT_TX_BY_REF = 18
 ATH10K_FW_FEATURE_NON_BMI = 19
-ATH10K_FW_FEATURE_MAX = 20
+ATH10K_FW_FEATURE_SINGLE_CHAN_INFO_PER_CHANNEL = 20
+ATH10K_FW_FEATURE_MAX = 21
 
 feature_map = {
     'ext-wmi-mgmt-rx': ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX,
@@ -87,6 +88,8 @@ feature_map = {
     'no-ps': ATH10K_FW_FEATURE_NO_PS,
     'mgmt-tx-by-ref': ATH10K_FW_FEATURE_MGMT_TX_BY_REF,
     'non-bmi': ATH10K_FW_FEATURE_NON_BMI,
+    'single-chan-info-per-channel':
+        ATH10K_FW_FEATURE_SINGLE_CHAN_INFO_PER_CHANNEL,
 }
 
 # from enum ath10k_fw_wmi_op_version in ath10k/hw.h
-- 
2.19.1.1215.g8438c0b245-goog

