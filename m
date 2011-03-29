Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:36017 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1C2Av5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 20:51:57 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: remove unused macros in fw.h
Date: Mon, 28 Mar 2011 17:55:44 -0700
Message-Id: <1301360144-4986-4-git-send-email-bzhao@marvell.com>
In-Reply-To: <1301360144-4986-1-git-send-email-bzhao@marvell.com>
References: <1301360144-4986-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

These definitions are no longer used after previous cleanups.

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h |   42 -------------------------------------
 1 files changed, 0 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 2d93391..b4e4991 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -107,8 +107,6 @@ enum KEY_INFO_WAPI {
 
 #define FIRMWARE_READY				0xfedc
 
-#define FIRMWARE_TRANSFER_NBLOCK		2
-
 enum MWIFIEX_802_11_PRIVACY_FILTER {
 	MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL,
 	MWIFIEX_802_11_PRIV_FILTER_8021X_WEP
@@ -125,50 +123,22 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define TLV_TYPE_KEY_MATERIAL       (PROPRIETARY_TLV_BASE_ID + 0)
 #define TLV_TYPE_CHANLIST           (PROPRIETARY_TLV_BASE_ID + 1)
 #define TLV_TYPE_NUMPROBES          (PROPRIETARY_TLV_BASE_ID + 2)
-#define TLV_TYPE_RSSI_LOW           (PROPRIETARY_TLV_BASE_ID + 4)
-#define TLV_TYPE_SNR_LOW            (PROPRIETARY_TLV_BASE_ID + 5)
-#define TLV_TYPE_FAILCOUNT          (PROPRIETARY_TLV_BASE_ID + 6)
-#define TLV_TYPE_BCNMISS            (PROPRIETARY_TLV_BASE_ID + 7)
-#define TLV_TYPE_LEDBEHAVIOR        (PROPRIETARY_TLV_BASE_ID + 9)
 #define TLV_TYPE_PASSTHROUGH        (PROPRIETARY_TLV_BASE_ID + 10)
-#define TLV_TYPE_POWER_TBL_2_4GHZ   (PROPRIETARY_TLV_BASE_ID + 12)
-#define TLV_TYPE_POWER_TBL_5GHZ     (PROPRIETARY_TLV_BASE_ID + 13)
 #define TLV_TYPE_WMMQSTATUS         (PROPRIETARY_TLV_BASE_ID + 16)
 #define TLV_TYPE_WILDCARDSSID       (PROPRIETARY_TLV_BASE_ID + 18)
 #define TLV_TYPE_TSFTIMESTAMP       (PROPRIETARY_TLV_BASE_ID + 19)
-#define TLV_TYPE_RSSI_HIGH          (PROPRIETARY_TLV_BASE_ID + 22)
-#define TLV_TYPE_SNR_HIGH           (PROPRIETARY_TLV_BASE_ID + 23)
 
-#define TLV_TYPE_STARTBGSCANLATER   (PROPRIETARY_TLV_BASE_ID + 30)
 #define TLV_TYPE_AUTH_TYPE          (PROPRIETARY_TLV_BASE_ID + 31)
-#define TLV_TYPE_LINK_QUALITY       (PROPRIETARY_TLV_BASE_ID + 36)
-#define TLV_TYPE_RSSI_LOW_DATA      (PROPRIETARY_TLV_BASE_ID + 38)
-#define TLV_TYPE_SNR_LOW_DATA       (PROPRIETARY_TLV_BASE_ID + 39)
-#define TLV_TYPE_RSSI_HIGH_DATA     (PROPRIETARY_TLV_BASE_ID + 40)
-#define TLV_TYPE_SNR_HIGH_DATA      (PROPRIETARY_TLV_BASE_ID + 41)
 
 #define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
 #define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
-#define TLV_TYPE_BSSID              (PROPRIETARY_TLV_BASE_ID + 35)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
-#define TLV_TYPE_HT_CAP                  (PROPRIETARY_TLV_BASE_ID + 74)
-#define TLV_TYPE_HT_INFO                 (PROPRIETARY_TLV_BASE_ID + 75)
-#define TLV_SECONDARY_CHANNEL_OFFSET     (PROPRIETARY_TLV_BASE_ID + 76)
-#define TLV_TYPE_2040BSS_COEXISTENCE     (PROPRIETARY_TLV_BASE_ID + 77)
-#define TLV_TYPE_OVERLAP_BSS_SCAN_PARAM  (PROPRIETARY_TLV_BASE_ID + 78)
-#define TLV_TYPE_EXTCAP                  (PROPRIETARY_TLV_BASE_ID + 79)
-#define TLV_TYPE_HT_OPERATIONAL_MCS_SET  (PROPRIETARY_TLV_BASE_ID + 80)
-
-#define ADDBA_TID_MASK   (BIT(2) | BIT(3) | BIT(4) | BIT(5))
-#define DELBA_TID_MASK   (BIT(12) | BIT(13) | BIT(14) | BIT(15))
 #define SSN_MASK         0xfff0
 
 #define BA_RESULT_SUCCESS        0x0
-#define BA_RESULT_FAILURE        0x1
 #define BA_RESULT_TIMEOUT        0x2
-#define BA_RESULT_DATA_INVALID   0x3
 
 #define IS_BASTREAM_SETUP(ptr)  (ptr->ba_status)
 
@@ -214,7 +184,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 
 #define LLC_SNAP_LEN    8
 
-#define TLV_TYPE_RATE_DROP_PATTERN  (PROPRIETARY_TLV_BASE_ID + 81)
 #define TLV_TYPE_RATE_DROP_CONTROL  (PROPRIETARY_TLV_BASE_ID + 82)
 #define TLV_TYPE_RATE_SCOPE         (PROPRIETARY_TLV_BASE_ID + 83)
 
@@ -282,15 +251,7 @@ enum ENH_PS_MODES {
 #define HostCmd_RET_BIT                       0x8000
 #define HostCmd_ACT_GEN_GET                   0x0000
 #define HostCmd_ACT_GEN_SET                   0x0001
-#define HostCmd_ACT_GEN_REMOVE                0x0004
-#define HostCmd_ACT_SET_BOTH                  0x0003
-#define HostCmd_ACT_GET_BOTH                  0x000c
 #define HostCmd_RESULT_OK                     0x0000
-#define HostCmd_RESULT_ERROR                  0x0001
-#define HostCmd_RESULT_NOT_SUPPORT            0x0002
-#define HostCmd_RESULT_PENDING                0x0003
-#define HostCmd_RESULT_BUSY                   0x0004
-#define HostCmd_RESULT_PARTIAL_DATA           0x0005
 
 #define HostCmd_ACT_MAC_RX_ON                 0x0001
 #define HostCmd_ACT_MAC_TX_ON                 0x0002
@@ -298,11 +259,8 @@ enum ENH_PS_MODES {
 #define HostCmd_ACT_MAC_ETHERNETII_ENABLE     0x0010
 #define HostCmd_ACT_MAC_PROMISCUOUS_ENABLE    0x0080
 #define HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE  0x0100
-#define HostCmd_ACT_MAC_RTS_CTS_ENABLE        0x0200
-#define HostCmd_ACT_MAC_STRICT_PROTECTION_ENABLE  0x0400
 #define HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON     0x2000
 
-#define HostCmd_BSS_MODE_BSS                0x0001
 #define HostCmd_BSS_MODE_IBSS               0x0002
 #define HostCmd_BSS_MODE_ANY                0x0003
 
-- 
1.7.0.2

