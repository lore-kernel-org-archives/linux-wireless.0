Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56405 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab2GDIpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 04:45:31 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/4] introduce GCMP cipher
Date: Wed, 4 Jul 2012 11:45:10 +0300
Message-ID: <1341391511-11359-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120704_104536_215822_9A883DCA)
In-Reply-To: <1341391511-11359-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341391511-11359-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recognize OUI and print "GCMP" name

    Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 info.c |    2 ++
 scan.c |    3 +++
 2 files changed, 5 insertions(+)

diff --git a/info.c b/info.c
index e896eb5..50a9073 100644
--- a/info.c
+++ b/info.c
@@ -36,6 +36,8 @@ static char *cipher_name(__u32 c)
 		return "CCMP (00-0f-ac:4)";
 	case 0x000fac06:
 		return "CMAC (00-0f-ac:6)";
+	case 0x000fac08:
+		return "GCMP (00-0f-ac:8)";
 	case 0x00147201:
 		return "WPI-SMS4 (00-14-72:1)";
 	default:
diff --git a/scan.c b/scan.c
index 5f8ce93..7ae7929 100644
--- a/scan.c
+++ b/scan.c
@@ -305,6 +305,9 @@ static void print_cipher(const uint8_t *data)
 		case 6:
 			printf("AES-128-CMAC");
 			break;
+		case 8:
+			printf("GCMP");
+			break;
 		default:
 			printf("%.02x-%.02x-%.02x:%d",
 				data[0], data[1] ,data[2], data[3]);
-- 
1.7.9.5

