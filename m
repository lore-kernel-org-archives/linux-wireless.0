Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54807 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867AbZATPJp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 10:09:45 -0500
Subject: [PATCH 5/7] airo: use __attribute__ ((packed)) not #pragma pack(1)
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1232462691.22158.6.camel@localhost.localdomain>
References: <1232462691.22158.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 10:08:29 -0500
Message-Id: <1232464109.22158.16.camel@localhost.localdomain> (sfid-20090120_160949_836294_0104E612)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We'll get rid of the typedefs a bit later, but for now minimize the diff.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index d483491..8fa8585 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -496,39 +496,41 @@ typedef struct {
  * so all rid access should use the read/writeXXXRid routines.
  */
 
-/* This is redundant for x86 archs, but it seems necessary for ARM */
-#pragma pack(1)
-
 /* This structure came from an email sent to me from an engineer at
    aironet for inclusion into this driver */
-typedef struct {
+typedef struct WepKeyRid WepKeyRid;
+struct WepKeyRid {
 	__le16 len;
 	__le16 kindex;
 	u8 mac[ETH_ALEN];
 	__le16 klen;
 	u8 key[16];
-} WepKeyRid;
+} __attribute__ ((packed));
 
 /* These structures are from the Aironet's PC4500 Developers Manual */
-typedef struct {
+typedef struct Ssid Ssid;
+struct Ssid {
 	__le16 len;
 	u8 ssid[32];
-} Ssid;
+} __attribute__ ((packed));
 
-typedef struct {
+typedef struct SsidRid SsidRid;
+struct SsidRid {
 	__le16 len;
 	Ssid ssids[3];
-} SsidRid;
+} __attribute__ ((packed));
 
-typedef struct {
+typedef struct ModulationRid ModulationRid;
+struct ModulationRid {
         __le16 len;
         __le16 modulation;
 #define MOD_DEFAULT cpu_to_le16(0)
 #define MOD_CCK cpu_to_le16(1)
 #define MOD_MOK cpu_to_le16(2)
-} ModulationRid;
+} __attribute__ ((packed));
 
-typedef struct {
+typedef struct ConfigRid ConfigRid;
+struct ConfigRid {
 	__le16 len; /* sizeof(ConfigRid) */
 	__le16 opmode; /* operating mode */
 #define MODE_STA_IBSS cpu_to_le16(0)
@@ -649,9 +651,10 @@ typedef struct {
 #define MAGIC_STAY_IN_CAM (1<<10)
 	u8 magicControl;
 	__le16 autoWake;
-} ConfigRid;
+} __attribute__ ((packed));
 
-typedef struct {
+typedef struct StatusRid StatusRid;
+struct StatusRid {
 	__le16 len;
 	u8 mac[ETH_ALEN];
 	__le16 mode;
@@ -707,21 +710,23 @@ typedef struct {
 #define STAT_LEAPFAILED 91
 #define STAT_LEAPTIMEDOUT 92
 #define STAT_LEAPCOMPLETE 93
-} StatusRid;
+} __attribute__ ((packed));
 
-typedef struct {
+typedef struct StatsRid StatsRid;
+struct StatsRid {
 	__le16 len;
 	__le16 spacer;
 	__le32 vals[100];
-} StatsRid;
-
+} __attribute__ ((packed));
 
-typedef struct {
+typedef struct APListRid APListRid;
+struct APListRid {
 	__le16 len;
 	u8 ap[4][ETH_ALEN];
-} APListRid;
+} __attribute__ ((packed));
 
-typedef struct {
+typedef struct CapabilityRid CapabilityRid;
+struct CapabilityRid {
 	__le16 len;
 	char oui[3];
 	char zero;
@@ -748,17 +753,18 @@ typedef struct {
 	__le16 bootBlockVer;
 	__le16 requiredHard;
 	__le16 extSoftCap;
-} CapabilityRid;
-
+} __attribute__ ((packed));
 
 /* Only present on firmware >= 5.30.17 */
-typedef struct {
+typedef struct BSSListRidExtra BSSListRidExtra;
+struct BSSListRidExtra {
   __le16 unknown[4];
   u8 fixed[12]; /* WLAN management frame */
   u8 iep[624];
-} BSSListRidExtra;
+} __attribute__ ((packed));
 
-typedef struct {
+typedef struct BSSListRid BSSListRid;
+struct BSSListRid {
   __le16 len;
   __le16 index; /* First is 0 and 0xffff means end of list */
 #define RADIO_FH 1 /* Frequency hopping radio type */
@@ -789,33 +795,37 @@ typedef struct {
 
   /* Only present on firmware >= 5.30.17 */
   BSSListRidExtra extra;
-} BSSListRid;
+} __attribute__ ((packed));
 
 typedef struct {
   BSSListRid bss;
   struct list_head list;
 } BSSListElement;
 
-typedef struct {
+typedef struct tdsRssiEntry tdsRssiEntry;
+struct tdsRssiEntry {
   u8 rssipct;
   u8 rssidBm;
-} tdsRssiEntry;
+} __attribute__ ((packed));
 
-typedef struct {
+typedef struct tdsRssiRid tdsRssiRid;
+struct tdsRssiRid {
   u16 len;
   tdsRssiEntry x[256];
-} tdsRssiRid;
+} __attribute__ ((packed));
 
-typedef struct {
-	u16 len;
-	u16 state;
-	u16 multicastValid;
+typedef struct MICRid MICRid;
+struct MICRid {
+	__le16 len;
+	__le16 state;
+	__le16 multicastValid;
 	u8  multicast[16];
-	u16 unicastValid;
+	__le16 unicastValid;
 	u8  unicast[16];
-} MICRid;
+} __attribute__ ((packed));
 
-typedef struct {
+typedef struct MICBuffer MICBuffer;
+struct MICBuffer {
 	__be16 typelen;
 
 	union {
@@ -830,15 +840,13 @@ typedef struct {
 	} u;
 	__be32 mic;
 	__be32 seq;
-} MICBuffer;
+} __attribute__ ((packed));
 
 typedef struct {
 	u8 da[ETH_ALEN];
 	u8 sa[ETH_ALEN];
 } etherHead;
 
-#pragma pack()
-
 #define TXCTL_TXOK (1<<1) /* report if tx is ok */
 #define TXCTL_TXEX (1<<2) /* report if tx fails */
 #define TXCTL_802_3 (0<<3) /* 802.3 packet */

