Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34334 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbbHPFao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 01:30:44 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: wilc1000: code style: fix globals initialized to false
Date: Sun, 16 Aug 2015 01:30:13 -0400
Message-Id: <f2aa32ae321011c30cb9af96ff32fcc56c5faf0e.1439702894.git.raphael.beamonte@gmail.com> (sfid-20150816_073110_825970_3BB29BF8)
In-Reply-To: <cover.1439702894.git.raphael.beamonte@gmail.com>
References: <cover.1439702894.git.raphael.beamonte@gmail.com>
In-Reply-To: <cover.1439702894.git.raphael.beamonte@gmail.com>
References: <cover.1439702894.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Globals should not be initialized to 0 or NULL.

Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bab5319..53c4ca9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -536,7 +536,7 @@ typedef enum {
 tstrWILC_WFIDrv *terminated_handle;
 tstrWILC_WFIDrv *gWFiDrvHandle;
 #ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-bool g_obtainingIP = false;
+bool g_obtainingIP;
 #endif
 u8 P2P_LISTEN_STATE;
 static struct task_struct *HostIFthreadHandler;
@@ -558,7 +558,7 @@ static u8 gapu8RcvdSurveyResults[2][MAX_SURVEY_RESULT_FRAG_SIZE];
 
 static u8 gapu8RcvdAssocResp[MAX_ASSOC_RESP_FRAME_SIZE];
 
-bool gbScanWhileConnected = false;
+bool gbScanWhileConnected;
 
 static s8 gs8Rssi;
 static s8 gs8lnkspd;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index fac16db..4c40955 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -482,7 +482,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 #endif
 
 #ifdef TCP_ENHANCEMENTS
-bool EnableTCPAckFilter = false;
+bool EnableTCPAckFilter;
 
 void Enable_TCP_ACK_Filter(bool value)
 {
-- 
2.1.4

