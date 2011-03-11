Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29955 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab1CKC4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:12 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:55:49 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 06/20] ath6kl: remove-typedef AR3K_CONFIG_INFO
Date: Thu, 10 Mar 2011 18:55:33 -0800
Message-ID: <1299812147-12069-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s AR3K_CONFIG_INFO \
	"struct ar3k_config_info" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/include/ar3kconfig.h        |    6 ++--
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |   20 +++++++++---------
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |   22 ++++++++++----------
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |    4 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    2 +-
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |    6 ++--
 6 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/ath6kl/include/ar3kconfig.h b/drivers/staging/ath6kl/include/ar3kconfig.h
index 4d73201..20d295b 100644
--- a/drivers/staging/ath6kl/include/ar3kconfig.h
+++ b/drivers/staging/ath6kl/include/ar3kconfig.h
@@ -38,7 +38,7 @@ extern "C" {
 #define AR3K_CONFIG_FLAG_SET_AR6K_SCALE_STEP        (1 << 3)
 
 
-typedef struct {
+struct ar3k_config_info {
     u32 Flags;           /* config flags */
     void                     *pHCIDev;        /* HCI bridge device     */
     HCI_TRANSPORT_PROPERTIES *pHCIProps;      /* HCI bridge props      */
@@ -52,9 +52,9 @@ typedef struct {
     u16 IdleTimeout;     /* TLPM idle timeout */
     u16 WakeupTimeout;   /* TLPM wakeup timeout */
     u8 bdaddr[6];       /* Bluetooth device address */
-} AR3K_CONFIG_INFO;
+};
                                                                                         
-int AR3KConfigure(AR3K_CONFIG_INFO *pConfigInfo);
+int AR3KConfigure(struct ar3k_config_info *pConfigInfo);
 
 int AR3KConfigureExit(void *config);
 
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
index 005b3ba..3e9c95e 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
@@ -47,9 +47,9 @@
 #define HCI_MAX_EVT_RECV_LENGTH             257
 #define EXIT_MIN_BOOT_COMMAND_STATUS_OFFSET  5
 
-int AthPSInitialize(AR3K_CONFIG_INFO *hdev);
+int AthPSInitialize(struct ar3k_config_info *hdev);
 
-static int SendHCICommand(AR3K_CONFIG_INFO *pConfig,
+static int SendHCICommand(struct ar3k_config_info *pConfig,
                                u8 *pBuffer,
                                int              Length)
 {
@@ -84,7 +84,7 @@ static int SendHCICommand(AR3K_CONFIG_INFO *pConfig,
     return status;
 }
 
-static int RecvHCIEvent(AR3K_CONFIG_INFO *pConfig,
+static int RecvHCIEvent(struct ar3k_config_info *pConfig,
                              u8 *pBuffer,
                              int              *pLength)
 {
@@ -122,7 +122,7 @@ static int RecvHCIEvent(AR3K_CONFIG_INFO *pConfig,
     return status;
 } 
     
-int SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
+int SendHCICommandWaitCommandComplete(struct ar3k_config_info *pConfig,
                                            u8 *pHCICommand,
                                            int              CmdLength,
                                            u8 **ppEventBuffer,
@@ -209,7 +209,7 @@ int SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
     return status;    
 }
 
-static int AR3KConfigureHCIBaud(AR3K_CONFIG_INFO *pConfig)
+static int AR3KConfigureHCIBaud(struct ar3k_config_info *pConfig)
 {
     int    status = 0;
     u8 hciBaudChangeCommand[] =  {0x0c,0xfc,0x2,0,0};
@@ -274,7 +274,7 @@ static int AR3KConfigureHCIBaud(AR3K_CONFIG_INFO *pConfig)
     return status;
 }
 
-static int AR3KExitMinBoot(AR3K_CONFIG_INFO *pConfig)
+static int AR3KExitMinBoot(struct ar3k_config_info *pConfig)
 {
     int  status;
     char exitMinBootCmd[] = {0x25,0xFC,0x0c,0x03,0x00,0x00,0x00,0x00,0x00,0x00,
@@ -310,7 +310,7 @@ static int AR3KExitMinBoot(AR3K_CONFIG_INFO *pConfig)
     return status;                                              
 }
                                  
-static int AR3KConfigureSendHCIReset(AR3K_CONFIG_INFO *pConfig)
+static int AR3KConfigureSendHCIReset(struct ar3k_config_info *pConfig)
 {
     int status = 0;
     u8 hciResetCommand[] = {0x03,0x0c,0x0};
@@ -334,7 +334,7 @@ static int AR3KConfigureSendHCIReset(AR3K_CONFIG_INFO *pConfig)
     return status;
 }
 
-static int AR3KEnableTLPM(AR3K_CONFIG_INFO *pConfig)
+static int AR3KEnableTLPM(struct ar3k_config_info *pConfig)
 {
     int  status;
     /* AR3K vendor specific command for Host Wakeup Config */
@@ -453,7 +453,7 @@ static int AR3KEnableTLPM(AR3K_CONFIG_INFO *pConfig)
     return status;                                              
 }
 
-int AR3KConfigure(AR3K_CONFIG_INFO *pConfig)
+int AR3KConfigure(struct ar3k_config_info *pConfig)
 {
     int        status = 0;
         
@@ -524,7 +524,7 @@ int AR3KConfigure(AR3K_CONFIG_INFO *pConfig)
 int AR3KConfigureExit(void *config)
 {
     int        status = 0;
-    AR3K_CONFIG_INFO *pConfig = (AR3K_CONFIG_INFO *)config;
+    struct ar3k_config_info *pConfig = (struct ar3k_config_info *)config;
         
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("AR3K Config: Cleaning up AR3K ...\n"));
                                 
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
index 3dce6f5..3436cbd 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
@@ -43,10 +43,10 @@ typedef struct {
 
     PSCmdPacket *HciCmdList;
     u32 num_packets;
-    AR3K_CONFIG_INFO *dev;
+    struct ar3k_config_info *dev;
 }HciCommandListParam;
 
-int SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
+int SendHCICommandWaitCommandComplete(struct ar3k_config_info *pConfig,
                                            u8 *pHCICommand,
                                            int              CmdLength,
                                            u8 **ppEventBuffer,
@@ -56,8 +56,8 @@ u32 Rom_Version;
 u32 Build_Version;
 extern bool BDADDR;
 
-int getDeviceType(AR3K_CONFIG_INFO *pConfig, u32 *code);
-int ReadVersionInfo(AR3K_CONFIG_INFO *pConfig);
+int getDeviceType(struct ar3k_config_info *pConfig, u32 *code);
+int ReadVersionInfo(struct ar3k_config_info *pConfig);
 #ifndef HCI_TRANSPORT_SDIO
 
 DECLARE_WAIT_QUEUE_HEAD(PsCompleteEvent);
@@ -70,7 +70,7 @@ int PSHciWritepacket(struct hci_dev*,u8* Data, u32 len);
 extern char *bdaddr;
 #endif /* HCI_TRANSPORT_SDIO */
 
-int write_bdaddr(AR3K_CONFIG_INFO *pConfig,u8 *bdaddr,int type);
+int write_bdaddr(struct ar3k_config_info *pConfig,u8 *bdaddr,int type);
 
 int PSSendOps(void *arg);
 
@@ -91,7 +91,7 @@ void Hci_log(u8 * log_string,u8 *data,u32 len)
 
 
 
-int AthPSInitialize(AR3K_CONFIG_INFO *hdev)
+int AthPSInitialize(struct ar3k_config_info *hdev)
 {
     int status = 0;
     if(hdev == NULL) {
@@ -147,7 +147,7 @@ int PSSendOps(void *arg)
     u8 *path = NULL;
     u8 *config_path = NULL;
     u8 config_bdaddr[MAX_BDADDR_FORMAT_LENGTH];
-    AR3K_CONFIG_INFO *hdev = (AR3K_CONFIG_INFO*)arg;
+    struct ar3k_config_info *hdev = (struct ar3k_config_info*)arg;
     struct device *firmwareDev = NULL;
     status = 0;
     HciCmdList = NULL;
@@ -389,7 +389,7 @@ complete:
  *  with a HCI Command Complete event.
  *  For HCI SDIO transport, this will be internally defined. 
  */
-int SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
+int SendHCICommandWaitCommandComplete(struct ar3k_config_info *pConfig,
                                            u8 *pHCICommand,
                                            int              CmdLength,
                                            u8 **ppEventBuffer,
@@ -481,7 +481,7 @@ int str2ba(unsigned char *str_bdaddr,unsigned char *bdaddr)
 	return 0; 
 }
 
-int write_bdaddr(AR3K_CONFIG_INFO *pConfig,u8 *bdaddr,int type)
+int write_bdaddr(struct ar3k_config_info *pConfig,u8 *bdaddr,int type)
 {
 	u8 bdaddr_cmd[] = { 0x0B, 0xFC, 0x0A, 0x01, 0x01, 
 							0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
@@ -516,7 +516,7 @@ int write_bdaddr(AR3K_CONFIG_INFO *pConfig,u8 *bdaddr,int type)
     return result;
 
 }
-int ReadVersionInfo(AR3K_CONFIG_INFO *pConfig)
+int ReadVersionInfo(struct ar3k_config_info *pConfig)
 {
     u8 hciCommand[] =  {0x1E,0xfc,0x00};
     u8 *event;
@@ -531,7 +531,7 @@ int ReadVersionInfo(AR3K_CONFIG_INFO *pConfig)
    }
     return result;
 }
-int getDeviceType(AR3K_CONFIG_INFO *pConfig, u32 *code)
+int getDeviceType(struct ar3k_config_info *pConfig, u32 *code)
 {
     u8 hciCommand[] =  {0x05,0xfc,0x05,0x00,0x00,0x00,0x00,0x04};
     u8 *event;
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
index b97d91f..d443513 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
@@ -64,12 +64,12 @@
 
 
 #ifndef HCI_TRANSPORT_SDIO
-#define AR3K_CONFIG_INFO        struct hci_dev
+#define struct ar3k_config_info        struct hci_dev
 extern wait_queue_head_t HciEvent;
 extern wait_queue_t Eventwait;
 extern u8 *HciEventpacket;
 #endif /* #ifndef HCI_TRANSPORT_SDIO */
 
-int AthPSInitialize(AR3K_CONFIG_INFO *hdev);
+int AthPSInitialize(struct ar3k_config_info *hdev);
 int ReadPSEvent(u8* Data);
 #endif /* __AR3KPSCONFIG_H */
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index f8d8999..3397995 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -2011,7 +2011,7 @@ ar6000_stop_endpoint(struct net_device *dev, bool keepprofile, bool getdbglogs)
 #else
         // FIXME: workaround to reset BT's UART baud rate to default
         if (NULL != ar->exitCallback) {
-            AR3K_CONFIG_INFO ar3kconfig;
+            struct ar3k_config_info ar3kconfig;
             int status;
 
             A_MEMZERO(&ar3kconfig,sizeof(ar3kconfig));
diff --git a/drivers/staging/ath6kl/os/linux/hci_bridge.c b/drivers/staging/ath6kl/os/linux/hci_bridge.c
index db38bbf..ee52d11 100644
--- a/drivers/staging/ath6kl/os/linux/hci_bridge.c
+++ b/drivers/staging/ath6kl/os/linux/hci_bridge.c
@@ -100,7 +100,7 @@ typedef struct {
 #define HCI_GET_OP_CODE(p)          (((u16)((p)[1])) << 8) | ((u16)((p)[0]))
 
 extern unsigned int setupbtdev;
-AR3K_CONFIG_INFO      ar3kconfig;
+struct ar3k_config_info      ar3kconfig;
 
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
 AR6K_HCI_BRIDGE_INFO *g_pHcidevInfo;
@@ -222,7 +222,7 @@ static int ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
     AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)pContext;
     int              status;
     u32 address, hci_uart_pwr_mgmt_params;
-//    AR3K_CONFIG_INFO      ar3kconfig;
+//    struct ar3k_config_info      ar3kconfig;
     
     pHcidevInfo->pHCIDev = HCIHandle;
     
@@ -667,7 +667,7 @@ int hci_test_send(AR_SOFTC_T *ar, struct sk_buff *skb)
 void ar6000_set_default_ar3kconfig(AR_SOFTC_T *ar, void *ar3kconfig)
 {
     AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)ar->hcidev_info;
-    AR3K_CONFIG_INFO *config = (AR3K_CONFIG_INFO *)ar3kconfig;
+    struct ar3k_config_info *config = (struct ar3k_config_info *)ar3kconfig;
 
     config->pHCIDev = pHcidevInfo->pHCIDev;
     config->pHCIProps = &pHcidevInfo->HCIProps;
-- 
1.7.4.15.g7811d

