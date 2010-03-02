Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:50699 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab0CBWrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 17:47:04 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/4] rndis_wlan: get max_num_pmkids from device
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Mar 2010 00:38:36 +0200
Message-ID: <20100302223836.2794.49756.stgit@fate.lan>
In-Reply-To: <20100302223825.2794.13615.stgit@fate.lan>
References: <20100302223825.2794.13615.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend rndis_wlan_get_caps() to get 802.11 capabilities and maximum
supported number of PMKIDs by device.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   35 +++++++++++++++++++++++++++++++++--
 1 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 51e6880..4054b70 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -117,6 +117,7 @@ MODULE_PARM_DESC(workaround_interval,
 #define OID_802_11_ADD_KEY			cpu_to_le32(0x0d01011d)
 #define OID_802_11_REMOVE_KEY			cpu_to_le32(0x0d01011e)
 #define OID_802_11_ASSOCIATION_INFORMATION	cpu_to_le32(0x0d01011f)
+#define OID_802_11_CAPABILITY			cpu_to_le32(0x0d010122)
 #define OID_802_11_PMKID			cpu_to_le32(0x0d010123)
 #define OID_802_11_NETWORK_TYPES_SUPPORTED	cpu_to_le32(0x0d010203)
 #define OID_802_11_NETWORK_TYPE_IN_USE		cpu_to_le32(0x0d010204)
@@ -358,6 +359,19 @@ struct ndis_80211_assoc_info {
 	__le32 offset_resp_ies;
 } __attribute__((packed));
 
+struct ndis_80211_auth_encr_pair {
+	__le32 auth_mode;
+	__le32 encr_mode;
+} __attribute__((packed));
+
+struct ndis_80211_capability {
+	__le32 length;
+	__le32 version;
+	__le32 num_pmkids;
+	__le32 num_auth_encr_pair;
+	struct ndis_80211_auth_encr_pair auth_encr_pair[0];
+} __attribute__((packed));
+
 /*
  *  private data
  */
@@ -2498,12 +2512,14 @@ static void rndis_wlan_indication(struct usbnet *usbdev, void *ind, int buflen)
 	}
 }
 
-static int rndis_wlan_get_caps(struct usbnet *usbdev)
+static int rndis_wlan_get_caps(struct usbnet *usbdev, struct wiphy *wiphy)
 {
 	struct {
 		__le32	num_items;
 		__le32	items[8];
 	} networks_supported;
+	struct ndis_80211_capability *caps;
+	u8 caps_buf[sizeof(*caps) + sizeof(caps->auth_encr_pair) * 16];
 	int len, retval, i, n;
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
@@ -2531,6 +2547,21 @@ static int rndis_wlan_get_caps(struct usbnet *usbdev)
 		}
 	}
 
+	/* get device 802.11 capabilities, number of PMKIDs */
+	caps = (struct ndis_80211_capability *)caps_buf;
+	len = sizeof(caps_buf);
+	retval = rndis_query_oid(usbdev, OID_802_11_CAPABILITY, caps, &len);
+	if (retval >= 0) {
+		devdbg(usbdev, "OID_802_11_CAPABILITY -> len %d, ver %d, "
+				"pmkids %d, auth-encr-pairs %d",
+				le32_to_cpu(caps->length),
+				le32_to_cpu(caps->version),
+				le32_to_cpu(caps->num_pmkids),
+				le32_to_cpu(caps->num_auth_encr_pair));
+		wiphy->max_num_pmkids = le32_to_cpu(caps->num_pmkids);
+	} else
+		wiphy->max_num_pmkids = 0;
+
 	return retval;
 }
 
@@ -2778,7 +2809,7 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	wiphy->max_scan_ssids = 1;
 
 	/* TODO: fill-out band/encr information based on priv->caps */
-	rndis_wlan_get_caps(usbdev);
+	rndis_wlan_get_caps(usbdev, wiphy);
 
 	memcpy(priv->channels, rndis_channels, sizeof(rndis_channels));
 	memcpy(priv->rates, rndis_rates, sizeof(rndis_rates));

