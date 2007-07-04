Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:29650 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbXGDG7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2007 02:59:49 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Wed, 4 Jul 2007 08:59:40 +0200
Subject: [PATCH 1/2] libertas: remove bss_descriptior->networktsf
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707040859.41019.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This value was parsed out, but then nowhere used ... except in
some debugfs output. I can't imagine anyone wanting to use this
value for anything real (as no other driver exports it), so
bye-bye.

Along this, made the columns of
/sys/kernel/debug/libertas_wireless/*/getscantable align again.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/debugfs.c |    7 +--
 drivers/net/wireless/libertas/scan.c    |   69 -------------------------------
 drivers/net/wireless/libertas/scan.h    |    4 +-
 3 files changed, 5 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 4b9533a..63e747a 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -66,7 +66,7 @@ static ssize_t libertas_getscantable(struct file *file, char __user *userbuf,
 	struct bss_descriptor * iter_bss;
 
 	pos += snprintf(buf+pos, len-pos,
-		"# | ch  | ss  |       bssid       |   cap    |    TSF   | Qual | SSID \n");
+		"# | ch  | rssi |       bssid       |   cap    | Qual | SSID \n");
 
 	mutex_lock(&priv->adapter->lock);
 	list_for_each_entry (iter_bss, &priv->adapter->network_list, list) {
@@ -75,15 +75,14 @@ static ssize_t libertas_getscantable(struct file *file, char __user *userbuf,
 		u16 spectrum_mgmt = (iter_bss->capability & WLAN_CAPABILITY_SPECTRUM_MGMT);
 
 		pos += snprintf(buf+pos, len-pos,
-			"%02u| %03d | %03ld | " MAC_FMT " |",
+			"%02u| %03d | %04ld | " MAC_FMT " |",
 			numscansdone, iter_bss->channel, iter_bss->rssi,
 			MAC_ARG(iter_bss->bssid));
 		pos += snprintf(buf+pos, len-pos, " %04x-", iter_bss->capability);
 		pos += snprintf(buf+pos, len-pos, "%c%c%c |",
 				ibss ? 'A' : 'I', privacy ? 'P' : ' ',
 				spectrum_mgmt ? 'S' : ' ');
-		pos += snprintf(buf+pos, len-pos, " %08llx |", iter_bss->networktsf);
-		pos += snprintf(buf+pos, len-pos, " %d |", SCAN_RSSI(iter_bss->rssi));
+		pos += snprintf(buf+pos, len-pos, " %04d |", SCAN_RSSI(iter_bss->rssi));
 		pos += snprintf(buf+pos, len-pos, " %s\n",
 		                escape_essid(iter_bss->ssid, iter_bss->ssid_len));
 
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 4f621a6..aea2e90 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -837,58 +837,6 @@ out:
 }
 
 /**
- *  @brief Inspect the scan response buffer for pointers to expected TLVs
- *
- *  TLVs can be included at the end of the scan response BSS information.
- *    Parse the data in the buffer for pointers to TLVs that can potentially
- *    be passed back in the response
- *
- *  @param ptlv        Pointer to the start of the TLV buffer to parse
- *  @param tlvbufsize  size of the TLV buffer
- *  @param ptsftlv     Output parameter: Pointer to the TSF TLV if found
- *
- *  @return            void
- */
-static
-void wlan_ret_802_11_scan_get_tlv_ptrs(struct mrvlietypes_data * ptlv,
-				       int tlvbufsize,
-				       struct mrvlietypes_tsftimestamp ** ptsftlv)
-{
-	struct mrvlietypes_data *pcurrenttlv;
-	int tlvbufleft;
-	u16 tlvtype;
-	u16 tlvlen;
-
-	pcurrenttlv = ptlv;
-	tlvbufleft = tlvbufsize;
-	*ptsftlv = NULL;
-
-	lbs_deb_scan("SCAN_RESP: tlvbufsize = %d\n", tlvbufsize);
-	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_RESP: TLV Buf", (u8 *) ptlv, tlvbufsize);
-
-	while (tlvbufleft >= sizeof(struct mrvlietypesheader)) {
-		tlvtype = le16_to_cpu(pcurrenttlv->header.type);
-		tlvlen = le16_to_cpu(pcurrenttlv->header.len);
-
-		switch (tlvtype) {
-		case TLV_TYPE_TSFTIMESTAMP:
-			*ptsftlv = (struct mrvlietypes_tsftimestamp *) pcurrenttlv;
-			break;
-
-		default:
-			lbs_deb_scan("SCAN_RESP: Unhandled TLV = %d\n",
-			       tlvtype);
-			/* Give up, this seems corrupted */
-			return;
-		}		/* switch */
-
-		tlvbufleft -= (sizeof(ptlv->header) + tlvlen);
-		pcurrenttlv =
-		    (struct mrvlietypes_data *) (pcurrenttlv->Data + tlvlen);
-	}			/* while */
-}
-
-/**
  *  @brief Interpret a BSS scan response returned from the firmware
  *
  *  Parse the various fixed fields and IEs passed back for a a BSS probe
@@ -1684,8 +1632,6 @@ int libertas_ret_80211_scan(wlan_private * priv, struct cmd_ds_command *resp)
 {
 	wlan_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_scan_rsp *pscan;
-	struct mrvlietypes_data *ptlv;
-	struct mrvlietypes_tsftimestamp *ptsftlv;
 	struct bss_descriptor * iter_bss;
 	struct bss_descriptor * safe;
 	u8 *pbssinfo;
@@ -1734,11 +1680,6 @@ int libertas_ret_80211_scan(wlan_private * priv, struct cmd_ds_command *resp)
 				     + sizeof(pscan->nr_sets)
 				     + S_DS_GEN);
 
-	ptlv = (struct mrvlietypes_data *) (pscan->bssdesc_and_tlvbuffer + bytesleft);
-
-	/* Search the TLV buffer space in the scan response for any valid TLVs */
-	wlan_ret_802_11_scan_get_tlv_ptrs(ptlv, tlvbufsize, &ptsftlv);
-
 	/*
 	 *  Process each scan response returned (pscan->nr_sets).  Save
 	 *    the information in the newbssentry and then insert into the
@@ -1791,16 +1732,6 @@ int libertas_ret_80211_scan(wlan_private * priv, struct cmd_ds_command *resp)
 		       new.bssid[0], new.bssid[1], new.bssid[2],
 		       new.bssid[3], new.bssid[4], new.bssid[5]);
 
-		/*
-		 * If the TSF TLV was appended to the scan results, save the
-		 *   this entries TSF value in the networktsf field.  The
-		 *   networktsf is the firmware's TSF value at the time the
-		 *   beacon or probe response was received.
-		 */
-		if (ptsftlv) {
-			new.networktsf = le64_to_cpup(&ptsftlv->tsftable[idx]);
-		}
-
 		/* Copy the locally created newbssentry to the scan table */
 		memcpy(found, &new, offsetof(struct bss_descriptor, list));
 	}
diff --git a/drivers/net/wireless/libertas/scan.h b/drivers/net/wireless/libertas/scan.h
index def0db5..28decf3 100644
--- a/drivers/net/wireless/libertas/scan.h
+++ b/drivers/net/wireless/libertas/scan.h
@@ -151,7 +151,9 @@ struct bss_descriptor {
 
 	u32 atimwindow;
 
+	/* IW_MODE_AUTO, IW_MODE_ADHOC, IW_MODE_INFRA */
 	u8 mode;
+
 	/* zero-terminated array of supported data rates */
 	u8 rates[MAX_RATES + 1];
 
@@ -161,8 +163,6 @@ struct bss_descriptor {
 	union ieeetypes_phyparamset phyparamset;
 	union IEEEtypes_ssparamset ssparamset;
 
-	u64 networktsf;		//!< TSF timestamp from the current firmware TSF
-
 	struct ieeetypes_countryinfofullset countryinfo;
 
 	u8 wpa_ie[MAX_WPA_IE_LEN];
-- 
1.5.2.1

