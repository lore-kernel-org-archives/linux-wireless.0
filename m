Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27058 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaJHKkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 06:40:39 -0400
Date: Wed, 8 Oct 2014 13:40:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] staging: rtl8723au: incorrect use of ether_addr_copy()
Message-ID: <20141008104014.GA23096@mwanda> (sfid-20141008_124045_465070_6EDA5A7F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return from myid() isn't aligned correctly for ether_addr_copy().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index 3eb77de..c8f7890 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -2402,7 +2402,7 @@ void issue_beacon23a(struct rtw_adapter *padapter, int timeout_ms)
 	mgmt->seq_ctrl = 0;
 
 	ether_addr_copy(mgmt->da, bc_addr);
-	ether_addr_copy(mgmt->sa, myid(&padapter->eeprompriv));
+	memcpy(mgmt->sa, myid(&padapter->eeprompriv), ETH_ALEN);
 	ether_addr_copy(mgmt->bssid, get_my_bssid23a(cur_network));
 
 	/* timestamp will be inserted by hardware */
@@ -2556,7 +2556,7 @@ static void issue_probersp(struct rtw_adapter *padapter, unsigned char *da,
 		cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_RESP);
 
 	ether_addr_copy(mgmt->da, da);
-	ether_addr_copy(mgmt->sa, mac);
+	memcpy(mgmt->sa, mac, ETH_ALEN);
 	ether_addr_copy(mgmt->bssid, bssid);
 
 	mgmt->seq_ctrl = cpu_to_le16(IEEE80211_SN_TO_SEQ(pmlmeext->mgnt_seq));
@@ -2718,7 +2718,7 @@ static int _issue_probereq(struct rtw_adapter *padapter,
 		ether_addr_copy(pwlanhdr->addr3, bc_addr);
 	}
 
-	ether_addr_copy(pwlanhdr->addr2, mac);
+	memcpy(pwlanhdr->addr2, mac, ETH_ALEN);
 
 	pwlanhdr->seq_ctrl =
 		cpu_to_le16(IEEE80211_SN_TO_SEQ(pmlmeext->mgnt_seq));
@@ -2863,8 +2863,8 @@ static void issue_auth(struct rtw_adapter *padapter, struct sta_info *psta,
 #ifdef CONFIG_8723AU_AP_MODE
 		unsigned short val16;
 		ether_addr_copy(mgmt->da, psta->hwaddr);
-		ether_addr_copy(mgmt->sa, myid(&padapter->eeprompriv));
-		ether_addr_copy(mgmt->bssid, myid(&padapter->eeprompriv));
+		memcpy(mgmt->sa, myid(&padapter->eeprompriv), ETH_ALEN);
+		memcpy(mgmt->bssid, myid(&padapter->eeprompriv), ETH_ALEN);
 
 		/*  setting auth algo number */
 		val16 = (u16)psta->authalg;
@@ -2895,7 +2895,7 @@ static void issue_auth(struct rtw_adapter *padapter, struct sta_info *psta,
 		struct ieee80211_mgmt *iv_mgmt;
 
 		ether_addr_copy(mgmt->da, get_my_bssid23a(&pmlmeinfo->network));
-		ether_addr_copy(mgmt->sa, myid(&padapter->eeprompriv));
+		memcpy(mgmt->sa, myid(&padapter->eeprompriv), ETH_ALEN);
 		ether_addr_copy(mgmt->bssid,
 				get_my_bssid23a(&pmlmeinfo->network));
 
@@ -3006,7 +3006,7 @@ static void issue_assocrsp(struct rtw_adapter *padapter, unsigned short status,
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | pkt_type);
 
 	ether_addr_copy(mgmt->da, pstat->hwaddr);
-	ether_addr_copy(mgmt->sa, myid(&padapter->eeprompriv));
+	memcpy(mgmt->sa, myid(&padapter->eeprompriv), ETH_ALEN);
 	ether_addr_copy(mgmt->bssid, get_my_bssid23a(&pmlmeinfo->network));
 
 	mgmt->seq_ctrl = cpu_to_le16(IEEE80211_SN_TO_SEQ(pmlmeext->mgnt_seq));
@@ -3129,7 +3129,7 @@ static void issue_assocreq(struct rtw_adapter *padapter)
 		cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ASSOC_REQ);
 
 	ether_addr_copy(mgmt->da, get_my_bssid23a(&pmlmeinfo->network));
-	ether_addr_copy(mgmt->sa, myid(&padapter->eeprompriv));
+	memcpy(mgmt->sa, myid(&padapter->eeprompriv), ETH_ALEN);
 	ether_addr_copy(mgmt->bssid, get_my_bssid23a(&pmlmeinfo->network));
 
 	mgmt->seq_ctrl = cpu_to_le16(IEEE80211_SN_TO_SEQ(pmlmeext->mgnt_seq));
@@ -3400,7 +3400,7 @@ static int _issue_nulldata23a(struct rtw_adapter *padapter, unsigned char *da,
 		pwlanhdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 
 	ether_addr_copy(pwlanhdr->addr1, da);
-	ether_addr_copy(pwlanhdr->addr2, myid(&padapter->eeprompriv));
+	memcpy(pwlanhdr->addr2, myid(&padapter->eeprompriv), ETH_ALEN);
 	ether_addr_copy(pwlanhdr->addr3, get_my_bssid23a(&pmlmeinfo->network));
 
 	pwlanhdr->seq_ctrl =
@@ -3528,7 +3528,7 @@ static int _issue_qos_nulldata23a(struct rtw_adapter *padapter,
 		pwlanhdr->qos_ctrl |= cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
 
 	ether_addr_copy(pwlanhdr->addr1, da);
-	ether_addr_copy(pwlanhdr->addr2, myid(&padapter->eeprompriv));
+	memcpy(pwlanhdr->addr2, myid(&padapter->eeprompriv), ETH_ALEN);
 	ether_addr_copy(pwlanhdr->addr3, get_my_bssid23a(&pmlmeinfo->network));
 
 	pwlanhdr->seq_ctrl =
@@ -3633,7 +3633,7 @@ static int _issue_deauth(struct rtw_adapter *padapter, unsigned char *da,
 		cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_DEAUTH);
 
 	ether_addr_copy(mgmt->da, da);
-	ether_addr_copy(mgmt->sa, myid(&padapter->eeprompriv));
+	memcpy(mgmt->sa, myid(&padapter->eeprompriv), ETH_ALEN);
 	ether_addr_copy(mgmt->bssid, get_my_bssid23a(&pmlmeinfo->network));
 
 	mgmt->seq_ctrl = cpu_to_le16(IEEE80211_SN_TO_SEQ(pmlmeext->mgnt_seq));
@@ -3737,7 +3737,7 @@ void issue_action_spct_ch_switch23a(struct rtw_adapter *padapter,
 		cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ACTION);
 
 	ether_addr_copy(mgmt->da, ra); /* RA */
-	ether_addr_copy(mgmt->sa, myid(&padapter->eeprompriv)); /* TA */
+	memcpy(mgmt->sa, myid(&padapter->eeprompriv), ETH_ALEN); /* TA */
 	ether_addr_copy(mgmt->bssid, ra); /* DA = RA */
 
 	mgmt->seq_ctrl = cpu_to_le16(IEEE80211_SN_TO_SEQ(pmlmeext->mgnt_seq));
@@ -3799,7 +3799,7 @@ void issue_action_BA23a(struct rtw_adapter *padapter,
 		cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ACTION);
 
 	ether_addr_copy(mgmt->da, raddr);
-	ether_addr_copy(mgmt->sa, myid(&padapter->eeprompriv));
+	memcpy(mgmt->sa, myid(&padapter->eeprompriv), ETH_ALEN);
 	ether_addr_copy(mgmt->bssid, get_my_bssid23a(&pmlmeinfo->network));
 
 	mgmt->seq_ctrl = cpu_to_le16(IEEE80211_SN_TO_SEQ(pmlmeext->mgnt_seq));
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 271c33d..976ec2c 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -219,7 +219,7 @@ ConstructBeacon(struct rtw_adapter *padapter, u8 *pframe, u32 *pLength)
 		cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
 
 	ether_addr_copy(mgmt->da, bc_addr);
-	ether_addr_copy(mgmt->sa, myid(&padapter->eeprompriv));
+	memcpy(mgmt->sa, myid(&padapter->eeprompriv), ETH_ALEN);
 	ether_addr_copy(mgmt->bssid, get_my_bssid23a(cur_network));
 
 	/* A Beacon frame shouldn't have fragment bits set */
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index bd6953a..cb81e64 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -2414,7 +2414,7 @@ void rtw_cfg80211_indicate_sta_disassoc(struct rtw_adapter *padapter,
 	mgmt.frame_control =
 		cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_DEAUTH);
 
-	ether_addr_copy(mgmt.da, myid(&padapter->eeprompriv));
+	memcpy(mgmt.da, myid(&padapter->eeprompriv), ETH_ALEN);
 	ether_addr_copy(mgmt.sa, da);
 	ether_addr_copy(mgmt.bssid, get_my_bssid23a(&pmlmeinfo->network));
 
