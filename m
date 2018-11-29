Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A07EC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 02:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25356206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 02:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="G964AWSC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25356206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbeK2Nmi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 08:42:38 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42704 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbeK2Nmi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 08:42:38 -0500
Received: by mail-pl1-f193.google.com with SMTP id x21-v6so228712pln.9
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2018 18:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CApyoOuU/oo6VDPTry9e5ylt0AFhnlyjooBhd+0eLUA=;
        b=G964AWSCKYKc/nlogm8uTGETNhveH4rzsU9LyBjPH8gyxKcM4FJf9aJMrLnkuMwD5T
         XWsre+ULMctgx5+neUVNJ2ayxH+J7KERHAu1BcKAyGbBhdgOsW4s0Pu/gQafifBxZ1t4
         e/MVVv+nah7jLkWN+jJ8BidzSNiKzrFhjE3Xk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CApyoOuU/oo6VDPTry9e5ylt0AFhnlyjooBhd+0eLUA=;
        b=ME5xuz3PsQbiJWDOxuomJdjRpHDa6YBHF0Xh6jZE4E7TvaYy0ObLi5EnvAF6QBd6xB
         W8ReeZRi0PuQP/VPLACe4ka8iF8lVRBMeDilwDzIaThvgW8hxbgsjYTuzniOEuOHjsal
         nMXxYUpWFdExJ4PUDS+6IYcQD8aOvKqjEEH8xHhIwHbwIlXD6zhuOXoSitRmQ6h05TfK
         90ei/irb3YsU0BIAb5E/ztBL8Zlx/G/11CNOnmpmpaGLPBAqO16R5OjGi2np8OOCZimz
         s+kvf2e8zYEEDY2wyuyl9hiQlAkJuL8M48Klmk/O/QDliB3G5GBCfNnDY8LdIIxpA9pc
         HhmQ==
X-Gm-Message-State: AA+aEWaiBVNE89BMLVTaLVUS24XsfFsxwRqcnNHZ7OQUFT8H0fiTSEEH
        RpjX8zNJFvIkPn1nehoz9XdKVQ==
X-Google-Smtp-Source: AFSGD/XwQlrgYDfUC64QIA+jQwJa8uQiX3SSrMxk4FdYbpU/TpsJ+jVdr15BB4WK+P11pqog5m6XFw==
X-Received: by 2002:a17:902:7d82:: with SMTP id a2mr4854083plm.163.1543459132433;
        Wed, 28 Nov 2018 18:38:52 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id q1sm414280pfb.96.2018.11.28.18.38.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Nov 2018 18:38:51 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] iw: dump 'rx bitrate' in link stats
Date:   Wed, 28 Nov 2018 18:38:48 -0800
Message-Id: <20181129023848.186299-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.20.0.rc0.387.gc7a69e6b6c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We include it in 'station dump' but not 'link'.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 link.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/link.c b/link.c
index 0a323920ff2f..1ed7f631a121 100644
--- a/link.c
+++ b/link.c
@@ -121,6 +121,7 @@ static int print_link_sta(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_RX_PACKETS] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_TX_PACKETS] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_SIGNAL] = { .type = NLA_U8 },
+		[NL80211_STA_INFO_RX_BITRATE] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_TX_BITRATE] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_LLID] = { .type = NLA_U16 },
 		[NL80211_STA_INFO_PLID] = { .type = NLA_U16 },
@@ -160,6 +161,12 @@ static int print_link_sta(struct nl_msg *msg, void *arg)
 		printf("\tsignal: %d dBm\n",
 			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL]));
 
+	if (sinfo[NL80211_STA_INFO_RX_BITRATE]) {
+		char buf[100];
+
+		parse_bitrate(sinfo[NL80211_STA_INFO_RX_BITRATE], buf, sizeof(buf));
+		printf("\trx bitrate: %s\n", buf);
+	}
 	if (sinfo[NL80211_STA_INFO_TX_BITRATE]) {
 		char buf[100];
 
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog

