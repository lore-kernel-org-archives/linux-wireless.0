Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA3CC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 01:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD36020989
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 01:13:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JkS00Jap"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfBYBMt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Feb 2019 20:12:49 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46140 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfBYBMt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Feb 2019 20:12:49 -0500
Received: by mail-ot1-f65.google.com with SMTP id c18so6433686otl.13;
        Sun, 24 Feb 2019 17:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4yDD0h3RQse+g5OiHPmpM2XKhzpbYCMB2kyaR+4JK4E=;
        b=JkS00Japomfr/6S/bngFfWGlkxnBBwJ+Xs12k2ik56TXaHTw1NY+lvkEcxJ9wcRJAa
         PsP6lq3Y7UNV4uSgUOFDnwbKkU5BuBwHj8UkdrOXdzndptJ5++/B3wg1fLbKT+KXQJ8J
         vEV8DbJblQ18cWZiJDS0eOR0c7Ocm0z5ywRn0h2oc4CxOWjctk/snDDWpo7Hlcbca/QM
         kSUif53HaObg8ey3BPB6YiffzCXQccOolpCSun486jjbP68Hejj0Y0+Kq8PdT7OuEHaP
         PQ4CodwmOSB4V4nxrvK7RmSWPjsXENVA/qXf6bi1r0L/Ymynv2x49PuqpJxHjbk627Nf
         uHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=4yDD0h3RQse+g5OiHPmpM2XKhzpbYCMB2kyaR+4JK4E=;
        b=AifEUQ2SAoesdgUQKcQN52nGB5QPxbHhx5gSjUatWx5hzAHule6JzSzqQyBXyVhxbk
         Dj+sX10DB0gaaZpmxYL5sErIwnVLBXa+9YrS0Miz8XxXSJs4UZRzCe4477l+Otmo7nSf
         ztjDfvYIXe3sMm5m13Bt3pvQrjEgh1hV1aS063Vg+NoKZpIHcgoo4MFfHbp/GSJQPp11
         IgpC1JPHHJI+4cAR1BQiNEr/qb6ssXn30MziCfWSg6F8+rJcFY5sGCbSM8fblcR2pTmg
         Brp9EGb927lluAuhXP9MNZCFE29iZ8SayCKKeIpXD7Xemdr/9Law1r43IM895kaXaqeL
         ZYIg==
X-Gm-Message-State: AHQUAuZDNyR7rbKRwiBGMo46kYGl++Hh/I3+Kl3lHQ+4FQkNyiY3eNAm
        tZMew+jypcEbFjNmINTxjyv67xBi
X-Google-Smtp-Source: AHgI3IYAZxQNEJfoqnGRJ7WZIaHVQIUs1sylKYpH182NTKiGRMTAvjedyBQNUc6tMIa3pC74DqHMYA==
X-Received: by 2002:a05:6830:1255:: with SMTP id s21mr10251033otp.18.1551057166771;
        Sun, 24 Feb 2019 17:12:46 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id r1sm3490490otk.48.2019.02.24.17.12.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 17:12:46 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     linux-firmware@kernel.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        netdev@vger.kernel.org, Max Chou <max.chou@realtek.com>
Subject: [PATCH] rtl_bt: Update firmware for BT part of RTL8822C
Date:   Sun, 24 Feb 2019 19:12:42 -0600
Message-Id: <20190225011242.14002-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The file was sent to me by Max Chou <max.chou@realtek.com>.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Max Chou <max.chou@realtek.com>
---
 WHENCE                  |   2 ++
 rtl_bt/rtl8822cu_fw.bin | Bin 22412 -> 41588 bytes
 2 files changed, 2 insertions(+)

diff --git a/WHENCE b/WHENCE
index 853990b..351b312 100644
--- a/WHENCE
+++ b/WHENCE
@@ -3254,6 +3254,8 @@ Files rtl_bt/rtl8822b_* came directly from Realtek. These files are
 updated on April 14, 2017.
 Files rtl_bt/rtl8821c_* and rtl_bt/rtl8723d_* came directly from Realtek.
 File rtl_bt/rtl8822cu_fw.bin came directly from Realtek.
+updated on February 24, 2019
+File rtl_bt/rtl8822cu_fw.bin came directly from Realtek.
 
 --------------------------------------------------------------------------
 
diff --git a/rtl_bt/rtl8822cu_fw.bin b/rtl_bt/rtl8822cu_fw.bin
index 558037c14cb51243528cfb433c6ad4a829b716f7..9a43075277f8a01ab00e9d78a4e33e87d258e8a8 100644
GIT binary patch
delta 22071
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
BMYI3_

delta 4059
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
TbDL1YCx{ZBSZL?&7Q=r5PE^0=

-- 
2.20.1

