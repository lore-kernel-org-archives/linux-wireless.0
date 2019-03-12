Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8306AC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 04:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F5332087C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 04:39:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="QIGxcr0u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfCLEjv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 00:39:51 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:41566 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfCLEju (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 00:39:50 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id E0A36A06
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 04:39:48 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Dxo_mizHoM_o for <linux-wireless@vger.kernel.org>;
        Mon, 11 Mar 2019 23:39:48 -0500 (CDT)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id B0F64712
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 23:39:48 -0500 (CDT)
Received: by mail-io1-f69.google.com with SMTP id k5so916691ioh.13
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 21:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=CjRuBsTPxOSNjGTsK1VobIY7FzAvfFeIc8QwTDAuL4Q=;
        b=QIGxcr0uW/vlEvdgJ1yLDQPxwUPZgHh0gbyEiyB0Ly5SHEjTd2qMz8pxpGGLplLEVT
         /mKMlRKR4uJ++vNyG4gIh1qiYrKDR5ZYcHXEDJnF9TGcKQXkHCdWu5nnPBr1cyQLZMax
         M8BgyQlml5HxoysxHuTltkakRkWA4AUW554ExjJoFjZsclxzMYC/IrwUC6Y0vkwzc7bA
         ub7lsFROfcngGejz628Q15PZ7Ul8vvDHtWh6R0I99BSw1htrM8ePoH4DjOdaavTtwPBg
         mclQ0A8FkClzbFZ8+njfbXPkOownZLjS4SUQ5gD5o5JwHS+PbNyJTHQHGOqvG6OogNcw
         SrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CjRuBsTPxOSNjGTsK1VobIY7FzAvfFeIc8QwTDAuL4Q=;
        b=CvBigRvqCozEQlqhUHEVBl256H50YUj3vgRe5Hd1bPiyPVYlyErV/k06T/nyDmEbTE
         Kxzi9DgBszjLLZk0S7UDGriF8UmJS55X3JLpvag4EgU3SCVwz3ltaVPNQTEerVmL+P7k
         e9uSM6hEwCFI0miIpGP9XpJFTYDtWKuzgEfw09e1k3YHZ5JPWfP6AgVUH1wYEle+WUxh
         /zBqAboOwJPP2rSUdXdtXIBf104Yj7Bw+mhN3xBR7hDr7HOxenYruW35NLrW8EyR4w+C
         WuKAyshG8YHF0qcniiZsk5uzULJ60m7O8mBG9W7TaeIpXG+vlhxwl5LaQLuuitbVLXyR
         m87w==
X-Gm-Message-State: APjAAAW+hcbU1iebeLHA7ZdHts7Za/0kTePwJpOLVbL2OjbeeyT0Bl3C
        b2e459LodmrvWW8u+07omrLnJXU4xN6v5citMVqGRhOlaybkc5p1qsjAuaSxjL+Dojq5eLKIStD
        i2ry+accrOzEVya0lp35P1GYjFw34/a4=
X-Received: by 2002:a24:2847:: with SMTP id h68mr895147ith.82.1552365588263;
        Mon, 11 Mar 2019 21:39:48 -0700 (PDT)
X-Google-Smtp-Source: APXvYqykaFubQmtG1am3j9NH2GUFQBME4vgBHar8hqOKQ98fhQ2Lv4IGc1wVOxBKYgIPhPW13s+Cow==
X-Received: by 2002:a24:2847:: with SMTP id h68mr895130ith.82.1552365587953;
        Mon, 11 Mar 2019 21:39:47 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id v141sm269580ita.18.2019.03.11.21.39.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 21:39:46 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: brcm80211: fix missing checks for kmemdup
Date:   Mon, 11 Mar 2019 23:39:27 -0500
Message-Id: <20190312043929.727-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case kmemdup fails, the fix sets conn_info->req_ie_len to zero
to avoid buffer overflows.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index e92f6351bd22..5d9a3c35fef5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5464,6 +5464,8 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 		conn_info->req_ie =
 		    kmemdup(cfg->extra_buf, conn_info->req_ie_len,
 			    GFP_KERNEL);
+		if (!conn_info->req_ie)
+			conn_info->req_ie_len = 0;
 	} else {
 		conn_info->req_ie_len = 0;
 		conn_info->req_ie = NULL;
@@ -5480,6 +5482,8 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 		conn_info->resp_ie =
 		    kmemdup(cfg->extra_buf, conn_info->resp_ie_len,
 			    GFP_KERNEL);
+		if (!conn_info->resp_ie)
+			conn_info->req_ie_len = 0;
 	} else {
 		conn_info->resp_ie_len = 0;
 		conn_info->resp_ie = NULL;
-- 
2.17.1

