Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:51359 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbZHNMR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 08:17:59 -0400
Received: by bwz22 with SMTP id 22so1106892bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 05:17:59 -0700 (PDT)
Message-ID: <4A8555F5.5090603@gmail.com>
Date: Fri, 14 Aug 2009 14:17:57 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] b43: Add LP-PHY firmware loading support
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for loading LP-PHY firmware to b43_try_request_fw.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/main.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index fbcbe4f..51767fa 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2062,8 +2062,12 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 		filename = "ucode5";
 	else if ((rev >= 11) && (rev <= 12))
 		filename = "ucode11";
-	else if (rev >= 13)
+	else if (rev == 13)
 		filename = "ucode13";
+	else if (rev == 14)
+		filename = "ucode14";
+	else if (rev >= 15)
+		filename = "ucode15";
 	else
 		goto err_no_ucode;
 	err = b43_do_request_fw(ctx, filename, &fw->ucode);
@@ -2111,6 +2115,16 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 		else
 			goto err_no_initvals;
 		break;
+	case B43_PHYTYPE_LP:
+		if (rev == 13)
+			filename = "lp0initvals13";
+		else if (rev == 14)
+			filename = "lp0initvals14";
+		else if (rev >= 15)
+			filename = "lp0initvals15";
+		else
+			goto err_no_initvals;
+		break;
 	default:
 		goto err_no_initvals;
 	}
@@ -2145,6 +2159,15 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 		else
 			goto err_no_initvals;
 		break;
+	case B43_PHYTYPE_LP:
+		if (rev == 13)
+			filename = "lp0bsinitvals13";
+		else if (rev == 14)
+			filename = "lp0bsinitvals14";
+		else if (rev >= 15)
+			filename = "lp0bsinitvals15";
+		else
+			goto err_no_initvals;
 	default:
 		goto err_no_initvals;
 	}
-- 
1.6.2.4



