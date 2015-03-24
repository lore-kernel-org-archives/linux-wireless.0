Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:54112 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753576AbbCXSKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 14:10:17 -0400
Message-ID: <1427220609.5642.39.camel@perches.com> (sfid-20150324_191038_413699_7D163A41)
Subject: [PATCH] staging: rtl8723au: Remove uses of MAC_FMT and MAC_ARG
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	LKML <linux-kernel@vger.kernel.org>
Date: Tue, 24 Mar 2015 11:10:09 -0700
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the standard vsprintf kernel extension to format
mac addresses.

This reduces object code size a bit.

Miscellanea:

o Coalesce formats
o Realign arguments
o Remove the now unused MAC_FMT and MAC_ARG #defines

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rtl8723au/core/rtw_ap.c           | 41 ++++++-------
 drivers/staging/rtl8723au/core/rtw_mlme.c         | 26 ++++----
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c     | 72 +++++++++++------------
 drivers/staging/rtl8723au/core/rtw_recv.c         | 42 +++++--------
 drivers/staging/rtl8723au/core/rtw_wlan_util.c    |  6 +-
 drivers/staging/rtl8723au/core/rtw_xmit.c         |  8 +--
 drivers/staging/rtl8723au/include/ieee80211.h     |  3 -
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 18 +++---
 drivers/staging/rtl8723au/os_dep/os_intfs.c       |  7 +--
 9 files changed, 101 insertions(+), 122 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index bed13db..6456689 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -260,15 +260,17 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
 			list_del_init(&psta->asoc_list);
 			pstapriv->asoc_list_cnt--;
 
-			DBG_8723A("asoc expire "MAC_FMT", state = 0x%x\n", MAC_ARG(psta->hwaddr), psta->state);
+			DBG_8723A("asoc expire %pM, state = 0x%x\n",
+				  psta->hwaddr, psta->state);
 			updated = ap_free_sta23a(padapter, psta, false, WLAN_REASON_DEAUTH_LEAVING);
 		} else {
 			/* TODO: Aging mechanism to digest frames in sleep_q to avoid running out of xmitframe */
 			if (psta->sleepq_len > (NR_XMITFRAME/pstapriv->asoc_list_cnt)
 				&& padapter->xmitpriv.free_xmitframe_cnt < ((NR_XMITFRAME/pstapriv->asoc_list_cnt)/2)
 			) {
-				DBG_8723A("%s sta:"MAC_FMT", sleepq_len:%u, free_xmitframe_cnt:%u, asoc_list_cnt:%u, clear sleep_q\n", __func__,
-					  MAC_ARG(psta->hwaddr),
+				DBG_8723A("%s sta:%pM, sleepq_len:%u, free_xmitframe_cnt:%u, asoc_list_cnt:%u, clear sleep_q\n",
+					  __func__,
+					  psta->hwaddr,
 					  psta->sleepq_len,
 					  padapter->xmitpriv.free_xmitframe_cnt,
 					  pstapriv->asoc_list_cnt);
@@ -305,7 +307,8 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
 
 		psta->keep_alive_trycnt++;
 		if (ret == _SUCCESS) {
-			DBG_8723A("asoc check, sta(" MAC_FMT ") is alive\n", MAC_ARG(psta->hwaddr));
+			DBG_8723A("asoc check, sta(%pM) is alive\n",
+				  psta->hwaddr);
 			psta->expire_to = pstapriv->expire_to;
 			psta->keep_alive_trycnt = 0;
 			continue;
@@ -317,7 +320,8 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
 
 		psta->keep_alive_trycnt = 0;
 
-		DBG_8723A("asoc expire "MAC_FMT", state = 0x%x\n", MAC_ARG(psta->hwaddr), psta->state);
+		DBG_8723A("asoc expire %pM, state = 0x%x\n",
+			  psta->hwaddr, psta->state);
 		spin_lock_bh(&pstapriv->asoc_list_lock);
 		if (!list_empty(&psta->asoc_list)) {
 			list_del_init(&psta->asoc_list);
@@ -1044,7 +1048,7 @@ int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
 	struct wlan_acl_pool *pacl_list = &pstapriv->acl_list;
 	struct rtw_queue *pacl_node_q = &pacl_list->acl_node_q;
 
-	DBG_8723A("%s(acl_num =%d) =" MAC_FMT "\n", __func__, pacl_list->num, MAC_ARG(addr));
+	DBG_8723A("%s(acl_num =%d) =%pM\n", __func__, pacl_list->num, addr);
 
 	if ((NUM_ACL-1) < pacl_list->num)
 		return -1;
@@ -1476,8 +1480,8 @@ void bss_cap_update_on_sta_join23a(struct rtw_adapter *padapter, struct sta_info
 	if (psta->flags & WLAN_STA_HT) {
 		u16 ht_capab = le16_to_cpu(psta->htpriv.ht_cap.cap_info);
 
-		DBG_8723A("HT: STA " MAC_FMT " HT Capabilities Info: 0x%04x\n",
-				MAC_ARG(psta->hwaddr), ht_capab);
+		DBG_8723A("HT: STA %pM HT Capabilities Info: 0x%04x\n",
+			  psta->hwaddr, ht_capab);
 
 		if (psta->no_ht_set) {
 			psta->no_ht_set = 0;
@@ -1489,10 +1493,9 @@ void bss_cap_update_on_sta_join23a(struct rtw_adapter *padapter, struct sta_info
 				psta->no_ht_gf_set = 1;
 				pmlmepriv->num_sta_ht_no_gf++;
 			}
-			DBG_8723A("%s STA " MAC_FMT " - no "
-				   "greenfield, num of non-gf stations %d\n",
-				   __func__, MAC_ARG(psta->hwaddr),
-				   pmlmepriv->num_sta_ht_no_gf);
+			DBG_8723A("%s STA %pM - no greenfield, num of non-gf stations %d\n",
+				  __func__, psta->hwaddr,
+				  pmlmepriv->num_sta_ht_no_gf);
 		}
 
 		if ((ht_capab & IEEE80211_HT_CAP_SUP_WIDTH_20_40) == 0) {
@@ -1500,10 +1503,9 @@ void bss_cap_update_on_sta_join23a(struct rtw_adapter *padapter, struct sta_info
 				psta->ht_20mhz_set = 1;
 				pmlmepriv->num_sta_ht_20mhz++;
 			}
-			DBG_8723A("%s STA " MAC_FMT " - 20 MHz HT, "
-				   "num of 20MHz HT STAs %d\n",
-				   __func__, MAC_ARG(psta->hwaddr),
-				   pmlmepriv->num_sta_ht_20mhz);
+			DBG_8723A("%s STA %pM - 20 MHz HT, num of 20MHz HT STAs %d\n",
+				  __func__, psta->hwaddr,
+				  pmlmepriv->num_sta_ht_20mhz);
 		}
 
 	} else {
@@ -1512,10 +1514,9 @@ void bss_cap_update_on_sta_join23a(struct rtw_adapter *padapter, struct sta_info
 			pmlmepriv->num_sta_no_ht++;
 		}
 		if (pmlmepriv->htpriv.ht_option) {
-			DBG_8723A("%s STA " MAC_FMT
-				   " - no HT, num of non-HT stations %d\n",
-				   __func__, MAC_ARG(psta->hwaddr),
-				   pmlmepriv->num_sta_no_ht);
+			DBG_8723A("%s STA %pM - no HT, num of non-HT stations %d\n",
+				  __func__, psta->hwaddr,
+				  pmlmepriv->num_sta_no_ht);
 		}
 	}
 
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 7299ef0..78c05e3 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -238,9 +238,9 @@ static void _rtw_roaming(struct rtw_adapter *padapter,
 		pnetwork = &pmlmepriv->cur_network;
 
 	if (padapter->mlmepriv.to_roaming > 0) {
-		DBG_8723A("roaming from %s("MAC_FMT"), length:%d\n",
+		DBG_8723A("roaming from %s(%pM), length:%d\n",
 			  pnetwork->network.Ssid.ssid,
-			  MAC_ARG(pnetwork->network.MacAddress),
+			  pnetwork->network.MacAddress,
 			  pnetwork->network.Ssid.ssid_len);
 		memcpy(&pmlmepriv->assoc_ssid, &pnetwork->network.Ssid,
 		       sizeof(struct cfg80211_ssid));
@@ -754,8 +754,8 @@ void rtw_free_assoc_resources23a(struct rtw_adapter *adapter,
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_,
 		 ("+rtw_free_assoc_resources23a\n"));
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("tgt_network->network.MacAddress="MAC_FMT" ssid=%s\n",
-		  MAC_ARG(tgt_network->network.MacAddress),
+		 ("tgt_network->network.MacAddress=%pM ssid=%s\n",
+		  tgt_network->network.MacAddress,
 		  tgt_network->network.Ssid.ssid));
 
 	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE|WIFI_AP_STATE)) {
@@ -998,8 +998,9 @@ rtw_joinbss_update_network23a(struct rtw_adapter *padapter,
 	DBG_8723A("%s\n", __func__);
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("\nfw_state:%x, BSSID:"MAC_FMT"\n", get_fwstate(pmlmepriv),
-		  MAC_ARG(pnetwork->network.MacAddress)));
+		 ("\nfw_state:%x, BSSID:%pM\n",
+		  get_fwstate(pmlmepriv),
+		  pnetwork->network.MacAddress));
 
 	/*  why not use ptarget_wlan?? */
 	memcpy(&cur_network->network, &pnetwork->network,
@@ -1330,8 +1331,7 @@ void rtw_stadel_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 	else
 		mac_id = pstadel->mac_id;
 
-	DBG_8723A("%s(mac_id=%d)=" MAC_FMT "\n", __func__, mac_id,
-		  MAC_ARG(pstadel->macaddr));
+	DBG_8723A("%s(mac_id=%d)=%pM\n", __func__, mac_id, pstadel->macaddr);
 
 	if (check_fwstate(pmlmepriv, WIFI_AP_STATE))
 		return;
@@ -1582,13 +1582,12 @@ static int rtw_check_join_candidate(struct mlme_priv *pmlmepriv,
 	}
 
 	if (updated) {
-		DBG_8723A("[by_bssid:%u][assoc_ssid:%s][to_roaming:%u] "
-			  "new candidate: %s("MAC_FMT") rssi:%d\n",
+		DBG_8723A("[by_bssid:%u][assoc_ssid:%s][to_roaming:%u] new candidate: %s(%pM) rssi:%d\n",
 			  pmlmepriv->assoc_by_bssid,
 			  pmlmepriv->assoc_ssid.ssid,
 			  adapter->mlmepriv.to_roaming,
 			  (*candidate)->network.Ssid.ssid,
-			  MAC_ARG((*candidate)->network.MacAddress),
+			  (*candidate)->network.MacAddress,
 			  (int)(*candidate)->network.Rssi);
 	}
 
@@ -1739,9 +1738,10 @@ int rtw_select_and_join_from_scanned_queue23a(struct mlme_priv *pmlmepriv)
 		ret = _FAIL;
 		goto exit;
 	} else {
-		DBG_8723A("%s: candidate: %s("MAC_FMT", ch:%u)\n", __func__,
+		DBG_8723A("%s: candidate: %s(%pM, ch:%u)\n",
+			  __func__,
 			  candidate->network.Ssid.ssid,
-			  MAC_ARG(candidate->network.MacAddress),
+			  candidate->network.MacAddress,
 			  candidate->network.DSConfig);
 	}
 
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index d01ca1d..f4d847a 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -968,8 +968,7 @@ OnAuth23a(struct rtw_adapter *padapter, struct recv_frame *precv_frame)
 	pstat = rtw_get_stainfo23a(pstapriv, sa);
 	if (!pstat) {
 		/*  allocate a new one */
-		DBG_8723A("going to alloc stainfo for sa ="MAC_FMT"\n",
-			  MAC_ARG(sa));
+		DBG_8723A("going to alloc stainfo for sa =%pM\n", sa);
 		pstat = rtw_alloc_stainfo23a(pstapriv, sa, GFP_ATOMIC);
 		if (!pstat) {
 			DBG_8723A(" Exceed the upper limit of supported "
@@ -1396,8 +1395,8 @@ OnAssocReq23a(struct rtw_adapter *padapter, struct recv_frame *precv_frame)
 	/* now parse all ieee802_11 ie to point to elems */
 
 	if (rtw_validate_frame_ies(pos, left)) {
-		DBG_8723A("STA " MAC_FMT " sent invalid association request\n",
-			  MAC_ARG(pstat->hwaddr));
+		DBG_8723A("STA %pM sent invalid association request\n",
+			  pstat->hwaddr);
 		status = WLAN_STATUS_UNSPECIFIED_FAILURE;
 		goto OnAssocReq23aFail;
 	}
@@ -1407,8 +1406,8 @@ OnAssocReq23a(struct rtw_adapter *padapter, struct recv_frame *precv_frame)
 	p = cfg80211_find_ie(WLAN_EID_SSID, pos, left);
 	if (!p || p[1] == 0) {
 		/*  broadcast ssid, however it is not allowed in assocreq */
-		DBG_8723A("STA " MAC_FMT " sent invalid association request "
-			  "lacking an SSID\n", MAC_ARG(pstat->hwaddr));
+		DBG_8723A("STA %pM sent invalid association request lacking an SSID\n",
+			  pstat->hwaddr);
 		status = WLAN_STATUS_UNSPECIFIED_FAILURE;
 		goto OnAssocReq23aFail;
 	} else {
@@ -1537,9 +1536,8 @@ OnAssocReq23a(struct rtw_adapter *padapter, struct recv_frame *precv_frame)
 		int copy_len;
 
 		if (psecuritypriv->wpa_psk == 0) {
-			DBG_8723A("STA " MAC_FMT ": WPA/RSN IE in association "
-			"request, but AP don't support WPA/RSN\n",
-				  MAC_ARG(pstat->hwaddr));
+			DBG_8723A("STA %pM: WPA/RSN IE in association request, but AP don't support WPA/RSN\n",
+				  pstat->hwaddr);
 
 			status = WLAN_STATUS_INVALID_IE;
 
@@ -1645,8 +1643,8 @@ OnAssocReq23a(struct rtw_adapter *padapter, struct recv_frame *precv_frame)
 	if (pstat->flags & WLAN_STA_HT &&
 	    (pstat->wpa2_pairwise_cipher & WPA_CIPHER_TKIP ||
 	     pstat->wpa_pairwise_cipher & WPA_CIPHER_TKIP)) {
-		DBG_8723A("HT: " MAC_FMT " tried to use TKIP with HT "
-			  "association\n", MAC_ARG(pstat->hwaddr));
+		DBG_8723A("HT: %pM tried to use TKIP with HT association\n",
+			  pstat->hwaddr);
 
 		/* status = WLAN_STATUS_CIPHER_REJECTED_PER_POLICY; */
 		/* goto OnAssocReq23aFail; */
@@ -2806,17 +2804,16 @@ static int issue_probereq_ex(struct rtw_adapter *padapter,
 
 	if (try_cnt && wait_ms) {
 		if (da)
-			DBG_8723A("%s(%s): to "MAC_FMT", ch:%u%s, %d/%d "
-				  "in %u ms\n",	__func__,
-				  padapter->pnetdev->name,
-				  MAC_ARG(da), rtw_get_oper_ch23a(padapter),
-				  ret == _SUCCESS?", acked":"", i, try_cnt,
+			DBG_8723A("%s(%s): to %pM, ch:%u%s, %d/%d in %u ms\n",
+				  __func__, padapter->pnetdev->name,
+				  da, rtw_get_oper_ch23a(padapter),
+				  ret == _SUCCESS ? ", acked" : "", i, try_cnt,
 				  jiffies_to_msecs(jiffies - start));
 		else
 			DBG_8723A("%s(%s):, ch:%u%s, %d/%d in %u ms\n",
 				  __func__, padapter->pnetdev->name,
 				  rtw_get_oper_ch23a(padapter),
-				  ret == _SUCCESS?", acked":"", i, try_cnt,
+				  ret == _SUCCESS ? ", acked" : "", i, try_cnt,
 				  jiffies_to_msecs(jiffies - start));
 	}
 exit:
@@ -3460,17 +3457,16 @@ int issue_nulldata23a(struct rtw_adapter *padapter, unsigned char *da,
 
 	if (try_cnt && wait_ms) {
 		if (da)
-			DBG_8723A("%s(%s): to "MAC_FMT", ch:%u%s, %d/%d "
-				  "in %u ms\n", __func__,
-				  padapter->pnetdev->name,
-				  MAC_ARG(da), rtw_get_oper_ch23a(padapter),
-				  ret == _SUCCESS?", acked":"", i, try_cnt,
+			DBG_8723A("%s(%s): to %pM, ch:%u%s, %d/%d in %u ms\n",
+				  __func__, padapter->pnetdev->name,
+				  da, rtw_get_oper_ch23a(padapter),
+				  ret == _SUCCESS ? ", acked" : "", i, try_cnt,
 				  jiffies_to_msecs(jiffies - start));
 		else
 			DBG_8723A("%s(%s):, ch:%u%s, %d/%d in %u ms\n",
 				  __func__, padapter->pnetdev->name,
 				  rtw_get_oper_ch23a(padapter),
-				  ret == _SUCCESS?", acked":"", i, try_cnt,
+				  ret == _SUCCESS ? ", acked" : "", i, try_cnt,
 				  jiffies_to_msecs(jiffies - start));
 	}
 exit:
@@ -3587,17 +3583,16 @@ int issue_qos_nulldata23a(struct rtw_adapter *padapter, unsigned char *da,
 
 	if (try_cnt && wait_ms) {
 		if (da)
-			DBG_8723A("%s(%s): to "MAC_FMT", ch:%u%s, %d/%d "
-				  "in %u ms\n", __func__,
-				  padapter->pnetdev->name,
-				  MAC_ARG(da), rtw_get_oper_ch23a(padapter),
-				  ret == _SUCCESS?", acked":"", i, try_cnt,
+			DBG_8723A("%s(%s): to %pM, ch:%u%s, %d/%d in %u ms\n",
+				  __func__, padapter->pnetdev->name,
+				  da, rtw_get_oper_ch23a(padapter),
+				  ret == _SUCCESS ? ", acked" : "", i, try_cnt,
 				  jiffies_to_msecs(jiffies - start));
 		else
 			DBG_8723A("%s(%s):, ch:%u%s, %d/%d in %u ms\n",
 				  __func__, padapter->pnetdev->name,
 				  rtw_get_oper_ch23a(padapter),
-				  ret == _SUCCESS?", acked":"", i, try_cnt,
+				  ret == _SUCCESS ? ", acked" : "", i, try_cnt,
 				  jiffies_to_msecs(jiffies - start));
 	}
 exit:
@@ -3615,7 +3610,7 @@ static int _issue_deauth(struct rtw_adapter *padapter, unsigned char *da,
 	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
 	int ret = _FAIL;
 
-	/* DBG_8723A("%s to "MAC_FMT"\n", __func__, MAC_ARG(da)); */
+	/* DBG_8723A("%s to %pM\n", __func__, da); */
 
 	pmgntframe = alloc_mgtxmitframe23a(pxmitpriv);
 	if (!pmgntframe)
@@ -3660,7 +3655,7 @@ exit:
 int issue_deauth23a(struct rtw_adapter *padapter, unsigned char *da,
 		    unsigned short reason)
 {
-	DBG_8723A("%s to "MAC_FMT"\n", __func__, MAC_ARG(da));
+	DBG_8723A("%s to %pM\n", __func__, da);
 	return _issue_deauth(padapter, da, reason, false);
 }
 
@@ -3692,17 +3687,16 @@ static int issue_deauth_ex(struct rtw_adapter *padapter, u8 *da,
 
 	if (try_cnt && wait_ms) {
 		if (da)
-			DBG_8723A("%s(%s): to "MAC_FMT", ch:%u%s, %d/%d "
-				  "in %u ms\n", __func__,
-				  padapter->pnetdev->name,
-				  MAC_ARG(da), rtw_get_oper_ch23a(padapter),
-				  ret == _SUCCESS?", acked":"", i, try_cnt,
+			DBG_8723A("%s(%s): to %pM, ch:%u%s, %d/%d in %u ms\n",
+				  __func__, padapter->pnetdev->name,
+				  da, rtw_get_oper_ch23a(padapter),
+				  ret == _SUCCESS ? ", acked" : "", i, try_cnt,
 				  jiffies_to_msecs(jiffies - start));
 		else
 			DBG_8723A("%s(%s):, ch:%u%s, %d/%d in %u ms\n",
 				  __func__, padapter->pnetdev->name,
 				  rtw_get_oper_ch23a(padapter),
-				  ret == _SUCCESS?", acked":"", i, try_cnt,
+				  ret == _SUCCESS ? ", acked" : "", i, try_cnt,
 				  jiffies_to_msecs(jiffies - start));
 	}
 exit:
@@ -3719,8 +3713,8 @@ void issue_action_spct_ch_switch23a(struct rtw_adapter *padapter,
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 
-	DBG_8723A("%s(%s): ra ="MAC_FMT", ch:%u, offset:%u\n", __func__,
-		  padapter->pnetdev->name, MAC_ARG(ra), new_ch, ch_offset);
+	DBG_8723A("%s(%s): ra=%pM, ch:%u, offset:%u\n",
+		  __func__, padapter->pnetdev->name, ra, new_ch, ch_offset);
 
 	pmgntframe = alloc_mgtxmitframe23a(pxmitpriv);
 	if (!pmgntframe)
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 9c78300..9ce6d22 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -301,10 +301,7 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
 			 ("\n recvframe_chkmic:prxattrib->encrypt == WLAN_CIPHER_SUITE_TKIP\n"));
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-			 ("\n recvframe_chkmic:da = 0x%02x:0x%02x:0x%02x:0x%02x:"
-			  "0x%02x:0x%02x\n", prxattrib->ra[0],
-			  prxattrib->ra[1], prxattrib->ra[2], prxattrib->ra[3],
-			  prxattrib->ra[4], prxattrib->ra[5]));
+			 ("\n recvframe_chkmic:da = %pM\n", prxattrib->ra));
 
 		/* calculate mic code */
 		if (stainfo != NULL) {
@@ -406,12 +403,8 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 					  prxattrib->hdrlen));
 
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-					 ("ra = 0x%.2x 0x%.2x 0x%.2x 0x%.2x 0x%."
-					  "2x 0x%.2x psecuritypriv->"
-					  "binstallGrpkey =%d ",
-					  prxattrib->ra[0], prxattrib->ra[1],
-					  prxattrib->ra[2], prxattrib->ra[3],
-					  prxattrib->ra[4], prxattrib->ra[5],
+					 ("ra = %pM psecuritypriv->binstallGrpkey =%d ",
+					  prxattrib->ra,
 					  psecuritypriv->binstallGrpkey));
 
 				/*  double check key_index for some timing
@@ -887,8 +880,8 @@ int ap2sta_data_frame(struct rtw_adapter *adapter,
 		/*  da should be for me */
 		if (!ether_addr_equal(myhwaddr, pattrib->dst) && !bmcast) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-				(" ap2sta_data_frame:  compare DA fail; DA ="
-				 MAC_FMT"\n", MAC_ARG(pattrib->dst)));
+				 (" ap2sta_data_frame:  compare DA fail; DA=%pM\n",
+				  pattrib->dst));
 			ret = _FAIL;
 			goto exit;
 		}
@@ -898,15 +891,14 @@ int ap2sta_data_frame(struct rtw_adapter *adapter,
 		    ether_addr_equal(mybssid, "\x0\x0\x0\x0\x0\x0") ||
 		    !ether_addr_equal(pattrib->bssid, mybssid)) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-				(" ap2sta_data_frame:  compare BSSID fail ; "
-				 "BSSID ="MAC_FMT"\n", MAC_ARG(pattrib->bssid)));
+				(" ap2sta_data_frame:  compare BSSID fail ; BSSID=%pM\n",
+				 pattrib->bssid));
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-				 ("mybssid ="MAC_FMT"\n", MAC_ARG(mybssid)));
+				 ("mybssid=%pM\n", mybssid));
 
 			if (!bmcast) {
-				DBG_8723A("issue_deauth23a to the nonassociated "
-					  "ap =" MAC_FMT " for the reason(7)\n",
-					  MAC_ARG(pattrib->bssid));
+				DBG_8723A("issue_deauth23a to the nonassociated ap=%pM for the reason(7)\n",
+					  pattrib->bssid);
 				issue_deauth23a(adapter, pattrib->bssid,
 					     WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA);
 			}
@@ -964,9 +956,8 @@ int ap2sta_data_frame(struct rtw_adapter *adapter,
 		if (ether_addr_equal(myhwaddr, pattrib->dst) && !bmcast) {
 			*psta = rtw_get_stainfo23a(pstapriv, pattrib->bssid);
 			if (*psta == NULL) {
-				DBG_8723A("issue_deauth23a to the ap =" MAC_FMT
-					  " for the reason(7)\n",
-					  MAC_ARG(pattrib->bssid));
+				DBG_8723A("issue_deauth23a to the ap=%pM for the reason(7)\n",
+					  pattrib->bssid);
 
 				issue_deauth23a(adapter, pattrib->bssid,
 					     WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA);
@@ -1011,9 +1002,8 @@ int sta2ap_data_frame(struct rtw_adapter *adapter,
 		if (*psta == NULL) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
 				 ("can't get psta under AP_MODE; drop pkt\n"));
-			DBG_8723A("issue_deauth23a to sta =" MAC_FMT
-				  " for the reason(7)\n",
-				  MAC_ARG(pattrib->src));
+			DBG_8723A("issue_deauth23a to sta=%pM for the reason(7)\n",
+				  pattrib->src);
 
 			issue_deauth23a(adapter, pattrib->src,
 				     WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA);
@@ -1043,8 +1033,8 @@ int sta2ap_data_frame(struct rtw_adapter *adapter,
 			ret = RTW_RX_HANDLED;
 			goto exit;
 		}
-		DBG_8723A("issue_deauth23a to sta =" MAC_FMT " for the reason(7)\n",
-			  MAC_ARG(pattrib->src));
+		DBG_8723A("issue_deauth23a to sta=%pM for the reason(7)\n",
+			  pattrib->src);
 		issue_deauth23a(adapter, pattrib->src,
 			     WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA);
 		ret = RTW_RX_HANDLED;
diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
index 69d9e0f..829bba7 100644
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -876,9 +876,9 @@ int rtw_check_bcn_info23a(struct rtw_adapter *Adapter,
 	}
 
 	if (!ether_addr_equal(cur_network->network.MacAddress, mgmt->bssid)) {
-		DBG_8723A("%s: linked but recv other bssid bcn"
-			  MAC_FMT MAC_FMT "\n", __func__, MAC_ARG(mgmt->bssid),
-			  MAC_ARG(cur_network->network.MacAddress));
+		DBG_8723A("%s: linked but recv other bssid bcn %pM %pM\n",
+			  __func__, mgmt->bssid,
+			  cur_network->network.MacAddress);
 		return _FAIL;
 	}
 
diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
index 1c82dff..98602d9 100644
--- a/drivers/staging/rtl8723au/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
@@ -493,8 +493,8 @@ static int update_attrib(struct rtw_adapter *padapter,
 		psta = rtw_get_stainfo23a(pstapriv, pattrib->ra);
 		if (psta == NULL) { /*  if we cannot get psta => drrp the pkt */
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_alert_,
-				 ("\nupdate_attrib => get sta_info fail, ra:"
-				  MAC_FMT"\n", MAC_ARG(pattrib->ra)));
+				 ("\nupdate_attrib => get sta_info fail, ra:%pM\n",
+				  pattrib->ra));
 			res = _FAIL;
 			goto exit;
 		} else if (check_fwstate(pmlmepriv, WIFI_AP_STATE) &&
@@ -511,8 +511,8 @@ static int update_attrib(struct rtw_adapter *padapter,
 	} else {
 		/*  if we cannot get psta => drop the pkt */
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_alert_,
-			 ("\nupdate_attrib => get sta_info fail, ra:" MAC_FMT
-			  "\n", MAC_ARG(pattrib->ra)));
+			 ("\nupdate_attrib => get sta_info fail, ra:%pM\n",
+			  pattrib->ra));
 		res = _FAIL;
 		goto exit;
 	}
diff --git a/drivers/staging/rtl8723au/include/ieee80211.h b/drivers/staging/rtl8723au/include/ieee80211.h
index 3caf4f5..3aa40a3 100644
--- a/drivers/staging/rtl8723au/include/ieee80211.h
+++ b/drivers/staging/rtl8723au/include/ieee80211.h
@@ -251,9 +251,6 @@ join_res:
 > 0: TID
 */
 
-#define MAC_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
-#define MAC_ARG(x) ((u8*)(x))[0],((u8*)(x))[1],((u8*)(x))[2],((u8*)(x))[3],((u8*)(x))[4],((u8*)(x))[5]
-
 #define MAXTID	16
 
 #define WME_OUI_TYPE 2
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index 537bd82..f925170 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -1076,8 +1076,7 @@ static int cfg80211_rtw_get_station(struct wiphy *wiphy,
 		ret = -ENOENT;
 		goto exit;
 	}
-	DBG_8723A("%s(%s): mac =" MAC_FMT "\n", __func__, ndev->name,
-		  MAC_ARG(mac));
+	DBG_8723A("%s(%s): mac=%pM\n", __func__, ndev->name, mac);
 
 	/* for infra./P2PClient mode */
 	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE) &&
@@ -1085,8 +1084,8 @@ static int cfg80211_rtw_get_station(struct wiphy *wiphy,
 		struct wlan_network *cur_network = &pmlmepriv->cur_network;
 
 		if (!ether_addr_equal(mac, cur_network->network.MacAddress)) {
-			DBG_8723A("%s, mismatch bssid =" MAC_FMT "\n", __func__,
-				  MAC_ARG(cur_network->network.MacAddress));
+			DBG_8723A("%s, mismatch bssid=%pM\n",
+				  __func__, cur_network->network.MacAddress);
 			ret = -ENOENT;
 			goto exit;
 		}
@@ -1989,7 +1988,7 @@ static int cfg80211_rtw_connect(struct wiphy *wiphy, struct net_device *ndev,
 	DBG_8723A("ssid =%s, len =%zu\n", sme->ssid, sme->ssid_len);
 
 	if (sme->bssid)
-		DBG_8723A("bssid =" MAC_FMT "\n", MAC_ARG(sme->bssid));
+		DBG_8723A("bssid=%pM\n", sme->bssid);
 
 	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING)) {
 		ret = -EBUSY;
@@ -2523,8 +2522,8 @@ static int rtw_cfg80211_monitor_if_xmit_entry(struct sk_buff *skb,
 
 		mgmt = (struct ieee80211_mgmt *)dot11_hdr;
 
-		DBG_8723A("RTW_Tx:da =" MAC_FMT " via %s(%s)\n",
-			  MAC_ARG(mgmt->da), __func__, ndev->name);
+		DBG_8723A("RTW_Tx:da=%pM via %s(%s)\n",
+			  mgmt->da, __func__, ndev->name);
 		category = mgmt->u.action.category;
 		action = mgmt->u.action.u.wme_action.action_code;
 		DBG_8723A("RTW_Tx:category(%u), action(%u)\n",
@@ -2877,7 +2876,7 @@ static int cfg80211_rtw_del_station(struct wiphy *wiphy,
 		return ret;
 	}
 
-	DBG_8723A("free sta macaddr =" MAC_FMT "\n", MAC_ARG(mac));
+	DBG_8723A("free sta macaddr=%pM\n", mac);
 
 	if (is_broadcast_ether_addr(mac))
 		return -EINVAL;
@@ -3053,8 +3052,7 @@ static int cfg80211_rtw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	cfg80211_mgmt_tx_status(padapter->rtw_wdev, *cookie, buf, len, ack,
 				GFP_KERNEL);
 
-	DBG_8723A("RTW_Tx:tx_ch =%d, da =" MAC_FMT "\n", tx_ch,
-		  MAC_ARG(hdr->da));
+	DBG_8723A("RTW_Tx:tx_ch =%d, da =%pM\n", tx_ch, hdr->da);
 	category = hdr->u.action.category;
 	action = hdr->u.action.u.wme_action.action_code;
 	DBG_8723A("RTW_Tx:category(%u), action(%u)\n", category, action);
diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
index db6a1597..8f732d9 100644
--- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
@@ -594,8 +594,8 @@ static int _rtw_drv_register_netdev(struct rtw_adapter *padapter, char *name)
 		ret = _FAIL;
 		goto error_register_netdev;
 	}
-	DBG_8723A("%s, MAC Address (if%d) = " MAC_FMT "\n", __func__,
-		  (padapter->iface_id + 1), MAC_ARG(pnetdev->dev_addr));
+	DBG_8723A("%s, MAC Address (if%d) = %pM\n",
+		  __func__, padapter->iface_id + 1, pnetdev->dev_addr);
 	return ret;
 
 error_register_netdev:
@@ -666,8 +666,7 @@ int netdev_open23a(struct net_device *pnetdev)
 			goto netdev_open23a_error;
 		}
 
-		DBG_8723A("MAC Address = "MAC_FMT"\n",
-			  MAC_ARG(pnetdev->dev_addr));
+		DBG_8723A("MAC Address = %pM\n", pnetdev->dev_addr);
 
 		if (init_hw_mlme_ext23a(padapter) == _FAIL) {
 			DBG_8723A("can't init mlme_ext_priv\n");


