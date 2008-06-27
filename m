Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9052 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035AbYF0UUL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 16:20:11 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 4/5] hostap: add radiotap support in monitor mode
To: Jouni Malinen <j@w1.fi>, John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 27 Jun 2008 16:20:10 -0400
Message-ID: <20080627202010.18603.9323.stgit@dv.roinet.com> (sfid-20080627_222015_846133_FBBCB9BA)
In-Reply-To: <20080627201952.18603.98308.stgit@dv.roinet.com>
References: <20080627201952.18603.98308.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide MAC time, rate, channel, signal and noise.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_80211_rx.c |   21 +++++++++++++++++++++
 drivers/net/wireless/hostap/hostap_ioctl.c    |    5 ++++-
 drivers/net/wireless/hostap/hostap_wlan.h     |   14 +++++++++++++-
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_80211_rx.c b/drivers/net/wireless/hostap/hostap_80211_rx.c
index 020f450..f106bc1 100644
--- a/drivers/net/wireless/hostap/hostap_80211_rx.c
+++ b/drivers/net/wireless/hostap/hostap_80211_rx.c
@@ -78,6 +78,9 @@ int prism2_rx_80211(struct net_device *dev, struct sk_buff *skb,
 			prism_header = 2;
 			phdrlen = sizeof(struct linux_wlan_ng_cap_hdr);
 		}
+	} else if (dev->type == ARPHRD_IEEE80211_RADIOTAP) {
+		prism_header = 3;
+		phdrlen = sizeof(struct hostap_radiotap_rx);
 	} else {
 		prism_header = 0;
 		phdrlen = 0;
@@ -165,6 +168,24 @@ hdr->f.status = s; hdr->f.len = l; hdr->f.data = d
 		hdr->ssi_noise  = htonl(rx_stats->noise);
 		hdr->preamble   = htonl(0); /* unknown */
 		hdr->encoding   = htonl(1); /* cck */
+	} else if (prism_header == 3) {
+		struct hostap_radiotap_rx *hdr;
+		hdr = (struct hostap_radiotap_rx *)skb_push(skb, phdrlen);
+		memset(hdr, 0, phdrlen);
+		hdr->hdr.it_len = cpu_to_le16(phdrlen);
+		hdr->hdr.it_present =
+			cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
+				    (1 << IEEE80211_RADIOTAP_CHANNEL) |
+				    (1 << IEEE80211_RADIOTAP_RATE) |
+				    (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
+				    (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE));
+		hdr->tsft = cpu_to_le64(rx_stats->mac_time);
+		hdr->chan_freq = cpu_to_le16(freq_list[local->channel - 1]);
+		hdr->chan_flags = cpu_to_le16(IEEE80211_CHAN_CCK |
+						 IEEE80211_CHAN_2GHZ);
+		hdr->rate = rx_stats->rate / 5;
+		hdr->dbm_antsignal = rx_stats->signal;
+		hdr->dbm_antnoise = rx_stats->noise;
 	}
 
 	ret = skb->len - phdrlen;
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index ed52d98..3f8b1d7 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -897,6 +897,8 @@ static void hostap_monitor_set_type(local_info_t *local)
 	if (local->monitor_type == PRISM2_MONITOR_PRISM ||
 	    local->monitor_type == PRISM2_MONITOR_CAPHDR) {
 		dev->type = ARPHRD_IEEE80211_PRISM;
+	} else if (local->monitor_type == PRISM2_MONITOR_RADIOTAP) {
+		dev->type = ARPHRD_IEEE80211_RADIOTAP;
 	} else {
 		dev->type = ARPHRD_IEEE80211;
 	}
@@ -2520,7 +2522,8 @@ static int prism2_ioctl_priv_prism2_param(struct net_device *dev,
 	case PRISM2_PARAM_MONITOR_TYPE:
 		if (value != PRISM2_MONITOR_80211 &&
 		    value != PRISM2_MONITOR_CAPHDR &&
-		    value != PRISM2_MONITOR_PRISM) {
+		    value != PRISM2_MONITOR_PRISM &&
+		    value != PRISM2_MONITOR_RADIOTAP) {
 			ret = -EINVAL;
 			break;
 		}
diff --git a/drivers/net/wireless/hostap/hostap_wlan.h b/drivers/net/wireless/hostap/hostap_wlan.h
index 15445bc..ffdf487 100644
--- a/drivers/net/wireless/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/hostap/hostap_wlan.h
@@ -5,6 +5,7 @@
 #include <linux/netdevice.h>
 #include <linux/mutex.h>
 #include <net/iw_handler.h>
+#include <net/ieee80211_radiotap.h>
 
 #include "hostap_config.h"
 #include "hostap_common.h"
@@ -55,6 +56,17 @@ struct linux_wlan_ng_cap_hdr {
 	__be32 encoding;
 } __attribute__ ((packed));
 
+struct hostap_radiotap_rx {
+	struct ieee80211_radiotap_header hdr;
+	__le64 tsft;
+	u8 rate;
+	u8 padding;
+	__le16 chan_freq;
+	__le16 chan_flags;
+	s8 dbm_antsignal;
+	s8 dbm_antnoise;
+} __attribute__ ((packed));
+
 #define LWNG_CAP_DID_BASE   (4 | (1 << 6)) /* section 4, group 1 */
 #define LWNG_CAPHDR_VERSION 0x80211001
 
@@ -734,7 +746,7 @@ struct local_info {
 	unsigned long scan_timestamp; /* Time started to scan */
 	enum {
 		PRISM2_MONITOR_80211 = 0, PRISM2_MONITOR_PRISM = 1,
-		PRISM2_MONITOR_CAPHDR = 2
+		PRISM2_MONITOR_CAPHDR = 2, PRISM2_MONITOR_RADIOTAP = 3
 	} monitor_type;
 	int monitor_allow_fcserr;
 
