Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35140 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbcGFMmC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 08:42:02 -0400
Received: by mail-wm0-f65.google.com with SMTP id a66so35375390wme.2
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2016 05:42:02 -0700 (PDT)
From: =?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@gmail.com>
Subject: [PATCH] iw: recognize 256-bit cipher suites
Date: Wed,  6 Jul 2016 15:41:41 +0300
Message-Id: <20160706124141.564692-1-grawity@gmail.com> (sfid-20160706_144207_581106_6E9A134A)
In-Reply-To: <CAPWNY8UmGXA0S34HUYnPvhsqV80v1K_W4NC8wnSF=Gf8S75yFw@mail.gmail.com>
References: <CAPWNY8UmGXA0S34HUYnPvhsqV80v1K_W4NC8wnSF=Gf8S75yFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mantas Mikulėnas <grawity@gmail.com>
---
 info.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/info.c b/info.c
index b375123..1eba5c9 100644
--- a/info.c
+++ b/info.c
@@ -31,11 +31,21 @@ static char *cipher_name(__u32 c)
 	case 0x000fac02:
 		return "TKIP (00-0f-ac:2)";
 	case 0x000fac04:
-		return "CCMP (00-0f-ac:4)";
+		return "CCMP-128 (00-0f-ac:4)";
 	case 0x000fac06:
 		return "CMAC (00-0f-ac:6)";
 	case 0x000fac08:
-		return "GCMP (00-0f-ac:8)";
+		return "GCMP-128 (00-0f-ac:8)";
+	case 0x000fac09:
+		return "GCMP-256 (00-0f-ac:9)";
+	case 0x000fac0a:
+		return "CCMP-256 (00-0f-ac:10)";
+	case 0x000fac0b:
+		return "GMAC-128 (00-0f-ac:11)";
+	case 0x000fac0c:
+		return "GMAC-256 (00-0f-ac:12)";
+	case 0x000fac0d:
+		return "CMAC-256 (00-0f-ac:13)";
 	case 0x00147201:
 		return "WPI-SMS4 (00-14-72:1)";
 	default:
-- 
2.9.0

