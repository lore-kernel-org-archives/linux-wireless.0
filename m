Return-Path: <SRS0=4aWb=A7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF93FC433DF
	for <linux-wireless@archiver.kernel.org>; Mon, 20 Jul 2020 14:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE3FE22B4E
	for <linux-wireless@archiver.kernel.org>; Mon, 20 Jul 2020 14:52:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.cipht.net header.i=@mg.cipht.net header.b="gmitZM1K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgGTOwJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 20 Jul 2020 10:52:09 -0400
Received: from m42-7.mailgun.net ([69.72.42.7]:17119 "EHLO m42-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgGTOwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Jul 2020 10:52:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.cipht.net; q=dns/txt;
 s=mailo; t=1595256728; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=phX0axoq3uT/fW4P3Mg+Pdgs/5gJncqzSjzV8Av9Mms=; b=gmitZM1KYjaMG2jgyN32UkT4ZdLGqJ48hCx7BuxDsjPn3Q5PdVqXukp+BGKWFs3y97meyFhd
 YDHwAhIsd0tgXwmJQkBoFRzTCpbh/0U5Njkz6j/gkqDqvq9J0co8RHI1A1iPxqWjJQitxVGJ
 85xEM+0wh4vsj0z5GOsvcLhgcgY=
X-Mailgun-Sending-Ip: 69.72.42.7
X-Mailgun-Sid: WyJlMWU0MyIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiZDFjMTNjIl0=
Received: from quelaan.hitronhub.home
 (CPE84948c4ba0f3-CM84948c4ba0f0.cpe.net.cable.rogers.com [174.117.215.139])
 by smtp-out-n18.prod.us-west-2.postgun.com with SMTP id
 5f15af90d50c36e7295529e7 (version=TLS1.3, cipher=TLS_AES_128_GCM_SHA256);
 Mon, 20 Jul 2020 14:52:00 GMT
From:   Julian Squires <julian@cipht.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Julian Squires <julian@cipht.net>
Subject: [PATCH] cfg80211: allow vendor dumpit to terminate by returning 0
Date:   Mon, 20 Jul 2020 12:20:35 -0230
Message-Id: <20200720145033.401307-1-julian@cipht.net>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Although it's likely that I'm misunderstanding the intended interface
for vendor command dumpit, I couldn't find any detailed documentation
on it, or examples of drivers implementing it, so I'm sending in this
patch hoping it will at least lead to clarification.

It seems to me that dumpit, like netlink_callback->dump, should signal
successful completion by returning 0.

Currently, that will just cause dumpit to be called again, possibly
many times until an error occurs.  Since skb->len is never going to be
0 by the time dumpit is called, the only way for dumpit to signal
completion is by returning an error.  If it returns a positive value,
the current message is cancelled, but that positive value is returned
and nl80211_vendor_cmd_dump gets called again.

Signed-off-by: Julian Squires <julian@cipht.net>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 78442fc4fc01..229d48ccf57f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13156,7 +13156,7 @@ static int nl80211_vendor_cmd_dump(struct sk_buff *skb,
 		if (err == -ENOBUFS || err == -ENOENT) {
 			genlmsg_cancel(skb, hdr);
 			break;
-		} else if (err) {
+		} else if (err <= 0) {
 			genlmsg_cancel(skb, hdr);
 			goto out;
 		}
-- 
2.27.0

