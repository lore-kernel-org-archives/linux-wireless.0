Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:49211 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbbKZJMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 04:12:05 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NYF029QD07XAG10@mailout2.samsung.com> for
 linux-wireless@vger.kernel.org; Thu, 26 Nov 2015 18:11:57 +0900 (KST)
From: Rahul Jain <rahul.jain@samsung.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Amit Khatri <amit.khatri@samsung.com>,
	Rahul Jain <rahul.jain@samsung.com>
Subject: [PATCH 2/2]iw: UNSPECIFIED_CHAR_IN_COND : Fix
Date: Thu, 26 Nov 2015 14:41:20 +0530
Message-id: <1448529080-710-1-git-send-email-rahul.jain@samsung.com> (sfid-20151126_101214_793085_737C1A0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Khatri <amit.khatri@samsung.com>

Signed-off-by: Amit Khatri <amit.khatri@samsung.com>
Signed-off-by: Rahul Jain <rahul.jain@samsung.com>
---
 util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/util.c b/util.c
index 8fd14bd..7edc830 100644
--- a/util.c
+++ b/util.c
@@ -330,11 +330,13 @@ void print_ssid_escaped(const uint8_t len, const uint8_t *data)
 
 static int hex2num(char digit)
 {
+	unsigned char temp;
+	temp = digit;
 	if (!isxdigit(digit))
 		return -1;
 	if (isdigit(digit))
 		return digit - '0';
-	return tolower(digit) - 'a' + 10;
+	return tolower(temp) - 'a' + 10;
 }
 
 static int hex2byte(char *hex)
-- 
1.9.1

