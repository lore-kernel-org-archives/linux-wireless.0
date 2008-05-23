Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8130 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757985AbYEWBzH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 21:55:07 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 5/5] hostap: add radiotap support,
	always use it in monitor mode
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>
Date: Thu, 22 May 2008 21:55:05 -0400
Message-ID: <20080523015505.16636.58672.stgit@dv.roinet.com> (sfid-20080523_035512_299872_B5EA383A)
In-Reply-To: <20080523015442.16636.92254.stgit@dv.roinet.com>
References: <20080523015442.16636.92254.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide MAC time, rate, channel, signal and noise.  Remove
"monitor_type" and "getmonitor_type" ioctl.  Never add bogus CRC at the
end, as radiotap aware software would never need it.

Keep support for "no header" for the master and AP devices.  Simplify
hostap_80211_header_parse(), as it's never used on interfaces in monitor
mode.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_80211_rx.c |  126 ++++++++-----------------
 drivers/net/wireless/hostap/hostap_common.h   |    2 
 drivers/net/wireless/hostap/hostap_ioctl.c    |   27 -----
 drivers/net/wireless/hostap/hostap_main.c     |   21 +---
 drivers/net/wireless/hostap/hostap_wlan.h     |   44 ++-------
 5 files changed, 53 insertions(+), 167 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_80211_rx.c b/drivers/net/wireless/hostap/hostap_80211_rx.c
index 47884c3..832579f 100644
--- a/drivers/net/wireless/hostap/hostap_80211_rx.c
+++ b/drivers/net/wireless/hostap/hostap_80211_rx.c
@@ -54,35 +54,22 @@ void hostap_dump_rx_80211(const char *name, struct sk_buff *skb,
 }
 
 
-/* Send RX frame to netif with 802.11 (and possible prism) header.
+/* Send RX frame to netif with 802.11 and possibly radiotap header.
  * Called from hardware or software IRQ context. */
 int prism2_rx_80211(struct net_device *dev, struct sk_buff *skb,
 		    struct hostap_80211_rx_status *rx_stats, int type)
 {
 	struct hostap_interface *iface;
 	local_info_t *local;
-	int hdrlen, phdrlen, head_need, tail_need;
+	int hdrlen, rt_hdrlen;
 	u16 fc;
-	int prism_header, ret;
+	int ret;
 	struct ieee80211_hdr_4addr *hdr;
 
 	iface = netdev_priv(dev);
 	local = iface->local;
 	dev->last_rx = jiffies;
 
-	if (dev->type == ARPHRD_IEEE80211_PRISM) {
-		if (local->monitor_type == PRISM2_MONITOR_PRISM) {
-			prism_header = 1;
-			phdrlen = sizeof(struct linux_wlan_ng_prism_hdr);
-		} else { /* local->monitor_type == PRISM2_MONITOR_CAPHDR */
-			prism_header = 2;
-			phdrlen = sizeof(struct linux_wlan_ng_cap_hdr);
-		}
-	} else {
-		prism_header = 0;
-		phdrlen = 0;
-	}
-
 	hdr = (struct ieee80211_hdr_4addr *) skb->data;
 	fc = le16_to_cpu(hdr->frame_ctl);
 
@@ -95,84 +82,47 @@ int prism2_rx_80211(struct net_device *dev, struct sk_buff *skb,
 
 	hdrlen = hostap_80211_get_hdrlen(fc);
 
-	/* check if there is enough room for extra data; if not, expand skb
-	 * buffer to be large enough for the changes */
-	head_need = phdrlen;
-	tail_need = 0;
-#ifdef PRISM2_ADD_BOGUS_CRC
-	tail_need += 4;
-#endif /* PRISM2_ADD_BOGUS_CRC */
-
-	head_need -= skb_headroom(skb);
-	tail_need -= skb_tailroom(skb);
-
-	if (head_need > 0 || tail_need > 0) {
-		if (pskb_expand_head(skb, head_need > 0 ? head_need : 0,
-				     tail_need > 0 ? tail_need : 0,
-				     GFP_ATOMIC)) {
-			printk(KERN_DEBUG "%s: prism2_rx_80211 failed to "
-			       "reallocate skb buffer\n", dev->name);
-			dev_kfree_skb_any(skb);
-			return 0;
+	if (dev->type == ARPHRD_IEEE80211_RADIOTAP) {
+		int head_need;
+		struct hostap_radiotap_rx *rt_hdr;
+
+		/* if needed, expand skb buffer to accomodate radiotap header */
+		rt_hdrlen = sizeof(struct hostap_radiotap_rx);
+		head_need = rt_hdrlen - skb_headroom(skb);
+
+		if (head_need > 0) {
+			if (pskb_expand_head(skb, head_need, 0, GFP_ATOMIC)) {
+				printk(KERN_DEBUG "%s: prism2_rx_80211 failed "
+				       "to reallocate skb buffer\n", dev->name);
+				dev_kfree_skb_any(skb);
+				return 0;
+			}
 		}
-	}
 
-	/* We now have an skb with enough head and tail room, so just insert
-	 * the extra data */
-
-#ifdef PRISM2_ADD_BOGUS_CRC
-	memset(skb_put(skb, 4), 0xff, 4); /* Prism2 strips CRC */
-#endif /* PRISM2_ADD_BOGUS_CRC */
-
-	if (prism_header == 1) {
-		struct linux_wlan_ng_prism_hdr *hdr;
-		hdr = (struct linux_wlan_ng_prism_hdr *)
-			skb_push(skb, phdrlen);
-		memset(hdr, 0, phdrlen);
-		hdr->msgcode = LWNG_CAP_DID_BASE;
-		hdr->msglen = sizeof(*hdr);
-		memcpy(hdr->devname, dev->name, sizeof(hdr->devname));
-#define LWNG_SETVAL(f,i,s,l,d) \
-hdr->f.did = LWNG_CAP_DID_BASE | (i << 12); \
-hdr->f.status = s; hdr->f.len = l; hdr->f.data = d
-		LWNG_SETVAL(hosttime, 1, 0, 4, jiffies);
-		LWNG_SETVAL(mactime, 2, 0, 4, rx_stats->mac_time);
-		LWNG_SETVAL(channel, 3, 1 /* no value */, 4, 0);
-		LWNG_SETVAL(rssi, 4, 1 /* no value */, 4, 0);
-		LWNG_SETVAL(sq, 5, 1 /* no value */, 4, 0);
-		LWNG_SETVAL(signal, 6, 0, 4, rx_stats->signal);
-		LWNG_SETVAL(noise, 7, 0, 4, rx_stats->noise);
-		LWNG_SETVAL(rate, 8, 0, 4, rx_stats->rate / 5);
-		LWNG_SETVAL(istx, 9, 0, 4, 0);
-		LWNG_SETVAL(frmlen, 10, 0, 4, skb->len - phdrlen);
-#undef LWNG_SETVAL
-	} else if (prism_header == 2) {
-		struct linux_wlan_ng_cap_hdr *hdr;
-		hdr = (struct linux_wlan_ng_cap_hdr *)
-			skb_push(skb, phdrlen);
-		memset(hdr, 0, phdrlen);
-		hdr->version    = htonl(LWNG_CAPHDR_VERSION);
-		hdr->length     = htonl(phdrlen);
-		hdr->mactime    = __cpu_to_be64(rx_stats->mac_time);
-		hdr->hosttime   = __cpu_to_be64(jiffies);
-		hdr->phytype    = htonl(4); /* dss_dot11_b */
-		hdr->channel    = htonl(local->channel);
-		hdr->datarate   = htonl(rx_stats->rate);
-		hdr->antenna    = htonl(0); /* unknown */
-		hdr->priority   = htonl(0); /* unknown */
-		hdr->ssi_type   = htonl(3); /* raw */
-		hdr->ssi_signal = htonl(rx_stats->signal);
-		hdr->ssi_noise  = htonl(rx_stats->noise);
-		hdr->preamble   = htonl(0); /* unknown */
-		hdr->encoding   = htonl(1); /* cck */
+		rt_hdr = (struct hostap_radiotap_rx *)skb_push(skb, rt_hdrlen);
+		memset(rt_hdr, 0, rt_hdrlen);
+		rt_hdr->hdr.it_len = cpu_to_le16(rt_hdrlen);
+		rt_hdr->hdr.it_present =
+			cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
+				    (1 << IEEE80211_RADIOTAP_CHANNEL) |
+				    (1 << IEEE80211_RADIOTAP_RATE) |
+				    (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
+				    (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE));
+		rt_hdr->tsft = cpu_to_le64(rx_stats->mac_time);
+		rt_hdr->chan_freq = cpu_to_le16(freq_list[local->channel - 1]);
+		rt_hdr->chan_flags = cpu_to_le16(IEEE80211_CHAN_CCK |
+						    IEEE80211_CHAN_2GHZ);
+		rt_hdr->rate = rx_stats->rate / 5;
+		rt_hdr->dbm_antsignal = rx_stats->signal;
+		rt_hdr->dbm_antnoise = rx_stats->noise;
+	} else {
+		rt_hdrlen = 0;
 	}
 
-	ret = skb->len - phdrlen;
+	ret = skb->len - rt_hdrlen;
 	skb->dev = dev;
 	skb_reset_mac_header(skb);
-	skb_pull(skb, hdrlen);
-	if (prism_header)
-		skb_pull(skb, phdrlen);
+	skb_pull(skb, rt_hdrlen + hdrlen);
 	skb->pkt_type = PACKET_OTHERHOST;
 	skb->protocol = __constant_htons(ETH_P_802_2);
 	memset(skb->cb, 0, sizeof(skb->cb));
diff --git a/drivers/net/wireless/hostap/hostap_common.h b/drivers/net/wireless/hostap/hostap_common.h
index 2f92ecd..ba6725f 100644
--- a/drivers/net/wireless/hostap/hostap_common.h
+++ b/drivers/net/wireless/hostap/hostap_common.h
@@ -283,7 +283,7 @@ enum {
 	PRISM2_PARAM_IEEE_802_1X = 23,
 	PRISM2_PARAM_ANTSEL_TX = 24,
 	PRISM2_PARAM_ANTSEL_RX = 25,
-	PRISM2_PARAM_MONITOR_TYPE = 26,
+	/* PRISM2_PARAM_MONITOR_TYPE = 26, */
 	PRISM2_PARAM_WDS_TYPE = 27,
 	PRISM2_PARAM_HOSTSCAN = 28,
 	PRISM2_PARAM_AP_SCAN = 29,
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 7dc8392..5386831 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -894,12 +894,7 @@ static void hostap_monitor_set_type(local_info_t *local)
 	if (dev == NULL)
 		return;
 
-	if (local->monitor_type == PRISM2_MONITOR_PRISM ||
-	    local->monitor_type == PRISM2_MONITOR_CAPHDR) {
-		dev->type = ARPHRD_IEEE80211_PRISM;
-	} else {
-		dev->type = ARPHRD_IEEE80211;
-	}
+	dev->type = ARPHRD_IEEE80211_RADIOTAP;
 }
 
 
@@ -2247,10 +2242,6 @@ static const struct iw_priv_args prism2_priv[] = {
 	  IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "antsel_rx" },
 	{ PRISM2_PARAM_ANTSEL_RX,
 	  0, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "getantsel_rx" },
-	{ PRISM2_PARAM_MONITOR_TYPE,
-	  IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "monitor_type" },
-	{ PRISM2_PARAM_MONITOR_TYPE,
-	  0, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "getmonitor_type" },
 	{ PRISM2_PARAM_WDS_TYPE,
 	  IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "wds_type" },
 	{ PRISM2_PARAM_WDS_TYPE,
@@ -2511,18 +2502,6 @@ static int prism2_ioctl_priv_prism2_param(struct net_device *dev,
 		hostap_set_antsel(local);
 		break;
 
-	case PRISM2_PARAM_MONITOR_TYPE:
-		if (value != PRISM2_MONITOR_80211 &&
-		    value != PRISM2_MONITOR_CAPHDR &&
-		    value != PRISM2_MONITOR_PRISM) {
-			ret = -EINVAL;
-			break;
-		}
-		local->monitor_type = value;
-		if (local->iw_mode == IW_MODE_MONITOR)
-			hostap_monitor_set_type(local);
-		break;
-
 	case PRISM2_PARAM_WDS_TYPE:
 		local->wds_type = value;
 		break;
@@ -2789,10 +2768,6 @@ static int prism2_ioctl_priv_get_prism2_param(struct net_device *dev,
 		*param = local->antsel_rx;
 		break;
 
-	case PRISM2_PARAM_MONITOR_TYPE:
-		*param = local->monitor_type;
-		break;
-
 	case PRISM2_PARAM_WDS_TYPE:
 		*param = local->wds_type;
 		break;
diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wireless/hostap/hostap_main.c
index c8f41da..5de6123 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -597,25 +597,10 @@ void hostap_dump_tx_header(const char *name, const struct hfa384x_tx_frame *tx)
 static int hostap_80211_header_parse(const struct sk_buff *skb,
 				     unsigned char *haddr)
 {
-	struct hostap_interface *iface = netdev_priv(skb->dev);
-	local_info_t *local = iface->local;
-
-	if (local->monitor_type == PRISM2_MONITOR_PRISM ||
-	    local->monitor_type == PRISM2_MONITOR_CAPHDR) {
-		const unsigned char *mac = skb_mac_header(skb);
-
-		if (*(u32 *)mac == LWNG_CAP_DID_BASE) {
-			memcpy(haddr,
-			       mac + sizeof(struct linux_wlan_ng_prism_hdr) + 10,
-			       ETH_ALEN); /* addr2 */
-		} else { /* (*(u32 *)mac == htonl(LWNG_CAPHDR_VERSION)) */
-			memcpy(haddr,
-			       mac + sizeof(struct linux_wlan_ng_cap_hdr) + 10,
-			       ETH_ALEN); /* addr2 */
-		}
-	} else
-		memcpy(haddr, skb_mac_header(skb) + 10, ETH_ALEN); /* addr2 */
+	struct ieee80211_hdr_4addr *hdr =
+		(struct ieee80211_hdr_4addr *)skb_mac_header(skb);
 
+	memcpy(haddr, hdr->addr2, ETH_ALEN);
 	return ETH_ALEN;
 }
 
diff --git a/drivers/net/wireless/hostap/hostap_wlan.h b/drivers/net/wireless/hostap/hostap_wlan.h
index 15445bc..6e047cf 100644
--- a/drivers/net/wireless/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/hostap/hostap_wlan.h
@@ -5,6 +5,7 @@
 #include <linux/netdevice.h>
 #include <linux/mutex.h>
 #include <net/iw_handler.h>
+#include <net/ieee80211_radiotap.h>
 
 #include "hostap_config.h"
 #include "hostap_common.h"
@@ -23,36 +24,15 @@
  * prism2_send_mgmt() sends these with dev_queue_xmit() to prism2_tx(). */
 #define ETH_P_HOSTAP ETH_P_CONTROL
 
-/* ARPHRD_IEEE80211_PRISM uses a bloated version of Prism2 RX frame header
- * (from linux-wlan-ng) */
-struct linux_wlan_ng_val {
-	u32 did;
-	u16 status, len;
-	u32 data;
-} __attribute__ ((packed));
-
-struct linux_wlan_ng_prism_hdr {
-	u32 msgcode, msglen;
-	char devname[16];
-	struct linux_wlan_ng_val hosttime, mactime, channel, rssi, sq, signal,
-		noise, rate, istx, frmlen;
-} __attribute__ ((packed));
-
-struct linux_wlan_ng_cap_hdr {
-	__be32 version;
-	__be32 length;
-	__be64 mactime;
-	__be64 hosttime;
-	__be32 phytype;
-	__be32 channel;
-	__be32 datarate;
-	__be32 antenna;
-	__be32 priority;
-	__be32 ssi_type;
-	__be32 ssi_signal;
-	__be32 ssi_noise;
-	__be32 preamble;
-	__be32 encoding;
+struct hostap_radiotap_rx {
+	struct ieee80211_radiotap_header hdr;
+	__le64 tsft;
+	u8 rate;
+	u8 padding;
+	__le16 chan_freq;
+	__le16 chan_flags;
+	s8 dbm_antsignal;
+	s8 dbm_antnoise;
 } __attribute__ ((packed));
 
 #define LWNG_CAP_DID_BASE   (4 | (1 << 6)) /* section 4, group 1 */
@@ -732,10 +712,6 @@ struct local_info {
 
 	struct iw_statistics wstats;
 	unsigned long scan_timestamp; /* Time started to scan */
-	enum {
-		PRISM2_MONITOR_80211 = 0, PRISM2_MONITOR_PRISM = 1,
-		PRISM2_MONITOR_CAPHDR = 2
-	} monitor_type;
 	int monitor_allow_fcserr;
 
 	int hostapd; /* whether user space daemon, hostapd, is used for AP
