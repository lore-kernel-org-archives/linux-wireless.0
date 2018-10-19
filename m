Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F46BC67863
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 02:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E58DF20645
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 02:37:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E58DF20645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbeJSKlc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 06:41:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51353 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbeJSKlb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 06:41:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id 143-v6so2119540wmf.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 19:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1Qhau7MYou0yBV6VtIG0r5HsZFt6EdJqy054+lTJEP8=;
        b=pc6ylTwbY3EmnHlgKobGGwVnLn5tI5QpGNxXxA9QbTBR8lQgbFQvhBEu28OOZtPqN4
         0R0jTAJFfRQjm8m85i+c5JxKLb58L+4aCEiOU9s/NJyWiAopapzU+d6jCBCNelr5rb4u
         CI0BRuUkK8Xty2GV5Ze82vNeRZ7M8hAr+Sbo3h3l4bPEhTt2bCOEllXuq1VoOyVX5ead
         NsyizgrgzgB/8cZ+kA0X+rxq50Hcl6jir9oX2LnODk0+UG2NVq6ypEm1OjgKdo1KfpSS
         KBrHOvHRoUvDPoPk9qHlp5bV12ryw04Q9cdlOEkc1PUedmsdzXzJhbM9STYYiyN5mRLH
         FAbA==
X-Gm-Message-State: ABuFfoiTdGNnS8SmtiAZhJ/ZA61+MiAkwSSni0avPgnQw5RUnR0D7vX7
        z3KkyQUfelDLS5M6iEX4DkFGvpRz
X-Google-Smtp-Source: ACcGV60eB04rZTgl4JrIx2WGZ91RTI2tVxFxZUOq7vOKVLPWCPaRPts3dcp1Ws7M/IK02rbWWINAOg==
X-Received: by 2002:a1c:8942:: with SMTP id l63-v6mr2888960wmd.66.1539916650745;
        Thu, 18 Oct 2018 19:37:30 -0700 (PDT)
Received: from iss.Home ([139.47.105.30])
        by smtp.gmail.com with ESMTPSA id o17-v6sm20935823wro.2.2018.10.18.19.37.28
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Oct 2018 19:37:29 -0700 (PDT)
From:   Andrew Zaborowski <andrew.zaborowski@intel.com>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Emit a NEW_INTERFACE on iftype change
Date:   Fri, 19 Oct 2018 04:37:22 +0200
Message-Id: <20181019023722.6226-1-andrew.zaborowski@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Let userspace learn about iftype changes by sending an
NL80211_CMD_NEW_INTERFACE when handling a NL80211_CMD_SET_INTERFACE
command.  There seems to be no other place where the iftype can change:
nl80211_set_interface is the only caller of cfg80211_change_iface which
is the only caller of ops->change_virtual_intf.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 net/wireless/nl80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ac08ba5f0a..7b6b214bb4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3165,6 +3165,12 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 	if (!err && params.use_4addr != -1)
 		dev->ieee80211_ptr->use_4addr = params.use_4addr;
 
+	if (change && !err) {
+		struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
+	}
+
 	return err;
 }
 
-- 
2.19.1

