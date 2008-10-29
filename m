Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbYJ2LuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 07:50:05 -0400
Subject: [PATCH] don't use net/ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 02:25:30 +0100
Message-Id: <1225243531.1369.18.camel@johannes.berg> (sfid-20081029_125021_786122_12E56128)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert all the drivers using net/ieee80211.h to use linux/ieee80211.h.
Contains a bugfix in libertas where the SSID parsing could overrun the
buffer when the AP sends invalid information.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/ps3_gelic_wireless.c           |   17 +++---
 drivers/net/ps3_gelic_wireless.h           |    4 -
 drivers/net/wireless/airo.c                |   50 +++++++++---------
 drivers/net/wireless/atmel.c               |   70 +++++++++++++-------------
 drivers/net/wireless/libertas/assoc.c      |   18 +++---
 drivers/net/wireless/libertas/cmd.c        |    5 -
 drivers/net/wireless/libertas/dev.h        |    7 ++
 drivers/net/wireless/libertas/main.c       |    3 -
 drivers/net/wireless/libertas/persistcfg.c |    2 
 drivers/net/wireless/libertas/scan.c       |   77 ++++++++++++++---------------
 drivers/net/wireless/libertas/scan.h       |    4 +
 drivers/net/wireless/libertas/types.h      |    5 -
 drivers/net/wireless/libertas/wext.c       |    1 
 drivers/net/wireless/orinoco.c             |   31 ++++++-----
 drivers/net/wireless/rndis_wlan.c          |   24 ++++-----
 drivers/net/wireless/wl3501.h              |    4 -
 drivers/net/wireless/zd1201.c              |    4 -
 17 files changed, 167 insertions(+), 159 deletions(-)

--- everything.orig/drivers/net/ps3_gelic_wireless.c	2008-10-29 01:19:06.000000000 +0100
+++ everything/drivers/net/ps3_gelic_wireless.c	2008-10-29 02:19:32.000000000 +0100
@@ -30,10 +30,11 @@
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/wireless.h>
+#include <linux/ieee80211.h>
+#include <linux/if_arp.h>
 #include <linux/ctype.h>
 #include <linux/string.h>
 #include <net/iw_handler.h>
-#include <net/ieee80211.h>
 
 #include <linux/dma-mapping.h>
 #include <net/checksum.h>
@@ -449,9 +450,9 @@ static size_t gelic_wl_synthesize_ie(u8 
 
 	/* element id */
 	if (rsn)
-		*buf++ = MFIE_TYPE_RSN;
+		*buf++ = WLAN_EID_RSN;
 	else
-		*buf++ = MFIE_TYPE_GENERIC;
+		*buf++ = WLAN_EID_GENERIC;
 
 	/* length filed; set later */
 	buf++;
@@ -539,7 +540,7 @@ static void gelic_wl_parse_ie(u8 *data, 
 			break;
 
 		switch (item_id) {
-		case MFIE_TYPE_GENERIC:
+		case WLAN_EID_GENERIC:
 			if ((OUI_LEN + 1 <= item_len) &&
 			    !memcmp(pos, wpa_oui, OUI_LEN) &&
 			    pos[OUI_LEN] == 0x01) {
@@ -547,7 +548,7 @@ static void gelic_wl_parse_ie(u8 *data, 
 				ie_info->wpa.len = item_len + 2;
 			}
 			break;
-		case MFIE_TYPE_RSN:
+		case WLAN_EID_RSN:
 			ie_info->rsn.data = pos - 2;
 			/* length includes the header */
 			ie_info->rsn.len = item_len + 2;
@@ -581,7 +582,7 @@ static char *gelic_wl_translate_scan(str
 	char *tmp;
 	u8 rate;
 	unsigned int i, j, len;
-	u8 buf[MAX_WPA_IE_LEN];
+	u8 buf[64]; /* arbitrary size large enough */
 
 	pr_debug("%s: <-\n", __func__);
 
@@ -1741,14 +1742,14 @@ static void gelic_wl_scan_complete_event
 		target->essid_len = strnlen(scan_info->essid,
 					    sizeof(scan_info->essid));
 		target->rate_len = 0;
-		for (r = 0; r < MAX_RATES_LENGTH; r++)
+		for (r = 0; r < 12; r++)
 			if (scan_info->rate[r])
 				target->rate_len++;
 		if (8 < target->rate_len)
 			pr_info("%s: AP returns %d rates\n", __func__,
 				target->rate_len);
 		target->rate_ext_len = 0;
-		for (r = 0; r < MAX_RATES_EX_LENGTH; r++)
+		for (r = 0; r < 16; r++)
 			if (scan_info->ext_rate[r])
 				target->rate_ext_len++;
 		list_move_tail(&target->list, &wl->network_list);
--- everything.orig/drivers/net/wireless/airo.c	2008-10-29 01:21:20.000000000 +0100
+++ everything/drivers/net/wireless/airo.c	2008-10-29 01:56:01.000000000 +0100
@@ -47,10 +47,11 @@
 #include <linux/ioport.h>
 #include <linux/pci.h>
 #include <asm/uaccess.h>
-#include <net/ieee80211.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
+#include <linux/ieee80211.h>
+
 #include "airo.h"
 
 #define DRV_NAME "airo"
@@ -7275,56 +7276,53 @@ static inline char *airo_translate_scan(
 	if (test_bit(FLAG_WPA_CAPABLE, &ai->flags)) {
 		unsigned int num_null_ies = 0;
 		u16 length = sizeof (bss->extra.iep);
-		struct ieee80211_info_element *info_element =
-			(struct ieee80211_info_element *) &bss->extra.iep;
+		u8 *ie = (void *)&bss->extra.iep;
 
-		while ((length >= sizeof(*info_element)) && (num_null_ies < 2)) {
-			if (sizeof(*info_element) + info_element->len > length) {
+		while ((length >= 2) && (num_null_ies < 2)) {
+			if (2 + ie[1] > length) {
 				/* Invalid element, don't continue parsing IE */
 				break;
 			}
 
-			switch (info_element->id) {
-			case MFIE_TYPE_SSID:
+			switch (ie[0]) {
+			case WLAN_EID_SSID:
 				/* Two zero-length SSID elements
 				 * mean we're done parsing elements */
-				if (!info_element->len)
+				if (!ie[1])
 					num_null_ies++;
 				break;
 
-			case MFIE_TYPE_GENERIC:
-				if (info_element->len >= 4 &&
-				    info_element->data[0] == 0x00 &&
-				    info_element->data[1] == 0x50 &&
-				    info_element->data[2] == 0xf2 &&
-				    info_element->data[3] == 0x01) {
+			case WLAN_EID_GENERIC:
+				if (ie[1] >= 4 &&
+				    ie[2] == 0x00 &&
+				    ie[3] == 0x50 &&
+				    ie[4] == 0xf2 &&
+				    ie[5] == 0x01) {
 					iwe.cmd = IWEVGENIE;
-					iwe.u.data.length = min(info_element->len + 2,
-								  MAX_WPA_IE_LEN);
+					/* 64 is an arbitrary cut-off */
+					iwe.u.data.length = min(ie[1] + 2,
+								64);
 					current_ev = iwe_stream_add_point(
 							info, current_ev,
-							end_buf, &iwe,
-							(char *) info_element);
+							end_buf, &iwe, ie);
 				}
 				break;
 
-			case MFIE_TYPE_RSN:
+			case WLAN_EID_RSN:
 				iwe.cmd = IWEVGENIE;
-				iwe.u.data.length = min(info_element->len + 2,
-							  MAX_WPA_IE_LEN);
+				/* 64 is an arbitrary cut-off */
+				iwe.u.data.length = min(ie[1] + 2, 64);
 				current_ev = iwe_stream_add_point(
 					info, current_ev, end_buf,
-					&iwe, (char *) info_element);
+					&iwe, ie);
 				break;
 
 			default:
 				break;
 			}
 
-			length -= sizeof(*info_element) + info_element->len;
-			info_element =
-			    (struct ieee80211_info_element *)&info_element->
-			    data[info_element->len];
+			length -= 2 + ie[1];
+			ie += 2 + ie[1];
 		}
 	}
 	return current_ev;
--- everything.orig/drivers/net/wireless/atmel.c	2008-10-29 01:21:21.000000000 +0100
+++ everything/drivers/net/wireless/atmel.c	2008-10-29 02:01:41.000000000 +0100
@@ -67,7 +67,7 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/jiffies.h>
-#include <net/ieee80211.h>
+#include <linux/ieee80211.h>
 #include "atmel.h"
 
 #define DRIVER_MAJOR 0
@@ -569,7 +569,7 @@ static void atmel_wmem32(struct atmel_pr
 static void atmel_command_irq(struct atmel_private *priv);
 static int atmel_validate_channel(struct atmel_private *priv, int channel);
 static void atmel_management_frame(struct atmel_private *priv,
-				   struct ieee80211_hdr_4addr *header,
+				   struct ieee80211_hdr *header,
 				   u16 frame_len, u8 rssi);
 static void atmel_management_timer(u_long a);
 static void atmel_send_command(struct atmel_private *priv, int command,
@@ -577,7 +577,7 @@ static void atmel_send_command(struct at
 static int atmel_send_command_wait(struct atmel_private *priv, int command,
 				   void *cmd, int cmd_size);
 static void atmel_transmit_management_frame(struct atmel_private *priv,
-					    struct ieee80211_hdr_4addr *header,
+					    struct ieee80211_hdr *header,
 					    u8 *body, int body_len);
 
 static u8 atmel_get_mib8(struct atmel_private *priv, u8 type, u8 index);
@@ -785,7 +785,7 @@ static int start_tx(struct sk_buff *skb,
 {
 	static const u8 SNAP_RFC1024[6] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 	struct atmel_private *priv = netdev_priv(dev);
-	struct ieee80211_hdr_4addr header;
+	struct ieee80211_hdr header;
 	unsigned long flags;
 	u16 buff, frame_ctl, len = (ETH_ZLEN < skb->len) ? skb->len : ETH_ZLEN;
 
@@ -823,7 +823,7 @@ static int start_tx(struct sk_buff *skb,
 
 	frame_ctl = IEEE80211_FTYPE_DATA;
 	header.duration_id = 0;
-	header.seq_ctl = 0;
+	header.seq_ctrl = 0;
 	if (priv->wep_is_on)
 		frame_ctl |= IEEE80211_FCTL_PROTECTED;
 	if (priv->operating_mode == IW_MODE_ADHOC) {
@@ -840,7 +840,7 @@ static int start_tx(struct sk_buff *skb,
 	if (priv->use_wpa)
 		memcpy(&header.addr4, SNAP_RFC1024, 6);
 
-	header.frame_ctl = cpu_to_le16(frame_ctl);
+	header.frame_control = cpu_to_le16(frame_ctl);
 	/* Copy the wireless header into the card */
 	atmel_copy_to_card(dev, buff, (unsigned char *)&header, DATA_FRAME_WS_HEADER_SIZE);
 	/* Copy the packet sans its 802.3 header addresses which have been replaced */
@@ -860,7 +860,7 @@ static int start_tx(struct sk_buff *skb,
 }
 
 static void atmel_transmit_management_frame(struct atmel_private *priv,
-					    struct ieee80211_hdr_4addr *header,
+					    struct ieee80211_hdr *header,
 					    u8 *body, int body_len)
 {
 	u16 buff;
@@ -876,7 +876,7 @@ static void atmel_transmit_management_fr
 }
 
 static void fast_rx_path(struct atmel_private *priv,
-			 struct ieee80211_hdr_4addr *header,
+			 struct ieee80211_hdr *header,
 			 u16 msdu_size, u16 rx_packet_loc, u32 crc)
 {
 	/* fast path: unfragmented packet copy directly into skbuf */
@@ -914,7 +914,7 @@ static void fast_rx_path(struct atmel_pr
 	}
 
 	memcpy(skbp, header->addr1, 6); /* destination address */
-	if (le16_to_cpu(header->frame_ctl) & IEEE80211_FCTL_FROMDS)
+	if (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FROMDS)
 		memcpy(&skbp[6], header->addr3, 6);
 	else
 		memcpy(&skbp[6], header->addr2, 6); /* source address */
@@ -950,7 +950,7 @@ static int probe_crc(struct atmel_privat
 }
 
 static void frag_rx_path(struct atmel_private *priv,
-			 struct ieee80211_hdr_4addr *header,
+			 struct ieee80211_hdr *header,
 			 u16 msdu_size, u16 rx_packet_loc, u32 crc, u16 seq_no,
 			 u8 frag_no, int more_frags)
 {
@@ -958,7 +958,7 @@ static void frag_rx_path(struct atmel_pr
 	u8 source[6];
 	struct sk_buff *skb;
 
-	if (le16_to_cpu(header->frame_ctl) & IEEE80211_FCTL_FROMDS)
+	if (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FROMDS)
 		memcpy(source, header->addr3, 6);
 	else
 		memcpy(source, header->addr2, 6);
@@ -1041,7 +1041,7 @@ static void frag_rx_path(struct atmel_pr
 static void rx_done_irq(struct atmel_private *priv)
 {
 	int i;
-	struct ieee80211_hdr_4addr header;
+	struct ieee80211_hdr header;
 
 	for (i = 0;
 	     atmel_rmem8(priv, atmel_rx(priv, RX_DESC_FLAGS_OFFSET, priv->rx_desc_head)) == RX_DESC_FLAG_VALID &&
@@ -1068,10 +1068,10 @@ static void rx_done_irq(struct atmel_pri
 			goto next;
 		}
 
-		/* Get header as far as end of seq_ctl */
+		/* Get header as far as end of seq_ctrl */
 		atmel_copy_to_host(priv->dev, (char *)&header, rx_packet_loc, 24);
-		frame_ctl = le16_to_cpu(header.frame_ctl);
-		seq_control = le16_to_cpu(header.seq_ctl);
+		frame_ctl = le16_to_cpu(header.frame_control);
+		seq_control = le16_to_cpu(header.seq_ctrl);
 
 		/* probe for CRC use here if needed  once five packets have
 		   arrived with the same crc status, we assume we know what's
@@ -1822,7 +1822,7 @@ static int atmel_set_encodeext(struct ne
 	/* Determine and validate the key index */
 	idx = encoding->flags & IW_ENCODE_INDEX;
 	if (idx) {
-		if (idx < 1 || idx > WEP_KEYS)
+		if (idx < 1 || idx > 4)
 			return -EINVAL;
 		idx--;
 	} else
@@ -1885,7 +1885,7 @@ static int atmel_get_encodeext(struct ne
 
 	idx = encoding->flags & IW_ENCODE_INDEX;
 	if (idx) {
-		if (idx < 1 || idx > WEP_KEYS)
+		if (idx < 1 || idx > 4)
 			return -EINVAL;
 		idx--;
 	} else
@@ -2800,7 +2800,7 @@ static void handle_beacon_probe(struct a
 				u8 channel)
 {
 	int rejoin = 0;
-	int new = capability & MFIE_TYPE_POWER_CONSTRAINT ?
+	int new = capability & WLAN_CAPABILITY_SHORT_PREAMBLE ?
 		SHORT_PREAMBLE : LONG_PREAMBLE;
 
 	if (priv->preamble != new) {
@@ -2829,19 +2829,19 @@ static void handle_beacon_probe(struct a
 static void send_authentication_request(struct atmel_private *priv, u16 system,
 					u8 *challenge, int challenge_len)
 {
-	struct ieee80211_hdr_4addr header;
+	struct ieee80211_hdr header;
 	struct auth_body auth;
 
-	header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_AUTH);
+	header.frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_AUTH);
 	header.duration_id = cpu_to_le16(0x8000);
-	header.seq_ctl = 0;
+	header.seq_ctrl = 0;
 	memcpy(header.addr1, priv->CurrentBSSID, 6);
 	memcpy(header.addr2, priv->dev->dev_addr, 6);
 	memcpy(header.addr3, priv->CurrentBSSID, 6);
 
 	if (priv->wep_is_on && priv->CurrentAuthentTransactionSeqNum != 1)
 		/* no WEP for authentication frames with TrSeqNo 1 */
-                header.frame_ctl |=  cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+                header.frame_control |=  cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 
 	auth.alg = cpu_to_le16(system);
 
@@ -2864,7 +2864,7 @@ static void send_association_request(str
 {
 	u8 *ssid_el_p;
 	int bodysize;
-	struct ieee80211_hdr_4addr header;
+	struct ieee80211_hdr header;
 	struct ass_req_format {
 		__le16 capability;
 		__le16 listen_interval;
@@ -2877,10 +2877,10 @@ static void send_association_request(str
 		u8 rates[4];
 	} body;
 
-	header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+	header.frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 		(is_reassoc ? IEEE80211_STYPE_REASSOC_REQ : IEEE80211_STYPE_ASSOC_REQ));
 	header.duration_id = cpu_to_le16(0x8000);
-	header.seq_ctl = 0;
+	header.seq_ctrl = 0;
 
 	memcpy(header.addr1, priv->CurrentBSSID, 6);
 	memcpy(header.addr2, priv->dev->dev_addr, 6);
@@ -2890,7 +2890,7 @@ static void send_association_request(str
 	if (priv->wep_is_on)
 		body.capability |= cpu_to_le16(WLAN_CAPABILITY_PRIVACY);
 	if (priv->preamble == SHORT_PREAMBLE)
-		body.capability |= cpu_to_le16(MFIE_TYPE_POWER_CONSTRAINT);
+		body.capability |= cpu_to_le16(WLAN_CAPABILITY_SHORT_PREAMBLE);
 
 	body.listen_interval = cpu_to_le16(priv->listen_interval * priv->beacon_period);
 
@@ -2904,10 +2904,10 @@ static void send_association_request(str
 		bodysize = 12 + priv->SSID_size;
 	}
 
-	ssid_el_p[0] = MFIE_TYPE_SSID;
+	ssid_el_p[0] = WLAN_EID_SSID;
 	ssid_el_p[1] = priv->SSID_size;
 	memcpy(ssid_el_p + 2, priv->SSID, priv->SSID_size);
-	ssid_el_p[2 + priv->SSID_size] = MFIE_TYPE_RATES;
+	ssid_el_p[2 + priv->SSID_size] = WLAN_EID_SUPP_RATES;
 	ssid_el_p[3 + priv->SSID_size] = 4; /* len of suported rates */
 	memcpy(ssid_el_p + 4 + priv->SSID_size, atmel_basic_rates, 4);
 
@@ -2915,9 +2915,9 @@ static void send_association_request(str
 }
 
 static int is_frame_from_current_bss(struct atmel_private *priv,
-				     struct ieee80211_hdr_4addr *header)
+				     struct ieee80211_hdr *header)
 {
-	if (le16_to_cpu(header->frame_ctl) & IEEE80211_FCTL_FROMDS)
+	if (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FROMDS)
 		return memcmp(header->addr3, priv->CurrentBSSID, 6) == 0;
 	else
 		return memcmp(header->addr2, priv->CurrentBSSID, 6) == 0;
@@ -2965,7 +2965,7 @@ static int retrieve_bss(struct atmel_pri
 }
 
 static void store_bss_info(struct atmel_private *priv,
-			   struct ieee80211_hdr_4addr *header, u16 capability,
+			   struct ieee80211_hdr *header, u16 capability,
 			   u16 beacon_period, u8 channel, u8 rssi, u8 ssid_len,
 			   u8 *ssid, int is_beacon)
 {
@@ -3004,7 +3004,7 @@ static void store_bss_info(struct atmel_
 	else if (capability & WLAN_CAPABILITY_ESS)
 		priv->BSSinfo[index].BSStype =IW_MODE_INFRA;
 
-	priv->BSSinfo[index].preamble = capability & MFIE_TYPE_POWER_CONSTRAINT ?
+	priv->BSSinfo[index].preamble = capability & WLAN_CAPABILITY_SHORT_PREAMBLE ?
 		SHORT_PREAMBLE : LONG_PREAMBLE;
 }
 
@@ -3040,7 +3040,7 @@ static void authenticate(struct atmel_pr
 			}
 		} else if (system == WLAN_AUTH_SHARED_KEY) {
 			if (trans_seq_no == 0x0002 &&
-			    auth->el_id == MFIE_TYPE_CHALLENGE) {
+			    auth->el_id == WLAN_EID_CHALLENGE) {
 				send_authentication_request(priv, system, auth->chall_text, auth->chall_text_len);
 				return;
 			} else if (trans_seq_no == 0x0004) {
@@ -3291,12 +3291,12 @@ static void atmel_smooth_qual(struct atm
 
 /* deals with incoming managment frames. */
 static void atmel_management_frame(struct atmel_private *priv,
-				   struct ieee80211_hdr_4addr *header,
+				   struct ieee80211_hdr *header,
 				   u16 frame_len, u8 rssi)
 {
 	u16 subtype;
 
-	subtype = le16_to_cpu(header->frame_ctl) & IEEE80211_FCTL_STYPE;
+	subtype = le16_to_cpu(header->frame_control) & IEEE80211_FCTL_STYPE;
 	switch (subtype) {
 	case IEEE80211_STYPE_BEACON:
 	case IEEE80211_STYPE_PROBE_RESP:
--- everything.orig/drivers/net/wireless/libertas/assoc.c	2008-10-29 01:42:05.000000000 +0100
+++ everything/drivers/net/wireless/libertas/assoc.c	2008-10-29 01:43:16.000000000 +0100
@@ -2,6 +2,8 @@
 
 #include <linux/types.h>
 #include <linux/etherdevice.h>
+#include <linux/ieee80211.h>
+#include <linux/if_arp.h>
 #include <net/lib80211.h>
 
 #include "assoc.h"
@@ -342,12 +344,12 @@ static int lbs_adhoc_start(struct lbs_pr
 	WARN_ON(!assoc_req->channel);
 
 	/* set Physical parameter set */
-	cmd.phyparamset.dsparamset.elementid = MFIE_TYPE_DS_SET;
+	cmd.phyparamset.dsparamset.elementid = WLAN_EID_DS_PARAMS;
 	cmd.phyparamset.dsparamset.len = 1;
 	cmd.phyparamset.dsparamset.currentchan = assoc_req->channel;
 
 	/* set IBSS parameter set */
-	cmd.ssparamset.ibssparamset.elementid = MFIE_TYPE_IBSS_SET;
+	cmd.ssparamset.ibssparamset.elementid = WLAN_EID_IBSS_PARAMS;
 	cmd.ssparamset.ibssparamset.len = 2;
 	cmd.ssparamset.ibssparamset.atimwindow = 0;
 
@@ -431,8 +433,8 @@ static inline int match_bss_no_security(
 {
 	if (!secinfo->wep_enabled  && !secinfo->WPAenabled
 	    && !secinfo->WPA2enabled
-	    && match_bss->wpa_ie[0] != MFIE_TYPE_GENERIC
-	    && match_bss->rsn_ie[0] != MFIE_TYPE_RSN
+	    && match_bss->wpa_ie[0] != WLAN_EID_GENERIC
+	    && match_bss->rsn_ie[0] != WLAN_EID_RSN
 	    && !(match_bss->capability & WLAN_CAPABILITY_PRIVACY))
 		return 1;
 	else
@@ -454,7 +456,7 @@ static inline int match_bss_wpa(struct l
 				struct bss_descriptor *match_bss)
 {
 	if (!secinfo->wep_enabled && secinfo->WPAenabled
-	    && (match_bss->wpa_ie[0] == MFIE_TYPE_GENERIC)
+	    && (match_bss->wpa_ie[0] == WLAN_EID_GENERIC)
 	    /* privacy bit may NOT be set in some APs like LinkSys WRT54G
 	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY) */
 	   )
@@ -467,7 +469,7 @@ static inline int match_bss_wpa2(struct 
 				 struct bss_descriptor *match_bss)
 {
 	if (!secinfo->wep_enabled && secinfo->WPA2enabled &&
-	    (match_bss->rsn_ie[0] == MFIE_TYPE_RSN)
+	    (match_bss->rsn_ie[0] == WLAN_EID_RSN)
 	    /* privacy bit may NOT be set in some APs like LinkSys WRT54G
 	    (match_bss->capability & WLAN_CAPABILITY_PRIVACY) */
 	   )
@@ -481,8 +483,8 @@ static inline int match_bss_dynamic_wep(
 {
 	if (!secinfo->wep_enabled && !secinfo->WPAenabled
 	    && !secinfo->WPA2enabled
-	    && (match_bss->wpa_ie[0] != MFIE_TYPE_GENERIC)
-	    && (match_bss->rsn_ie[0] != MFIE_TYPE_RSN)
+	    && (match_bss->wpa_ie[0] != WLAN_EID_GENERIC)
+	    && (match_bss->rsn_ie[0] != WLAN_EID_RSN)
 	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
 		return 1;
 	else
--- everything.orig/drivers/net/wireless/libertas/cmd.c	2008-10-29 01:21:21.000000000 +0100
+++ everything/drivers/net/wireless/libertas/cmd.c	2008-10-29 01:31:25.000000000 +0100
@@ -5,7 +5,6 @@
 
 #include <net/iw_handler.h>
 #include <net/lib80211.h>
-#include <net/ieee80211.h>
 #include <linux/kfifo.h>
 #include "host.h"
 #include "hostcmd.h"
@@ -1072,7 +1071,7 @@ int lbs_mesh_config(struct lbs_private *
 
 	switch (action) {
 	case CMD_ACT_MESH_CONFIG_START:
-		ie->hdr.id = MFIE_TYPE_GENERIC;
+		ie->id = WLAN_EID_GENERIC;
 		ie->val.oui[0] = 0x00;
 		ie->val.oui[1] = 0x50;
 		ie->val.oui[2] = 0x43;
@@ -1084,7 +1083,7 @@ int lbs_mesh_config(struct lbs_private *
 		ie->val.mesh_capability = MARVELL_MESH_CAPABILITY;
 		ie->val.mesh_id_len = priv->mesh_ssid_len;
 		memcpy(ie->val.mesh_id, priv->mesh_ssid, priv->mesh_ssid_len);
-		ie->hdr.len = sizeof(struct mrvl_meshie_val) -
+		ie->len = sizeof(struct mrvl_meshie_val) -
 			IW_ESSID_MAX_SIZE + priv->mesh_ssid_len;
 		cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie_val));
 		break;
--- everything.orig/drivers/net/wireless/libertas/dev.h	2008-10-29 01:21:21.000000000 +0100
+++ everything/drivers/net/wireless/libertas/dev.h	2008-10-29 01:27:30.000000000 +0100
@@ -10,7 +10,6 @@
 #include <linux/wireless.h>
 #include <linux/ethtool.h>
 #include <linux/debugfs.h>
-#include <net/ieee80211.h>
 
 #include "defs.h"
 #include "hostcmd.h"
@@ -278,6 +277,12 @@ struct lbs_private {
 	struct enc_key wpa_mcast_key;
 	struct enc_key wpa_unicast_key;
 
+/*
+ * In theory, the IE is limited to the IE length, 255,
+ * but in practice 64 bytes are enough.
+ */
+#define MAX_WPA_IE_LEN 64
+
 	/** WPA Information Elements*/
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	u8 wpa_ie_len;
--- everything.orig/drivers/net/wireless/libertas/main.c	2008-10-29 01:21:21.000000000 +0100
+++ everything/drivers/net/wireless/libertas/main.c	2008-10-29 01:29:28.000000000 +0100
@@ -12,9 +12,8 @@
 #include <linux/kthread.h>
 #include <linux/kfifo.h>
 #include <linux/stddef.h>
-
+#include <linux/ieee80211.h>
 #include <net/iw_handler.h>
-#include <net/ieee80211.h>
 
 #include "host.h"
 #include "decl.h"
--- everything.orig/drivers/net/wireless/libertas/persistcfg.c	2008-10-29 01:41:42.000000000 +0100
+++ everything/drivers/net/wireless/libertas/persistcfg.c	2008-10-29 01:41:51.000000000 +0100
@@ -233,7 +233,7 @@ static ssize_t mesh_id_set(struct device
 	/* SSID len */
 	ie->val.mesh_id_len = len;
 	/* IE len */
-	ie->hdr.len = sizeof(struct mrvl_meshie_val) - IW_ESSID_MAX_SIZE + len;
+	ie->len = sizeof(struct mrvl_meshie_val) - IW_ESSID_MAX_SIZE + len;
 
 	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
 				   CMD_TYPE_MESH_SET_MESH_IE);
--- everything.orig/drivers/net/wireless/libertas/scan.c	2008-10-29 01:32:47.000000000 +0100
+++ everything/drivers/net/wireless/libertas/scan.c	2008-10-29 01:41:27.000000000 +0100
@@ -6,8 +6,8 @@
   */
 #include <linux/types.h>
 #include <linux/etherdevice.h>
+#include <linux/if_arp.h>
 #include <asm/unaligned.h>
-
 #include <net/lib80211.h>
 
 #include "host.h"
@@ -55,6 +55,8 @@
 //! Scan time specified in the channel TLV for each channel for active scans
 #define MRVDRV_ACTIVE_SCAN_CHAN_TIME   100
 
+#define DEFAULT_MAX_SCAN_AGE (15 * HZ)
+
 static int lbs_ret_80211_scan(struct lbs_private *priv, unsigned long dummy,
 			      struct cmd_header *resp);
 
@@ -593,38 +595,36 @@ static int lbs_process_bss(struct bss_de
 
 	/* process variable IE */
 	while (pos <= end - 2) {
-		struct ieee80211_info_element * elem = (void *)pos;
-
-		if (pos + elem->len > end) {
+		if (pos + pos[1] > end) {
 			lbs_deb_scan("process_bss: error in processing IE, "
 				     "bytes left < IE length\n");
 			break;
 		}
 
-		switch (elem->id) {
-		case MFIE_TYPE_SSID:
-			bss->ssid_len = elem->len;
-			memcpy(bss->ssid, elem->data, elem->len);
+		switch (pos[0]) {
+		case WLAN_EID_SSID:
+			bss->ssid_len = min_t(int, IEEE80211_MAX_SSID_LEN, pos[1]);
+			memcpy(bss->ssid, pos + 2, bss->ssid_len);
 			lbs_deb_scan("got SSID IE: '%s', len %u\n",
 			             print_ssid(ssid, bss->ssid, bss->ssid_len),
 			             bss->ssid_len);
 			break;
 
-		case MFIE_TYPE_RATES:
-			n_basic_rates = min_t(uint8_t, MAX_RATES, elem->len);
-			memcpy(bss->rates, elem->data, n_basic_rates);
+		case WLAN_EID_SUPP_RATES:
+			n_basic_rates = min_t(uint8_t, MAX_RATES, pos[1]);
+			memcpy(bss->rates, pos + 2, n_basic_rates);
 			got_basic_rates = 1;
 			lbs_deb_scan("got RATES IE\n");
 			break;
 
-		case MFIE_TYPE_FH_SET:
+		case WLAN_EID_FH_PARAMS:
 			pFH = (struct ieeetypes_fhparamset *) pos;
 			memmove(&bss->phyparamset.fhparamset, pFH,
 				sizeof(struct ieeetypes_fhparamset));
 			lbs_deb_scan("got FH IE\n");
 			break;
 
-		case MFIE_TYPE_DS_SET:
+		case WLAN_EID_DS_PARAMS:
 			pDS = (struct ieeetypes_dsparamset *) pos;
 			bss->channel = pDS->currentchan;
 			memcpy(&bss->phyparamset.dsparamset, pDS,
@@ -632,14 +632,14 @@ static int lbs_process_bss(struct bss_de
 			lbs_deb_scan("got DS IE, channel %d\n", bss->channel);
 			break;
 
-		case MFIE_TYPE_CF_SET:
+		case WLAN_EID_CF_PARAMS:
 			pCF = (struct ieeetypes_cfparamset *) pos;
 			memcpy(&bss->ssparamset.cfparamset, pCF,
 			       sizeof(struct ieeetypes_cfparamset));
 			lbs_deb_scan("got CF IE\n");
 			break;
 
-		case MFIE_TYPE_IBSS_SET:
+		case WLAN_EID_IBSS_PARAMS:
 			pibss = (struct ieeetypes_ibssparamset *) pos;
 			bss->atimwindow = le16_to_cpu(pibss->atimwindow);
 			memmove(&bss->ssparamset.ibssparamset, pibss,
@@ -647,7 +647,7 @@ static int lbs_process_bss(struct bss_de
 			lbs_deb_scan("got IBSS IE\n");
 			break;
 
-		case MFIE_TYPE_COUNTRY:
+		case WLAN_EID_COUNTRY:
 			pcountryinfo = (struct ieeetypes_countryinfoset *) pos;
 			lbs_deb_scan("got COUNTRY IE\n");
 			if (pcountryinfo->len < sizeof(pcountryinfo->countrycode)
@@ -664,7 +664,7 @@ static int lbs_process_bss(struct bss_de
 				    (int) (pcountryinfo->len + 2));
 			break;
 
-		case MFIE_TYPE_RATES_EX:
+		case WLAN_EID_EXT_SUPP_RATES:
 			/* only process extended supported rate if data rate is
 			 * already found. Data rate IE should come before
 			 * extended supported rate IE
@@ -675,50 +675,51 @@ static int lbs_process_bss(struct bss_de
 				break;
 			}
 
-			n_ex_rates = elem->len;
+			n_ex_rates = pos[1];
 			if (n_basic_rates + n_ex_rates > MAX_RATES)
 				n_ex_rates = MAX_RATES - n_basic_rates;
 
 			p = bss->rates + n_basic_rates;
-			memcpy(p, elem->data, n_ex_rates);
+			memcpy(p, pos + 2, n_ex_rates);
 			break;
 
-		case MFIE_TYPE_GENERIC:
-			if (elem->len >= 4 &&
-			    elem->data[0] == 0x00 && elem->data[1] == 0x50 &&
-			    elem->data[2] == 0xf2 && elem->data[3] == 0x01) {
-				bss->wpa_ie_len = min(elem->len + 2, MAX_WPA_IE_LEN);
-				memcpy(bss->wpa_ie, elem, bss->wpa_ie_len);
+		case WLAN_EID_GENERIC:
+			if (pos[1] >= 4 &&
+			    pos[2] == 0x00 && pos[3] == 0x50 &&
+			    pos[4] == 0xf2 && pos[5] == 0x01) {
+				bss->wpa_ie_len = min(pos[1] + 2, MAX_WPA_IE_LEN);
+				memcpy(bss->wpa_ie, pos, bss->wpa_ie_len);
 				lbs_deb_scan("got WPA IE\n");
-				lbs_deb_hex(LBS_DEB_SCAN, "WPA IE", bss->wpa_ie, elem->len);
-			} else if (elem->len >= MARVELL_MESH_IE_LENGTH &&
-				   elem->data[0] == 0x00 && elem->data[1] == 0x50 &&
-				   elem->data[2] == 0x43 && elem->data[3] == 0x04) {
+				lbs_deb_hex(LBS_DEB_SCAN, "WPA IE", bss->wpa_ie,
+					    bss->wpa_ie_len);
+			} else if (pos[1] >= MARVELL_MESH_IE_LENGTH &&
+				   pos[2] == 0x00 && pos[3] == 0x50 &&
+				   pos[4] == 0x43 && pos[4] == 0x04) {
 				lbs_deb_scan("got mesh IE\n");
 				bss->mesh = 1;
 			} else {
 				lbs_deb_scan("got generic IE: %02x:%02x:%02x:%02x, len %d\n",
-					elem->data[0], elem->data[1],
-					elem->data[2], elem->data[3],
-					elem->len);
+					pos[2], pos[3],
+					pos[4], pos[5],
+					pos[1]);
 			}
 			break;
 
-		case MFIE_TYPE_RSN:
+		case WLAN_EID_RSN:
 			lbs_deb_scan("got RSN IE\n");
-			bss->rsn_ie_len = min(elem->len + 2, MAX_WPA_IE_LEN);
-			memcpy(bss->rsn_ie, elem, bss->rsn_ie_len);
+			bss->rsn_ie_len = min(pos[1] + 2, MAX_WPA_IE_LEN);
+			memcpy(bss->rsn_ie, pos, bss->rsn_ie_len);
 			lbs_deb_hex(LBS_DEB_SCAN, "process_bss: RSN_IE",
-				    bss->rsn_ie, elem->len);
+				    bss->rsn_ie, bss->rsn_ie_len);
 			break;
 
 		default:
 			lbs_deb_scan("got IE 0x%04x, len %d\n",
-				     elem->id, elem->len);
+				     pos[0], pos[1]);
 			break;
 		}
 
-		pos += elem->len + 2;
+		pos += pos[1] + 2;
 	}
 
 	/* Timestamp */
--- everything.orig/drivers/net/wireless/libertas/scan.h	2008-10-29 01:30:12.000000000 +0100
+++ everything/drivers/net/wireless/libertas/scan.h	2008-10-29 01:32:34.000000000 +0100
@@ -7,6 +7,10 @@
 #ifndef _LBS_SCAN_H
 #define _LBS_SCAN_H
 
+#include <net/iw_handler.h>
+
+#define MAX_NETWORK_COUNT 128
+
 /**
  *  @brief Maximum number of channels that can be sent in a setuserscan ioctl
  */
--- everything.orig/drivers/net/wireless/libertas/types.h	2008-10-29 01:21:22.000000000 +0100
+++ everything/drivers/net/wireless/libertas/types.h	2008-10-29 01:28:58.000000000 +0100
@@ -7,7 +7,6 @@
 #include <linux/if_ether.h>
 #include <asm/byteorder.h>
 #include <linux/wireless.h>
-#include <net/ieee80211.h>
 
 struct ieeetypes_cfparamset {
 	u8 elementid;
@@ -258,7 +257,7 @@ struct mrvlietypes_ledbhv {
  * Note that the len member of the ieee80211_info_element varies depending on
  * the mesh_id_len */
 struct mrvl_meshie_val {
-	uint8_t oui[P80211_OUI_LEN];
+	uint8_t oui[3];
 	uint8_t type;
 	uint8_t subtype;
 	uint8_t version;
@@ -270,7 +269,7 @@ struct mrvl_meshie_val {
 } __attribute__ ((packed));
 
 struct mrvl_meshie {
-	struct ieee80211_info_element hdr;
+	u8 id, len;
 	struct mrvl_meshie_val val;
 } __attribute__ ((packed));
 
--- everything.orig/drivers/net/wireless/libertas/wext.c	2008-10-29 01:21:22.000000000 +0100
+++ everything/drivers/net/wireless/libertas/wext.c	2008-10-29 01:21:56.000000000 +0100
@@ -9,7 +9,6 @@
 #include <linux/bitops.h>
 
 #include <net/lib80211.h>
-#include <net/ieee80211.h>
 #include <net/iw_handler.h>
 
 #include "host.h"
--- everything.orig/drivers/net/wireless/orinoco.c	2008-10-29 01:21:22.000000000 +0100
+++ everything/drivers/net/wireless/orinoco.c	2008-10-29 01:51:07.000000000 +0100
@@ -86,8 +86,8 @@
 #include <linux/firmware.h>
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
+#include <linux/ieee80211.h>
 #include <net/iw_handler.h>
-#include <net/ieee80211.h>
 
 #include <linux/scatterlist.h>
 #include <linux/crypto.h>
@@ -143,7 +143,7 @@ static const u8 encaps_hdr[] = {0xaa, 0x
 #define ENCAPS_OVERHEAD		(sizeof(encaps_hdr) + 2)
 
 #define ORINOCO_MIN_MTU		256
-#define ORINOCO_MAX_MTU		(IEEE80211_DATA_LEN - ENCAPS_OVERHEAD)
+#define ORINOCO_MAX_MTU		(IEEE80211_MAX_DATA_LEN - ENCAPS_OVERHEAD)
 
 #define SYMBOL_MAX_VER_LEN	(14)
 #define USER_BAP		0
@@ -391,8 +391,7 @@ static void orinoco_bss_data_init(struct
 
 }
 
-static inline u8 *orinoco_get_ie(u8 *data, size_t len,
-				 enum ieee80211_mfie eid)
+static inline u8 *orinoco_get_ie(u8 *data, size_t len, u8 eid)
 {
 	u8 *p = data;
 	while ((p + 2) < (data + len)) {
@@ -409,7 +408,7 @@ static inline u8 *orinoco_get_wpa_ie(u8 
 {
 	u8 *p = data;
 	while ((p + 2 + WPA_SELECTOR_LEN) < (data + len)) {
-		if ((p[0] == MFIE_TYPE_GENERIC) &&
+		if ((p[0] == WLAN_EID_GENERIC) &&
 		    (memcmp(&p[2], WPA_OUI_TYPE, WPA_SELECTOR_LEN) == 0))
 			return p;
 		p += p[1] + 2;
@@ -839,7 +838,8 @@ static int orinoco_change_mtu(struct net
 	if ( (new_mtu < ORINOCO_MIN_MTU) || (new_mtu > ORINOCO_MAX_MTU) )
 		return -EINVAL;
 
-	if ( (new_mtu + ENCAPS_OVERHEAD + IEEE80211_HLEN) >
+	/* MTU + encapsulation + header length */
+	if ( (new_mtu + ENCAPS_OVERHEAD + 24) >
 	     (priv->nicbuf_size - ETH_HLEN) )
 		return -EINVAL;
 
@@ -1254,7 +1254,7 @@ static void orinoco_rx_monitor(struct ne
 	}
 
 	/* sanity check the length */
-	if (datalen > IEEE80211_DATA_LEN + 12) {
+	if (datalen > IEEE80211_MAX_DATA_LEN + 12) {
 		printk(KERN_DEBUG "%s: oversized monitor frame, "
 		       "data length = %d\n", dev->name, datalen);
 		stats->rx_length_errors++;
@@ -1383,7 +1383,7 @@ static void __orinoco_ev_rx(struct net_d
                    data. */
 		goto out;
 	}
-	if (length > IEEE80211_DATA_LEN) {
+	if (length > IEEE80211_MAX_DATA_LEN) {
 		printk(KERN_WARNING "%s: Oversized frame received (%d bytes)\n",
 		       dev->name, length);
 		stats->rx_length_errors++;
@@ -3289,7 +3289,7 @@ static int orinoco_init(struct net_devic
 
 	/* No need to lock, the hw_unavailable flag is already set in
 	 * alloc_orinocodev() */
-	priv->nicbuf_size = IEEE80211_FRAME_LEN + ETH_HLEN;
+	priv->nicbuf_size = IEEE80211_MAX_FRAME_LEN + ETH_HLEN;
 
 	/* Initialize the firmware */
 	err = hermes_init(hw);
@@ -4685,7 +4685,7 @@ static int orinoco_ioctl_set_encodeext(s
 	/* Determine and validate the key index */
 	idx = encoding->flags & IW_ENCODE_INDEX;
 	if (idx) {
-		if ((idx < 1) || (idx > WEP_KEYS))
+		if ((idx < 1) || (idx > 4))
 			goto out;
 		idx--;
 	} else
@@ -4790,7 +4790,7 @@ static int orinoco_ioctl_get_encodeext(s
 
 	idx = encoding->flags & IW_ENCODE_INDEX;
 	if (idx) {
-		if ((idx < 1) || (idx > WEP_KEYS))
+		if ((idx < 1) || (idx > 4))
 			goto out;
 		idx--;
 	} else
@@ -4953,7 +4953,8 @@ static int orinoco_ioctl_set_genie(struc
 	unsigned long flags;
 	int err = 0;
 
-	if ((wrqu->data.length > MAX_WPA_IE_LEN) ||
+	/* cut off at IEEE80211_MAX_DATA_LEN */
+	if ((wrqu->data.length > IEEE80211_MAX_DATA_LEN) ||
 	    (wrqu->data.length && (extra == NULL)))
 		return -EINVAL;
 
@@ -5636,7 +5637,7 @@ static inline char *orinoco_translate_ex
 						  &iwe, IW_EV_UINT_LEN);
 	}
 
-	ie = orinoco_get_ie(bss->data, sizeof(bss->data), MFIE_TYPE_DS_SET);
+	ie = orinoco_get_ie(bss->data, sizeof(bss->data), WLAN_EID_DS_PARAMS);
 	channel = ie ? ie[2] : 0;
 	if ((channel >= 1) && (channel <= NUM_CHANNELS)) {
 		/* Add channel and frequency */
@@ -5686,7 +5687,7 @@ static inline char *orinoco_translate_ex
 	}
 
 	/* RSN IE */
-	ie = orinoco_get_ie(bss->data, sizeof(bss->data), MFIE_TYPE_RSN);
+	ie = orinoco_get_ie(bss->data, sizeof(bss->data), WLAN_EID_RSN);
 	if (ie) {
 		iwe.cmd = IWEVGENIE;
 		iwe.u.data.length = ie[1] + 2;
@@ -5694,7 +5695,7 @@ static inline char *orinoco_translate_ex
 						  &iwe, ie);
 	}
 
-	ie = orinoco_get_ie(bss->data, sizeof(bss->data), MFIE_TYPE_RATES);
+	ie = orinoco_get_ie(bss->data, sizeof(bss->data), WLAN_EID_SUPP_RATES);
 	if (ie) {
 		char *p = current_ev + iwe_stream_lcp_len(info);
 		int i;
--- everything.orig/drivers/net/wireless/rndis_wlan.c	2008-10-29 01:21:22.000000000 +0100
+++ everything/drivers/net/wireless/rndis_wlan.c	2008-10-29 02:05:09.000000000 +0100
@@ -37,11 +37,11 @@
 #include <linux/usb.h>
 #include <linux/usb/cdc.h>
 #include <linux/wireless.h>
+#include <linux/ieee80211.h>
 #include <linux/if_arp.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
 #include <net/iw_handler.h>
-#include <net/ieee80211.h>
 #include <linux/usb/usbnet.h>
 #include <linux/usb/rndis_host.h>
 
@@ -1654,7 +1654,7 @@ static char *rndis_translate_scan(struct
 #ifdef DEBUG
 	struct usbnet *usbdev = dev->priv;
 #endif
-	struct ieee80211_info_element *ie;
+	u8 *ie;
 	char *current_val;
 	int bssid_len, ie_len, i;
 	u32 beacon, atim;
@@ -1753,20 +1753,20 @@ static char *rndis_translate_scan(struct
 	ie_len = min(bssid_len - (int)sizeof(*bssid),
 					(int)le32_to_cpu(bssid->ie_length));
 	ie_len -= sizeof(struct ndis_80211_fixed_ies);
-	while (ie_len >= sizeof(*ie) && sizeof(*ie) + ie->len <= ie_len) {
-		if ((ie->id == MFIE_TYPE_GENERIC && ie->len >= 4 &&
-				memcmp(ie->data, "\x00\x50\xf2\x01", 4) == 0) ||
-				ie->id == MFIE_TYPE_RSN) {
+	while (ie_len >= 2 && 2 + ie[1] <= ie_len) {
+		if ((ie[0] == WLAN_EID_GENERIC && ie[1] >= 4 &&
+		     memcmp(ie + 2, "\x00\x50\xf2\x01", 4) == 0) ||
+		    ie[0] == WLAN_EID_RSN) {
 			devdbg(usbdev, "IE: WPA%d",
-					(ie->id == MFIE_TYPE_RSN) ? 2 : 1);
+					(ie[0] == WLAN_EID_RSN) ? 2 : 1);
 			iwe.cmd = IWEVGENIE;
-			iwe.u.data.length = min(ie->len + 2, MAX_WPA_IE_LEN);
-			cev = iwe_stream_add_point(info, cev, end_buf, &iwe,
-								(u8 *)ie);
+			/* arbitrary cut-off at 64 */
+			iwe.u.data.length = min(ie[1] + 2, 64);
+			cev = iwe_stream_add_point(info, cev, end_buf, &iwe, ie);
 		}
 
-		ie_len -= sizeof(*ie) + ie->len;
-		ie = (struct ieee80211_info_element *)&ie->data[ie->len];
+		ie_len -= 2 + ie[1];
+		ie += 2 + ie[1];
 	}
 
 	return cev;
--- everything.orig/drivers/net/wireless/wl3501.h	2008-10-29 01:21:23.000000000 +0100
+++ everything/drivers/net/wireless/wl3501.h	2008-10-29 02:02:26.000000000 +0100
@@ -2,7 +2,7 @@
 #define __WL3501_H__
 
 #include <linux/spinlock.h>
-#include <net/ieee80211.h>
+#include <linux/ieee80211.h>
 
 /* define for WLA 2.0 */
 #define WL3501_BLKSZ 256
@@ -548,7 +548,7 @@ struct wl3501_80211_tx_plcp_hdr {
 
 struct wl3501_80211_tx_hdr {
 	struct wl3501_80211_tx_plcp_hdr	pclp_hdr;
-	struct ieee80211_hdr_4addr		mac_hdr;
+	struct ieee80211_hdr		mac_hdr;
 } __attribute__ ((packed));
 
 /*
--- everything.orig/drivers/net/wireless/zd1201.c	2008-10-29 01:21:23.000000000 +0100
+++ everything/drivers/net/wireless/zd1201.c	2008-10-29 02:05:39.000000000 +0100
@@ -17,11 +17,11 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
+#include <linux/ieee80211.h>
 #include <net/iw_handler.h>
 #include <linux/string.h>
 #include <linux/if_arp.h>
 #include <linux/firmware.h>
-#include <net/ieee80211.h>
 #include "zd1201.h"
 
 static struct usb_device_id zd1201_table[] = {
@@ -346,7 +346,7 @@ static void zd1201_usbrx(struct urb *urb
 				frag = kmalloc(sizeof(*frag), GFP_ATOMIC);
 				if (!frag)
 					goto resubmit;
-				skb = dev_alloc_skb(IEEE80211_DATA_LEN +14+2);
+				skb = dev_alloc_skb(IEEE80211_MAX_DATA_LEN +14+2);
 				if (!skb) {
 					kfree(frag);
 					goto resubmit;
--- everything.orig/drivers/net/ps3_gelic_wireless.h	2008-10-29 02:18:54.000000000 +0100
+++ everything/drivers/net/ps3_gelic_wireless.h	2008-10-29 02:19:19.000000000 +0100
@@ -164,8 +164,8 @@ struct gelic_eurus_scan_info {
 	__be16 security;
 	u8  bssid[8]; /* last ETH_ALEN are valid. bssid[0],[1] are unused */
 	u8  essid[32]; /* IW_ESSID_MAX_SIZE */
-	u8  rate[16]; /* first MAX_RATES_LENGTH(12) are valid */
-	u8  ext_rate[16]; /* first MAX_RATES_EX_LENGTH(16) are valid */
+	u8  rate[16]; /* first 12 are valid */
+	u8  ext_rate[16]; /* first 16 are valid */
 	__be32 reserved1;
 	__be32 reserved2;
 	__be32 reserved3;


