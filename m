Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35623 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbHQT2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 15:28:44 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCHv2 1/5] staging: wilc1000: remove void function return statements that are not useful
Date: Mon, 17 Aug 2015 15:28:26 -0400
Message-Id: <2d6a3d7d82e93a55cfb3ef37bc8e579bab807a90.1439838526.git.raphael.beamonte@gmail.com> (sfid-20150817_213016_056230_0A0195D3)
In-Reply-To: <cover.1439838526.git.raphael.beamonte@gmail.com>
References: <cover.1439838526.git.raphael.beamonte@gmail.com>
In-Reply-To: <cover.1439838526.git.raphael.beamonte@gmail.com>
References: <cover.1439838526.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c    | 4 ----
 drivers/staging/wilc1000/linux_wlan.c        | 1 -
 drivers/staging/wilc1000/wilc_exported_buf.c | 4 +---
 drivers/staging/wilc1000/wilc_wlan.c         | 3 ---
 drivers/staging/wilc1000/wilc_wlan_cfg.c     | 2 --
 5 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c473877..0cfc97d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6782,9 +6782,6 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", s32Error);
-
-
-	return;
 }
 
 /**
@@ -6848,7 +6845,6 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 	/*BugID_5348*/
 	up(&hSemHostIntDeinit);
-	return;
 }
 
 /**
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7eacc2f..e6e8a20 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1385,7 +1385,6 @@ void wilc1000_wlan_deinit(linux_wlan_t *nic)
 	} else {
 		PRINT_D(INIT_DBG, "wilc1000 is not initialized\n");
 	}
-	return;
 }
 
 int wlan_init_locks(linux_wlan_t *p_nic)
diff --git a/drivers/staging/wilc1000/wilc_exported_buf.c b/drivers/staging/wilc1000/wilc_exported_buf.c
index 5294578..deba6bd 100644
--- a/drivers/staging/wilc1000/wilc_exported_buf.c
+++ b/drivers/staging/wilc1000/wilc_exported_buf.c
@@ -65,12 +65,10 @@ static void __exit wilc_module_deinit(void)
 	FREE_WILC_BUFFER(g_tx_buf)
 	FREE_WILC_BUFFER(g_rx_buf)
 	FREE_WILC_BUFFER(g_fw_buf)
-
-	return;
 }
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Tony Cho");
 MODULE_DESCRIPTION("WILC1xxx Memory Manager");
 pure_initcall(wilc_module_init);
-module_exit(wilc_module_deinit);
\ No newline at end of file
+module_exit(wilc_module_deinit);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index fac16db..7c53a2b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -124,8 +124,6 @@ static void wilc_debug(uint32_t flag, char *fmt, ...)
 		if (g_wlan.os_func.os_debug)
 			g_wlan.os_func.os_debug(buf);
 	}
-
-	return;
 }
 
 static CHIP_PS_STATE_T genuChipPSstate = CHIP_WAKEDUP;
@@ -1325,7 +1323,6 @@ static void wilc_wlan_handle_rxq(void)
 
 	p->rxq_exit = 1;
 	PRINT_D(RX_DBG, "THREAD: Exiting RX thread\n");
-	return;
 }
 
 /********************************************
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index c10dffe..e2842d3 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -363,8 +363,6 @@ static void wilc_wlan_parse_response_frame(uint8_t *info, int size)
 		size -= (2 + len);
 		info += (2 + len);
 	}
-
-	return;
 }
 
 static int wilc_wlan_parse_info_frame(uint8_t *info, int size)
-- 
2.1.4

