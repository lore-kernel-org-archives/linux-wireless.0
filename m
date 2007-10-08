Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:17996 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbXJHJ0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 05:26:44 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: fix u8 constant
Date: Mon, 8 Oct 2007 11:07:27 +0200
References: <Pine.LNX.4.64.0710071209290.8127@anakin>
In-Reply-To: <Pine.LNX.4.64.0710071209290.8127@anakin>
Cc: Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710081107.27285.hs4233@mail.mn-solutions.de> (sfid-20071008_102650_357060_D469C520)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't write constants that are (per documentation and struct) u8
as 0x0001, use 0x01 instead. Also remove an useless cast.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: libertas-2.6/drivers/net/wireless/libertas/host.h
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/host.h	2007-10-08 11:51:46.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/host.h	2007-10-08 11:52:10.000000000 +0200
@@ -138,8 +138,8 @@
 #define CMD_ACT_REMOVE                      0x0004
 #define CMD_ACT_USE_DEFAULT                 0x0008
 
-#define CMD_TYPE_WEP_40_BIT                 0x0001
-#define CMD_TYPE_WEP_104_BIT                0x0002
+#define CMD_TYPE_WEP_40_BIT                 0x01
+#define CMD_TYPE_WEP_104_BIT                0x02
 
 #define CMD_NUM_OF_WEP_KEYS                 4
 
Index: libertas-2.6/drivers/net/wireless/libertas/cmd.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/cmd.c	2007-10-08 11:52:13.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/cmd.c	2007-10-08 11:52:36.000000000 +0200
@@ -181,13 +181,13 @@ static int wlan_cmd_802_11_set_wep(wlan_
 
 			switch (pkey->len) {
 			case KEY_LEN_WEP_40:
-				wep->keytype[i] = (u8)CMD_TYPE_WEP_40_BIT;
+				wep->keytype[i] = CMD_TYPE_WEP_40_BIT;
 				memmove(&wep->keymaterial[i], pkey->key,
 				        pkey->len);
 				lbs_deb_cmd("SET_WEP: add key %d (40 bit)\n", i);
 				break;
 			case KEY_LEN_WEP_104:
-				wep->keytype[i] = (u8)CMD_TYPE_WEP_104_BIT;
+				wep->keytype[i] = CMD_TYPE_WEP_104_BIT;
 				memmove(&wep->keymaterial[i], pkey->key,
 				        pkey->len);
 				lbs_deb_cmd("SET_WEP: add key %d (104 bit)\n", i);
