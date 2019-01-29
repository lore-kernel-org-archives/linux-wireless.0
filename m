Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39043C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 18:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A71520869
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 18:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfA2SZ5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 13:25:57 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52789 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfA2SZ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 13:25:57 -0500
Received: by mail-wm1-f66.google.com with SMTP id m1so18944674wml.2
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 10:25:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oqqU9uCKGZ/+5XXFPB6sxLAJCCzPhsXLR5WA45LzXsU=;
        b=uXVWoywjcZCt5JZuyrNy+ArwIqe0F7doCPPvPnrZl1t9M8kNmUV2TiTlr6L7bmRViL
         yJcomMejJQKWwVYOh5RDxdm1RcRMJ+3K8RdI6obHdR0k74RrhI5PRIgSqtkdmxrTAlLK
         GBZkFxkIgjad1/j9Y1xhhdMY6PiGoQXUQ8rBO3A+92inNsfoub2WuA9xZVXws5W4e67D
         2oq8VXhSicT8ElDzhhyDFvSeLJlr7uT38/9DEybEWmpo/CMlsSTYU6hCYkTkmJ9qpGr/
         I2yBXPsTLce5TsjhroNBAG/h3HRZloQ7HLWy1NtQmVGkz9TMhrmC1bMi8NhuxWYB8D5Z
         FoNA==
X-Gm-Message-State: AJcUukfxAw3Dk7yrN4u+lU7KddpY0GvRT35/63xUkJuGzbuZV0iLKyS/
        7AYCJxldqnMqfyG0vIvoMHmdox9EKeM=
X-Google-Smtp-Source: ALg8bN4BQ2VJs5ONkZT86mQmxOC9l4hokoX/Arjo3pk5A1YSvUNk3Jnn1KFnnVYLDonJeCY1+/BnkQ==
X-Received: by 2002:a1c:30b:: with SMTP id 11mr22235165wmd.110.1548786355010;
        Tue, 29 Jan 2019 10:25:55 -0800 (PST)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v6sm124797810wrd.88.2019.01.29.10.25.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 10:25:54 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH mac80211-next] cfg80211: fix typo
Date:   Tue, 29 Jan 2019 19:25:53 +0100
Message-Id: <20190129182553.443-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix spelling mistake in cfg80211.h: "lenght" -> "length".
The typo is also in the special comment block which
translates to documentation.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e0c41eb1c860..237839210a36 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5568,7 +5568,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
  * @dev: network device
  * @macaddr: the MAC address of the new candidate
  * @ie: information elements advertised by the peer candidate
- * @ie_len: lenght of the information elements buffer
+ * @ie_len: length of the information elements buffer
  * @gfp: allocation flags
  *
  * This function notifies cfg80211 that the mesh peer candidate has been
-- 
2.20.1

