Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4696 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758034Ab1F2XtM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:12 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 086/119] staging: brcm80211: rename structure
 definitions in dhd.h
Date: Wed, 29 Jun 2011 16:47:50 -0700
Message-ID: <1309391303-22741-87-git-send-email-frankyl@broadcom.com> (sfid-20110630_015159_058776_8B4903DB)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Structure definitions in dhd.h have been prefixed with brcmf_ for
consistent naming in fullmac driver and typedef of these structures
has been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |  130 +++++++++++----------
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c     |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |   12 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   22 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h   |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  103 +++++++++---------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |   14 +-
 7 files changed, 146 insertions(+), 139 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 2ebf015..93e0164 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -83,8 +83,9 @@
 #define	WLC_PHY_TYPE_LCN	8
 #define	WLC_PHY_TYPE_NULL	0xf
 
-#define WL_PKT_FILTER_FIXED_LEN		  offsetof(wl_pkt_filter_t, u)
-#define WL_PKT_FILTER_PATTERN_FIXED_LEN	  offsetof(wl_pkt_filter_pattern_t, mask_and_pattern)
+#define WL_PKT_FILTER_FIXED_LEN		  offsetof(struct brcmf_pkt_filter, u)
+#define WL_PKT_FILTER_PATTERN_FIXED_LEN	\
+	offsetof(struct brcmf_pkt_filter_pattern, mask_and_pattern)
 
 #define WL_EVENTING_MASK_LEN	16
 
@@ -94,9 +95,9 @@
 /* maximum channels returned by the get valid channels iovar */
 #define WL_NUMCHANNELS		64
 
-#define	WL_BSS_INFO_VERSION	108	/* current ver of wl_bss_info struct */
+#define	WL_BSS_INFO_VERSION	108 /* current ver of brcmf_bss_info struct */
 
-/* size of wl_scan_params not including variable length array */
+/* size of brcmf_scan_params not including variable length array */
 #define WL_SCAN_PARAMS_FIXED_SIZE 64
 
 /* masks for channel and ssid count */
@@ -109,7 +110,7 @@
 
 #define ISCAN_REQ_VERSION 1
 
-/* wl_iscan_results status values */
+/* brcmf_iscan_results status values */
 #define WL_SCAN_RESULTS_SUCCESS	0
 #define WL_SCAN_RESULTS_PARTIAL	1
 #define WL_SCAN_RESULTS_PENDING	2
@@ -319,7 +320,7 @@ enum dhd_bus_state {
  * start matching, the pattern to match, the size of the pattern, and a bitmask
  * that indicates which bits within the pattern should be matched.
  */
-typedef struct wl_pkt_filter_pattern {
+struct brcmf_pkt_filter_pattern {
 	u32 offset;		/* Offset within received packet to start pattern matching.
 				 * Offset '0' is the first byte of the ethernet header.
 				 */
@@ -327,29 +328,29 @@ typedef struct wl_pkt_filter_pattern {
 	u8 mask_and_pattern[1];	/* Variable length mask and pattern data.  mask starts
 					 * at offset 0.  Pattern immediately follows mask.
 					 */
-} wl_pkt_filter_pattern_t;
+};
 
 /* IOVAR "pkt_filter_add" parameter. Used to install packet filters. */
-typedef struct wl_pkt_filter {
+struct brcmf_pkt_filter {
 	u32 id;		/* Unique filter id, specified by app. */
 	u32 type;		/* Filter type (WL_PKT_FILTER_TYPE_xxx). */
 	u32 negate_match;	/* Negate the result of filter matches */
 	union {			/* Filter definitions */
-		wl_pkt_filter_pattern_t pattern;	/* Pattern matching filter */
+		struct brcmf_pkt_filter_pattern pattern; /* Filter pattern */
 	} u;
-} wl_pkt_filter_t;
+};
 
 /* IOVAR "pkt_filter_enable" parameter. */
-typedef struct wl_pkt_filter_enable {
+struct brcmf_pkt_filter_enable {
 	u32 id;		/* Unique filter id */
 	u32 enable;		/* Enable/disable bool */
-} wl_pkt_filter_enable_t;
+};
 
 /* BSS info structure
  * Applications MUST CHECK ie_offset field and length field to access IEs and
- * next bss_info structure in a vector (in wl_scan_results_t)
+ * next bss_info structure in a vector (in struct brcmf_scan_results)
  */
-typedef struct wl_bss_info {
+struct brcmf_bss_info {
 	u32 version;		/* version field */
 	u32 length;		/* byte length of data in this record,
 				 * starting at version and including IEs
@@ -382,15 +383,15 @@ typedef struct wl_bss_info {
 	s16 SNR;		/* average SNR of during frame reception */
 	/* Add new fields here */
 	/* variable length Information Elements */
-} wl_bss_info_t;
+};
 
-typedef struct wlc_ssid {
+struct brcmf_ssid {
 	u32 SSID_len;
 	unsigned char SSID[32];
-} wlc_ssid_t;
+};
 
-typedef struct wl_scan_params {
-	wlc_ssid_t ssid;	/* default: {0, ""} */
+struct brcmf_scan_params {
+	struct brcmf_ssid ssid;	/* default: {0, ""} */
 	u8 bssid[ETH_ALEN];	/* default: bcast */
 	s8 bss_type;		/* default: any,
 				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
@@ -408,71 +409,76 @@ typedef struct wl_scan_params {
 				 */
 	s32 channel_num;	/* count of channels and ssids that follow
 				 *
-				 * low half is count of channels in channel_list, 0
-				 * means default (use all available channels)
+				 * low half is count of channels in
+				 * channel_list, 0 means default (use all
+				 * available channels)
 				 *
-				 * high half is entries in wlc_ssid_t array that
-				 * follows channel_list, aligned for s32 (4 bytes)
-				 * meaning an odd channel count implies a 2-byte pad
-				 * between end of channel_list and first ssid
+				 * high half is entries in struct brcmf_ssid
+				 * array that follows channel_list, aligned for
+				 * s32 (4 bytes) meaning an odd channel count
+				 * implies a 2-byte pad between end of
+				 * channel_list and first ssid
 				 *
-				 * if ssid count is zero, single ssid in the fixed
-				 * parameter portion is assumed, otherwise ssid in
-				 * the fixed portion is ignored
+				 * if ssid count is zero, single ssid in the
+				 * fixed parameter portion is assumed, otherwise
+				 * ssid in the fixed portion is ignored
 				 */
 	u16 channel_list[1];	/* list of chanspecs */
-} wl_scan_params_t;
+};
 
 /* incremental scan struct */
-typedef struct wl_iscan_params {
+struct brcmf_iscan_params {
 	u32 version;
 	u16 action;
 	u16 scan_duration;
-	wl_scan_params_t params;
-} wl_iscan_params_t;
+	struct brcmf_scan_params params;
+};
 
-/* 3 fields + size of wl_scan_params, not including variable length array */
-#define WL_ISCAN_PARAMS_FIXED_SIZE (offsetof(wl_iscan_params_t, params) + sizeof(wlc_ssid_t))
+/* 3 fields + size of brcmf_scan_params, not including variable length array */
+#define BRCMF_ISCAN_PARAMS_FIXED_SIZE \
+	(offsetof(struct brcmf_iscan_params, params) + \
+	 sizeof(struct brcmf_ssid))
 
-typedef struct wl_scan_results {
+struct brcmf_scan_results {
 	u32 buflen;
 	u32 version;
 	u32 count;
-	wl_bss_info_t bss_info[1];
-} wl_scan_results_t;
+	struct brcmf_bss_info bss_info[1];
+};
 
 /* used for association with a specific BSSID and chanspec list */
-typedef struct wl_assoc_params {
+struct brcmf_assoc_params {
 	u8 bssid[ETH_ALEN];	/* 00:00:00:00:00:00: broadcast scan */
 	s32 chanspec_num;	/* 0: all available channels,
 				 * otherwise count of chanspecs in chanspec_list
 				 */
 	chanspec_t chanspec_list[1];	/* list of chanspecs */
-} wl_assoc_params_t;
-#define WL_ASSOC_PARAMS_FIXED_SIZE	(sizeof(wl_assoc_params_t) - sizeof(chanspec_t))
+};
+#define WL_ASSOC_PARAMS_FIXED_SIZE \
+	(sizeof(struct brcmf_assoc_params) - sizeof(chanspec_t))
 
 /* used for join with or without a specific bssid and channel list */
-typedef struct wl_join_params {
-	wlc_ssid_t ssid;
-	wl_assoc_params_t params;	/* optional field, but it must include the fixed portion
-					 * of the wl_assoc_params_t struct when it does present.
-					 */
-} wl_join_params_t;
+struct brcmf_join_params {
+	struct brcmf_ssid ssid;
+	struct brcmf_assoc_params params;
+};
 
-/* size of wl_scan_results not including variable length array */
-#define WL_SCAN_RESULTS_FIXED_SIZE (sizeof(wl_scan_results_t) - sizeof(wl_bss_info_t))
+/* size of brcmf_scan_results not including variable length array */
+#define BRCMF_SCAN_RESULTS_FIXED_SIZE \
+	(sizeof(struct brcmf_scan_results) - sizeof(struct brcmf_bss_info))
 
 /* incremental scan results struct */
-typedef struct wl_iscan_results {
+struct brcmf_iscan_results {
 	u32 status;
-	wl_scan_results_t results;
-} wl_iscan_results_t;
+	struct brcmf_scan_results results;
+};
 
-/* size of wl_iscan_results not including variable length array */
-#define WL_ISCAN_RESULTS_FIXED_SIZE \
-	(WL_SCAN_RESULTS_FIXED_SIZE + offsetof(wl_iscan_results_t, results))
+/* size of brcmf_iscan_results not including variable length array */
+#define BRCMF_ISCAN_RESULTS_FIXED_SIZE \
+	(BRCMF_SCAN_RESULTS_FIXED_SIZE + \
+	 offsetof(struct brcmf_iscan_results, results))
 
-typedef struct wl_wsec_key {
+struct brcmf_wsec_key {
 	u32 index;		/* key index */
 	u32 len;		/* key length */
 	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
@@ -490,30 +496,30 @@ typedef struct wl_wsec_key {
 	} rxiv;
 	u32 pad_5[2];
 	u8 ea[ETH_ALEN];	/* per station */
-} wl_wsec_key_t;
+};
 
 /* Used to get specific STA parameters */
-typedef struct {
+struct brcmf_scb_val {
 	u32 val;
 	u8 ea[ETH_ALEN];
-} scb_val_t;
+};
 
 /* channel encoding */
-typedef struct channel_info {
+struct brcmf_channel_info {
 	int hw_channel;
 	int target_channel;
 	int scan_channel;
-} channel_info_t;
+};
 
 /* Linux network driver ioctl encoding */
-typedef struct wl_ioctl {
+struct brcmf_ioctl {
 	uint cmd;		/* common ioctl definition */
 	void *buf;		/* pointer to user buffer */
 	uint len;		/* length of user buffer */
 	u8 set;		/* get or set request (optional) */
 	uint used;		/* bytes read or written (optional) */
 	uint needed;		/* bytes needed (optional) */
-} wl_ioctl_t;
+};
 
 /* Forward decls for struct dhd_pub (see below) */
 struct dhd_bus;		/* device bus info */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 471869f..7efe69c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -275,7 +275,7 @@ done:
 
 extern int dhd_bus_interface(struct dhd_bus *bus, uint arg, void *arg2);
 int
-brcmf_proto_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf,
+brcmf_proto_ioctl(dhd_pub_t *dhd, int ifidx, struct brcmf_ioctl *ioc, void *buf,
 		  int len)
 {
 	struct brcmf_proto *prot = dhd->prot;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 244ea72..84daa8e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -886,8 +886,8 @@ brcmf_c_pktfilter_offload_enable(dhd_pub_t *drvr, char *arg, int enable,
 	char *arg_save = 0, *arg_org = 0;
 	int rc;
 	char buf[128];
-	wl_pkt_filter_enable_t enable_parm;
-	wl_pkt_filter_enable_t *pkt_filterp;
+	struct brcmf_pkt_filter_enable enable_parm;
+	struct brcmf_pkt_filter_enable *pkt_filterp;
 
 	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
 	if (!arg_save) {
@@ -911,7 +911,7 @@ brcmf_c_pktfilter_offload_enable(dhd_pub_t *drvr, char *arg, int enable,
 	buf[str_len] = '\0';
 	buf_len = str_len + 1;
 
-	pkt_filterp = (wl_pkt_filter_enable_t *) (buf + str_len + 1);
+	pkt_filterp = (struct brcmf_pkt_filter_enable *) (buf + str_len + 1);
 
 	/* Parse packet filter id. */
 	enable_parm.id = simple_strtoul(argv[i], NULL, 0);
@@ -949,8 +949,8 @@ fail:
 void brcmf_c_pktfilter_offload_set(dhd_pub_t *drvr, char *arg)
 {
 	const char *str;
-	wl_pkt_filter_t pkt_filter;
-	wl_pkt_filter_t *pkt_filterp;
+	struct brcmf_pkt_filter pkt_filter;
+	struct brcmf_pkt_filter *pkt_filterp;
 	int buf_len;
 	int str_len;
 	int rc;
@@ -998,7 +998,7 @@ void brcmf_c_pktfilter_offload_set(dhd_pub_t *drvr, char *arg)
 	buf[str_len] = '\0';
 	buf_len = str_len + 1;
 
-	pkt_filterp = (wl_pkt_filter_t *) (buf + str_len + 1);
+	pkt_filterp = (struct brcmf_pkt_filter *) (buf + str_len + 1);
 
 	/* Parse packet filter id. */
 	pkt_filter.id = simple_strtoul(argv[i], NULL, 0);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 04b4511..6b2682f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -209,7 +209,7 @@ static void brcmf_set_packet_filter(int value, dhd_pub_t *drvr)
 static int brcmf_set_suspend(int value, dhd_pub_t *drvr)
 {
 	int power_mode = PM_MAX;
-	/* wl_pkt_filter_enable_t       enable_parm; */
+	/* struct wl_pkt_filter_enable       enable_parm; */
 	char iovbuf[32];
 	int bcn_li_dtim = 3;
 
@@ -426,7 +426,7 @@ static void _brcmf_set_multicast_list(dhd_info_t *drvr_priv, int ifidx)
 	struct netdev_hw_addr *ha;
 	u32 allmulti, cnt;
 
-	wl_ioctl_t ioc;
+	struct brcmf_ioctl ioc;
 	char *buf, *bufp;
 	uint buflen;
 	int ret;
@@ -539,7 +539,7 @@ static void _brcmf_set_multicast_list(dhd_info_t *drvr_priv, int ifidx)
 static int _brcmf_set_mac_address(dhd_info_t *drvr_priv, int ifidx, u8 *addr)
 {
 	char buf[32];
-	wl_ioctl_t ioc;
+	struct brcmf_ioctl ioc;
 	int ret;
 
 	DHD_TRACE(("%s enter\n", __func__));
@@ -993,7 +993,7 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 	 as a bitmap in toe_ol iovar */
 static int brcmf_toe_get(dhd_info_t *drvr_priv, int ifidx, u32 *toe_ol)
 {
-	wl_ioctl_t ioc;
+	struct brcmf_ioctl ioc;
 	char buf[32];
 	int ret;
 
@@ -1027,7 +1027,7 @@ static int brcmf_toe_get(dhd_info_t *drvr_priv, int ifidx, u32 *toe_ol)
 	 and set toe global enable iovar */
 static int brcmf_toe_set(dhd_info_t *drvr_priv, int ifidx, u32 toe_ol)
 {
-	wl_ioctl_t ioc;
+	struct brcmf_ioctl ioc;
 	char buf[32];
 	int toe, ret;
 
@@ -1220,7 +1220,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	memset(&ioc, 0, sizeof(ioc));
 
 	/* Copy the ioc control structure part of ioctl request */
-	if (copy_from_user(&ioc, ifr->ifr_data, sizeof(wl_ioctl_t))) {
+	if (copy_from_user(&ioc, ifr->ifr_data, sizeof(struct brcmf_ioctl))) {
 		bcmerror = -EINVAL;
 		goto done;
 	}
@@ -1248,8 +1248,8 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	}
 
 	/* To differentiate between wl and dhd read 4 more byes */
-	if ((copy_from_user(&driver, (char *)ifr->ifr_data + sizeof(wl_ioctl_t),
-			    sizeof(uint)) != 0)) {
+	if ((copy_from_user(&driver, (char *)ifr->ifr_data +
+			    sizeof(struct brcmf_ioctl), sizeof(uint)) != 0)) {
 		bcmerror = -EINVAL;
 		goto done;
 	}
@@ -1292,8 +1292,8 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 		brcmf_netdev_wait_pend8021x(net);
 
 	bcmerror =
-	    brcmf_proto_ioctl(&drvr_priv->pub, ifidx, (wl_ioctl_t *)&ioc, buf,
-			      buflen);
+	    brcmf_proto_ioctl(&drvr_priv->pub, ifidx, (struct brcmf_ioctl *)&ioc,
+			      buf, buflen);
 
 done:
 	if (!bcmerror && buf && ioc.buf) {
@@ -1604,7 +1604,7 @@ int brcmf_iovar(dhd_pub_t *drvr, int ifidx, char *name, char *cmd_buf,
 {
 	char buf[strlen(name) + 1 + cmd_len];
 	int len = sizeof(buf);
-	wl_ioctl_t ioc;
+	struct brcmf_ioctl ioc;
 	int ret;
 
 	len = brcmu_mkiovar(name, cmd_buf, cmd_len, buf, len);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index f8ca781..4ac2cd1 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -52,7 +52,7 @@ extern void brcmf_proto_hdrpush(dhd_pub_t *, int ifidx, struct sk_buff *txp);
 extern int brcmf_proto_hdrpull(dhd_pub_t *, int *ifidx, struct sk_buff *rxp);
 
 /* Use protocol to issue ioctl to dongle */
-extern int brcmf_proto_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc,
+extern int brcmf_proto_ioctl(dhd_pub_t *dhd, int ifidx, struct brcmf_ioctl *ioc,
 			  void *buf, int len);
 
 /* Check for and handle local prot-specific iovar commands */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 9d86fc1..aeb305c 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -186,7 +186,7 @@ static s32 wl_set_set_sharedkey(struct net_device *dev,
 static s32 wl_get_assoc_ies(struct wl_priv *wl);
 static void wl_clear_assoc_ies(struct wl_priv *wl);
 static void wl_ch_to_chanspec(int ch,
-	struct wl_join_params *join_params, size_t *join_params_size);
+	struct brcmf_join_params *join_params, size_t *join_params_size);
 
 /*
 ** information element utilities
@@ -197,7 +197,7 @@ static struct wireless_dev *wl_alloc_wdev(s32 sizeof_iface,
 			struct device *dev);
 static void wl_free_wdev(struct wl_priv *wl);
 static s32 wl_inform_bss(struct wl_priv *wl);
-static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi);
+static s32 wl_inform_single_bss(struct wl_priv *wl, struct brcmf_bss_info *bi);
 static s32 wl_update_bss_info(struct wl_priv *wl);
 static s32 wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 			u8 key_idx, const u8 *mac_addr,
@@ -206,8 +206,8 @@ static s32 wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 /*
 ** key indianess swap utilities
 */
-static void swap_key_from_BE(struct wl_wsec_key *key);
-static void swap_key_to_BE(struct wl_wsec_key *key);
+static void swap_key_from_BE(struct brcmf_wsec_key *key);
+static void swap_key_to_BE(struct brcmf_wsec_key *key);
 
 /*
 ** wl_priv memory init/deinit utilities
@@ -264,13 +264,13 @@ static s32 wl_dev_iovar_setbuf(struct net_device *dev, s8 *iovar,
 static s32 wl_dev_iovar_getbuf(struct net_device *dev, s8 *iovar,
 				 void *param, s32 paramlen, void *bufptr,
 				 s32 buflen);
-static s32 wl_run_iscan(struct wl_iscan_ctrl *iscan, struct wlc_ssid *ssid,
+static s32 wl_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid,
 			  u16 action);
 static s32 wl_do_iscan(struct wl_priv *wl);
 static s32 wl_wakeup_iscan(struct wl_iscan_ctrl *iscan);
 static s32 wl_invoke_iscan(struct wl_priv *wl);
 static s32 wl_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
-				  struct wl_scan_results **bss_list);
+				  struct brcmf_scan_results **bss_list);
 static void wl_notify_iscan_complete(struct wl_iscan_ctrl *iscan, bool aborted);
 static void wl_init_iscan_eloop(struct wl_iscan_eloop *el);
 static s32 wl_iscan_done(struct wl_priv *wl);
@@ -492,7 +492,7 @@ static const u32 __wl_cipher_suites[] = {
 	WLAN_CIPHER_SUITE_AES_CMAC,
 };
 
-static void swap_key_from_BE(struct wl_wsec_key *key)
+static void swap_key_from_BE(struct brcmf_wsec_key *key)
 {
 	key->index = cpu_to_le32(key->index);
 	key->len = cpu_to_le32(key->len);
@@ -503,7 +503,7 @@ static void swap_key_from_BE(struct wl_wsec_key *key)
 	key->iv_initialized = cpu_to_le32(key->iv_initialized);
 }
 
-static void swap_key_to_BE(struct wl_wsec_key *key)
+static void swap_key_to_BE(struct brcmf_wsec_key *key)
 {
 	key->index = le32_to_cpu(key->index);
 	key->len = le32_to_cpu(key->len);
@@ -518,7 +518,7 @@ static s32
 wl_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 {
 	struct ifreq ifr;
-	struct wl_ioctl ioc;
+	struct brcmf_ioctl ioc;
 	mm_segment_t fs;
 	s32 err = 0;
 
@@ -588,7 +588,8 @@ done:
 	return err;
 }
 
-static void wl_iscan_prep(struct wl_scan_params *params, struct wlc_ssid *ssid)
+static void wl_iscan_prep(struct brcmf_scan_params *params,
+			  struct brcmf_ssid *ssid)
 {
 	memcpy(params->bssid, ether_bcast, ETH_ALEN);
 	params->bss_type = DOT11_BSSTYPE_ANY;
@@ -604,7 +605,7 @@ static void wl_iscan_prep(struct wl_scan_params *params, struct wlc_ssid *ssid)
 	params->passive_time = cpu_to_le32(params->passive_time);
 	params->home_time = cpu_to_le32(params->home_time);
 	if (ssid && ssid->SSID_len)
-		memcpy(&params->ssid, ssid, sizeof(wlc_ssid_t));
+		memcpy(&params->ssid, ssid, sizeof(struct brcmf_ssid));
 
 }
 
@@ -633,15 +634,15 @@ wl_dev_iovar_getbuf(struct net_device *dev, s8 * iovar, void *param,
 }
 
 static s32
-wl_run_iscan(struct wl_iscan_ctrl *iscan, struct wlc_ssid *ssid, u16 action)
+wl_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid, u16 action)
 {
-	s32 params_size =
-	    (WL_SCAN_PARAMS_FIXED_SIZE + offsetof(wl_iscan_params_t, params));
-	struct wl_iscan_params *params;
+	s32 params_size = (WL_SCAN_PARAMS_FIXED_SIZE +
+				offsetof(struct brcmf_iscan_params, params));
+	struct brcmf_iscan_params *params;
 	s32 err = 0;
 
 	if (ssid && ssid->SSID_len)
-		params_size += sizeof(struct wlc_ssid);
+		params_size += sizeof(struct brcmf_ssid);
 	params = kzalloc(params_size, GFP_KERNEL);
 	if (unlikely(!params))
 		return -ENOMEM;
@@ -653,7 +654,7 @@ wl_run_iscan(struct wl_iscan_ctrl *iscan, struct wlc_ssid *ssid, u16 action)
 	params->action = cpu_to_le16(action);
 	params->scan_duration = cpu_to_le16(0);
 
-	/* params_size += offsetof(wl_iscan_params_t, params); */
+	/* params_size += offsetof(struct brcmf_iscan_params, params); */
 	err = wl_dev_iovar_setbuf(iscan->dev, "iscan", params, params_size,
 				iscan->ioctl_buf, BRCMF_C_IOCTL_SMLEN);
 	if (unlikely(err)) {
@@ -671,7 +672,7 @@ static s32 wl_do_iscan(struct wl_priv *wl)
 {
 	struct wl_iscan_ctrl *iscan = wl_to_iscan(wl);
 	struct net_device *ndev = wl_to_ndev(wl);
-	struct wlc_ssid ssid;
+	struct brcmf_ssid ssid;
 	s32 passive_scan;
 	s32 err = 0;
 
@@ -933,7 +934,7 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_ibss_params *params)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
-	struct wl_join_params join_params;
+	struct brcmf_join_params join_params;
 	size_t join_params_size = 0;
 	s32 err = 0;
 	s32 wsec = 0;
@@ -1011,7 +1012,7 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	/* Configure required join parameter */
-	memset(&join_params, 0, sizeof(wl_join_params_t));
+	memset(&join_params, 0, sizeof(struct brcmf_join_params));
 
 	/* SSID */
 	join_params.ssid.SSID_len =
@@ -1278,7 +1279,7 @@ wl_set_set_sharedkey(struct net_device *dev,
 {
 	struct wl_priv *wl = ndev_to_wl(dev);
 	struct wl_security *sec;
-	struct wl_wsec_key key;
+	struct brcmf_wsec_key key;
 	s32 val;
 	s32 err = 0;
 
@@ -1344,7 +1345,7 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	struct ieee80211_channel *chan = sme->channel;
-	struct wl_join_params join_params;
+	struct brcmf_join_params join_params;
 	size_t join_params_size;
 
 	s32 err = 0;
@@ -1440,7 +1441,7 @@ wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		       u16 reason_code)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
-	scb_val_t scbval;
+	struct brcmf_scb_val scbval;
 	s32 err = 0;
 
 	WL_TRACE("Enter. Reason code = %d\n", reason_code);
@@ -1452,7 +1453,7 @@ wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(&scbval.ea, wl_read_prof(wl, WL_PROF_BSSID), ETH_ALEN);
 	scbval.val = cpu_to_le32(scbval.val);
 	err = wl_dev_ioctl(dev, BRCMF_C_DISASSOC, &scbval,
-			sizeof(scb_val_t));
+			sizeof(struct brcmf_scb_val));
 	if (unlikely(err))
 		WL_ERR("error (%d)\n", err);
 
@@ -1578,7 +1579,7 @@ static s32
 wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	      u8 key_idx, const u8 *mac_addr, struct key_params *params)
 {
-	struct wl_wsec_key key;
+	struct brcmf_wsec_key key;
 	s32 err = 0;
 
 	memset(&key, 0, sizeof(key));
@@ -1666,7 +1667,7 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr,
 		    struct key_params *params)
 {
-	struct wl_wsec_key key;
+	struct brcmf_wsec_key key;
 	s32 val;
 	s32 wsec;
 	s32 err = 0;
@@ -1759,7 +1760,7 @@ static s32
 wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
-	struct wl_wsec_key key;
+	struct brcmf_wsec_key key;
 	s32 err = 0;
 	s32 val;
 	s32 wsec;
@@ -1826,7 +1827,7 @@ wl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		    void (*callback) (void *cookie, struct key_params * params))
 {
 	struct key_params params;
-	struct wl_wsec_key key;
+	struct brcmf_wsec_key key;
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	struct wl_security *sec;
 	s32 wsec;
@@ -1897,7 +1898,7 @@ wl_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 			u8 *mac, struct station_info *sinfo)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
-	scb_val_t scb_val;
+	struct brcmf_scb_val scb_val;
 	int rssi;
 	s32 rate;
 	s32 err = 0;
@@ -1931,7 +1932,7 @@ wl_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	if (test_bit(WL_STATUS_CONNECTED, &wl->status)) {
 		scb_val.val = 0;
 		err = wl_dev_ioctl(dev, BRCMF_C_GET_RSSI, &scb_val,
-				sizeof(scb_val_t));
+				sizeof(struct brcmf_scb_val));
 		if (unlikely(err)) {
 			WL_ERR("Could not get rssi (%d)\n", err);
 		}
@@ -2379,8 +2380,8 @@ static void wl_free_wdev(struct wl_priv *wl)
 
 static s32 wl_inform_bss(struct wl_priv *wl)
 {
-	struct wl_scan_results *bss_list;
-	struct wl_bss_info *bi = NULL;	/* must be initialized */
+	struct brcmf_scan_results *bss_list;
+	struct brcmf_bss_info *bi = NULL;	/* must be initialized */
 	s32 err = 0;
 	int i;
 
@@ -2401,7 +2402,7 @@ static s32 wl_inform_bss(struct wl_priv *wl)
 }
 
 
-static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi)
+static s32 wl_inform_single_bss(struct wl_priv *wl, struct brcmf_bss_info *bi)
 {
 	struct wiphy *wiphy = wl_to_wiphy(wl);
 	struct ieee80211_channel *notify_channel;
@@ -2466,7 +2467,7 @@ wl_inform_ibss(struct wl_priv *wl, struct net_device *dev, const u8 *bssid)
 {
 	struct wiphy *wiphy = wl_to_wiphy(wl);
 	struct ieee80211_channel *notify_channel;
-	struct wl_bss_info *bi = NULL;
+	struct brcmf_bss_info *bi = NULL;
 	struct ieee80211_supported_band *band;
 	u8 *buf = NULL;
 	s32 err = 0;
@@ -2496,7 +2497,7 @@ wl_inform_ibss(struct wl_priv *wl, struct net_device *dev, const u8 *bssid)
 		goto CleanUp;
 	}
 
-	bi = (wl_bss_info_t *)(buf + 4);
+	bi = (struct brcmf_bss_info *)(buf + 4);
 
 	channel = bi->ctl_ch ? bi->ctl_ch :
 				CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
@@ -2743,7 +2744,7 @@ static void wl_clear_assoc_ies(struct wl_priv *wl)
 }
 
 
-static void wl_ch_to_chanspec(int ch, struct wl_join_params *join_params,
+static void wl_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 	size_t *join_params_size)
 {
 	chanspec_t chanspec = 0;
@@ -2779,8 +2780,8 @@ static void wl_ch_to_chanspec(int ch, struct wl_join_params *join_params,
 
 static s32 wl_update_bss_info(struct wl_priv *wl)
 {
-	struct wl_bss_info *bi;
-	struct wlc_ssid *ssid;
+	struct brcmf_bss_info *bi;
+	struct brcmf_ssid *ssid;
 	struct brcmu_tlv *tim;
 	u16 beacon_interval;
 	u8 dtim_period;
@@ -2792,7 +2793,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 	if (wl_is_ibssmode(wl))
 		return err;
 
-	ssid = (struct wlc_ssid *)wl_read_prof(wl, WL_PROF_SSID);
+	ssid = (struct brcmf_ssid *)wl_read_prof(wl, WL_PROF_SSID);
 
 	*(u32 *)wl->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
 	err = wl_dev_ioctl(wl_to_ndev(wl), BRCMF_C_GET_BSS_INFO,
@@ -2802,7 +2803,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 		goto update_bss_info_out;
 	}
 
-	bi = (struct wl_bss_info *)(wl->extra_buf + 4);
+	bi = (struct brcmf_bss_info *)(wl->extra_buf + 4);
 	err = wl_inform_single_bss(wl, bi);
 	if (unlikely(err))
 		goto update_bss_info_out;
@@ -2917,8 +2918,8 @@ static s32
 wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 		      const brcmf_event_msg_t *e, void *data)
 {
-	struct channel_info channel_inform;
-	struct wl_scan_results *bss_list;
+	struct brcmf_channel_info channel_inform;
+	struct brcmf_scan_results *bss_list;
 	u32 len = WL_SCAN_BUF_MAX;
 	s32 err = 0;
 	bool scan_abort = false;
@@ -3153,24 +3154,24 @@ static s32 wl_wakeup_iscan(struct wl_iscan_ctrl *iscan)
 
 static s32
 wl_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
-		     struct wl_scan_results **bss_list)
+		     struct brcmf_scan_results **bss_list)
 {
-	struct wl_iscan_results list;
-	struct wl_scan_results *results;
-	struct wl_iscan_results *list_buf;
+	struct brcmf_iscan_results list;
+	struct brcmf_scan_results *results;
+	struct brcmf_iscan_results *list_buf;
 	s32 err = 0;
 
 	memset(iscan->scan_buf, 0, WL_ISCAN_BUF_MAX);
-	list_buf = (struct wl_iscan_results *)iscan->scan_buf;
+	list_buf = (struct brcmf_iscan_results *)iscan->scan_buf;
 	results = &list_buf->results;
-	results->buflen = WL_ISCAN_RESULTS_FIXED_SIZE;
+	results->buflen = BRCMF_ISCAN_RESULTS_FIXED_SIZE;
 	results->version = 0;
 	results->count = 0;
 
 	memset(&list, 0, sizeof(list));
 	list.results.buflen = cpu_to_le32(WL_ISCAN_BUF_MAX);
 	err = wl_dev_iovar_getbuf(iscan->dev, "iscanresults", &list,
-				WL_ISCAN_RESULTS_FIXED_SIZE, iscan->scan_buf,
+				BRCMF_ISCAN_RESULTS_FIXED_SIZE, iscan->scan_buf,
 				WL_ISCAN_BUF_MAX);
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
@@ -3930,11 +3931,11 @@ wl_update_prof(struct wl_priv *wl, const brcmf_event_msg_t *e, void *data,
 	       s32 item)
 {
 	s32 err = 0;
-	struct wlc_ssid *ssid;
+	struct brcmf_ssid *ssid;
 
 	switch (item) {
 	case WL_PROF_SSID:
-		ssid = (wlc_ssid_t *) data;
+		ssid = (struct brcmf_ssid *) data;
 		memset(wl->profile->ssid.SSID, 0,
 		       sizeof(wl->profile->ssid.SSID));
 		memcpy(wl->profile->ssid.SSID, ssid->SSID, ssid->SSID_len);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 7848b3c..3400cc9 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -206,7 +206,7 @@ struct wl_cfg80211_bss_info {
 
 /* basic structure of scan request */
 struct wl_scan_req {
-	struct wlc_ssid ssid;
+	struct brcmf_ssid ssid;
 };
 
 /* basic structure of information element */
@@ -244,7 +244,7 @@ struct wl_ibss {
 /* dongle profile */
 struct wl_profile {
 	u32 mode;
-	struct wlc_ssid ssid;
+	struct brcmf_ssid ssid;
 	u8 bssid[ETH_ALEN];
 	u16 beacon_interval;
 	u8 dtim_period;
@@ -303,9 +303,9 @@ struct wl_priv {
 	struct list_head eq_list;	/* used for event queue */
 	spinlock_t eq_lock;	/* for event queue synchronization */
 	struct mutex usr_sync;	/* maily for dongle up/down synchronization */
-	struct wl_scan_results *bss_list;	/* bss_list holding scanned
+	struct brcmf_scan_results *bss_list;	/* bss_list holding scanned
 						 ap information */
-	struct wl_scan_results *scan_results;
+	struct brcmf_scan_results *scan_results;
 	struct wl_scan_req *scan_req_int;	/* scan request object for
 						 internal purpose */
 	struct wl_cfg80211_bss_info *bss_info;	/* bss information for
@@ -354,11 +354,11 @@ struct wl_priv {
 #define wl_to_iscan(w) (w->iscan)
 #define wl_to_conn(w) (&w->conn_info)
 
-static inline struct wl_bss_info *next_bss(struct wl_scan_results *list,
-					   struct wl_bss_info *bss)
+static inline struct brcmf_bss_info *next_bss(struct brcmf_scan_results *list,
+					   struct brcmf_bss_info *bss)
 {
 	return bss = bss ?
-		(struct wl_bss_info *)((unsigned long)bss +
+		(struct brcmf_bss_info *)((unsigned long)bss +
 				       le32_to_cpu(bss->length)) :
 		list->bss_info;
 }
-- 
1.7.1


