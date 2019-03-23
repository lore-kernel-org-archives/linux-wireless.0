Return-Path: <SRS0=3nVx=R2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45820C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 10:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17A69218A5
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 10:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfCWKU2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Mar 2019 06:20:28 -0400
Received: from s2.neomailbox.net ([5.148.176.60]:6818 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfCWKU2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Mar 2019 06:20:28 -0400
X-Greylist: delayed 2393 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Mar 2019 06:20:27 EDT
From:   Antonio Quartulli <a@unstable.cc>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Antonio Quartulli <a@unstable.cc>
Subject: [PATCH] iw: print 4ADDR attribute when dumping interface
Date:   Sat, 23 Mar 2019 10:39:14 +0100
Message-Id: <20190323093914.3281-1-a@unstable.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Print the value of the 4ADDR attribute when dumping the interface
status.

Signed-off-by: Antonio Quartulli <a@unstable.cc>
---

This patch was sleeping in my local repo for a while .. maybe it is useful to
other people too.

Cheers,

 interface.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/interface.c b/interface.c
index 712bbdc..678955d 100644
--- a/interface.c
+++ b/interface.c
@@ -447,6 +447,11 @@ static int print_iface_handler(struct nl_msg *msg, void *arg)
 		printf("%s\tmulticast TXQ:%s\n", indent, buf);
 	}
 
+	if (tb_msg[NL80211_ATTR_4ADDR]) {
+		uint8_t use_4addr = nla_get_u8(tb_msg[NL80211_ATTR_4ADDR]);
+		printf("%s\t4addr: %d\n", indent, use_4addr);
+	}
+
 	return NL_SKIP;
 }
 
-- 
2.21.0

