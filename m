Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33221 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbbIPLLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 07:11:45 -0400
Received: by pacex6 with SMTP id ex6so207189436pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 04:11:45 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/10] staging: wilc1000: replace INLINE with static inline
Date: Wed, 16 Sep 2015 20:11:27 +0900
Message-Id: <1442401895-7463-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150916_131148_692005_F9E5A030)
In-Reply-To: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

INLINE macro is defined as static __inline so that it is replaced by
static inline.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 30 ++++++++++++++---------------
 drivers/staging/wilc1000/wilc_wlan.c        | 16 +++++++--------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 8164a33..9605517 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -301,7 +301,7 @@ u16 g_num_total_switches = (sizeof(gastrWIDs) / sizeof(tstrWID));
 
 /* This function extracts the beacon period field from the beacon or probe   */
 /* response frame.                                                           */
-INLINE u16 get_beacon_period(u8 *data)
+static inline u16 get_beacon_period(u8 *data)
 {
 	u16 bcn_per = 0;
 
@@ -311,7 +311,7 @@ INLINE u16 get_beacon_period(u8 *data)
 	return bcn_per;
 }
 
-INLINE u32 get_beacon_timestamp_lo(u8 *data)
+static inline u32 get_beacon_timestamp_lo(u8 *data)
 {
 	u32 time_stamp = 0;
 	u32 index    = MAC_HDR_LEN;
@@ -324,7 +324,7 @@ INLINE u32 get_beacon_timestamp_lo(u8 *data)
 	return time_stamp;
 }
 
-INLINE u32 get_beacon_timestamp_hi(u8 *data)
+static inline u32 get_beacon_timestamp_hi(u8 *data)
 {
 	u32 time_stamp = 0;
 	u32 index    = (MAC_HDR_LEN + 4);
@@ -340,7 +340,7 @@ INLINE u32 get_beacon_timestamp_hi(u8 *data)
 /* This function extracts the 'frame type and sub type' bits from the MAC    */
 /* header of the input frame.                                                */
 /* Returns the value in the LSB of the returned value.                       */
-INLINE tenuFrmSubtype get_sub_type(u8 *header)
+static inline tenuFrmSubtype get_sub_type(u8 *header)
 {
 	return ((tenuFrmSubtype)(header[0] & 0xFC));
 }
@@ -348,7 +348,7 @@ INLINE tenuFrmSubtype get_sub_type(u8 *header)
 /* This function extracts the 'to ds' bit from the MAC header of the input   */
 /* frame.                                                                    */
 /* Returns the value in the LSB of the returned value.                       */
-INLINE u8 get_to_ds(u8 *header)
+static inline u8 get_to_ds(u8 *header)
 {
 	return (header[1] & 0x01);
 }
@@ -356,28 +356,28 @@ INLINE u8 get_to_ds(u8 *header)
 /* This function extracts the 'from ds' bit from the MAC header of the input */
 /* frame.                                                                    */
 /* Returns the value in the LSB of the returned value.                       */
-INLINE u8 get_from_ds(u8 *header)
+static inline u8 get_from_ds(u8 *header)
 {
 	return ((header[1] & 0x02) >> 1);
 }
 
 /* This function extracts the MAC Address in 'address1' field of the MAC     */
 /* header and updates the MAC Address in the allocated 'addr' variable.      */
-INLINE void get_address1(u8 *pu8msa, u8 *addr)
+static inline void get_address1(u8 *pu8msa, u8 *addr)
 {
 	memcpy(addr, pu8msa + 4, 6);
 }
 
 /* This function extracts the MAC Address in 'address2' field of the MAC     */
 /* header and updates the MAC Address in the allocated 'addr' variable.      */
-INLINE void get_address2(u8 *pu8msa, u8 *addr)
+static inline void get_address2(u8 *pu8msa, u8 *addr)
 {
 	memcpy(addr, pu8msa + 10, 6);
 }
 
 /* This function extracts the MAC Address in 'address3' field of the MAC     */
 /* header and updates the MAC Address in the allocated 'addr' variable.      */
-INLINE void get_address3(u8 *pu8msa, u8 *addr)
+static inline void get_address3(u8 *pu8msa, u8 *addr)
 {
 	memcpy(addr, pu8msa + 16, 6);
 }
@@ -385,7 +385,7 @@ INLINE void get_address3(u8 *pu8msa, u8 *addr)
 /* This function extracts the BSSID from the incoming WLAN packet based on   */
 /* the 'from ds' bit, and updates the MAC Address in the allocated 'addr'    */
 /* variable.                                                                 */
-INLINE void get_BSSID(u8 *data, u8 *bssid)
+static inline void get_BSSID(u8 *data, u8 *bssid)
 {
 	if (get_from_ds(data) == 1)
 		get_address2(data, bssid);
@@ -396,7 +396,7 @@ INLINE void get_BSSID(u8 *data, u8 *bssid)
 }
 
 /* This function extracts the SSID from a beacon/probe response frame        */
-INLINE void get_ssid(u8 *data, u8 *ssid, u8 *p_ssid_len)
+static inline void get_ssid(u8 *data, u8 *ssid, u8 *p_ssid_len)
 {
 	u8 len = 0;
 	u8 i   = 0;
@@ -422,7 +422,7 @@ INLINE void get_ssid(u8 *data, u8 *ssid, u8 *p_ssid_len)
 
 /* This function extracts the capability info field from the beacon or probe */
 /* response frame.                                                           */
-INLINE u16 get_cap_info(u8 *data)
+static inline u16 get_cap_info(u8 *data)
 {
 	u16 cap_info = 0;
 	u16 index    = MAC_HDR_LEN;
@@ -443,7 +443,7 @@ INLINE u16 get_cap_info(u8 *data)
 
 /* This function extracts the capability info field from the Association */
 /* response frame.                                                                       */
-INLINE u16 get_assoc_resp_cap_info(u8 *data)
+static inline u16 get_assoc_resp_cap_info(u8 *data)
 {
 	u16 cap_info = 0;
 
@@ -455,7 +455,7 @@ INLINE u16 get_assoc_resp_cap_info(u8 *data)
 
 /* This funcion extracts the association status code from the incoming       */
 /* association response frame and returns association status code            */
-INLINE u16 get_asoc_status(u8 *data)
+static inline u16 get_asoc_status(u8 *data)
 {
 	u16 asoc_status = 0;
 
@@ -467,7 +467,7 @@ INLINE u16 get_asoc_status(u8 *data)
 
 /* This function extracts association ID from the incoming association       */
 /* response frame							                                     */
-INLINE u16 get_asoc_id(u8 *data)
+static inline u16 get_asoc_id(u8 *data)
 {
 	u16 asoc_id = 0;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index add9eeb..4ea7de4 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -98,8 +98,8 @@ typedef struct {
 
 static wilc_wlan_dev_t g_wlan;
 
-INLINE void chip_allow_sleep(void);
-INLINE void chip_wakeup(void);
+static inline void chip_allow_sleep(void);
+static inline void chip_wakeup(void);
 /********************************************
  *
  *      Debug
@@ -126,10 +126,10 @@ static void wilc_debug(u32 flag, char *fmt, ...)
 static CHIP_PS_STATE_T genuChipPSstate = CHIP_WAKEDUP;
 
 /*BugID_5213*/
-/*acquire_bus() and release_bus() are made INLINE functions*/
+/*acquire_bus() and release_bus() are made static inline functions*/
 /*as a temporary workaround to fix a problem of receiving*/
 /*unknown interrupt from FW*/
-INLINE void acquire_bus(BUS_ACQUIRE_T acquire)
+static inline void acquire_bus(BUS_ACQUIRE_T acquire)
 {
 
 	mutex_lock(g_wlan.hif_lock);
@@ -142,7 +142,7 @@ INLINE void acquire_bus(BUS_ACQUIRE_T acquire)
 	}
 
 }
-INLINE void release_bus(BUS_RELEASE_T release)
+static inline void release_bus(BUS_RELEASE_T release)
 {
 	#ifdef WILC_OPTIMIZE_SLEEP_INT
 	if (release == RELEASE_ALLOW_SLEEP)
@@ -678,7 +678,7 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(void)
 
 #ifdef WILC_OPTIMIZE_SLEEP_INT
 
-INLINE void chip_allow_sleep(void)
+static inline void chip_allow_sleep(void)
 {
 	u32 reg = 0;
 
@@ -688,7 +688,7 @@ INLINE void chip_allow_sleep(void)
 	g_wlan.hif_func.hif_write_reg(0xf0, reg & ~(1 << 0));
 }
 
-INLINE void chip_wakeup(void)
+static inline void chip_wakeup(void)
 {
 	u32 reg, clk_status_reg, trials = 0;
 	u32 sleep_time;
@@ -767,7 +767,7 @@ INLINE void chip_wakeup(void)
 	genuChipPSstate = CHIP_WAKEDUP;
 }
 #else
-INLINE void chip_wakeup(void)
+static inline void chip_wakeup(void)
 {
 	u32 reg, trials = 0;
 
-- 
2.5.1

