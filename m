Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A97DC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 17:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 575D7218A1
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 17:05:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="N3HPYaSz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbfCORFK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 13:05:10 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:46452 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729721AbfCORFD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 13:05:03 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 66A30D84
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2019 17:05:02 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HjWeIb6fkpar for <linux-wireless@vger.kernel.org>;
        Fri, 15 Mar 2019 12:05:02 -0500 (CDT)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 913ADDC8
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2019 12:04:57 -0500 (CDT)
Received: by mail-io1-f69.google.com with SMTP id i24so7458910iol.21
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2019 10:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YwhJH5GB8pt3iUXHf1JwdPsOSGOUsqwtuBgclVL38OY=;
        b=N3HPYaSzmMUcfpXv0GDgM0GirnqjPjI0rSmUip+D9QomIcsEzf/jIDvzDyaY39eh0I
         /MKwKr8fboM3CBF23ZwhvYwNINJpAOCuuWPFxbvzG+rhSBLZI5qTCTUczE3pdWOa4VAb
         B+AQsuDhsXT3uTiYDTLNVj90GMxoPBxrsxHMoU0VGALgDn4U7nzjtzZoer8Je/gSjOHR
         TK9yZGpf3PBsg5UtvJGHag8qzOvlH64D392r/Kdyx90Jwyxv8/Um+43T4Bz16YO9lY9V
         R76FtEAxxEAQYjnCt7ivwnhxRa1Yc2AE+WDgc0C9kuWhQSYtcVeAS+3gMsVSKV4Rb+xo
         Lzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YwhJH5GB8pt3iUXHf1JwdPsOSGOUsqwtuBgclVL38OY=;
        b=KWtsAl1RB/HVmuEToQOXqEy/GRozUZSTCNZyn848IxknGMm4SaUHtBEo0Ef+VVd9pU
         HdmqWAdRVc73nGHPFtQnxus+jtgs7R99eOC5jLHUmg4CxGVn1YkOhNs5qa8HBDERijCV
         LIKQ9fa4AHcKPbhOHDaQZ75qUVZ8xxwhJEa0Pz9lMabuMV81rXf+bThrF2Guj8TnAwFi
         VaQo0ID7LQMpK5Q6E6Lafug1MFyzshmsXDoXUzaaOcMkB3O4/5+6BEqeyorU49zy1ECn
         +MZXvXNzRbGKi1mwbMTBaaopHwc5mT1Se0XQOe5Q4dJ+oA4NTWm4PlH/Fd+WQBrQr9ID
         R+lw==
X-Gm-Message-State: APjAAAVn30u3kxrnQXA+ClyfefdGUGrFswKI5oBZPRhoaO9ushUgXy67
        Bav0u5YJY2hY69C5JKkMY3OrQ9PtvJD8+rOcYiMoa5nRgD0SyslK7S4pW3BE8FIW7niGrrvfORs
        UnkUQI/00M5blxLH+/Gom82c2xKSeJe4=
X-Received: by 2002:a24:2f84:: with SMTP id j126mr2967794itj.42.1552669496537;
        Fri, 15 Mar 2019 10:04:56 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy6M+Y0g5R4vG7BpUfWzMKZ8eyPQDVJ07+uA8YqCt1mkPv00mGK715tCuwj1IqDC2PzateaGw==
X-Received: by 2002:a24:2f84:: with SMTP id j126mr2967759itj.42.1552669496196;
        Fri, 15 Mar 2019 10:04:56 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id e10sm923664iok.85.2019.03.15.10.04.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2019 10:04:55 -0700 (PDT)
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
Subject: [PATCH v3] brcmfmac: fix missing checks for kmemdup
Date:   Fri, 15 Mar 2019 12:04:32 -0500
Message-Id: <20190315170433.3845-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <d712dd26-8b51-143a-b3ff-ad44f2774944@broadcom.com>
References: <d712dd26-8b51-143a-b3ff-ad44f2774944@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case kmemdup fails, the fix sets conn_info->req_ie_len and
conn_info->resp_ie_len to zero to avoid buffer overflows.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index e92f6351bd22..8ee8af4e7ec4 100644
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
+			conn_info->resp_ie_len = 0;
 	} else {
 		conn_info->resp_ie_len = 0;
 		conn_info->resp_ie = NULL;
-- 
2.17.1

