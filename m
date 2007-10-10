Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2928 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbXJJBjf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 21:39:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: fix endianness breakage
Date: Tue,  9 Oct 2007 21:30:42 -0400
Message-Id: <11919798433410-git-send-email-linville@tuxdriver.com> (sfid-20071010_023937_362225_C3B5FF7E)
In-Reply-To: <11919798433964-git-send-email-linville@tuxdriver.com>
References: <11919798433964-git-send-email-linville@tuxdriver.com>
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

