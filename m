Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3992 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbXJZVHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:07:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: fix endianness breakage
Date: Fri, 26 Oct 2007 17:04:27 -0400
Message-Id: <11934326803330-git-send-email-linville@tuxdriver.com> (sfid-20071026_220751_114041_927EEEE5)
In-Reply-To: <11934326803769-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Al Viro <viro@ftp.linux.org.uk>

	wep->keytype[] is u8

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas/cmd.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 4a8f5dc..86fff8d 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -185,14 +185,12 @@ static int wlan_cmd_802_11_set_wep(wlan_private * priv,
 
 			switch (pkey->len) {
 			case KEY_LEN_WEP_40:
-				wep->keytype[i] =
-					cpu_to_le16(cmd_type_wep_40_bit);
+				wep->keytype[i] = cmd_type_wep_40_bit;
 				memmove(&wep->keymaterial[i], pkey->key,
 				        pkey->len);
 				break;
 			case KEY_LEN_WEP_104:
-				wep->keytype[i] =
-					cpu_to_le16(cmd_type_wep_104_bit);
+				wep->keytype[i] = cmd_type_wep_104_bit;
 				memmove(&wep->keymaterial[i], pkey->key,
 				        pkey->len);
 				break;
-- 
1.5.2.4

