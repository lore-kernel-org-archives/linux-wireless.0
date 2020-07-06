Return-Path: <SRS0=AxV3=AR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD808C433DF
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jul 2020 21:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 673442064C
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jul 2020 21:19:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.cipht.net header.i=@mg.cipht.net header.b="N9PIwGNo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgGFVTs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Jul 2020 17:19:48 -0400
Received: from m42-7.mailgun.net ([69.72.42.7]:37179 "EHLO m42-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbgGFVTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Jul 2020 17:19:48 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2020 17:19:47 EDT
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.cipht.net; q=dns/txt;
 s=mailo; t=1594070388; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=y46UTPpAFgIIXslRAziMQZJaZWiv42x6vkspq2qAmcU=; b=N9PIwGNoQZhJgpVH6J21ktrXceyBfqGh/h83p3sohi8tQYxkxV7Bfq9sCZyXl03uufq7E7V9
 XL3c0bY2F8n3yn6fpbMKYCLdriDqt7ueNfVCBdIyT2wJTmxUBXvYfOn/ROWSC39MZzYJYhCV
 GtrqD8kOXaky9I5HpvH4eajvCeg=
X-Mailgun-Sending-Ip: 69.72.42.7
X-Mailgun-Sid: WyJlMWU0MyIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiZDFjMTNjIl0=
Received: from localhost.localdomain (172-97-136-92.cpe.distributel.net
 [172.97.136.92]) by smtp-out-n12.prod.us-west-2.postgun.com with SMTP id
 5f03944455886724ff9d8c21 (version=TLS1.3, cipher=TLS_AES_128_GCM_SHA256);
 Mon, 06 Jul 2020 21:14:44 GMT
From:   Julian Squires <julian@cipht.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Julian Squires <julian@cipht.net>
Subject: [PATCH] cfg80211: check vendor command doit pointer before use
Date:   Mon,  6 Jul 2020 17:13:53 -0400
Message-Id: <20200706211353.2366470-1-julian@cipht.net>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In the case where a vendor command does not implement doit, and has no
flags set, doit would not be validated and a NULL pointer dereference
would occur, for example when invoking the vendor command via iw.

I encountered this while developing new vendor commands.  Perhaps in
practice it is advisable to always implement doit along with dumpit,
but it seems reasonable to me to always check doit anyway, not just
when NEED_WDEV.

Signed-off-by: Julian Squires <julian@cipht.net>
---
 net/wireless/nl80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0e07fb8585fb..7fbca0854265 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13266,13 +13266,13 @@ static int nl80211_vendor_cmd(struct sk_buff *skb, struct genl_info *info)
 				if (!wdev_running(wdev))
 					return -ENETDOWN;
 			}
-
-			if (!vcmd->doit)
-				return -EOPNOTSUPP;
 		} else {
 			wdev = NULL;
 		}
 
+		if (!vcmd->doit)
+			return -EOPNOTSUPP;
+
 		if (info->attrs[NL80211_ATTR_VENDOR_DATA]) {
 			data = nla_data(info->attrs[NL80211_ATTR_VENDOR_DATA]);
 			len = nla_len(info->attrs[NL80211_ATTR_VENDOR_DATA]);
-- 
2.27.0

