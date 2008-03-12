Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:28678 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbYCLQJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 12:09:06 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: remove some unused commands
Date: Wed, 12 Mar 2008 17:06:09 +0100
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803121706.09735.hs4233@mail.mn-solutions.de> (sfid-20080312_160912_160391_1C4737C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Neither CMD_802_11_PAIRWISE_TSC nor CMD_802_11_GROUP_TSC is used or
documented. It might have something to do with TKIP sequence counters,
but that's just an educated guess. Remove all occurences of them.

CMD_CODE_DNLD is also neither used nor documented.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-12 15:09:19.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-12 15:41:49.000000000 +0100
@@ -1379,8 +1379,6 @@ int lbs_prepare_and_send_command(struct 
 	case CMD_802_11_AD_HOC_START:
 		ret = lbs_cmd_80211_ad_hoc_start(priv, cmdptr, pdata_buf);
 		break;
-	case CMD_CODE_DNLD:
-		break;
 
 	case CMD_802_11_RESET:
 		ret = lbs_cmd_802_11_reset(priv, cmdptr, cmd_action);
@@ -1440,11 +1438,6 @@ int lbs_prepare_and_send_command(struct 
 		ret = lbs_cmd_80211_ad_hoc_stop(priv, cmdptr);
 		break;
 
-	case CMD_802_11_PAIRWISE_TSC:
-		break;
-	case CMD_802_11_GROUP_TSC:
-		break;
-
 	case CMD_802_11_MAC_ADDRESS:
 		ret = lbs_cmd_802_11_mac_address(priv, cmdptr, cmd_action);
 		break;
Index: wireless-testing/drivers/net/wireless/libertas/host.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/host.h	2008-03-12 15:09:19.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/host.h	2008-03-12 15:41:41.000000000 +0100
@@ -33,7 +33,6 @@
 #define CMD_RET_802_11_ASSOCIATE		0x8012
 
 /* Command codes */
-#define CMD_CODE_DNLD				0x0002
 #define CMD_GET_HW_SPEC				0x0003
 #define	CMD_EEPROM_UPDATE			0x0004
 #define CMD_802_11_RESET			0x0005
@@ -68,8 +67,6 @@
 #define CMD_802_11_AD_HOC_JOIN			0x002c
 #define CMD_802_11_QUERY_TKIP_REPLY_CNTRS	0x002e
 #define CMD_802_11_ENABLE_RSN			0x002f
-#define CMD_802_11_PAIRWISE_TSC			0x0036
-#define CMD_802_11_GROUP_TSC			0x0037
 #define CMD_802_11_SET_AFC			0x003c
 #define CMD_802_11_GET_AFC			0x003d
 #define CMD_802_11_AD_HOC_STOP			0x0040
