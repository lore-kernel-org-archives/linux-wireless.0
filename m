Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:58107 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933545AbbHJVxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 17:53:12 -0400
From: Joe Perches <joe@perches.com>
To: devel@driverdev.osuosl.org, Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 18/19] staging: wilc1000: Remove unnecessary externs
Date: Mon, 10 Aug 2015 14:51:33 -0700
Message-Id: <5765f9db0d6829956e40e3c033b080e046c3492e.1439241826.git.joe@perches.com> (sfid-20150810_235357_020717_D33497BC)
In-Reply-To: <cover.1439241825.git.joe@perches.com>
References: <cover.1439241825.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using 'extern' is not necessary for function prototypes.

Miscellanea:

o Reflow alignments

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       | 30 +++++++++++------------
 drivers/staging/wilc1000/linux_wlan_common.h      |  4 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  2 +-
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 56ff2ba..3af1935 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -163,27 +163,27 @@ typedef struct wid_site_survey_reslts {
 } wid_site_survey_reslts_s;
 #endif
 
-extern s32 CoreConfiguratorInit(void);
-extern s32 CoreConfiguratorDeInit(void);
+s32 CoreConfiguratorInit(void);
+s32 CoreConfiguratorDeInit(void);
 
-extern s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-			 u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
-extern s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
-extern s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
+s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
+		  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
+s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
+s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
-extern s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
-			      tstrConnectRespInfo **ppstrConnectRespInfo);
-extern s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo);
+s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
+		       tstrConnectRespInfo **ppstrConnectRespInfo);
+s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo);
 
 #ifndef CONNECT_DIRECT
-extern s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
-			      wid_site_survey_reslts_s **ppstrSurveyResults,
-			      u32 *pu32SurveyResultsCount);
-extern s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults);
+s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
+		       wid_site_survey_reslts_s **ppstrSurveyResults,
+		       u32 *pu32SurveyResultsCount);
+s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults);
 #endif
 
-extern s32 SendRawPacket(s8 *pspacket, s32 s32PacketLen);
-extern void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length);
+s32 SendRawPacket(s8 *pspacket, s32 s32PacketLen);
+void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length);
 void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length);
 void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length);
 
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 2476bfd..e6ebf3e 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -39,8 +39,8 @@ enum debug_region {
 #define FIRM_DBG                (1 << Firmware_debug)
 
 #if defined (WILC_DEBUGFS)
-extern int wilc_debugfs_init(void);
-extern void wilc_debugfs_remove(void);
+int wilc_debugfs_init(void);
+void wilc_debugfs_remove(void);
 
 extern atomic_t REGION;
 extern atomic_t DEBUG_LEVEL;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index c25350c..97b663b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -123,7 +123,7 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 #ifdef TCP_ENHANCEMENTS
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH 54
 #define DEFAULT_LINK_SPEED 72
-extern void Enable_TCP_ACK_Filter(bool value);
+void Enable_TCP_ACK_Filter(bool value);
 #endif
 
 #endif
-- 
2.1.2

