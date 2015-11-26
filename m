Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:38306 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbKZJLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 04:11:15 -0500
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NYF00TN506MIH30@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Thu, 26 Nov 2015 18:11:10 +0900 (KST)
From: Rahul Jain <rahul.jain@samsung.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Amit Khatri <amit.khatri@samsung.com>,
	Rahul Jain <rahul.jain@samsung.com>
Subject: [PATCH 1/2]iw: DEREF_AFTER_NULL: fix
Date: Thu, 26 Nov 2015 14:40:19 +0530
Message-id: <1448529019-661-1-git-send-email-rahul.jain@samsung.com> (sfid-20151126_101131_309752_BE67E944)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Khatri <amit.khatri@samsung.com>

Signed-off-by: Amit Khatri <amit.khatri@samsung.com>
Signed-off-by: Rahul Jain <rahul.jain@samsung.com>
---
 wowlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/wowlan.c b/wowlan.c
index 25f260b..ac2c13d 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -194,7 +194,8 @@ static int wowlan_parse_tcp_file(struct nl_msg *msg, const char *fn)
 	err = -ENOBUFS;
  close:
 	fclose(f);
-	nla_nest_end(msg, tcp);
+	if(tcp)
+		nla_nest_end(msg, tcp);
 	return err;
 }
 
-- 
1.9.1

