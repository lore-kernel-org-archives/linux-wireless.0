Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43113 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab1DUUaq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 16:30:46 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 13:30:20 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>, <kvalo@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 1/5] ath6kl: add support for AR6003 v2.1.1
Date: Thu, 21 Apr 2011 13:30:36 -0700
Message-ID: <1303417840-19605-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1303417840-19605-1-git-send-email-lrodriguez@atheros.com>
References: <1303417840-19605-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Singh <nsingh@atheros.com>

This adds support for AR6003 v2.1.1. Highlights changes
for this new hardware are:

1. Host interest area, through which driver communicates
   with FW has been enhanced to accomodate additional
   members for proper functioanlity of new HW.

2. The firmware and the board data files are different
   for AR6003 v2.1.1. The capability to read those file
   have been added in the driver.

3. Certain parameters like numdevice, firmware mode needs to be
   programmed for proper functionality of new driver.

Signed-off-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/include/common/targaddrs.h  |  226 +++++++++++++++++---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |  133 +++++++++---
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |   57 +++++-
 3 files changed, 340 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/ath6kl/include/common/targaddrs.h b/drivers/staging/ath6kl/include/common/targaddrs.h
index e921b30..b172209 100644
--- a/drivers/staging/ath6kl/include/common/targaddrs.h
+++ b/drivers/staging/ath6kl/include/common/targaddrs.h
@@ -87,15 +87,7 @@ PREPACK struct host_interest_s {
     /* Pointer to debug logging header */
     u32 hi_dbglog_hdr;                             /* 0x08 */
 
-    /* Indicates whether or not flash is present on Target.
-     * NB: flash_is_present indicator is here not just
-     * because it might be of interest to the Host; but
-     * also because it's set early on by Target's startup
-     * asm code and we need it to have a special RAM address
-     * so that it doesn't get reinitialized with the rest
-     * of data.
-     */
-    u32 hi_flash_is_present;                       /* 0x0c */
+    u32 hi_unused1;                       /* 0x0c */
 
     /*
      * General-purpose flag bits, similar to AR6000_OPTION_* flags.
@@ -109,7 +101,7 @@ PREPACK struct host_interest_s {
      */
     u32 hi_serial_enable;                          /* 0x14 */
 
-    /* Start address of Flash DataSet index, if any */
+    /* Start address of DataSet index, if any */
     u32 hi_dset_list_head;                         /* 0x18 */
 
     /* Override Target application start address */
@@ -167,35 +159,179 @@ PREPACK struct host_interest_s {
     u32 hi_hci_uart_support_pins;                  /* 0xa4 */
         /* NOTE: byte [0] = RESET pin (bit 7 is polarity), bytes[1]..bytes[3] are for future use */
     u32 hi_hci_uart_pwr_mgmt_params;               /* 0xa8 */
-        /* 0xa8 - [0]: 1 = enable, 0 = disable
-         *        [1]: 0 = UART FC active low, 1 = UART FC active high
-         * 0xa9 - [7:0]: wakeup timeout in ms
-         * 0xaa, 0xab - [15:0]: idle timeout in ms
-         */       
-    /* Pointer to extended board Data  */
-    u32 hi_board_ext_data;                         /* 0xac */
-    u32 hi_board_ext_data_initialized;             /* 0xb0 */
+	/*
+	 * 0xa8   - [1]: 0 = UART FC active low, 1 = UART FC active high
+	 *      [31:16]: wakeup timeout in ms
+	 */
+
+	/* Pointer to extended board data */
+	u32 hi_board_ext_data;                /* 0xac */
+	u32 hi_board_ext_data_config;         /* 0xb0 */
+
+	/*
+         * Bit [0]  :   valid
+         * Bit[31:16:   size
+	*/
+	/*
+	 * hi_reset_flag is used to do some stuff when target reset.
+	 * such as restore app_start after warm reset or
+	 * preserve host Interest area, or preserve ROM data, literals etc.
+	 */
+	u32 hi_reset_flag;                            /* 0xb4 */
+	/* indicate hi_reset_flag is valid */
+	u32 hi_reset_flag_valid;                      /* 0xb8 */
+	u32 hi_hci_uart_pwr_mgmt_params_ext;           /* 0xbc */
+	/*
+	 * 0xbc - [31:0]: idle timeout in ms
+	 */
+	/* ACS flags */
+	u32 hi_acs_flags;                              /* 0xc0 */
+	u32 hi_console_flags;                          /* 0xc4 */
+	u32 hi_nvram_state;                            /* 0xc8 */
+	u32 hi_option_flag2;                           /* 0xcc */
+
+	/* If non-zero, override values sent to Host in WMI_READY event. */
+	u32 hi_sw_version_override;                    /* 0xd0 */
+	u32 hi_abi_version_override;                   /* 0xd4 */
+
+	/*
+	 * Percentage of high priority RX traffic to total expected RX traffic -
+	 * applicable only to ar6004
+	 */
+	u32 hi_hp_rx_traffic_ratio;                    /* 0xd8 */
+
+	/* test applications flags */
+	u32 hi_test_apps_related    ;                  /* 0xdc */
+	/* location of test script */
+	u32 hi_ota_testscript;                         /* 0xe0 */
+	/* location of CAL data */
+	u32 hi_cal_data;                               /* 0xe4 */
+	/* Number of packet log buffers */
+        u32 hi_pktlog_num_buffers;                     /* 0xe8 */
+
 } POSTPACK;
 
 /* Bits defined in hi_option_flag */
 #define HI_OPTION_TIMER_WAR       0x01 /* Enable timer workaround */
 #define HI_OPTION_BMI_CRED_LIMIT  0x02 /* Limit BMI command credits */
 #define HI_OPTION_RELAY_DOT11_HDR 0x04 /* Relay Dot11 hdr to/from host */
-#define HI_OPTION_FW_MODE_LSB     0x08 /* low bit of MODE (see below) */
-#define HI_OPTION_FW_MODE_MSB     0x10 /* high bit of MODE (see below) */
-#define HI_OPTION_ENABLE_PROFILE  0x20 /* Enable CPU profiling */
-#define HI_OPTION_DISABLE_DBGLOG  0x40 /* Disable debug logging */
-#define HI_OPTION_SKIP_ERA_TRACKING  0x80 /* Skip Era Tracking */
-#define HI_OPTION_PAPRD_DISABLE      0x100 /* Disable PAPRD (debug) */
+/* MAC addr method 0-locally administred 1-globally unique addrs */
+#define HI_OPTION_MAC_ADDR_METHOD   0x08
+#define HI_OPTION_FW_BRIDGE         0x10 /* Firmware Bridging */
+#define HI_OPTION_ENABLE_PROFILE    0x20 /* Enable CPU profiling */
+#define HI_OPTION_DISABLE_DBGLOG    0x40 /* Disable debug logging */
+#define HI_OPTION_SKIP_ERA_TRACKING 0x80 /* Skip Era Tracking */
+#define HI_OPTION_PAPRD_DISABLE     0x100 /* Disable PAPRD (debug) */
+#define HI_OPTION_NUM_DEV_LSB       0x200
+#define HI_OPTION_NUM_DEV_MSB       0x800
+#define HI_OPTION_DEV_MODE_LSB      0x1000
+#define HI_OPTION_DEV_MODE_MSB      0x8000000
+/* Disable LowFreq Timer Stabilization */
+#define HI_OPTION_NO_LFT_STBL       0x10000000
+#define HI_OPTION_SKIP_REG_SCAN     0x20000000 /* Skip regulatory scan */
+/* Do regulatory scan during init beforesending WMI ready event to host */
+#define HI_OPTION_INIT_REG_SCAN     0x40000000
+#define HI_OPTION_SKIP_MEMMAP       0x80000000 /* REV6: Do not adjust memory
+                                                map */
+
+/* hi_option_flag2 options */
+#define HI_OPTION_OFFLOAD_AMSDU     0x01
+#define HI_OPTION_DFS_SUPPORT       0x02 /* Enable DFS support */
+
+#define HI_OPTION_MAC_ADDR_METHOD_SHIFT 3
 
 /* 2 bits of hi_option_flag are used to represent 3 modes */
 #define HI_OPTION_FW_MODE_IBSS    0x0 /* IBSS Mode */
 #define HI_OPTION_FW_MODE_BSS_STA 0x1 /* STA Mode */
 #define HI_OPTION_FW_MODE_AP      0x2 /* AP Mode */
 
-/* Fw Mode Mask */
-#define HI_OPTION_FW_MODE_MASK    0x3
-#define HI_OPTION_FW_MODE_SHIFT   0x3
+/* 2 bits of hi_option flag are usedto represent 4 submodes */
+#define HI_OPTION_FW_SUBMODE_NONE    0x0  /* Normal mode */
+#define HI_OPTION_FW_SUBMODE_P2PDEV  0x1  /* p2p device mode */
+#define HI_OPTION_FW_SUBMODE_P2PCLIENT 0x2 /* p2p client mode */
+#define HI_OPTION_FW_SUBMODE_P2PGO   0x3 /* p2p go mode */
+
+/* Num dev Mask */
+#define HI_OPTION_NUM_DEV_MASK    0x7
+#define HI_OPTION_NUM_DEV_SHIFT   0x9
+
+/* firmware bridging */
+#define HI_OPTION_FW_BRIDGE_SHIFT 0x04
+
+/* Fw Mode/SubMode Mask
+|------------------------------------------------------------------------------|
+|   SUB   |   SUB   |   SUB   |  SUB    |         |         |         |
+| MODE[3] | MODE[2] | MODE[1] | MODE[0] | MODE[3] | MODE[2] | MODE[1] | MODE[0|
+|   (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)
+|------------------------------------------------------------------------------|
+*/
+#define HI_OPTION_FW_MODE_BITS         0x2
+#define HI_OPTION_FW_MODE_MASK         0x3
+#define HI_OPTION_FW_MODE_SHIFT        0xC
+#define HI_OPTION_ALL_FW_MODE_MASK     0xFF
+
+#define HI_OPTION_FW_SUBMODE_BITS      0x2
+#define HI_OPTION_FW_SUBMODE_MASK      0x3
+#define HI_OPTION_FW_SUBMODE_SHIFT     0x14
+#define HI_OPTION_ALL_FW_SUBMODE_MASK  0xFF00
+#define HI_OPTION_ALL_FW_SUBMODE_SHIFT 0x8
+
+/* hi_reset_flag */
+
+/* preserve App Start address */
+#define HI_RESET_FLAG_PRESERVE_APP_START         0x01
+/* preserve host interest */
+#define HI_RESET_FLAG_PRESERVE_HOST_INTEREST     0x02
+#define HI_RESET_FLAG_PRESERVE_ROMDATA           0x04  /* preserve ROM data */
+#define HI_RESET_FLAG_PRESERVE_NVRAM_STATE       0x08
+#define HI_RESET_FLAG_PRESERVE_BOOT_INFO         0x10
+
+#define HI_RESET_FLAG_IS_VALID  0x12345678 /* indicate the reset flag is
+valid */
+
+#define ON_RESET_FLAGS_VALID() \
+	(HOST_INTEREST->hi_reset_flag_valid == HI_RESET_FLAG_IS_VALID)
+
+#define RESET_FLAGS_VALIDATE()  \
+	(HOST_INTEREST->hi_reset_flag_valid = HI_RESET_FLAG_IS_VALID)
+
+#define RESET_FLAGS_INVALIDATE() \
+	(HOST_INTEREST->hi_reset_flag_valid = 0)
+
+#define ON_RESET_PRESERVE_APP_START() \
+        (HOST_INTEREST->hi_reset_flag & HI_RESET_FLAG_PRESERVE_APP_START)
+
+#define ON_RESET_PRESERVE_NVRAM_STATE() \
+        (HOST_INTEREST->hi_reset_flag & HI_RESET_FLAG_PRESERVE_NVRAM_STATE)
+
+#define ON_RESET_PRESERVE_HOST_INTEREST() \
+        (HOST_INTEREST->hi_reset_flag & HI_RESET_FLAG_PRESERVE_HOST_INTEREST)
+
+#define ON_RESET_PRESERVE_ROMDATA() \
+        (HOST_INTEREST->hi_reset_flag & HI_RESET_FLAG_PRESERVE_ROMDATA)
+
+#define ON_RESET_PRESERVE_BOOT_INFO() \
+        (HOST_INTEREST->hi_reset_flag & HI_RESET_FLAG_PRESERVE_BOOT_INFO)
+
+#define HI_ACS_FLAGS_ENABLED        (1 << 0)    /* ACS is enabled */
+#define HI_ACS_FLAGS_USE_WWAN       (1 << 1)    /* Use physical WWAN device */
+#define HI_ACS_FLAGS_TEST_VAP       (1 << 2)    /* Use test VAP */
+
+/* CONSOLE FLAGS
+ *
+ * Bit Range  Meaning
+ * ---------  --------------------------------
+ *   2..0     UART ID (0 = Default)
+ *    3       Baud Select (0 = 9600, 1 = 115200)
+ *   30..4    Reserved
+ *    31      Enable Console
+ *
+ */
+
+#define HI_CONSOLE_FLAGS_ENABLE       (1 << 31)
+#define HI_CONSOLE_FLAGS_UART_MASK    (0x7)
+#define HI_CONSOLE_FLAGS_UART_SHIFT   0
+#define HI_CONSOLE_FLAGS_BAUD_SELECT  (1 << 3)
 
 /*
  * Intended for use by Host software, this macro returns the Target RAM
@@ -208,26 +344,48 @@ PREPACK struct host_interest_s {
 #define AR6003_HOST_INTEREST_ITEM_ADDRESS(item) \
     (u32)((unsigned long)&((((struct host_interest_s *)(AR6003_HOST_INTEREST_ADDRESS))->item)))
 
+#define AR6004_HOST_INTEREST_ITEM_ADDRESS(item) \
+        ((A_UINT32)&((((struct host_interest_s *)(AR6004_HOST_INTEREST_ADDRESS))->item)))
+
+
 #define HOST_INTEREST_DBGLOG_IS_ENABLED() \
         (!(HOST_INTEREST->hi_option_flag & HI_OPTION_DISABLE_DBGLOG))
 
+#define HOST_INTEREST_PKTLOG_IS_ENABLED() \
+        ((HOST_INTEREST->hi_pktlog_num_buffers))
+
+
 #define HOST_INTEREST_PROFILE_IS_ENABLED() \
         (HOST_INTEREST->hi_option_flag & HI_OPTION_ENABLE_PROFILE)
 
+#define LF_TIMER_STABILIZATION_IS_ENABLED() \
+        (!(HOST_INTEREST->hi_option_flag & HI_OPTION_NO_LFT_STBL))
+
+#define IS_AMSDU_OFFLAOD_ENABLED() \
+        ((HOST_INTEREST->hi_option_flag2 & HI_OPTION_OFFLOAD_AMSDU))
+
+#define HOST_INTEREST_DFS_IS_ENABLED() \
+        ((HOST_INTEREST->hi_option_flag2 & HI_OPTION_DFS_SUPPORT))
+
 /* Convert a Target virtual address into a Target physical address */
 #define AR6002_VTOP(vaddr) ((vaddr) & 0x001fffff)
 #define AR6003_VTOP(vaddr) ((vaddr) & 0x001fffff)
 #define TARG_VTOP(TargetType, vaddr) \
         (((TargetType) == TARGET_TYPE_AR6002) ? AR6002_VTOP(vaddr) : AR6003_VTOP(vaddr))
 
-/* override REV2 ROM's app start address */
-#define AR6002_REV2_APP_START_OVERRIDE    0x911A00
-#define AR6003_REV1_APP_START_OVERRIDE    0x944c00
-#define AR6003_REV1_OTP_DATA_ADDRESS      0x542800
-#define AR6003_REV2_APP_START_OVERRIDE    0x945000
-#define AR6003_REV2_OTP_DATA_ADDRESS      0x543800
-#define AR6003_BOARD_EXT_DATA_ADDRESS     0x57E600
+#define AR6003_REV2_APP_START_OVERRIDE          0x944C00
+#define AR6003_REV2_APP_LOAD_ADDRESS            0x543180
+#define AR6003_REV2_BOARD_EXT_DATA_ADDRESS      0x57E500
+#define AR6003_REV2_DATASET_PATCH_ADDRESS       0x57e884
+#define AR6003_REV2_RAM_RESERVE_SIZE            6912
+
+#define AR6003_REV3_APP_START_OVERRIDE          0x945d00
+#define AR6003_REV3_APP_LOAD_ADDRESS            0x545000
+#define AR6003_REV3_BOARD_EXT_DATA_ADDRESS      0x542330
+#define AR6003_REV3_DATASET_PATCH_ADDRESS       0x57FF74
+#define AR6003_REV3_RAM_RESERVE_SIZE            512
 
+#define AR6003_BOARD_EXT_DATA_ADDRESS           0x57E600
 
 /* # of u32 entries in targregs, used by DIAG_FETCH_TARG_REGS */
 #define AR6003_FETCH_TARG_REGS_COUNT 64
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index db87720..36722ed 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -131,6 +131,8 @@ unsigned int wlanNodeCaching = 1;
 unsigned int enableuartprint = ENABLEUARTPRINT_DEFAULT;
 unsigned int logWmiRawMsgs = 0;
 unsigned int enabletimerwar = 0;
+unsigned int num_device = 1;
+unsigned int regscanmode;
 unsigned int fwmode = 1;
 unsigned int mbox_yield_limit = 99;
 unsigned int enablerssicompensation = 0;
@@ -155,6 +157,8 @@ unsigned int hciuartstep = HCIUARTSTEP_DEFAULT;
 unsigned int csumOffload=0;
 unsigned int csumOffloadTest=0;
 unsigned int eppingtest=0;
+unsigned int mac_addr_method;
+unsigned int firmware_bridge;
 
 module_param_string(ifname, ifname, sizeof(ifname), 0644);
 module_param(wlaninitmode, int, 0644);
@@ -957,6 +961,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
                 filename = AR6003_REV1_OTP_FILE;
             } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
                 filename = AR6003_REV2_OTP_FILE;
+                } else if (ar->arVersion.target_ver == AR6003_REV3_VERSION) {
+                        filename = AR6003_REV3_OTP_FILE;
             } else {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown firmware revision: %d\n", ar->arVersion.target_ver));
                 return A_ERROR;
@@ -968,6 +974,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
                 filename = AR6003_REV1_FIRMWARE_FILE;
             } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
                 filename = AR6003_REV2_FIRMWARE_FILE;
+                } else if (ar->arVersion.target_ver == AR6003_REV3_VERSION) {
+                        filename = AR6003_REV3_FIRMWARE_FILE;
             } else {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown firmware revision: %d\n", ar->arVersion.target_ver));
                 return A_ERROR;
@@ -979,6 +987,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
                     filename = AR6003_REV1_EPPING_FIRMWARE_FILE;
                 } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
                     filename = AR6003_REV2_EPPING_FIRMWARE_FILE;
+                } else if (ar->arVersion.target_ver == AR6003_REV3_VERSION) {
+                        filename = AR6003_REV3_EPPING_FIRMWARE_FILE;
                 } else {
                     AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("eppingtest : unsupported firmware revision: %d\n", 
                         ar->arVersion.target_ver));
@@ -993,6 +1003,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
                     filename = AR6003_REV1_TCMD_FIRMWARE_FILE;
                 } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
                     filename = AR6003_REV2_TCMD_FIRMWARE_FILE;
+                } else if (ar->arVersion.target_ver == AR6003_REV3_VERSION) {
+                        filename = AR6003_REV3_TCMD_FIRMWARE_FILE;
                 } else {
                     AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown firmware revision: %d\n", ar->arVersion.target_ver));
                     return A_ERROR;
@@ -1020,6 +1032,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
                 filename = AR6003_REV1_PATCH_FILE;
             } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
                 filename = AR6003_REV2_PATCH_FILE;
+                } else if (ar->arVersion.target_ver == AR6003_REV3_VERSION) {
+                        filename = AR6003_REV3_PATCH_FILE;
             } else {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown firmware revision: %d\n", ar->arVersion.target_ver));
                 return A_ERROR;
@@ -1031,6 +1045,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
                 filename = AR6003_REV1_BOARD_DATA_FILE;
             } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
                 filename = AR6003_REV2_BOARD_DATA_FILE;
+                } else if (ar->arVersion.target_ver == AR6003_REV3_VERSION) {
+                        filename = AR6003_REV3_BOARD_DATA_FILE;
             } else {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown firmware revision: %d\n", ar->arVersion.target_ver));
                 return A_ERROR;
@@ -1085,8 +1101,10 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
             }
 
             /* Record the fact that extended board Data IS initialized */
-            param = 1;
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data_initialized), (u8 *)&param, 4));
+            param = (board_ext_data_size << 16) | 1;
+            bmifn(BMIWriteMemory(ar->arHifDevice,
+            HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data_config),
+				       (unsigned char *)&param, 4));
         }
         fw_entry_size = board_data_size;
     }
@@ -1243,7 +1261,9 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
             bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data_initialized), (u8 *)&param, 4));
 
             /* Transfer One time Programmable data */
-            AR6K_DATA_DOWNLOAD_ADDRESS(address, ar->arVersion.target_ver);
+	    AR6K_APP_LOAD_ADDRESS(address, ar->arVersion.target_ver);
+	    if (ar->arVersion.target_ver == AR6003_REV3_VERSION)
+		  address = 0x1234;
             status = ar6000_transfer_bin_file(ar, AR6K_OTP_FILE, address, true);
             if (status == 0) {
                 /* Execute the OTP code */
@@ -1259,7 +1279,9 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
         }
 
         /* Download Target firmware */
-        AR6K_DATA_DOWNLOAD_ADDRESS(address, ar->arVersion.target_ver);
+        AR6K_APP_LOAD_ADDRESS(address, ar->arVersion.target_ver);
+        if (ar->arVersion.target_ver == AR6003_REV3_VERSION)
+                address = 0x1234;
         if ((ar6000_transfer_bin_file(ar, AR6K_FIRMWARE_FILE, address, true)) != 0) {
             return A_ERROR;
         }
@@ -1268,25 +1290,16 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
         AR6K_APP_START_OVERRIDE_ADDRESS(address, ar->arVersion.target_ver);
         bmifn(BMISetAppStart(ar->arHifDevice, address));
 
-        /* Apply the patches */
-        AR6K_PATCH_DOWNLOAD_ADDRESS(address, ar->arVersion.target_ver);
-        if ((ar6000_transfer_bin_file(ar, AR6K_PATCH_FILE, address, false)) != 0) {
-            return A_ERROR;
-        }
-
-        param = address;
-        bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_dset_list_head), (u8 *)&param, 4));
-
-        if (ar->arTargetType == TARGET_TYPE_AR6003) {
-            if (ar->arVersion.target_ver == AR6003_REV1_VERSION) {
-                /* Reserve 5.5K of RAM */
-                param = 5632;
-            } else { /* AR6003_REV2_VERSION */
-                /* Reserve 6.5K of RAM */
-                param = 6656;
-            }
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_end_RAM_reserve_sz), (u8 *)&param, 4));
-        }
+	if(ar->arTargetType == TARGET_TYPE_AR6003) {
+		AR6K_DATASET_PATCH_ADDRESS(address, ar->arVersion.target_ver);
+		if ((ar6000_transfer_bin_file(ar, AR6K_PATCH_FILE,
+					      address, false)) != 0)
+			return A_ERROR;
+		param = address;
+		bmifn(BMIWriteMemory(ar->arHifDevice,
+		HOST_INTEREST_ITEM_ADDRESS(ar, hi_dset_list_head),
+					   (unsigned char *)&param, 4));
+	}
 
         /* Restore system sleep */
         address = RTC_BASE_ADDRESS + SYSTEM_SLEEP_ADDRESS;
@@ -1418,7 +1431,11 @@ ar6000_configure_target(struct ar6_softc *ar)
             return A_ERROR;
         }
 
+        param |= (num_device << HI_OPTION_NUM_DEV_SHIFT);
         param |= (fwmode << HI_OPTION_FW_MODE_SHIFT);
+        param |= (mac_addr_method << HI_OPTION_MAC_ADDR_METHOD_SHIFT);
+        param |= (firmware_bridge << HI_OPTION_FW_BRIDGE_SHIFT);
+
 
         if (BMIWriteMemory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
@@ -1466,18 +1483,34 @@ ar6000_configure_target(struct ar6_softc *ar)
      * It is difficult to patch the firmware boot code,
      * but possible in theory.
      */
-    if (ar->arTargetType == TARGET_TYPE_AR6003) {
-        param = AR6003_BOARD_EXT_DATA_ADDRESS; 
-        if (BMIWriteMemory(ar->arHifDevice,
-            HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data),
-            (u8 *)&param,
-            4) != 0)
-        {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for hi_board_ext_data failed \n"));
-            return A_ERROR;
-        }
-    }
 
+	if (ar->arTargetType == TARGET_TYPE_AR6003) {
+		A_UINT32 ramReservedSz;
+		if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
+			param = AR6003_REV2_BOARD_EXT_DATA_ADDRESS;
+			ramReservedSz =  AR6003_REV2_RAM_RESERVE_SIZE;
+                } else {
+			param = AR6003_REV3_BOARD_EXT_DATA_ADDRESS;
+			ramReservedSz =  AR6003_REV3_RAM_RESERVE_SIZE;
+		}
+		if (BMIWriteMemory(ar->arHifDevice,
+			HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data),
+						   (u8 *)&param, 4) != 0) {
+				AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
+						("BMIWriteMemory for "
+						 "hi_board_ext_data failed\n"));
+				return A_ERROR;
+		}
+		if (BMIWriteMemory(ar->arHifDevice,
+				   HOST_INTEREST_ITEM_ADDRESS(ar,
+				   hi_end_RAM_reserve_sz),
+				   (u8 *)&ramReservedSz, 4) != 0) {
+			AR_DEBUG_PRINTF(ATH_DEBUG_ERR ,
+					("BMIWriteMemory for "
+					 "hi_end_RAM_reserve_sz failed\n"));
+			return A_ERROR;
+		}
+	}
 
         /* since BMIInit is called in the driver layer, we have to set the block
          * size here for the target */
@@ -2641,6 +2674,38 @@ int ar6000_init(struct net_device *dev)
         goto ar6000_init_done;
     }
 
+	if (regscanmode) {
+		A_UINT32 param;
+
+		if (BMIReadMemory(ar->arHifDevice,
+				  HOST_INTEREST_ITEM_ADDRESS(ar,
+							     hi_option_flag),
+							     (u8 *)&param,
+							     4) != 0) {
+			AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
+					("BMIReadMemory forsetting "
+					 "regscanmode failed\n"));
+			return A_ERROR;
+		}
+
+		if (regscanmode == 1)
+			param |= HI_OPTION_SKIP_REG_SCAN;
+		else if (regscanmode == 2)
+			param |= HI_OPTION_INIT_REG_SCAN;
+
+		if (BMIWriteMemory(ar->arHifDevice,
+				   HOST_INTEREST_ITEM_ADDRESS(ar,
+							      hi_option_flag),
+							      (u8 *)&param,
+							      4) != 0) {
+			AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
+					("BMIWriteMemory forsetting "
+					"regscanmode failed\n"));
+			return A_ERROR;
+		}
+		AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("Regulatory scan mode set\n"));
+	}
+
     /*
      * give our connected endpoints some buffers
      */
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index e47b078..666a591 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -281,15 +281,37 @@ typedef enum _AR6K_BIN_FILE {
     } \
 } while (0)
 
+#define AR6K_DATASET_PATCH_ADDRESS(_param, _ver) do { \
+        if ((_ver) == AR6003_REV2_VERSION) { \
+                (_param) = AR6003_REV2_DATASET_PATCH_ADDRESS; \
+        } else if ((_ver) == AR6003_REV3_VERSION) { \
+                (_param) = AR6003_REV3_DATASET_PATCH_ADDRESS; \
+        } else { \
+        AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown Version: %d\n", _ver)); \
+        A_ASSERT(0); \
+        } \
+} while (0)
+
+#define AR6K_APP_LOAD_ADDRESS(_param, _ver) do { \
+        if ((_ver) == AR6003_REV2_VERSION) { \
+                (_param) = AR6003_REV2_APP_LOAD_ADDRESS; \
+        } else if ((_ver) == AR6003_REV3_VERSION) { \
+                (_param) = AR6003_REV3_APP_LOAD_ADDRESS; \
+        } else { \
+        AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown Version: %d\n", _ver)); \
+        A_ASSERT(0); \
+        } \
+} while (0)
+
 #define AR6K_APP_START_OVERRIDE_ADDRESS(_param, _ver) do { \
-    if ((_ver) == AR6003_REV1_VERSION) { \
-        (_param) = AR6003_REV1_APP_START_OVERRIDE; \
-    } else if ((_ver) == AR6003_REV2_VERSION) { \
-        (_param) = AR6003_REV2_APP_START_OVERRIDE; \
-    } else { \
-       AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown Version: %d\n", _ver)); \
-       A_ASSERT(0); \
-    } \
+        if ((_ver) == AR6003_REV2_VERSION) { \
+                (_param) = AR6003_REV2_APP_START_OVERRIDE; \
+        } else if ((_ver) == AR6003_REV3_VERSION) { \
+                (_param) = AR6003_REV3_APP_START_OVERRIDE; \
+        } else { \
+        AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown Version: %d\n", _ver)); \
+        A_ASSERT(0); \
+        } \
 } while (0)
 
 /* AR6003 1.0 definitions */
@@ -332,6 +354,25 @@ typedef enum _AR6K_BIN_FILE {
 #define AR6003_REV2_BOARD_DATA_FILE         "ath6k/AR6003/hw2.0/bdata.CUSTOM.bin"
 #endif /* Board Data File */
 
+/* AR6003 3.0 definitions */
+#define AR6003_REV3_VERSION                 0x30000582
+#define AR6003_REV3_OTP_FILE                "ath6k/AR6003/hw2.1.1/otp.bin"
+#define AR6003_REV3_FIRMWARE_FILE           "ath6k/AR6003/hw2.1.1/athwlan.bin"
+#define AR6003_REV3_TCMD_FIRMWARE_FILE    "ath6k/AR6003/hw2.1.1/athtcmd_ram.bin"
+#define AR6003_REV3_ART_FIRMWARE_FILE       "ath6k/AR6003/hw2.1.1/device.bin"
+#define AR6003_REV3_PATCH_FILE            "ath6k/AR6003/hw2.1.1/data.patch.bin"
+#define AR6003_REV3_EPPING_FIRMWARE_FILE "ath6k/AR6003/hw2.1.1/endpointping.bin"
+#ifdef CONFIG_AR600x_SD31_XXX
+#define AR6003_REV3_BOARD_DATA_FILE       "ath6k/AR6003/hw2.1.1/bdata.SD31.bin"
+#elif defined(CONFIG_AR600x_SD32_XXX)
+#define AR6003_REV3_BOARD_DATA_FILE        "ath6k/AR6003/hw2.1.1/bdata.SD32.bin"
+#elif defined(CONFIG_AR600x_WB31_XXX)
+#define AR6003_REV3_BOARD_DATA_FILE        "ath6k/AR6003/hw2.1.1/bdata.WB31.bin"
+#else
+#define AR6003_REV3_BOARD_DATA_FILE      "ath6k/AR6003/hw2.1.1/bdata.CUSTOM.bin"
+#endif /* Board Data File */
+
+
 /* Power states */
 enum {
     WLAN_PWR_CTRL_UP = 0,
-- 
1.7.4.15.g7811d

