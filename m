Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759720AbXHNLmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:42:13 -0400
Subject: [PATCH v2] hostapd: work with monitor interface
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Andy Green <andy@warmcat.com>
In-Reply-To: <1186992004.27916.53.camel@johannes.berg>
References: <1186992004.27916.53.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 01:14:11 +0200
Message-Id: <1187046852.32435.36.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So here it is. hostapd using monitor interfaces instead of the
management interface. It now uses the AP mode ethernet interface to get
at EAPOL frames instead of the management interface.

Thanks goes to Andy for letting me use his radiotap iterator code from
the kernel under GPL2/BSD :)

The code requires libnl from SVN.

There are few TODO items but those are not regressions except the
channel/phytype one and I'm not sure hostapd actually uses that info.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 hostapd/Makefile             |    3 
 hostapd/defconfig            |    5 
 hostapd/driver_devicescape.c |  563 ++++++++++++++++++++++++++-----------------
 hostapd/ieee802_11.c         |    3 
 hostapd/radiotap.c           |  281 +++++++++++++++++++++
 hostapd/radiotap.h           |  242 ++++++++++++++++++
 hostapd/radiotap_iter.h      |   41 +++
 7 files changed, 926 insertions(+), 212 deletions(-)

--- hostap.orig/hostapd/Makefile	2007-08-13 13:33:22.000000000 +0200
+++ hostap/hostapd/Makefile	2007-08-13 14:01:47.000000000 +0200
@@ -117,7 +117,8 @@ endif
 
 ifdef CONFIG_DRIVER_DEVICESCAPE
 CFLAGS += -DCONFIG_DRIVER_DEVICESCAPE
-OBJS += driver_devicescape.o
+LIBS += -lnl
+OBJS += driver_devicescape.o radiotap.o
 endif
 
 ifdef CONFIG_DRIVER_BSD
--- hostap.orig/hostapd/driver_devicescape.c	2007-08-13 14:01:47.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-14 00:10:17.000000000 +0200
@@ -16,33 +16,39 @@
 
 #include "includes.h"
 #include <sys/ioctl.h>
-
-#ifdef USE_KERNEL_HEADERS
-#include <asm/types.h>
+#include <netlink/genl/genl.h>
+#include <netlink/genl/family.h>
+#include <netlink/genl/ctrl.h>
+#include <netlink/msg.h>
+#include <netlink/attr.h>
+#include <linux/nl80211.h>
+#include <net/if.h>
 #include <linux/if_packet.h>
 #include <linux/if_ether.h>   /* The L2 protocols */
-#include <linux/if_arp.h>
 #include <linux/wireless.h>
-#else /* USE_KERNEL_HEADERS */
 #include <net/if_arp.h>
-#include <netpacket/packet.h>
-#include "wireless_copy.h"
-#endif /* USE_KERNEL_HEADERS */
+#include <linux/filter.h>
 
 #include "hostapd.h"
 #include "driver.h"
 #include "ieee802_1x.h"
 #include "eloop.h"
-#include "priv_netlink.h"
 #include "ieee802_11.h"
 #include "sta_info.h"
 #include "hw_features.h"
+#include "radiotap_iter.h"
+/*
+ * once you remove this include, remove everything
+ * about using wireless-dev sources from defconfig
+ */
 #include <hostapd_ioctl.h>
-#include <ieee80211_common.h>
 
-/* there used to be this constant in the kernel sources, but
- * the kernel no longer needs it.... we use it internally.... */
-#define ieee80211_msg_passive_scan 3
+enum ieee80211_msg_type {
+	ieee80211_msg_normal,
+	ieee80211_msg_tx_callback_ack,
+	ieee80211_msg_tx_callback_fail,
+	ieee80211_msg_passive_scan,
+};
 
 /* from net/mac80211.h */
 enum {
@@ -60,13 +66,15 @@ struct i802_driver_data {
 	struct hostapd_data *hapd;
 
 	char iface[IFNAMSIZ + 1];
-	char mgmt_iface[IFNAMSIZ + 1];
-	int mgmt_ifindex;
-	int sock; /* raw packet socket for driver access */
 	int ioctl_sock; /* socket for ioctl() use */
 	int wext_sock; /* socket for wireless events */
+	int monitor_sock; /* socket for monitor */
+	int monitor_ifidx;
 
 	int we_version;
+	struct nl_handle *nl_handle;
+	struct nl_cache *nl_cache;
+	struct genl_family *nl80211;
 };
 
 
@@ -89,7 +97,7 @@ static int hostapd_set_iface_flags(struc
 	if (ioctl(drv->ioctl_sock, SIOCGIFFLAGS, &ifr) != 0) {
 		perror("ioctl[SIOCGIFFLAGS]");
 		wpa_printf(MSG_DEBUG, "Could not read interface flags (%s)",
-			   drv->mgmt_iface);
+			   drv->iface);
 		return -1;
 	}
 
@@ -103,17 +111,6 @@ static int hostapd_set_iface_flags(struc
 		return -1;
 	}
 
-	if (dev_up) {
-		memset(&ifr, 0, sizeof(ifr));
-		os_strlcpy(ifr.ifr_name, drv->mgmt_iface, IFNAMSIZ);
-		ifr.ifr_mtu = HOSTAPD_MTU;
-		if (ioctl(drv->ioctl_sock, SIOCSIFMTU, &ifr) != 0) {
-			perror("ioctl[SIOCSIFMTU]");
-			printf("Setting MTU failed - trying to survive with "
-			       "current value\n");
-		}
-	}
-
 	return 0;
 }
 
@@ -302,37 +299,6 @@ static int hostap_ioctl_prism2param(stru
 }
 
 
-static int hostap_ioctl_get_prism2param_iface(const char *iface,
-					      struct i802_driver_data *drv,
-					      int param)
-{
-	struct iwreq iwr;
-	int *i;
-
-	memset(&iwr, 0, sizeof(iwr));
-	os_strlcpy(iwr.ifr_name, iface, IFNAMSIZ);
-	i = (int *) iwr.u.name;
-	*i = param;
-
-	if (ioctl(drv->ioctl_sock, PRISM2_IOCTL_GET_PRISM2_PARAM, &iwr) < 0) {
-		char buf[128];
-		snprintf(buf, sizeof(buf),
-			 "%s: ioctl[PRISM2_IOCTL_GET_PRISM2_PARAM]", iface);
-		perror(buf);
-		return -1;
-	}
-
-	return *i;
-}
-
-
-static int hostap_ioctl_get_prism2param(struct i802_driver_data *drv,
-					int param)
-{
-	return hostap_ioctl_get_prism2param_iface(drv->iface, drv, param);
-}
-
-
 static int i802_set_ssid(const char *ifname, void *priv, const u8 *buf,
 			 int len)
 {
@@ -355,12 +321,43 @@ static int i802_set_ssid(const char *ifn
 }
 
 
-static int i802_send_mgmt_frame(void *priv, const void *msg, size_t len,
+static int i802_send_mgmt_frame(void *priv, const void *data, size_t len,
 				int flags)
 {
-	struct i802_driver_data *drv = priv;
+	struct ieee80211_hdr *hdr = (void*) data;
+	__u8 rtap_hdr[] = {
+		0x00, 0x00, /* radiotap version */
+		0x09, 0x00, /* radiotap length */
+		0x02, 0x00, 0x00, 0x00, /* bmap: flags */
+		0x04,       /* F_WEP (encrypt if required) */
+	};
+	struct i802_driver_data *drv = priv;
+	struct iovec iov[2] = {
+		{
+			.iov_base = &rtap_hdr,
+			.iov_len = sizeof(rtap_hdr),
+		},
+		{
+			.iov_base = (void*)data,
+			.iov_len = len,
+		}
+	};
+	struct msghdr msg = {
+		.msg_name = NULL,
+		.msg_namelen = 0,
+		.msg_iov = iov,
+		.msg_iovlen = 2,
+		.msg_control = NULL,
+		.msg_controllen = 0,
+		.msg_flags = 0,
+	};
 
-	return send(drv->sock, msg, len, flags);
+	/*
+	 * ugh, guess what, the generic code sets one of the version
+	 * bits to request tx callback
+	 */
+	hdr->frame_control &= ~host_to_le16(BIT(1));
+	return sendmsg(drv->monitor_sock, &msg, flags);
 }
 
 
@@ -595,8 +592,6 @@ static int i802_send_eapol(void *priv, c
 	hdr->frame_control =
 		IEEE80211_FC(WLAN_FC_TYPE_DATA, WLAN_FC_STYPE_DATA);
 	hdr->frame_control |= host_to_le16(WLAN_FC_FROMDS);
-	/* Request TX callback */
-	hdr->frame_control |= host_to_le16(BIT(1));
 	if (encrypt)
 		hdr->frame_control |= host_to_le16(WLAN_FC_ISWEP);
 #if 0 /* To be enabled if qos determination is added above */
@@ -626,6 +621,10 @@ static int i802_send_eapol(void *priv, c
 	pos += 2;
 	memcpy(pos, data, data_len);
 
+	/*
+	 * send via the monitor interface so it won't be dropped
+	 * if PAE is enabled
+	 */
 	res = i802_send_mgmt_frame(drv, (u8 *) hdr, len, 0);
 	free(hdr);
 
@@ -887,6 +886,8 @@ static int i802_set_ieee8021x(const char
 {
 	struct i802_driver_data *drv = priv;
 
+	printf("eapol = %d\n", enabled);
+
 	if (hostap_ioctl_prism2param_iface(ifname, drv,
 					   PRISM2_PARAM_IEEE_802_1X, enabled))
 	{
@@ -1165,7 +1166,7 @@ static int i802_set_sta_vlan(void *priv,
 
 
 static void handle_data(struct hostapd_data *hapd, u8 *buf, size_t len,
-			u16 stype, struct ieee80211_frame_info *fi)
+			u16 stype)
 {
 	struct ieee80211_hdr *hdr;
 	u16 fc, ethertype;
@@ -1281,50 +1282,9 @@ static void handle_tx_callback(struct ho
 }
 
 
-static void dump_frame_info(struct ieee80211_frame_info *fi, size_t len)
-{
-	u64 ts, tus;
-
-	tus = ts = be_to_host64(fi->hosttime);
-	ts /= 1000000;
-	tus -= ts * 1000000;
-	wpa_hexdump(MSG_DEBUG, "Frame info dump", (u8 *) fi, len);
-        printf("version:\t0x%08x\n", ntohl(fi->version));
-        printf("length:\t%d\n", ntohl(fi->length));
-        printf("mactime:\t%lld\n", be_to_host64(fi->mactime));
-        printf("hosttime:\t%lld.%06lld\n", ts, tus);
-        printf("phytype:\t%d\n", ntohl(fi->phytype));
-        printf("channel:\t%d\n", ntohl(fi->channel));
-        printf("datarate:\t%d\n", ntohl(fi->datarate));
-        printf("antenna:\t%d\n", ntohl(fi->antenna));
-        printf("priority\t%d\n", ntohl(fi->priority));
-        printf("ssi_type:\t%d\n", ntohl(fi->ssi_type));
-        printf("ssi_signal:\t%d\n", ntohl(fi->ssi_signal));
-        printf("ssi_noise:\t%d\n", ntohl(fi->ssi_noise));
-        printf("preamble:\t%d\n", ntohl(fi->preamble));
-        printf("encoding:\t%d\n", ntohl(fi->encoding));
-        printf("msg_type:\t%d\n", ntohl(fi->msg_type));
-}
-
-
-static void hostapd_michael_mic_failure(struct hostapd_data *hapd, u8 *buf,
-					size_t len)
-{
-	struct ieee80211_hdr *hdr;
-
-	if (len < 24) {
-		printf("Too short frame (%d) with Michael MIC failure\n", len);
-		return;
-	}
-
-	hdr = (struct ieee80211_hdr *) buf;
-
-	mlme_michaelmicfailure_indication(hapd, hdr->addr2);
-}
-
-
 static void handle_frame(struct hostapd_iface *iface, u8 *buf, size_t len,
-			 struct ieee80211_frame_info *fi)
+			 struct hostapd_frame_info *hfi,
+			 enum ieee80211_msg_type msg_type)
 {
 	struct ieee80211_hdr *hdr;
 	u16 fc, type, stype;
@@ -1333,27 +1293,6 @@ static void handle_frame(struct hostapd_
 	int broadcast_bssid = 0;
 	size_t i;
 	u8 *bssid;
-	int msg_type = ntohl(fi->msg_type);
-	struct hostapd_frame_info hfi;
-
-#if 0 /* TODO */
-	/* special handling for message types without IEEE 802.11 header */
-	if (msg_type == ieee80211_msg_set_aid_for_sta) {
-		ieee802_11_set_aid_for_sta(iface->bss[0], buf, data_len);
-		return;
-	}
-#endif
-# if 0
-/* TODO
- * get key notification from kernel again... it doesn't give one now
- * because this code doesn't care
- */
-	if (msg_type == ieee80211_msg_key_threshold_notification) {
-		ieee802_11_key_threshold_notification(iface->bss[0], buf,
-						      data_len);
-		return;
-	}
-#endif
 
 	/* PS-Poll frame from not associated is 16 bytes. All other frames
 	 * passed to hostapd are 24 bytes or longer.
@@ -1421,27 +1360,6 @@ static void handle_frame(struct hostapd_
 	case ieee80211_msg_tx_callback_fail:
 		handle_tx_callback(hapd, buf, data_len, 0);
 		return;
-/*
- * TODO
- * the kernel never sends this any more, add new nl80211
- * notification if you need this.
-
-	case ieee80211_msg_wep_frame_unknown_key:
-		ieee802_11_rx_unknown_key(hapd, buf, data_len);
-		return;
- */
-	case ieee80211_msg_michael_mic_failure:
-		hostapd_michael_mic_failure(hapd, buf, data_len);
-		return;
-/*
- * TODO
- * We should be telling them to go away. But we don't support that now.
- * See also below and above for other TODO items related to this.
-
- 	case ieee80211_msg_sta_not_assoc:
-		ieee802_11_rx_sta_not_assoc(hapd, buf, data_len);
-		return;
- */
 	default:
 		printf("handle_frame: unknown msg_type %d\n", msg_type);
 		return;
@@ -1453,19 +1371,12 @@ static void handle_frame(struct hostapd_
 			       stype == WLAN_FC_STYPE_PROBE_REQ) ?
 			      HOSTAPD_DEBUG_EXCESSIVE : HOSTAPD_DEBUG_VERBOSE,
 			      "MGMT\n");
-		memset(&hfi, 0, sizeof(hfi));
-		hfi.phytype = ntohl(fi->phytype);
-		hfi.channel = ntohl(fi->channel);
-		hfi.datarate = ntohl(fi->datarate);
-		hfi.ssi_signal = ntohl(fi->ssi_signal);
-		hfi.passive_scan = ntohl(fi->msg_type) ==
-			ieee80211_msg_passive_scan;
 		if (broadcast_bssid) {
 			for (i = 0; i < iface->num_bss; i++)
 				ieee802_11_mgmt(iface->bss[i], buf, data_len,
-						stype, &hfi);
+						stype, hfi);
 		} else
-			ieee802_11_mgmt(hapd, buf, data_len, stype, &hfi);
+			ieee802_11_mgmt(hapd, buf, data_len, stype, hfi);
 		break;
 	case WLAN_FC_TYPE_CTRL:
 		/* TODO: send deauth/disassoc if not associated STA sends
@@ -1474,7 +1385,7 @@ static void handle_frame(struct hostapd_
 		break;
 	case WLAN_FC_TYPE_DATA:
 		HOSTAPD_DEBUG(HOSTAPD_DEBUG_MINIMAL, "DATA\n");
-		handle_data(hapd, buf, data_len, stype, fi);
+		handle_data(hapd, buf, data_len, stype);
 		break;
 	default:
 		printf("unknown frame type %d\n", type);
@@ -1483,13 +1394,16 @@ static void handle_frame(struct hostapd_
 }
 
 
-static void handle_read(int sock, void *eloop_ctx, void *sock_ctx)
+static void handle_monitor_read(int sock, void *eloop_ctx, void *sock_ctx)
 {
 	struct hostapd_iface *iface = eloop_ctx;
 	int len;
 	unsigned char buf[3000];
-	struct ieee80211_frame_info *fi;
 	HAPD_DECL;
+	struct ieee80211_radiotap_iterator iter;
+	int ret;
+	struct hostapd_frame_info hfi;
+	int injected = 0, failed = 0, msg_type;
 
 	len = recv(sock, buf, sizeof(buf), 0);
 	if (len < 0) {
@@ -1506,26 +1420,132 @@ static void handle_read(int sock, void *
 		printf("\n");
         }
 
-	if (len < (int) sizeof(struct ieee80211_frame_info)) {
-		printf("handle_read: too short (%d)\n", len);
-		return;
-	}
+        if (ieee80211_radiotap_iterator_init(&iter, (void*)buf, len)) {
+        	printf("received invalid radiotap frame\n");
+        	return;
+        }
 
-	fi = (struct ieee80211_frame_info *) buf;
+	memset(&hfi, 0, sizeof(hfi));
 
-	if (ntohl(fi->version) != IEEE80211_FI_VERSION) {
-		printf("Invalid frame info version!\n");
-		dump_frame_info(fi, len);
-		return;
+	while (1) {
+		ret = ieee80211_radiotap_iterator_next(&iter);
+		if (ret == -ENOENT)
+			break;
+		if (ret) {
+			printf("received invalid radiotap frame\n");
+			return;
+		}
+		switch (iter.this_arg_index) {
+		case IEEE80211_RADIOTAP_TX_FLAGS:
+			injected = 1;
+			failed = le_to_host16((*(uint16_t *) iter.this_arg)) &
+					IEEE80211_RADIOTAP_F_TX_FAIL;
+			break;
+		case IEEE80211_RADIOTAP_DATA_RETRIES:
+			break;
+		case IEEE80211_RADIOTAP_CHANNEL:
+			/* TODO convert from freq/flags to channel number
+			hfi.channel = XXX;
+			hfi.phytype = XXX;
+			 */
+			break;
+		case IEEE80211_RADIOTAP_RATE:
+			hfi.datarate = *iter.this_arg * 5;
+			break;
+		case IEEE80211_RADIOTAP_DB_ANTSIGNAL:
+			hfi.ssi_signal = *iter.this_arg;
+			break;
+		}
 	}
 
-	handle_frame(iface,
-		     buf + sizeof(struct ieee80211_frame_info),
-		     len - sizeof(struct ieee80211_frame_info),
-		     fi);
+	if (!injected)
+		msg_type = ieee80211_msg_normal;
+	else if (failed)
+		msg_type = ieee80211_msg_tx_callback_fail;
+	else
+		msg_type = ieee80211_msg_tx_callback_ack;
+
+	handle_frame(iface, buf + iter.max_length,
+		     len - iter.max_length, &hfi, msg_type);
 }
 
 
+/*
+ * "the suggested interface is the pcap library"
+ * screw that.
+ *
+ * BPF load operations do network-to-host swapping,
+ * but radiotap is little endian, hence we use these
+ * macros at some points
+ */
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define LE32(x) (x)
+#define LE16(x) (x)
+#else
+#define LE16(x) ( ( ((x) <<  8) & 0xFF00) | \
+		  ( ((x) >>  8) & 0x00FF) )
+#define LE32(x) ( LE16((x))<<16 | LE16((x)>>16) )
+#endif
+
+/*
+ * we post-process the filter code later and rewrite
+ * this to the offset to the last instruction
+ */
+#define PASS	0xFF
+#define FAIL	0xFE
+
+struct sock_filter msock_filter_insns[] = {
+	/*
+	 * do a little-endian load of the radiotap length field
+	 */
+	/* load lower byte into A */
+	BPF_STMT(BPF_LD  | BPF_B | BPF_ABS, 2),
+	/* put it into X (== index register) */
+	BPF_STMT(BPF_MISC| BPF_TAX, 0),
+	/* load upper byte into A */
+	BPF_STMT(BPF_LD  | BPF_B | BPF_ABS, 3),
+	/* left-shift it by 8 */
+	BPF_STMT(BPF_ALU | BPF_LSH | BPF_K, 8),
+	/* or with X */
+	BPF_STMT(BPF_ALU | BPF_OR | BPF_X, 0),
+	/* put result into X */
+	BPF_STMT(BPF_MISC| BPF_TAX, 0),
+
+	/*
+	 * Allow management frames through, this also gives us those
+	 * management frames that we sent ourselves with status
+	 */
+	/* load the lower byte of the IEEE 802.11 frame control field */
+	BPF_STMT(BPF_LD  | BPF_B | BPF_IND, 0),
+	/* mask off frame type and version */
+	BPF_STMT(BPF_ALU | BPF_AND | BPF_K, 0xF),
+	/* accept frame if it's both 0, fall through otherwise */
+	BPF_JUMP(BPF_JMP | BPF_JEQ, 0, PASS, 0),
+
+	/*
+	 * TODO: add a bit to radiotap RX flags that indicates
+	 * that the sending station is not associated, then
+	 * add a filter here that filters on our DA and that flag
+	 * to allow us to deauth frames to that bad station.
+	 *
+	 * Not a regression -- we didn't do it before either.
+	 */
+
+	/* do we need any other frames? */
+
+	/* keep these last two statements or change the code below */
+	/* return 0 == "DROP" */
+	BPF_STMT(BPF_RET | BPF_K, 0),
+	/* return ~0 == "keep all" */
+	BPF_STMT(BPF_RET | BPF_K, ~0),
+};
+
+static struct sock_fprog msock_filter = {
+	.len = sizeof(msock_filter_insns)/sizeof(msock_filter_insns[0]),
+	.filter = msock_filter_insns,
+};
+
+
 static int i802_init_sockets(struct i802_driver_data *drv)
 {
 	struct hostapd_data *hapd = drv->hapd;
@@ -1533,8 +1553,11 @@ static int i802_init_sockets(struct i802
 	struct ifreq ifr;
 	struct sockaddr_ll addr;
 	struct iwreq iwr;
-
-	drv->sock = drv->ioctl_sock = -1;
+	char buf[IFNAMSIZ];
+	struct nl_msg *msg;
+	socklen_t optlen;
+	int optval;
+	int idx;
 
 	drv->ioctl_sock = socket(PF_INET, SOCK_DGRAM, 0);
 	if (drv->ioctl_sock < 0) {
@@ -1542,64 +1565,169 @@ static int i802_init_sockets(struct i802
 		return -1;
 	}
 
-	/* Enable management interface */
-	if (hostap_ioctl_prism2param(drv, PRISM2_PARAM_MGMT_IF, 1) < 0) {
-		printf("Failed to enable management interface.\n");
+	/*
+	 * initialise generic netlink, nl80211, and get a monitor mode
+	 * interface.
+	 */
+	drv->nl_handle = nl_handle_alloc();
+	if (!drv->nl_handle) {
+		printf("Failed to allocate netlink handle.\n");
 		return -1;
 	}
-	drv->mgmt_ifindex =
-		hostap_ioctl_get_prism2param(drv, PRISM2_PARAM_MGMT_IF);
-	if (drv->mgmt_ifindex < 0) {
-		printf("Failed to get ifindex for the management "
-		       "interface.\n");
+
+	if (genl_connect(drv->nl_handle)) {
+		printf("Failed to connect to generic netlink.\n");
 		return -1;
 	}
 
-	memset(&ifr, 0, sizeof(ifr));
-	ifr.ifr_ifindex = drv->mgmt_ifindex;
-	if (ioctl(drv->ioctl_sock, SIOCGIFNAME, &ifr) != 0) {
-		perror("ioctl(SIOCGIFNAME)");
+	drv->nl_cache = genl_ctrl_alloc_cache(drv->nl_handle);
+	if (!drv->nl_cache) {
+		printf("Failed to allocate generic netlink cache.\n");
 		return -1;
 	}
-	os_strlcpy(drv->mgmt_iface, ifr.ifr_name, sizeof(drv->mgmt_iface));
 
-	memset(&iwr, 0, sizeof(iwr));
-	os_strlcpy(iwr.ifr_name, hapd->conf->iface, IFNAMSIZ);
-	iwr.u.mode = IW_MODE_MASTER;
+	drv->nl80211 = genl_ctrl_search_by_name(drv->nl_cache, "nl80211");
+	if (!drv->nl80211) {
+		printf("nl80211 not found.\n");
+		return -1;
+	}
 
-	if (ioctl(drv->ioctl_sock, SIOCSIWMODE, &iwr) < 0) {
-		perror("ioctl[SIOCSIWMODE]");
+	/* conjure a monitor interface */
+	msg = nlmsg_alloc();
+	if (!msg) {
+		printf("Failed to allocate netlink message.\n");
+		return -1;
+	}
+	snprintf(buf, IFNAMSIZ, "mon.%s", hapd->conf->iface);
+	buf[IFNAMSIZ-1] = '\0';
+	genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0,
+		    0, NL80211_CMD_ADD_VIRTUAL_INTERFACE, 0);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX,
+		    if_nametoindex(hapd->conf->iface));
+	NLA_PUT_STRING(msg, NL80211_ATTR_IFNAME, buf);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFTYPE, NL80211_IFTYPE_MONITOR);
+	if (nl_send_auto_complete(drv->nl_handle, msg) < 0 ||
+	    nl_wait_for_ack(drv->nl_handle) < 0) {
+	nla_put_failure:
+		nlmsg_free(msg);
+		printf("Failed to create monitor interface %s.\n", buf);
+		return -1;
 	}
+	nlmsg_free(msg);
 
-	if (hostapd_set_iface_flags(drv, 1))
+	/*
+	 * TODO: try disabling receiving control frames on the monitor iface,
+	 * but this needs new kernel API first
+	 */
+
+	memset(&ifr, 0, sizeof(ifr));
+	os_strlcpy(ifr.ifr_name, buf, IFNAMSIZ);
+
+	if (ioctl(drv->ioctl_sock, SIOCGIFFLAGS, &ifr) != 0) {
+		perror("ioctl[SIOCGIFFLAGS]");
+		wpa_printf(MSG_DEBUG, "Could not read interface flags (%s)",
+			drv->iface);
 		return -1;
+	}
+
+	ifr.ifr_flags |= IFF_UP;
+
+	if (ioctl(drv->ioctl_sock, SIOCSIFFLAGS, &ifr) != 0) {
+		perror("ioctl[SIOCSIFFLAGS]");
+		return -1;
+	}
 
 	memset(&addr, 0, sizeof(addr));
 	addr.sll_family = AF_PACKET;
-	addr.sll_ifindex = ifr.ifr_ifindex;
+	drv->monitor_ifidx = addr.sll_ifindex = if_nametoindex(buf);
 	HOSTAPD_DEBUG(HOSTAPD_DEBUG_MINIMAL,
-		      "Opening raw packet socket for ifindex %d\n",
+		      "Opening raw packet socket for monitor (%d)\n",
 		      addr.sll_ifindex);
 
-	drv->sock = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
-	if (drv->sock < 0) {
+	drv->monitor_sock = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
+	if (drv->monitor_sock < 0) {
 		perror("socket[PF_PACKET,SOCK_RAW]");
 		return -1;
 	}
 
-	if (bind(drv->sock, (struct sockaddr *) &addr, sizeof(addr)) < 0) {
+	/* rewrite all PASS/FAIL jump offsets */
+	for (idx = 0; idx < msock_filter.len; idx++) {
+		struct sock_filter *insn = &msock_filter_insns[idx];
+
+		if (BPF_CLASS(insn->code) == BPF_JMP) {
+			if (insn->code == (BPF_JMP|BPF_JA)) {
+				if (insn->k == PASS)
+					insn->k = msock_filter.len - idx - 2;
+				else if (insn->k == FAIL)
+					insn->k = msock_filter.len - idx - 3;
+			}
+
+			if (insn->jt == PASS)
+				insn->jt = msock_filter.len - idx - 2;
+			else if (insn->jt == FAIL)
+				insn->jt = msock_filter.len - idx - 3;
+
+			if (insn->jf == PASS)
+				insn->jf = msock_filter.len - idx - 2;
+			else if (insn->jf == FAIL)
+				insn->jf = msock_filter.len - idx - 3;
+		}
+		/*
+		printf("BPF insn 0x%.2x: ", idx);
+		printf("0x%.4x ", insn->code);
+		printf("0x%.8x ", insn->k);
+		printf("0x%.2x ", insn->jt);
+		printf("0x%.2x\n", insn->jf);
+		*/
+	}
+
+	if (setsockopt(drv->monitor_sock, SOL_SOCKET, SO_ATTACH_FILTER,
+		       &msock_filter, sizeof(msock_filter))) {
+		perror("failed to attach filter");
+		return -1;
+	}
+
+	if (bind(drv->monitor_sock, (struct sockaddr *) &addr,
+		 sizeof(addr)) < 0) {
 		perror(__FILE__ ":bind");
 		return -1;
 	}
 
-	if (eloop_register_read_sock(drv->sock, handle_read, iface, NULL)) {
-		printf("Could not register read socket\n");
+	optlen = sizeof(optval);
+	optval = 20;
+	if (setsockopt(drv->monitor_sock, SOL_SOCKET, SO_PRIORITY,
+		       &optval, optlen)) {
+		perror("Failed to set socket priority");
 		return -1;
 	}
 
+	if (eloop_register_read_sock(drv->monitor_sock, handle_monitor_read,
+				     iface, NULL)) {
+		printf("Could not register monitor read socket\n");
+		return -1;
+	}
+
+	memset(&iwr, 0, sizeof(iwr));
+	os_strlcpy(iwr.ifr_name, hapd->conf->iface, IFNAMSIZ);
+	iwr.u.mode = IW_MODE_MASTER;
+
+	if (ioctl(drv->ioctl_sock, SIOCSIWMODE, &iwr) < 0) {
+		perror("ioctl[SIOCSIWMODE]");
+	}
+
+	if (hostapd_set_iface_flags(drv, 1))
+		return -1;
+
+	memset(&addr, 0, sizeof(addr));
+	addr.sll_family = AF_PACKET;
+	addr.sll_ifindex = ifr.ifr_ifindex;
+	HOSTAPD_DEBUG(HOSTAPD_DEBUG_MINIMAL,
+		      "Opening raw packet socket for ifindex %d\n",
+		      addr.sll_ifindex);
+
         memset(&ifr, 0, sizeof(ifr));
         os_strlcpy(ifr.ifr_name, drv->iface, sizeof(ifr.ifr_name));
-        if (ioctl(drv->sock, SIOCGIFHWADDR, &ifr) != 0) {
+        if (ioctl(drv->ioctl_sock, SIOCGIFHWADDR, &ifr) != 0) {
 		perror("ioctl(SIOCGIFHWADDR)");
 		return -1;
         }
@@ -1888,12 +2016,12 @@ static int i802_wireless_event_init(void
 static void i802_wireless_event_deinit(void *priv)
 {
 	struct i802_driver_data *drv = priv;
+
 	if (drv->wext_sock < 0)
 		return;
-	eloop_unregister_read_sock(drv->sock);
-	close(drv->sock);
 	eloop_unregister_read_sock(drv->wext_sock);
 	close(drv->wext_sock);
+
 }
 
 
@@ -1961,20 +2089,33 @@ failed:
 static void i802_deinit(void *priv)
 {
 	struct i802_driver_data *drv = priv;
+	struct nl_msg *msg;
 
 	/* Disable the radio. */
 	(void) hostap_ioctl_prism2param(drv, PRISM2_PARAM_RADIO_ENABLED, 0);
 
-	/* Disable management interface */
-	(void) hostap_ioctl_prism2param(drv, PRISM2_PARAM_MGMT_IF, 0);
-
 	(void) hostapd_set_iface_flags(drv, 0);
 
-	if (drv->sock >= 0)
-		close(drv->sock);
 	if (drv->ioctl_sock >= 0)
 		close(drv->ioctl_sock);
 
+	eloop_unregister_read_sock(drv->monitor_sock);
+	close(drv->monitor_sock);
+
+	msg = nlmsg_alloc();
+	if (msg) {
+		genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0,
+			    0, NL80211_CMD_DEL_VIRTUAL_INTERFACE, 0);
+		NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->monitor_ifidx);
+		if (nl_send_auto_complete(drv->nl_handle, msg) < 0 ||
+		    nl_wait_for_ack(drv->nl_handle) < 0)
+		nla_put_failure:
+			printf("Failed to remove monitor interface.\n");
+		nlmsg_free(msg);
+	}
+	nl_cache_free(drv->nl_cache);
+	nl_handle_destroy(drv->nl_handle);
+
 	free(drv);
 }
 
--- hostap.orig/hostapd/defconfig	2007-08-13 13:33:22.000000000 +0200
+++ hostap/hostapd/defconfig	2007-08-13 14:01:47.000000000 +0200
@@ -30,6 +30,11 @@ CONFIG_DRIVER_HOSTAP=y
 # wireless-dev.git tree).
 #WIRELESS_DEV=/usr/src/wireless-dev
 #CFLAGS += -I$(WIRELESS_DEV)/net/mac80211
+# driver_devicescape.c requires a rather new libnl, probably not
+# shipped with your distribution yet
+#LIBNL=/usr/src/libnl
+#CFLAGS += -I$(LIBNL)/include
+#LIBS += -L$(LIBNL)/lib
 
 # Driver interface for FreeBSD net80211 layer (e.g., Atheros driver)
 #CONFIG_DRIVER_BSD=y
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ hostap/hostapd/radiotap.c	2007-08-13 14:01:47.000000000 +0200
@@ -0,0 +1,281 @@
+/*
+ * Radiotap parser
+ *
+ * Copyright 2007		Andy Green <andy@warmcat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Alternatively, this software may be distributed under the terms of BSD
+ * license.
+ *
+ * See README and COPYING for more details.
+ *
+ *
+ * Modified for userspace by Johannes Berg <johannes@sipsolutions.net>
+ * I only modified some things on top to ease syncing should bugs be found.
+ */
+
+#include <stdint.h>
+#include <stddef.h>
+#include <errno.h>
+#include "common.h"
+#include "radiotap_iter.h"
+
+#define le16_to_cpu		le_to_host16
+#define le32_to_cpu		le_to_host32
+#define get_unaligned(x)	(*(x))
+#define u8			uint8_t
+#define __le32			uint32_t
+#define u32			uint32_t
+#define ulong			unsigned long
+#define unlikely(cond)		(cond)
+
+/* function prototypes and related defs are in radiotap_iter.h */
+
+/**
+ * ieee80211_radiotap_iterator_init - radiotap parser iterator initialization
+ * @iterator: radiotap_iterator to initialize
+ * @radiotap_header: radiotap header to parse
+ * @max_length: total length we can parse into (eg, whole packet length)
+ *
+ * Returns: 0 or a negative error code if there is a problem.
+ *
+ * This function initializes an opaque iterator struct which can then
+ * be passed to ieee80211_radiotap_iterator_next() to visit every radiotap
+ * argument which is present in the header.  It knows about extended
+ * present headers and handles them.
+ *
+ * How to use:
+ * call __ieee80211_radiotap_iterator_init() to init a semi-opaque iterator
+ * struct ieee80211_radiotap_iterator (no need to init the struct beforehand)
+ * checking for a good 0 return code.  Then loop calling
+ * __ieee80211_radiotap_iterator_next()... it returns either 0,
+ * -ENOENT if there are no more args to parse, or -EINVAL if there is a problem.
+ * The iterator's @this_arg member points to the start of the argument
+ * associated with the current argument index that is present, which can be
+ * found in the iterator's @this_arg_index member.  This arg index corresponds
+ * to the IEEE80211_RADIOTAP_... defines.
+ *
+ * Radiotap header length:
+ * You can find the CPU-endian total radiotap header length in
+ * iterator->max_length after executing ieee80211_radiotap_iterator_init()
+ * successfully.
+ *
+ * Alignment Gotcha:
+ * You must take care when dereferencing iterator.this_arg
+ * for multibyte types... the pointer is not aligned.  Use
+ * get_unaligned((type *)iterator.this_arg) to dereference
+ * iterator.this_arg for type "type" safely on all arches.
+ *
+ * Example code:
+ * See Documentation/networking/radiotap-headers.txt
+ */
+
+int ieee80211_radiotap_iterator_init(
+    struct ieee80211_radiotap_iterator *iterator,
+    struct ieee80211_radiotap_header *radiotap_header,
+    int max_length)
+{
+	/* Linux only supports version 0 radiotap format */
+	if (radiotap_header->it_version)
+		return -EINVAL;
+
+	/* sanity check for allowed length and radiotap length field */
+	if (max_length < le16_to_cpu(get_unaligned(&radiotap_header->it_len)))
+		return -EINVAL;
+
+	iterator->rtheader = radiotap_header;
+	iterator->max_length = le16_to_cpu(get_unaligned(
+						&radiotap_header->it_len));
+	iterator->arg_index = 0;
+	iterator->bitmap_shifter = le32_to_cpu(get_unaligned(
+						&radiotap_header->it_present));
+	iterator->arg = (u8 *)radiotap_header + sizeof(*radiotap_header);
+	iterator->this_arg = NULL;
+
+	/* find payload start allowing for extended bitmap(s) */
+
+	if (unlikely(iterator->bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT))) {
+		while (le32_to_cpu(get_unaligned((__le32 *)iterator->arg)) &
+				   (1<<IEEE80211_RADIOTAP_EXT)) {
+			iterator->arg += sizeof(u32);
+
+			/*
+			 * check for insanity where the present bitmaps
+			 * keep claiming to extend up to or even beyond the
+			 * stated radiotap header length
+			 */
+
+			if (((ulong)iterator->arg -
+			     (ulong)iterator->rtheader) > iterator->max_length)
+				return -EINVAL;
+		}
+
+		iterator->arg += sizeof(u32);
+
+		/*
+		 * no need to check again for blowing past stated radiotap
+		 * header length, because ieee80211_radiotap_iterator_next
+		 * checks it before it is dereferenced
+		 */
+	}
+
+	/* we are all initialized happily */
+
+	return 0;
+}
+
+
+/**
+ * ieee80211_radiotap_iterator_next - return next radiotap parser iterator arg
+ * @iterator: radiotap_iterator to move to next arg (if any)
+ *
+ * Returns: 0 if there is an argument to handle,
+ * -ENOENT if there are no more args or -EINVAL
+ * if there is something else wrong.
+ *
+ * This function provides the next radiotap arg index (IEEE80211_RADIOTAP_*)
+ * in @this_arg_index and sets @this_arg to point to the
+ * payload for the field.  It takes care of alignment handling and extended
+ * present fields.  @this_arg can be changed by the caller (eg,
+ * incremented to move inside a compound argument like
+ * IEEE80211_RADIOTAP_CHANNEL).  The args pointed to are in
+ * little-endian format whatever the endianess of your CPU.
+ *
+ * Alignment Gotcha:
+ * You must take care when dereferencing iterator.this_arg
+ * for multibyte types... the pointer is not aligned.  Use
+ * get_unaligned((type *)iterator.this_arg) to dereference
+ * iterator.this_arg for type "type" safely on all arches.
+ */
+
+int ieee80211_radiotap_iterator_next(
+    struct ieee80211_radiotap_iterator *iterator)
+{
+
+	/*
+	 * small length lookup table for all radiotap types we heard of
+	 * starting from b0 in the bitmap, so we can walk the payload
+	 * area of the radiotap header
+	 *
+	 * There is a requirement to pad args, so that args
+	 * of a given length must begin at a boundary of that length
+	 * -- but note that compound args are allowed (eg, 2 x u16
+	 * for IEEE80211_RADIOTAP_CHANNEL) so total arg length is not
+	 * a reliable indicator of alignment requirement.
+	 *
+	 * upper nybble: content alignment for arg
+	 * lower nybble: content length for arg
+	 */
+
+	static const u8 rt_sizes[] = {
+		[IEEE80211_RADIOTAP_TSFT] = 0x88,
+		[IEEE80211_RADIOTAP_FLAGS] = 0x11,
+		[IEEE80211_RADIOTAP_RATE] = 0x11,
+		[IEEE80211_RADIOTAP_CHANNEL] = 0x24,
+		[IEEE80211_RADIOTAP_FHSS] = 0x22,
+		[IEEE80211_RADIOTAP_DBM_ANTSIGNAL] = 0x11,
+		[IEEE80211_RADIOTAP_DBM_ANTNOISE] = 0x11,
+		[IEEE80211_RADIOTAP_LOCK_QUALITY] = 0x22,
+		[IEEE80211_RADIOTAP_TX_ATTENUATION] = 0x22,
+		[IEEE80211_RADIOTAP_DB_TX_ATTENUATION] = 0x22,
+		[IEEE80211_RADIOTAP_DBM_TX_POWER] = 0x11,
+		[IEEE80211_RADIOTAP_ANTENNA] = 0x11,
+		[IEEE80211_RADIOTAP_DB_ANTSIGNAL] = 0x11,
+		[IEEE80211_RADIOTAP_DB_ANTNOISE] = 0x11,
+		[IEEE80211_RADIOTAP_TX_FLAGS] = 0x22,
+		[IEEE80211_RADIOTAP_DATA_RETRIES] = 0x11,
+		/*
+		 * add more here as they are defined in
+		 * include/net/ieee80211_radiotap.h
+		 */
+	};
+
+	/*
+	 * for every radiotap entry we can at
+	 * least skip (by knowing the length)...
+	 */
+
+	while (iterator->arg_index < sizeof(rt_sizes)) {
+		int hit = 0;
+		int pad;
+
+		if (!(iterator->bitmap_shifter & 1))
+			goto next_entry; /* arg not present */
+
+		/*
+		 * arg is present, account for alignment padding
+		 *  8-bit args can be at any alignment
+		 * 16-bit args must start on 16-bit boundary
+		 * 32-bit args must start on 32-bit boundary
+		 * 64-bit args must start on 64-bit boundary
+		 *
+		 * note that total arg size can differ from alignment of
+		 * elements inside arg, so we use upper nybble of length
+		 * table to base alignment on
+		 *
+		 * also note: these alignments are ** relative to the
+		 * start of the radiotap header **.  There is no guarantee
+		 * that the radiotap header itself is aligned on any
+		 * kind of boundary.
+		 *
+		 * the above is why get_unaligned() is used to dereference
+		 * multibyte elements from the radiotap area
+		 */
+
+		pad = (((ulong)iterator->arg) -
+			((ulong)iterator->rtheader)) &
+			((rt_sizes[iterator->arg_index] >> 4) - 1);
+
+		if (pad)
+			iterator->arg +=
+				(rt_sizes[iterator->arg_index] >> 4) - pad;
+
+		/*
+		 * this is what we will return to user, but we need to
+		 * move on first so next call has something fresh to test
+		 */
+		iterator->this_arg_index = iterator->arg_index;
+		iterator->this_arg = iterator->arg;
+		hit = 1;
+
+		/* internally move on the size of this arg */
+		iterator->arg += rt_sizes[iterator->arg_index] & 0x0f;
+
+		/*
+		 * check for insanity where we are given a bitmap that
+		 * claims to have more arg content than the length of the
+		 * radiotap section.  We will normally end up equalling this
+		 * max_length on the last arg, never exceeding it.
+		 */
+
+		if (((ulong)iterator->arg - (ulong)iterator->rtheader) >
+		    iterator->max_length)
+			return -EINVAL;
+
+	next_entry:
+		iterator->arg_index++;
+		if (unlikely((iterator->arg_index & 31) == 0)) {
+			/* completed current u32 bitmap */
+			if (iterator->bitmap_shifter & 1) {
+				/* b31 was set, there is more */
+				/* move to next u32 bitmap */
+				iterator->bitmap_shifter = le32_to_cpu(
+					get_unaligned(iterator->next_bitmap));
+				iterator->next_bitmap++;
+			} else
+				/* no more bitmaps: end */
+				iterator->arg_index = sizeof(rt_sizes);
+		} else /* just try the next bit */
+			iterator->bitmap_shifter >>= 1;
+
+		/* if we found a valid arg earlier, return it now */
+		if (hit)
+			return 0;
+	}
+
+	/* we don't know how to handle any more args, we're done */
+	return -ENOENT;
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ hostap/hostapd/radiotap.h	2007-08-13 14:01:47.000000000 +0200
@@ -0,0 +1,242 @@
+/* $FreeBSD: src/sys/net80211/ieee80211_radiotap.h,v 1.5 2005/01/22 20:12:05 sam Exp $ */
+/* $NetBSD: ieee80211_radiotap.h,v 1.11 2005/06/22 06:16:02 dyoung Exp $ */
+
+/*-
+ * Copyright (c) 2003, 2004 David Young.  All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of David Young may not be used to endorse or promote
+ *    products derived from this software without specific prior
+ *    written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY DAVID YOUNG ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
+ * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
+ * PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL DAVID
+ * YOUNG BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+ * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
+ * OF SUCH DAMAGE.
+ */
+
+/*
+ * Modifications to fit into the linux IEEE 802.11 stack,
+ * Mike Kershaw (dragorn@kismetwireless.net)
+ */
+
+#ifndef IEEE80211RADIOTAP_H
+#define IEEE80211RADIOTAP_H
+
+#include <stdint.h>
+
+/* Base version of the radiotap packet header data */
+#define PKTHDR_RADIOTAP_VERSION		0
+
+/* A generic radio capture format is desirable. There is one for
+ * Linux, but it is neither rigidly defined (there were not even
+ * units given for some fields) nor easily extensible.
+ *
+ * I suggest the following extensible radio capture format. It is
+ * based on a bitmap indicating which fields are present.
+ *
+ * I am trying to describe precisely what the application programmer
+ * should expect in the following, and for that reason I tell the
+ * units and origin of each measurement (where it applies), or else I
+ * use sufficiently weaselly language ("is a monotonically nondecreasing
+ * function of...") that I cannot set false expectations for lawyerly
+ * readers.
+ */
+
+/* The radio capture header precedes the 802.11 header.
+ * All data in the header is little endian on all platforms.
+ */
+struct ieee80211_radiotap_header {
+	uint8_t it_version;	/* Version 0. Only increases
+				 * for drastic changes,
+				 * introduction of compatible
+				 * new fields does not count.
+				 */
+	uint8_t it_pad;
+	uint16_t it_len;	/* length of the whole
+				 * header in bytes, including
+				 * it_version, it_pad,
+				 * it_len, and data fields.
+				 */
+	uint32_t it_present;	/* A bitmap telling which
+				 * fields are present. Set bit 31
+				 * (0x80000000) to extend the
+				 * bitmap by another 32 bits.
+				 * Additional extensions are made
+				 * by setting bit 31.
+				 */
+};
+
+/* Name                                 Data type    Units
+ * ----                                 ---------    -----
+ *
+ * IEEE80211_RADIOTAP_TSFT              __le64       microseconds
+ *
+ *      Value in microseconds of the MAC's 64-bit 802.11 Time
+ *      Synchronization Function timer when the first bit of the
+ *      MPDU arrived at the MAC. For received frames, only.
+ *
+ * IEEE80211_RADIOTAP_CHANNEL           2 x uint16_t   MHz, bitmap
+ *
+ *      Tx/Rx frequency in MHz, followed by flags (see below).
+ *
+ * IEEE80211_RADIOTAP_FHSS              uint16_t       see below
+ *
+ *      For frequency-hopping radios, the hop set (first byte)
+ *      and pattern (second byte).
+ *
+ * IEEE80211_RADIOTAP_RATE              u8           500kb/s
+ *
+ *      Tx/Rx data rate
+ *
+ * IEEE80211_RADIOTAP_DBM_ANTSIGNAL     s8           decibels from
+ *                                                   one milliwatt (dBm)
+ *
+ *      RF signal power at the antenna, decibel difference from
+ *      one milliwatt.
+ *
+ * IEEE80211_RADIOTAP_DBM_ANTNOISE      s8           decibels from
+ *                                                   one milliwatt (dBm)
+ *
+ *      RF noise power at the antenna, decibel difference from one
+ *      milliwatt.
+ *
+ * IEEE80211_RADIOTAP_DB_ANTSIGNAL      u8           decibel (dB)
+ *
+ *      RF signal power at the antenna, decibel difference from an
+ *      arbitrary, fixed reference.
+ *
+ * IEEE80211_RADIOTAP_DB_ANTNOISE       u8           decibel (dB)
+ *
+ *      RF noise power at the antenna, decibel difference from an
+ *      arbitrary, fixed reference point.
+ *
+ * IEEE80211_RADIOTAP_LOCK_QUALITY      uint16_t       unitless
+ *
+ *      Quality of Barker code lock. Unitless. Monotonically
+ *      nondecreasing with "better" lock strength. Called "Signal
+ *      Quality" in datasheets.  (Is there a standard way to measure
+ *      this?)
+ *
+ * IEEE80211_RADIOTAP_TX_ATTENUATION    uint16_t       unitless
+ *
+ *      Transmit power expressed as unitless distance from max
+ *      power set at factory calibration.  0 is max power.
+ *      Monotonically nondecreasing with lower power levels.
+ *
+ * IEEE80211_RADIOTAP_DB_TX_ATTENUATION uint16_t       decibels (dB)
+ *
+ *      Transmit power expressed as decibel distance from max power
+ *      set at factory calibration.  0 is max power.  Monotonically
+ *      nondecreasing with lower power levels.
+ *
+ * IEEE80211_RADIOTAP_DBM_TX_POWER      s8           decibels from
+ *                                                   one milliwatt (dBm)
+ *
+ *      Transmit power expressed as dBm (decibels from a 1 milliwatt
+ *      reference). This is the absolute power level measured at
+ *      the antenna port.
+ *
+ * IEEE80211_RADIOTAP_FLAGS             u8           bitmap
+ *
+ *      Properties of transmitted and received frames. See flags
+ *      defined below.
+ *
+ * IEEE80211_RADIOTAP_ANTENNA           u8           antenna index
+ *
+ *      Unitless indication of the Rx/Tx antenna for this packet.
+ *      The first antenna is antenna 0.
+ *
+ * IEEE80211_RADIOTAP_RX_FLAGS          uint16_t       bitmap
+ *
+ *     Properties of received frames. See flags defined below.
+ *
+ * IEEE80211_RADIOTAP_TX_FLAGS          uint16_t       bitmap
+ *
+ *     Properties of transmitted frames. See flags defined below.
+ *
+ * IEEE80211_RADIOTAP_RTS_RETRIES       u8           data
+ *
+ *     Number of rts retries a transmitted frame used.
+ *
+ * IEEE80211_RADIOTAP_DATA_RETRIES      u8           data
+ *
+ *     Number of unicast retries a transmitted frame used.
+ *
+ */
+enum ieee80211_radiotap_type {
+	IEEE80211_RADIOTAP_TSFT = 0,
+	IEEE80211_RADIOTAP_FLAGS = 1,
+	IEEE80211_RADIOTAP_RATE = 2,
+	IEEE80211_RADIOTAP_CHANNEL = 3,
+	IEEE80211_RADIOTAP_FHSS = 4,
+	IEEE80211_RADIOTAP_DBM_ANTSIGNAL = 5,
+	IEEE80211_RADIOTAP_DBM_ANTNOISE = 6,
+	IEEE80211_RADIOTAP_LOCK_QUALITY = 7,
+	IEEE80211_RADIOTAP_TX_ATTENUATION = 8,
+	IEEE80211_RADIOTAP_DB_TX_ATTENUATION = 9,
+	IEEE80211_RADIOTAP_DBM_TX_POWER = 10,
+	IEEE80211_RADIOTAP_ANTENNA = 11,
+	IEEE80211_RADIOTAP_DB_ANTSIGNAL = 12,
+	IEEE80211_RADIOTAP_DB_ANTNOISE = 13,
+	IEEE80211_RADIOTAP_RX_FLAGS = 14,
+	IEEE80211_RADIOTAP_TX_FLAGS = 15,
+	IEEE80211_RADIOTAP_RTS_RETRIES = 16,
+	IEEE80211_RADIOTAP_DATA_RETRIES = 17,
+	IEEE80211_RADIOTAP_EXT = 31
+};
+
+/* Channel flags. */
+#define	IEEE80211_CHAN_TURBO	0x0010	/* Turbo channel */
+#define	IEEE80211_CHAN_CCK	0x0020	/* CCK channel */
+#define	IEEE80211_CHAN_OFDM	0x0040	/* OFDM channel */
+#define	IEEE80211_CHAN_2GHZ	0x0080	/* 2 GHz spectrum channel. */
+#define	IEEE80211_CHAN_5GHZ	0x0100	/* 5 GHz spectrum channel */
+#define	IEEE80211_CHAN_PASSIVE	0x0200	/* Only passive scan allowed */
+#define	IEEE80211_CHAN_DYN	0x0400	/* Dynamic CCK-OFDM channel */
+#define	IEEE80211_CHAN_GFSK	0x0800	/* GFSK channel (FHSS PHY) */
+
+/* For IEEE80211_RADIOTAP_FLAGS */
+#define	IEEE80211_RADIOTAP_F_CFP	0x01	/* sent/received
+						 * during CFP
+						 */
+#define	IEEE80211_RADIOTAP_F_SHORTPRE	0x02	/* sent/received
+						 * with short
+						 * preamble
+						 */
+#define	IEEE80211_RADIOTAP_F_WEP	0x04	/* sent/received
+						 * with WEP encryption
+						 */
+#define	IEEE80211_RADIOTAP_F_FRAG	0x08	/* sent/received
+						 * with fragmentation
+						 */
+#define	IEEE80211_RADIOTAP_F_FCS	0x10	/* frame includes FCS */
+#define	IEEE80211_RADIOTAP_F_DATAPAD	0x20	/* frame has padding between
+						 * 802.11 header and payload
+						 * (to 32-bit boundary)
+						 */
+/* For IEEE80211_RADIOTAP_RX_FLAGS */
+#define IEEE80211_RADIOTAP_F_RX_BADFCS	0x0001	/* frame failed crc check */
+
+/* For IEEE80211_RADIOTAP_TX_FLAGS */
+#define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001	/* failed due to excessive
+						 * retries */
+#define IEEE80211_RADIOTAP_F_TX_CTS	0x0002	/* used cts 'protection' */
+#define IEEE80211_RADIOTAP_F_TX_RTS	0x0004	/* used rts/cts handshake */
+
+#endif				/* IEEE80211_RADIOTAP_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ hostap/hostapd/radiotap_iter.h	2007-08-13 14:01:47.000000000 +0200
@@ -0,0 +1,41 @@
+#ifndef __RADIOTAP_ITER_H
+#define __RADIOTAP_ITER_H
+
+#include "radiotap.h"
+
+/* Radiotap header iteration
+ *   implemented in radiotap.c
+ */
+/**
+ * struct ieee80211_radiotap_iterator - tracks walk thru present radiotap args
+ * @rtheader: pointer to the radiotap header we are walking through
+ * @max_length: length of radiotap header in cpu byte ordering
+ * @this_arg_index: IEEE80211_RADIOTAP_... index of current arg
+ * @this_arg: pointer to current radiotap arg
+ * @arg_index: internal next argument index
+ * @arg: internal next argument pointer
+ * @next_bitmap: internal pointer to next present u32
+ * @bitmap_shifter: internal shifter for curr u32 bitmap, b0 set == arg present
+ */
+
+struct ieee80211_radiotap_iterator {
+	struct ieee80211_radiotap_header *rtheader;
+	int max_length;
+	int this_arg_index;
+	unsigned char *this_arg;
+
+	int arg_index;
+	unsigned char *arg;
+	uint32_t *next_bitmap;
+	uint32_t bitmap_shifter;
+};
+
+extern int ieee80211_radiotap_iterator_init(
+   struct ieee80211_radiotap_iterator *iterator,
+   struct ieee80211_radiotap_header *radiotap_header,
+   int max_length);
+
+extern int ieee80211_radiotap_iterator_next(
+   struct ieee80211_radiotap_iterator *iterator);
+
+#endif /* __RADIOTAP_ITER_H */
--- hostap.orig/hostapd/ieee802_11.c	2007-08-13 13:33:22.000000000 +0200
+++ hostap/hostapd/ieee802_11.c	2007-08-13 14:01:47.000000000 +0200
@@ -1672,6 +1672,9 @@ void ieee802_11_mgmt_cb(struct hostapd_d
 	case WLAN_FC_STYPE_PROBE_RESP:
 		HOSTAPD_DEBUG(HOSTAPD_DEBUG_MINIMAL, "mgmt::proberesp cb\n");
 		break;
+	case WLAN_FC_STYPE_DEAUTH:
+		/* ignore */
+		break;
 	default:
 		printf("unknown mgmt cb frame subtype %d\n", stype);
 		break;


