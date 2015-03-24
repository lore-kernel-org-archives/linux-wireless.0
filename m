Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:44715 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751899AbbCXXGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 19:06:54 -0400
Message-ID: <1427238404.12126.17.camel@perches.com> (sfid-20150325_000725_056002_9304E43D)
Subject: [PATCH] staging: rtl8723au: Update RT_TRACE macro and uses
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	LKML <linux-kernel@vger.kernel.org>
Date: Tue, 24 Mar 2015 16:06:44 -0700
In-Reply-To: <1427220609.5642.39.camel@perches.com>
References: <1427220609.5642.39.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create an rt_trace function using %pV to reduce overall code size.
Update the macro uses to remove unnecessary and now harmful parentheses.

Miscellanea around these changes:

o Coalesce formats
o Realign arguments
o Remove commented-out RT_TRACE uses
o Spelling fixes in formats
o Add missing newlines to formats
o Remove multiple newlines from formats
o Neaten formats where noticed
o Use %pM in one instance

Reduces code size ~20KB

Signed-off-by: Joe Perches <joe@perches.com>
---
Mostly done by various scripts&emacs.
Compiled, untested, no hardware,

 drivers/staging/rtl8723au/core/rtw_cmd.c           |  55 ++---
 drivers/staging/rtl8723au/core/rtw_efuse.c         |   3 -
 drivers/staging/rtl8723au/core/rtw_ieee80211.c     |  64 +++---
 drivers/staging/rtl8723au/core/rtw_mlme.c          | 134 ++++++-----
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c      |  24 +-
 drivers/staging/rtl8723au/core/rtw_pwrctrl.c       |  29 ++-
 drivers/staging/rtl8723au/core/rtw_recv.c          | 244 ++++++++++-----------
 drivers/staging/rtl8723au/core/rtw_security.c      |  58 +++--
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c       |  16 +-
 drivers/staging/rtl8723au/core/rtw_wlan_util.c     |  29 ++-
 drivers/staging/rtl8723au/core/rtw_xmit.c          | 181 +++++++--------
 drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c       |  38 ++--
 drivers/staging/rtl8723au/hal/hal_com.c            |  12 -
 drivers/staging/rtl8723au/hal/odm_debug.c          |  15 ++
 .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    |  19 +-
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c  | 124 +++++------
 drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c    |  93 +-------
 drivers/staging/rtl8723au/hal/rtl8723au_recv.c     |   2 +-
 drivers/staging/rtl8723au/hal/rtl8723au_xmit.c     |  16 +-
 drivers/staging/rtl8723au/hal/usb_halinit.c        |  40 ++--
 drivers/staging/rtl8723au/hal/usb_ops_linux.c      |  52 ++---
 drivers/staging/rtl8723au/include/rtw_debug.h      |  11 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |  91 ++++----
 drivers/staging/rtl8723au/os_dep/os_intfs.c        |  44 ++--
 drivers/staging/rtl8723au/os_dep/recv_linux.c      |  16 +-
 drivers/staging/rtl8723au/os_dep/usb_intf.c        |  30 +--
 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c   |  31 ++-
 drivers/staging/rtl8723au/os_dep/xmit_linux.c      |  12 +-
 28 files changed, 661 insertions(+), 822 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index f6b99d8..46aea16 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -299,9 +299,8 @@ post_process:
 		pcmd_callback =	rtw_cmd_callback[pcmd->cmdcode].callback;
 		if (!pcmd_callback) {
 			RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_,
-				 ("mlme_cmd_hdl(): pcmd_callback = 0x%p, "
-				  "cmdcode = 0x%x\n",
-				  pcmd_callback, pcmd->cmdcode));
+				 "mlme_cmd_hdl(): pcmd_callback = 0x%p, cmdcode = 0x%x\n",
+				 pcmd_callback, pcmd->cmdcode);
 			rtw_free_cmd_obj23a(pcmd);
 		} else {
 			/* need consider that free cmd_obj in
@@ -310,8 +309,8 @@ post_process:
 		}
 	} else {
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-			 ("%s: cmdcode = 0x%x callback not defined!\n",
-			  __func__, pcmd->cmdcode));
+			 "%s: cmdcode = 0x%x callback not defined!\n",
+			 __func__, pcmd->cmdcode);
 		rtw_free_cmd_obj23a(pcmd);
 	}
 }
@@ -343,7 +342,7 @@ int rtw_sitesurvey_cmd23a(struct rtw_adapter *padapter,
 	rtw_free_network_queue23a(padapter);
 
 	RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_,
-		 ("%s: flush network queue\n", __func__));
+		 "%s: flush network queue\n", __func__);
 
 	init_h2fwcmd_w_parm_no_rsp(ph2c, psurveyPara,
 				   GEN_CMD_CODE(_SiteSurvey));
@@ -412,12 +411,12 @@ int rtw_createbss_cmd23a(struct rtw_adapter  *padapter)
 
 	if (pmlmepriv->assoc_ssid.ssid_len == 0) {
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_,
-			 (" createbss for Any SSid:%s\n",
-			  pmlmepriv->assoc_ssid.ssid));
+			 "createbss for Any SSid:%s\n",
+			 pmlmepriv->assoc_ssid.ssid);
 	} else {
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_,
-			 (" createbss for SSid:%s\n",
-			  pmlmepriv->assoc_ssid.ssid));
+			 "createbss for SSid:%s\n",
+			 pmlmepriv->assoc_ssid.ssid);
 	}
 
 	pcmd = kzalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
@@ -460,19 +459,18 @@ int rtw_joinbss_cmd23a(struct rtw_adapter *padapter,
 
 	if (pmlmepriv->assoc_ssid.ssid_len == 0) {
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_,
-			 ("+Join cmd: Any SSid\n"));
+			 "+Join cmd: Any SSid\n");
 	} else {
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_notice_,
-			 ("+Join cmd: SSid =[%s]\n",
-			  pmlmepriv->assoc_ssid.ssid));
+			 "+Join cmd: SSid =[%s]\n",
+			 pmlmepriv->assoc_ssid.ssid);
 	}
 
 	pcmd = kzalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (!pcmd) {
 		res = _FAIL;
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-			 ("rtw_joinbss_cmd23a: memory allocate for cmd_obj "
-			  "fail!!!\n"));
+			 "rtw_joinbss_cmd23a: memory allocate for cmd_obj fail!!!\n");
 		goto exit;
 	}
 
@@ -497,7 +495,7 @@ int rtw_joinbss_cmd23a(struct rtw_adapter *padapter,
 		res = _FAIL;
 
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-			 ("rtw_joinbss_cmd23a :psecnetwork == NULL!!!\n"));
+			 "rtw_joinbss_cmd23a :psecnetwork == NULL!!!\n");
 
 		goto exit;
 	}
@@ -599,7 +597,7 @@ int rtw_disassoc_cmd23a(struct rtw_adapter *padapter, u32 deauth_timeout_ms,
 	int res = _SUCCESS;
 
 	RT_TRACE(_module_rtl871x_cmd_c_, _drv_notice_,
-		 ("+rtw_disassoc_cmd23a\n"));
+		 "+rtw_disassoc_cmd23a\n");
 
 	/* prepare cmd parameter */
 	param = kzalloc(sizeof(*param), GFP_ATOMIC);
@@ -1291,8 +1289,7 @@ void rtw_survey_cmd_callback23a(struct rtw_adapter *padapter,
 		mod_timer(&pmlmepriv->scan_to_timer,
 			  jiffies + msecs_to_jiffies(1));
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-			 ("\n ********Error: MgntActrtw_set_802_11_bssid23a_"
-			  "LIST_SCAN Fail ************\n\n."));
+			 "********Error: MgntActrtw_set_802_11_bssid23a_LIST_SCAN Fail ************\n");
 	}
 
 	/*  free cmd */
@@ -1309,7 +1306,7 @@ void rtw_disassoc_cmd23a_callback(struct rtw_adapter *padapter,
 		set_fwstate(pmlmepriv, _FW_LINKED);
 		spin_unlock_bh(&pmlmepriv->lock);
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-			 ("\n ***Error: disconnect_cmd_callback Fail ***\n."));
+			 "***Error: disconnect_cmd_callback Fail ***\n");
 		return;
 	}
 
@@ -1329,8 +1326,7 @@ void rtw_joinbss_cmd23a_callback(struct rtw_adapter *padapter,
 			  jiffies + msecs_to_jiffies(1));
 	} else if (pcmd->res != H2C_SUCCESS) {
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-			 ("********Error:rtw_select_and_join_from_scanned_"
-			  "queue Wait Sema  Fail ************\n"));
+			 "********Error:rtw_select_and_join_from_scanned_queue Wait Sema  Fail ************\n");
 		mod_timer(&pmlmepriv->assoc_timer,
 			  jiffies + msecs_to_jiffies(1));
 	}
@@ -1349,8 +1345,7 @@ void rtw_createbss_cmd23a_callback(struct rtw_adapter *padapter,
 
 	if (pcmd->res != H2C_SUCCESS) {
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-			 ("\n ********Error: rtw_createbss_cmd23a_callback  "
-			  "Fail ************\n\n."));
+			 "********Error: rtw_createbss_cmd23a_callback  Fail ************\n");
 		mod_timer(&pmlmepriv->assoc_timer,
 			  jiffies + msecs_to_jiffies(1));
 	}
@@ -1366,8 +1361,7 @@ void rtw_createbss_cmd23a_callback(struct rtw_adapter *padapter,
 						    GFP_KERNEL);
 			if (!psta) {
 				RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-					 ("\nCan't alloc sta_info when "
-					  "createbss_cmd_callback\n"));
+					 "Can't alloc sta_info when createbss_cmd_callback\n");
 				goto createbss_cmd_fail;
 			}
 		}
@@ -1382,8 +1376,7 @@ void rtw_createbss_cmd23a_callback(struct rtw_adapter *padapter,
 			pwlan = rtw_get_oldest_wlan_network23a(&pmlmepriv->scanned_queue);
 			if (!pwlan) {
 				RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-					 ("\n Error:  can't get pwlan in "
-					  "rtw23a_joinbss_event_cb\n"));
+					 "Error:  can't get pwlan in rtw23a_joinbss_event_cb\n");
 				spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 				goto createbss_cmd_fail;
 			}
@@ -1432,8 +1425,7 @@ void rtw_setstaKey_cmdrsp_callback23a(struct rtw_adapter *padapter,
 
 	if (!psta) {
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-			 ("\nERROR: rtw_setstaKey_cmdrsp_callback23a => "
-			  "can't get sta_info\n\n"));
+			 "ERROR: rtw_setstaKey_cmdrsp_callback23a => can't get sta_info\n");
 		goto exit;
 	}
 
@@ -1457,8 +1449,7 @@ void rtw_setassocsta_cmdrsp_callback23a(struct rtw_adapter *padapter,
 
 	if (psta == NULL) {
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-			 ("\nERROR: setassocsta_cmdrsp_callbac => can't "
-			  "get sta_info\n\n"));
+			 "ERROR: setassocsta_cmdrsp_callbac => can't get sta_info\n");
 		goto exit;
 	}
 
diff --git a/drivers/staging/rtl8723au/core/rtw_efuse.c b/drivers/staging/rtl8723au/core/rtw_efuse.c
index 29fc25b..92a34db 100644
--- a/drivers/staging/rtl8723au/core/rtw_efuse.c
+++ b/drivers/staging/rtl8723au/core/rtw_efuse.c
@@ -335,7 +335,6 @@ EFUSE_Write1Byte(struct rtw_adapter *Adapter, u16 Address, u8 Value)
 	u32	k = 0;
 	u16	contentLen = 0;
 
-	/* RT_TRACE(COMP_EFUSE, DBG_LOUD, ("Addr =%x Data =%x\n", Address, Value)); */
 	EFUSE_GetEfuseDefinition23a(Adapter, EFUSE_WIFI,
 				 TYPE_EFUSE_REAL_CONTENT_LEN,
 				 (void *)&contentLen);
@@ -404,8 +403,6 @@ efuse_OneByteWrite23a(struct rtw_adapter *pAdapter, u16 addr, u8 data)
 	u8	tmpidx = 0;
 	int	bResult;
 
-	/* RT_TRACE(COMP_EFUSE, DBG_LOUD, ("Addr = %x Data =%x\n", addr, data)); */
-
 	/* return	0; */
 
 	/*  -----------------e-fuse reg ctrl --------------------------------- */
diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
index bbbcfc8..cdd7bc4 100644
--- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
@@ -472,8 +472,8 @@ int rtw_parse_wpa_ie23a(const u8* wpa_ie, int wpa_ie_len, int *group_cipher, int
 		left -= WPA_SELECTOR_LEN;
 	} else if (left > 0) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("%s: ie length mismatch, %u too much",
-			  __func__, left));
+			 "%s: ie length mismatch, %u too much\n",
+			 __func__, left);
 
 		return _FAIL;
 	}
@@ -487,9 +487,8 @@ int rtw_parse_wpa_ie23a(const u8* wpa_ie, int wpa_ie_len, int *group_cipher, int
 
 		if (count == 0 || left < count * WPA_SELECTOR_LEN) {
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-				 ("%s: ie count botch (pairwise), "
-				  "count %u left %u", __func__,
-				  count, left));
+				 "%s: ie count botch (pairwise), count %u left %u\n",
+				 __func__, count, left);
 			return _FAIL;
 		}
 
@@ -501,7 +500,7 @@ int rtw_parse_wpa_ie23a(const u8* wpa_ie, int wpa_ie_len, int *group_cipher, int
 		}
 	} else if (left == 1) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("%s: ie too short (for key mgmt)", __func__));
+			 "%s: ie too short (for key mgmt)\n", __func__);
 		return _FAIL;
 	}
 
@@ -510,8 +509,8 @@ int rtw_parse_wpa_ie23a(const u8* wpa_ie, int wpa_ie_len, int *group_cipher, int
 			pos += 2;
 			if (!memcmp(pos, RTW_WPA_OUI23A_TYPE, 4)) {
 				RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-					 ("%s : there has 802.1x auth\n",
-					  __func__));
+					 "%s : there has 802.1x auth\n",
+					 __func__);
 				*is_8021x = 1;
 			}
 		}
@@ -549,8 +548,8 @@ int rtw_parse_wpa2_ie23a(const u8 *rsn_ie, int rsn_ie_len, int *group_cipher,
 		left -= RSN_SELECTOR_LEN;
 	} else if (left > 0) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("%s: ie length mismatch, %u too much",
-			  __func__, left));
+			 "%s: ie length mismatch, %u too much\n",
+			 __func__, left);
 		return _FAIL;
 	}
 
@@ -563,9 +562,8 @@ int rtw_parse_wpa2_ie23a(const u8 *rsn_ie, int rsn_ie_len, int *group_cipher,
 
 		if (count == 0 || left < count * RSN_SELECTOR_LEN) {
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-				 ("%s: ie count botch (pairwise), "
-				  "count %u left %u",
-				  __func__, count, left));
+				 "%s: ie count botch (pairwise), count %u left %u\n",
+				 __func__, count, left);
 			return _FAIL;
 		}
 
@@ -577,7 +575,7 @@ int rtw_parse_wpa2_ie23a(const u8 *rsn_ie, int rsn_ie_len, int *group_cipher,
 		}
 	} else if (left == 1) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("%s: ie too short (for key mgmt)",  __func__));
+			 "%s: ie too short (for key mgmt)\n",  __func__);
 
 		return _FAIL;
 	}
@@ -587,8 +585,8 @@ int rtw_parse_wpa2_ie23a(const u8 *rsn_ie, int rsn_ie_len, int *group_cipher,
 			pos += 2;
 			if (!memcmp(pos, SUITE_1X, 4)) {
 				RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-					 ("%s (): there has 802.1x auth\n",
-					  __func__));
+					 "%s (): there has 802.1x auth\n",
+					 __func__);
 				*is_8021x = 1;
 			}
 		}
@@ -700,7 +698,7 @@ static int rtw_get_cipher_info(struct wlan_network *pnetwork)
 
 	if (pbuf && pbuf[1] > 0) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-			 ("rtw_get_cipher_info: wpa_ielen: %d", pbuf[1]));
+			 "rtw_get_cipher_info: wpa_ielen: %d\n", pbuf[1]);
 		r = rtw_parse_wpa_ie23a(pbuf, pbuf[1] + 2, &group_cipher,
 				     &pairwise_cipher, &is8021x);
 		if (r == _SUCCESS) {
@@ -708,10 +706,9 @@ static int rtw_get_cipher_info(struct wlan_network *pnetwork)
 			pnetwork->BcnInfo.group_cipher = group_cipher;
 			pnetwork->BcnInfo.is_8021x = is8021x;
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-				 ("%s: pnetwork->pairwise_cipher: %d, is_"
-				  "8021x is %d", __func__,
-				  pnetwork->BcnInfo.pairwise_cipher,
-				  pnetwork->BcnInfo.is_8021x));
+				 "%s: pnetwork->pairwise_cipher: %d, is_8021x is %d\n",
+				 __func__, pnetwork->BcnInfo.pairwise_cipher,
+				 pnetwork->BcnInfo.is_8021x);
 			ret = _SUCCESS;
 		}
 	} else {
@@ -719,24 +716,23 @@ static int rtw_get_cipher_info(struct wlan_network *pnetwork)
 
 		if (pbuf && pbuf[1] > 0) {
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-				 ("get RSN IE\n"));
+				 "get RSN IE\n");
 			r = rtw_parse_wpa2_ie23a(pbuf, pbuf[1] + 2,
 					      &group_cipher, &pairwise_cipher,
 					      &is8021x);
 			if (r == _SUCCESS) {
 				RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-					 ("get RSN IE  OK!!!\n"));
+					 "get RSN IE  OK!!!\n");
 				pnetwork->BcnInfo.pairwise_cipher =
 					pairwise_cipher;
 				pnetwork->BcnInfo.group_cipher = group_cipher;
 				pnetwork->BcnInfo.is_8021x = is8021x;
 				RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-					 ("%s: pnetwork->pairwise_cipher: %d,"
-					  "pnetwork->group_cipher is %d, "
-					  "is_8021x is %d", __func__,
-					  pnetwork->BcnInfo.pairwise_cipher,
-					  pnetwork->BcnInfo.group_cipher,
-					  pnetwork->BcnInfo.is_8021x));
+					 "%s: pnetwork->pairwise_cipher: %d,pnetwork->group_cipher is %d, is_8021x is %d\n",
+					 __func__,
+					 pnetwork->BcnInfo.pairwise_cipher,
+					 pnetwork->BcnInfo.group_cipher,
+					 pnetwork->BcnInfo.is_8021x);
 				ret = _SUCCESS;
 			}
 		}
@@ -759,7 +755,7 @@ void rtw_get_bcn_info23a(struct wlan_network *pnetwork)
 		pnetwork->BcnInfo.encryp_protocol = ENCRYP_PROTOCOL_OPENSYS;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("%s: ssid =%s\n", __func__, pnetwork->network.Ssid.ssid));
+		 "%s: ssid =%s\n", __func__, pnetwork->network.Ssid.ssid);
 
 	pie = pnetwork->network.IEs;
 	pie_len = pnetwork->network.IELength;
@@ -776,11 +772,11 @@ void rtw_get_bcn_info23a(struct wlan_network *pnetwork)
 			pnetwork->BcnInfo.encryp_protocol = ENCRYP_PROTOCOL_WEP;
 	}
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("%s: pnetwork->encryp_protocol is %x\n", __func__,
-		  pnetwork->BcnInfo.encryp_protocol));
+		 "%s: pnetwork->encryp_protocol is %x\n", __func__,
+		 pnetwork->BcnInfo.encryp_protocol);
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("%s: pnetwork->encryp_protocol is %x\n", __func__,
-		  pnetwork->BcnInfo.encryp_protocol));
+		 "%s: pnetwork->encryp_protocol is %x\n", __func__,
+		 pnetwork->BcnInfo.encryp_protocol);
 	rtw_get_cipher_info(pnetwork);
 
 	/* get bwmode and ch_offset */
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 78c05e3..b6660d9 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -94,7 +94,7 @@ void rtw23a_free_mlme_priv_ie_data(struct mlme_priv *pmlmepriv)
 void rtw_free_mlme_priv23a(struct mlme_priv *pmlmepriv)
 {
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-		 ("rtw_free_mlme_priv23a\n"));
+		 "rtw_free_mlme_priv23a\n");
 
 	rtw23a_free_mlme_priv_ie_data(pmlmepriv);
 }
@@ -196,9 +196,8 @@ int rtw_if_up23a(struct rtw_adapter *padapter)
 	if (padapter->bDriverStopped || padapter->bSurpriseRemoved ||
 	    !check_fwstate(&padapter->mlmepriv, _FW_LINKED)) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-			 ("rtw_if_up23a:bDriverStopped(%d) OR "
-			  "bSurpriseRemoved(%d)", padapter->bDriverStopped,
-			  padapter->bSurpriseRemoved));
+			 "rtw_if_up23a:bDriverStopped(%d) OR bSurpriseRemoved(%d)\n",
+			 padapter->bDriverStopped, padapter->bSurpriseRemoved);
 		res = false;
 	} else
 		res =  true;
@@ -466,7 +465,7 @@ static void rtw_update_scanned_network(struct rtw_adapter *adapter,
 		if (!pnetwork) {
 			if (!oldest) {
 				RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-					 ("\n\n\nsomething wrong here\n\n\n"));
+					 "something wrong here\n");
 				goto exit;
 			}
 			pnetwork = oldest;
@@ -572,7 +571,7 @@ static int rtw_is_desired_network(struct rtw_adapter *adapter,
 void rtw_atimdone_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 {
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-		 ("receive atimdone_evet\n"));
+		 "receive atimdone_evet\n");
 }
 
 void rtw_survey_event_cb23a(struct rtw_adapter *adapter, const u8 *pbuf)
@@ -585,13 +584,12 @@ void rtw_survey_event_cb23a(struct rtw_adapter *adapter, const u8 *pbuf)
 	pnetwork = survey->bss;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("rtw_survey_event_cb23a, ssid=%s\n", pnetwork->Ssid.ssid));
+		 "rtw_survey_event_cb23a, ssid=%s\n", pnetwork->Ssid.ssid);
 
 	len = get_wlan_bssid_ex_sz(pnetwork);
 	if (len > (sizeof(struct wlan_bssid_ex))) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("\n ****rtw_survey_event_cb23a: return a wrong "
-			  "bss ***\n"));
+			 "****rtw_survey_event_cb23a: return a wrong bss ***\n");
 		return;
 	}
 
@@ -599,8 +597,6 @@ void rtw_survey_event_cb23a(struct rtw_adapter *adapter, const u8 *pbuf)
 
 	/*  update IBSS_network 's timestamp */
 	if (check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE)) {
-		/* RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-		   "rtw_survey_event_cb23a : WIFI_ADHOC_MASTER_STATE\n\n"); */
 		if (ether_addr_equal(pmlmepriv->cur_network.network.MacAddress,
 				     pnetwork->MacAddress)) {
 			struct wlan_network *ibss_wlan;
@@ -660,8 +656,8 @@ rtw_surveydone_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 	}
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("rtw_surveydone_event_callback23a: fw_state:%x\n\n",
-		  get_fwstate(pmlmepriv)));
+		 "rtw_surveydone_event_callback23a: fw_state:%x\n",
+		 get_fwstate(pmlmepriv));
 
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY)) {
 		del_timer_sync(&pmlmepriv->scan_to_timer);
@@ -669,8 +665,8 @@ rtw_surveydone_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 		_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 	} else {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("nic status =%x, survey done event comes too late!\n",
-			  get_fwstate(pmlmepriv)));
+			 "nic status =%x, survey done event comes too late!\n",
+			 get_fwstate(pmlmepriv));
 	}
 
 	rtw_set_signal_stat_timer(&adapter->recvpriv);
@@ -725,7 +721,7 @@ static void free_scanqueue(struct mlme_priv *pmlmepriv)
 	struct rtw_queue *scan_queue = &pmlmepriv->scanned_queue;
 	struct list_head *plist, *phead, *ptemp;
 
-	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_, ("+free_scanqueue\n"));
+	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_, "+free_scanqueue\n");
 	spin_lock_bh(&scan_queue->lock);
 
 	phead = get_list_head(scan_queue);
@@ -752,11 +748,11 @@ void rtw_free_assoc_resources23a(struct rtw_adapter *adapter,
 	struct sta_info *psta;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_,
-		 ("+rtw_free_assoc_resources23a\n"));
+		 "+rtw_free_assoc_resources23a\n");
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("tgt_network->network.MacAddress=%pM ssid=%s\n",
-		  tgt_network->network.MacAddress,
-		  tgt_network->network.Ssid.ssid));
+		 "tgt_network->network.MacAddress=%pM ssid=%s\n",
+		 tgt_network->network.MacAddress,
+		 tgt_network->network.Ssid.ssid);
 
 	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE|WIFI_AP_STATE)) {
 		psta = rtw_get_stainfo23a(&adapter->stapriv,
@@ -788,7 +784,7 @@ void rtw_free_assoc_resources23a(struct rtw_adapter *adapter,
 		pwlan->fixed = false;
 	else
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("rtw_free_assoc_resources23a : pwlan== NULL\n"));
+			 "rtw_free_assoc_resources23a : pwlan== NULL\n");
 
 	if (check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) &&
 	    adapter->stapriv.asoc_sta_count == 1)
@@ -808,7 +804,7 @@ void rtw_indicate_connect23a(struct rtw_adapter *padapter)
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-		 ("+rtw_indicate_connect23a\n"));
+		 "+rtw_indicate_connect23a\n");
 
 	pmlmepriv->to_join = false;
 
@@ -828,8 +824,8 @@ void rtw_indicate_connect23a(struct rtw_adapter *padapter)
 	rtw_set_scan_deny(padapter, 3000);
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-		 ("-rtw_indicate_connect23a: fw_state=0x%08x\n",
-		  get_fwstate(pmlmepriv)));
+		 "-rtw_indicate_connect23a: fw_state=0x%08x\n",
+		 get_fwstate(pmlmepriv));
 }
 
 /*
@@ -840,7 +836,7 @@ void rtw_indicate_disconnect23a(struct rtw_adapter *padapter)
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-		 ("+rtw_indicate_disconnect23a\n"));
+		 "+rtw_indicate_disconnect23a\n");
 
 	_clr_fwstate_(pmlmepriv, _FW_UNDER_LINKING|WIFI_UNDER_WPS);
 
@@ -998,9 +994,9 @@ rtw_joinbss_update_network23a(struct rtw_adapter *padapter,
 	DBG_8723A("%s\n", __func__);
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("\nfw_state:%x, BSSID:%pM\n",
-		  get_fwstate(pmlmepriv),
-		  pnetwork->network.MacAddress));
+		 "fw_state:%x, BSSID:%pM\n",
+		 get_fwstate(pmlmepriv),
+		 pnetwork->network.MacAddress);
 
 	/*  why not use ptarget_wlan?? */
 	memcpy(&cur_network->network, &pnetwork->network,
@@ -1043,7 +1039,7 @@ rtw_joinbss_update_network23a(struct rtw_adapter *padapter,
 	default:
 		pmlmepriv->fw_state = WIFI_NULL_STATE;
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("Invalid network_mode\n"));
+			 "Invalid network_mode\n");
 		break;
 	}
 
@@ -1078,16 +1074,16 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 	bool the_same_macaddr;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("joinbss event call back received with res=%d\n",
-		  pnetwork->join_res));
+		 "joinbss event call back received with res=%d\n",
+		 pnetwork->join_res);
 
 	if (pmlmepriv->assoc_ssid.ssid_len == 0) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("@@@@@   joinbss event call back  for Any SSid\n"));
+			 "@@@@@   joinbss event call back  for Any SSid\n");
 	} else {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("@@@@@   rtw23a_joinbss_event_cb for SSid:%s\n",
-			  pmlmepriv->assoc_ssid.ssid));
+			 "@@@@@   rtw23a_joinbss_event_cb for SSid:%s\n",
+			 pmlmepriv->assoc_ssid.ssid);
 	}
 
 	if (ether_addr_equal(pnetwork->network.MacAddress,
@@ -1099,15 +1095,14 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 	pnetwork->network.Length = get_wlan_bssid_ex_sz(&pnetwork->network);
 	if (pnetwork->network.Length > sizeof(struct wlan_bssid_ex)) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("\n\n ***joinbss_evt_callback return a wrong bss "
-			  "***\n\n"));
+			 "***joinbss_evt_callback return a wrong bss ***\n");
 		return;
 	}
 
 	spin_lock_bh(&pmlmepriv->lock);
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("\n rtw23a_joinbss_event_cb !! _enter_critical\n"));
+		 "rtw23a_joinbss_event_cb !! _enter_critical\n");
 
 	if (pnetwork->join_res > 0) {
 		spin_lock_bh(&pmlmepriv->scanned_queue.lock);
@@ -1156,8 +1151,7 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 							      pnetwork);
 			else {
 				RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-					 ("Can't find ptarget_wlan when "
-					  "joinbss_event callback\n"));
+					 "Can't find ptarget_wlan when joinbss_event callback\n");
 				spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 				goto ignore_joinbss_callback;
 			}
@@ -1170,8 +1164,7 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 				if (!ptarget_sta) {
 					RT_TRACE(_module_rtl871x_mlme_c_,
 						 _drv_err_,
-						 ("Can't update stainfo when "
-						  "joinbss_event callback\n"));
+						 "Can't update stainfo when joinbss_event callback\n");
 					spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 					goto ignore_joinbss_callback;
 				}
@@ -1184,19 +1177,19 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 				/* adhoc mode will rtw_indicate_connect23a
 				   when rtw_stassoc_event_callback23a */
 				RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-					 ("adhoc mode, fw_state:%x",
-					  get_fwstate(pmlmepriv)));
+					 "adhoc mode, fw_state:%x\n",
+					 get_fwstate(pmlmepriv));
 			}
 
 			/* s5. Cancle assoc_timer */
 			del_timer_sync(&pmlmepriv->assoc_timer);
 
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-				 ("Cancle assoc_timer\n"));
+				 "Cancle assoc_timer\n");
 		} else {
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-				 ("rtw23a_joinbss_event_cb err: fw_state:%x",
-				 get_fwstate(pmlmepriv)));
+				 "rtw23a_joinbss_event_cb err: fw_state:%x\n",
+				 get_fwstate(pmlmepriv));
 			spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 			goto ignore_joinbss_callback;
 		}
@@ -1210,8 +1203,8 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 
 		if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING)) {
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-				 ("fail! clear _FW_UNDER_LINKING ^^^fw_state="
-				  "%x\n", get_fwstate(pmlmepriv)));
+				 "fail! clear _FW_UNDER_LINKING ^^^fw_state=%x\n",
+				 get_fwstate(pmlmepriv));
 			_clr_fwstate_(pmlmepriv, _FW_UNDER_LINKING);
 		}
 	} else {
@@ -1262,8 +1255,7 @@ void rtw_stassoc_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 	if (psta != NULL) {
 		/* the sta have been in sta_info_queue => do nothing */
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("Error: rtw_stassoc_event_callback23a: sta has "
-			  "been in sta_hash_queue\n"));
+			 "Error: rtw_stassoc_event_callback23a: sta has been in sta_hash_queue\n");
 		/* between drv has received this event before and
 		   fw have not yet to set key to CAM_ENTRY) */
 		return;
@@ -1273,8 +1265,7 @@ void rtw_stassoc_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 		GFP_KERNEL);
 	if (!psta) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("Can't alloc sta_info when "
-			  "rtw_stassoc_event_callback23a\n"));
+			 "Can't alloc sta_info when rtw_stassoc_event_callback23a\n");
 		return;
 	}
 
@@ -1652,8 +1643,8 @@ rtw_select_candidate_from_queue(struct mlme_priv *pmlmepriv)
 		pnetwork = container_of(plist, struct wlan_network, list);
 		if (!pnetwork) {
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-				 ("%s: return _FAIL:(pnetwork == NULL)\n",
-				  __func__));
+				 "%s: return _FAIL:(pnetwork == NULL)\n",
+				 __func__);
 			goto exit;
 		}
 
@@ -1679,7 +1670,7 @@ int rtw_do_join_adhoc(struct rtw_adapter *adapter)
 	_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-		 ("switching to adhoc master\n"));
+		 "switching to adhoc master\n");
 
 	memcpy(&pdev_network->Ssid, &pmlmepriv->assoc_ssid,
 	       sizeof(struct cfg80211_ssid));
@@ -1692,7 +1683,7 @@ int rtw_do_join_adhoc(struct rtw_adapter *adapter)
 	ret = rtw_createbss_cmd23a(adapter);
 	if (ret != _SUCCESS) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("Error =>rtw_createbss_cmd23a status FAIL\n"));
+			 "Error =>rtw_createbss_cmd23a status FAIL\n");
 	} else  {
 		pmlmepriv->to_join = false;
 	}
@@ -1781,8 +1772,8 @@ int rtw_set_auth23a(struct rtw_adapter *adapter,
 	pcmd->rspsz = 0;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-		 ("after enqueue set_auth_cmd, auth_mode=%x\n",
-		  psecuritypriv->dot11AuthAlgrthm));
+		 "after enqueue set_auth_cmd, auth_mode=%x\n",
+		 psecuritypriv->dot11AuthAlgrthm);
 
 	res = rtw_enqueue_cmd23a(pcmdpriv, pcmd);
 
@@ -1822,15 +1813,13 @@ int rtw_set_key23a(struct rtw_adapter *adapter,
 		psetkeyparm->algorithm = (unsigned char)
 			psecuritypriv->dot118021XGrpPrivacy;
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("\n rtw_set_key23a: psetkeyparm->algorithm = "
-			  "(unsigned char)psecuritypriv->dot118021XGrpPrivacy "
-			  "=%d\n", psetkeyparm->algorithm));
+			 "rtw_set_key23a: psetkeyparm->algorithm = (unsigned char)psecuritypriv->dot118021XGrpPrivacy =%d\n",
+			 psetkeyparm->algorithm);
 	} else {
 		psetkeyparm->algorithm = (u8)psecuritypriv->dot11PrivacyAlgrthm;
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("\n rtw_set_key23a: psetkeyparm->algorithm = (u8)"
-			  "psecuritypriv->dot11PrivacyAlgrthm =%d\n",
-			  psetkeyparm->algorithm));
+			 "rtw_set_key23a: psetkeyparm->algorithm = (u8)psecuritypriv->dot11PrivacyAlgrthm =%d\n",
+			 psetkeyparm->algorithm);
 	}
 	psetkeyparm->keyid = keyid;/* 0~3 */
 	psetkeyparm->set_tx = set_tx;
@@ -1841,8 +1830,8 @@ int rtw_set_key23a(struct rtw_adapter *adapter,
 		  psetkeyparm->algorithm, psetkeyparm->keyid,
 		  pmlmepriv->key_mask);
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-		 ("\n rtw_set_key23a: psetkeyparm->algorithm =%d psetkeyparm->"
-		  "keyid = (u8)keyid =%d\n", psetkeyparm->algorithm, keyid));
+		 "rtw_set_key23a: psetkeyparm->algorithm =%d psetkeyparm->keyid = (u8)keyid =%d\n",
+		 psetkeyparm->algorithm, keyid);
 
 	switch (psetkeyparm->algorithm) {
 	case WLAN_CIPHER_SUITE_WEP40:
@@ -1869,9 +1858,8 @@ int rtw_set_key23a(struct rtw_adapter *adapter,
 		break;
 	default:
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("\n rtw_set_key23a:psecuritypriv->dot11PrivacyAlgrthm"
-			  " = %x (must be 1 or 2 or 4 or 5)\n",
-			  psecuritypriv->dot11PrivacyAlgrthm));
+			 "rtw_set_key23a:psecuritypriv->dot11PrivacyAlgrthm = %x (must be 1 or 2 or 4 or 5)\n",
+			 psecuritypriv->dot11PrivacyAlgrthm);
 		res = _FAIL;
 		kfree(pcmd);
 		kfree(psetkeyparm);
@@ -1998,8 +1986,8 @@ int rtw_restruct_sec_ie23a(struct rtw_adapter *adapter, u8 *in_ie, u8 *out_ie,
 	uint ndissecuritytype = psecuritypriv->ndisencryptstatus;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_,
-		 ("+rtw_restruct_sec_ie23a: ndisauthmode=%d "
-		  "ndissecuritytype=%d\n", ndisauthmode, ndissecuritytype));
+		 "+rtw_restruct_sec_ie23a: ndisauthmode=%d ndissecuritytype=%d\n",
+		 ndisauthmode, ndissecuritytype);
 
 	ielength = 0;
 	if (ndisauthmode == Ndis802_11AuthModeWPA ||
@@ -2065,8 +2053,8 @@ void rtw_update_registrypriv_dev_network23a(struct rtw_adapter *adapter)
 
 	pdev_network->DSConfig = pregistrypriv->channel;
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("pregistrypriv->channel =%d, pdev_network->DSConfig = 0x%x\n",
-		  pregistrypriv->channel, pdev_network->DSConfig));
+		 "pregistrypriv->channel =%d, pdev_network->DSConfig = 0x%x\n",
+		 pregistrypriv->channel, pdev_network->DSConfig);
 
 	if (cur_network->network.ifmode == NL80211_IFTYPE_ADHOC)
 		pdev_network->ATIMWindow = 0;
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index f4d847a..55fe47e 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -657,8 +657,8 @@ void mgt_dispatcher23a(struct rtw_adapter *padapter,
 
 	if (index > 13) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("Currently we do not support reserved sub-fr-type ="
-			  "%d\n", index));
+			 "Currently we do not support reserved sub-fr-type =%d\n",
+			 index);
 		return;
 	}
 	ptable += index;
@@ -2685,7 +2685,7 @@ static int _issue_probereq(struct rtw_adapter *padapter,
 	u8 bc_addr[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_,
-		 ("+%s\n", __func__));
+		 "+%s\n", __func__);
 
 	pmgntframe = alloc_mgtxmitframe23a(pxmitpriv);
 	if (!pmgntframe)
@@ -2756,7 +2756,7 @@ static int _issue_probereq(struct rtw_adapter *padapter,
 	pattrib->last_txcmdsz = pattrib->pktlen;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_,
-		 ("issuing probe_req, tx_len =%d\n", pattrib->last_txcmdsz));
+		 "issuing probe_req, tx_len =%d\n", pattrib->last_txcmdsz);
 
 	if (wait_ack) {
 		ret = dump_mgntframe23a_and_wait_ack23a(padapter, pmgntframe);
@@ -4341,7 +4341,8 @@ static void start_create_ibss(struct rtw_adapter *padapter)
 
 		/* issue beacon */
 		if (send_beacon23a(padapter) == _FAIL) {
-			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_, ("issuing beacon frame fail....\n"));
+			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
+				 "issuing beacon frame fail....\n");
 
 			report_join_res23a(padapter, -1);
 			pmlmeinfo->state = MSR_NOLINK;
@@ -4525,7 +4526,7 @@ static void process_80211d(struct rtw_adapter *padapter,
 
 		p += 3;
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_,
-			 ("%s: 802.11d country =%s\n", __func__, country));
+			 "%s: 802.11d country =%s\n", __func__, country);
 
 		i = 0;
 		while ((ie - p) >= 3) {
@@ -4702,9 +4703,8 @@ static void process_80211d(struct rtw_adapter *padapter,
 
 				chplan_new[i].ScanType = SCAN_ACTIVE;
 				RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_,
-					 ("%s: change channel %d scan type "
-					  "from passive to active\n",
-					  __func__, channel));
+					 "%s: change channel %d scan type from passive to active\n",
+					 __func__, channel);
 			}
 			break;
 		}
@@ -6060,7 +6060,7 @@ int mlme_evt_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
 	/*  checking if event code is valid */
 	if (evt_code >= MAX_C2HEVT) {
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-			 ("\nEvent Code(%d) mismatch!\n", evt_code));
+			 "Event Code(%d) mismatch!\n", evt_code);
 		goto _abort_event_;
 	}
 
@@ -6068,8 +6068,8 @@ int mlme_evt_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
 	if (wlanevents[evt_code].parmsize != 0 &&
 	    wlanevents[evt_code].parmsize != evt_sz) {
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-			 ("\nEvent(%d) Parm Size mismatch (%d vs %d)!\n",
-			  evt_code, wlanevents[evt_code].parmsize, evt_sz));
+			 "Event(%d) Parm Size mismatch (%d vs %d)!\n",
+			 evt_code, wlanevents[evt_code].parmsize, evt_sz);
 		goto _abort_event_;
 	}
 
diff --git a/drivers/staging/rtl8723au/core/rtw_pwrctrl.c b/drivers/staging/rtl8723au/core/rtw_pwrctrl.c
index e2d51af..7488a10 100644
--- a/drivers/staging/rtl8723au/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8723au/core/rtw_pwrctrl.c
@@ -202,17 +202,17 @@ void rtw_set_rpwm23a(struct rtw_adapter *padapter, u8 pslv)
 
 	if (pwrpriv->rpwm == pslv) {
 		RT_TRACE(_module_rtl871x_pwrctrl_c_, _drv_err_,
-			("%s: Already set rpwm[0x%02X], new = 0x%02X!\n",
-			 __func__, pwrpriv->rpwm, pslv));
+			 "%s: Already set rpwm[0x%02X], new = 0x%02X!\n",
+			 __func__, pwrpriv->rpwm, pslv);
 		return;
 	}
 
 	if (padapter->bSurpriseRemoved == true ||
 	    padapter->hw_init_completed == false) {
 		RT_TRACE(_module_rtl871x_pwrctrl_c_, _drv_err_,
-			 ("%s: SurpriseRemoved(%d) hw_init_completed(%d)\n",
-			  __func__, padapter->bSurpriseRemoved,
-			  padapter->hw_init_completed));
+			 "%s: SurpriseRemoved(%d) hw_init_completed(%d)\n",
+			 __func__, padapter->bSurpriseRemoved,
+			 padapter->hw_init_completed);
 
 		pwrpriv->cpwm = PS_STATE_S4;
 
@@ -221,22 +221,21 @@ void rtw_set_rpwm23a(struct rtw_adapter *padapter, u8 pslv)
 
 	if (padapter->bDriverStopped == true) {
 		RT_TRACE(_module_rtl871x_pwrctrl_c_, _drv_err_,
-			 ("%s: change power state(0x%02X) when DriverStopped\n",
-			  __func__, pslv));
+			 "%s: change power state(0x%02X) when DriverStopped\n",
+			 __func__, pslv);
 
 		if (pslv < PS_STATE_S2) {
 			RT_TRACE(_module_rtl871x_pwrctrl_c_, _drv_err_,
-				 ("%s: Reject to enter PS_STATE(0x%02X) lower "
-				  "than S2 when DriverStopped!!\n",
-				  __func__, pslv));
+				 "%s: Reject to enter PS_STATE(0x%02X) lower than S2 when DriverStopped!!\n",
+				 __func__, pslv);
 			return;
 		}
 	}
 
 	rpwm = pslv | pwrpriv->tog;
 	RT_TRACE(_module_rtl871x_pwrctrl_c_, _drv_notice_,
-		 ("rtw_set_rpwm23a: rpwm = 0x%02x cpwm = 0x%02x\n",
-		  rpwm, pwrpriv->cpwm));
+		 "rtw_set_rpwm23a: rpwm = 0x%02x cpwm = 0x%02x\n",
+		 rpwm, pwrpriv->cpwm);
 
 	pwrpriv->rpwm = pslv;
 
@@ -282,12 +281,12 @@ void rtw_set_ps_mode23a(struct rtw_adapter *padapter, u8 ps_mode,
 	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
 
 	RT_TRACE(_module_rtl871x_pwrctrl_c_, _drv_notice_,
-			 ("%s: PowerMode =%d Smart_PS =%d\n",
-			  __func__, ps_mode, smart_ps));
+		 "%s: PowerMode =%d Smart_PS =%d\n",
+		 __func__, ps_mode, smart_ps);
 
 	if (ps_mode > PM_Card_Disable) {
 		RT_TRACE(_module_rtl871x_pwrctrl_c_, _drv_err_,
-			 ("ps_mode:%d error\n", ps_mode));
+			 "ps_mode:%d error\n", ps_mode);
 		return;
 	}
 
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 9ce6d22..274a4b6 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -299,9 +299,9 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 
 	if (prxattrib->encrypt == WLAN_CIPHER_SUITE_TKIP) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-			 ("\n recvframe_chkmic:prxattrib->encrypt == WLAN_CIPHER_SUITE_TKIP\n"));
+			 "recvframe_chkmic:prxattrib->encrypt == WLAN_CIPHER_SUITE_TKIP\n");
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-			 ("\n recvframe_chkmic:da = %pM\n", prxattrib->ra));
+			 "recvframe_chkmic:da = %pM\n", prxattrib->ra);
 
 		/* calculate mic code */
 		if (stainfo != NULL) {
@@ -309,14 +309,13 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 				mickey = &psecuritypriv->dot118021XGrprxmickey[prxattrib->key_index].skey[0];
 
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-					 ("\n recvframe_chkmic: bcmc key\n"));
+					 "recvframe_chkmic: bcmc key\n");
 
 				if (!psecuritypriv->binstallGrpkey) {
 					res = _FAIL;
 					RT_TRACE(_module_rtl871x_recv_c_,
 						 _drv_err_,
-						 ("\n recvframe_chkmic:didn't "
-						  "install group key!!!!!!\n"));
+						 "recvframe_chkmic:didn't install group key!\n");
 					DBG_8723A("\n recvframe_chkmic:didn't "
 						  "install group key!!!!!!\n");
 					goto exit;
@@ -324,8 +323,7 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 			} else {
 				mickey = &stainfo->dot11tkiprxmickey.skey[0];
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-					 ("\n recvframe_chkmic: unicast "
-					  "key\n"));
+					 "recvframe_chkmic: unicast key\n");
 			}
 
 			/* icv_len included the mic code */
@@ -336,9 +334,8 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 				prxattrib->iv_len;
 
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-				 ("\n prxattrib->iv_len =%d prxattrib->icv_len ="
-				  "%d\n", prxattrib->iv_len,
-				  prxattrib->icv_len));
+				 "prxattrib->iv_len =%d prxattrib->icv_len =%d\n",
+				 prxattrib->iv_len, prxattrib->icv_len);
 
 			/* care the length of the data */
 			rtw_seccalctkipmic23a(mickey, pframe, payload,
@@ -353,10 +350,9 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 				if (miccode[i] != *(pframemic + i)) {
 					RT_TRACE(_module_rtl871x_recv_c_,
 						 _drv_err_,
-						 ("recvframe_chkmic:miccode"
-						  "[%d](%02x) != *(pframemic+"
-						  "%d)(%02x) ", i, miccode[i],
-						  i, *(pframemic + i)));
+						 "recvframe_chkmic:miccode[%d](%02x) != *(pframemic+%d)(%02x)\n",
+						 i, miccode[i],
+						 i, *(pframemic + i));
 					bmic_err = true;
 				}
 			}
@@ -365,47 +361,44 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 				int i;
 
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-					 ("\n *(pframemic-8)-*(pframemic-1) ="
-					  "0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:"
-					  "0x%02x:0x%02x:0x%02x\n",
-					  *(pframemic - 8), *(pframemic - 7),
-					  *(pframemic - 6), *(pframemic - 5),
-					  *(pframemic - 4), *(pframemic - 3),
-					  *(pframemic - 2), *(pframemic - 1)));
+					 "*(pframemic-8)-*(pframemic-1) =0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",
+					 *(pframemic - 8), *(pframemic - 7),
+					 *(pframemic - 6), *(pframemic - 5),
+					 *(pframemic - 4), *(pframemic - 3),
+					 *(pframemic - 2), *(pframemic - 1));
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-					 ("\n *(pframemic-16)-*(pframemic-9) ="
-					  "0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:"
-					  "0x%02x:0x%02x:0x%02x\n",
-					  *(pframemic - 16), *(pframemic - 15),
-					  *(pframemic - 14), *(pframemic - 13),
-					  *(pframemic - 12), *(pframemic - 11),
-					  *(pframemic - 10), *(pframemic - 9)));
+					 "*(pframemic-16)-*(pframemic-9) =0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",
+					 *(pframemic - 16), *(pframemic - 15),
+					 *(pframemic - 14), *(pframemic - 13),
+					 *(pframemic - 12), *(pframemic - 11),
+					 *(pframemic - 10), *(pframemic - 9));
 
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-					 ("\n ====== demp packet (len =%d) ======"
-					  "\n", precvframe->pkt->len));
+					 "====== demp packet (len =%d) ======\n",
+					 precvframe->pkt->len);
 				for (i = 0; i < precvframe->pkt->len; i = i + 8) {
 					RT_TRACE(_module_rtl871x_recv_c_,
-						 _drv_err_, ("0x%02x:0x%02x:0x"
-							    "%02x:0x%02x:0x%0"
-							    "2x:0x%02x:0x%02x"
-							    ":0x%02x",
-							    *(precvframe->pkt->data+i),*(precvframe->pkt->data+i+1),
-							    *(precvframe->pkt->data+i+2),*(precvframe->pkt->data+i+3),
-							    *(precvframe->pkt->data+i+4),*(precvframe->pkt->data+i+5),
-							    *(precvframe->pkt->data+i+6),*(precvframe->pkt->data+i+7)));
+						 _drv_err_,
+						 "0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",
+						 *(precvframe->pkt->data+i),
+						 *(precvframe->pkt->data+i+1),
+						 *(precvframe->pkt->data+i+2),
+						 *(precvframe->pkt->data+i+3),
+						 *(precvframe->pkt->data+i+4),
+						 *(precvframe->pkt->data+i+5),
+						 *(precvframe->pkt->data+i+6),
+						 *(precvframe->pkt->data+i+7));
 				}
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-					 ("\n ====== demp packet end [len =%d]"
-					  "======\n", precvframe->pkt->len));
+					 "====== demp packet end [len =%d]======\n",
+					 precvframe->pkt->len);
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-					 ("\n hrdlen =%d,\n",
-					  prxattrib->hdrlen));
+					 "hrdlen =%d\n", prxattrib->hdrlen);
 
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-					 ("ra = %pM psecuritypriv->binstallGrpkey =%d ",
-					  prxattrib->ra,
-					  psecuritypriv->binstallGrpkey));
+					 "ra = %pM psecuritypriv->binstallGrpkey =%d\n",
+					 prxattrib->ra,
+					 psecuritypriv->binstallGrpkey);
 
 				/*  double check key_index for some timing
 				    issue, cannot compare with
@@ -419,16 +412,17 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 				if ((prxattrib->bdecrypted == true) &&
 				    (brpt_micerror == true)) {
 					rtw_handle_tkip_mic_err23a(adapter, (u8)is_multicast_ether_addr(prxattrib->ra));
-					RT_TRACE(_module_rtl871x_recv_c_, _drv_err_, (" mic error :prxattrib->bdecrypted =%d ", prxattrib->bdecrypted));
+					RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
+						 "mic error :prxattrib->bdecrypted =%d\n",
+						 prxattrib->bdecrypted);
 					DBG_8723A(" mic error :prxattrib->"
 						  "bdecrypted =%d\n",
 						  prxattrib->bdecrypted);
 				} else {
 					RT_TRACE(_module_rtl871x_recv_c_,
 						 _drv_err_,
-						 (" mic error :prxattrib->"
-						  "bdecrypted =%d ",
-						  prxattrib->bdecrypted));
+						 "mic error :prxattrib->bdecrypted =%d\n",
+						 prxattrib->bdecrypted);
 					DBG_8723A(" mic error :prxattrib->"
 						  "bdecrypted =%d\n",
 						  prxattrib->bdecrypted);
@@ -442,14 +436,12 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 					psecuritypriv->bcheck_grpkey = 1;
 					RT_TRACE(_module_rtl871x_recv_c_,
 						 _drv_err_,
-						 ("psecuritypriv->bcheck_grp"
-						  "key = true"));
+						 "psecuritypriv->bcheck_grpkey = true\n");
 				}
 			}
 		} else {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("recvframe_chkmic: rtw_get_stainfo23a =="
-				  "NULL!!!\n"));
+				 "recvframe_chkmic: rtw_get_stainfo23a ==NULL!!!\n");
 		}
 
 		skb_trim(precvframe->pkt, precvframe->pkt->len - 8);
@@ -474,8 +466,8 @@ struct recv_frame *decryptor(struct rtw_adapter *padapter,
 	int res = _SUCCESS;
 
 	RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-		 ("prxstat->decrypted =%x prxattrib->encrypt = 0x%03x\n",
-		  prxattrib->bdecrypted, prxattrib->encrypt));
+		 "prxstat->decrypted =%x prxattrib->encrypt = 0x%03x\n",
+		 prxattrib->bdecrypted, prxattrib->encrypt);
 
 	if (prxattrib->encrypt > 0) {
 		u8 *iv = precv_frame->pkt->data + prxattrib->hdrlen;
@@ -558,8 +550,8 @@ static struct recv_frame *portctrl(struct rtw_adapter *adapter,
 	psta = rtw_get_stainfo23a(pstapriv, psta_addr);
 
 	RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-		 ("########portctrl:adapter->securitypriv.dot11AuthAlgrthm ="
-		  "%d\n", adapter->securitypriv.dot11AuthAlgrthm));
+		 "########portctrl:adapter->securitypriv.dot11AuthAlgrthm =%d\n",
+		 adapter->securitypriv.dot11AuthAlgrthm);
 
 	prtnframe = precv_frame;
 
@@ -573,8 +565,7 @@ static struct recv_frame *portctrl(struct rtw_adapter *adapter,
 			/* blocked */
 			/* only accept EAPOL frame */
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-				 ("########portctrl:psta->ieee8021x_blocked =="
-				  "1\n"));
+				 "########portctrl:psta->ieee8021x_blocked ==1\n");
 
 			if (ether_type != eapol_type) {
 				/* free this frame */
@@ -601,8 +592,8 @@ int recv_decache(struct recv_frame *precv_frame, u8 bretry,
 
 	if (tid > 15) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_notice_,
-			 ("recv_decache, (tid>15)! seq_ctrl = 0x%x, tid = 0x%x\n",
-			  seq_ctrl, tid));
+			 "recv_decache, (tid>15)! seq_ctrl = 0x%x, tid = 0x%x\n",
+			 seq_ctrl, tid);
 
 		return _FAIL;
 	}
@@ -610,9 +601,8 @@ int recv_decache(struct recv_frame *precv_frame, u8 bretry,
 	if (1) { /* if (bretry) */
 		if (seq_ctrl == prxcache->tid_rxseq[tid]) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_notice_,
-				 ("recv_decache, seq_ctrl = 0x%x, tid = 0x%x, "
-				  "tid_rxseq = 0x%x\n",
-				  seq_ctrl, tid, prxcache->tid_rxseq[tid]));
+				 "recv_decache, seq_ctrl = 0x%x, tid = 0x%x, tid_rxseq = 0x%x\n",
+				 seq_ctrl, tid, prxcache->tid_rxseq[tid]);
 
 			return _FAIL;
 		}
@@ -770,7 +760,7 @@ static int sta2sta_data_frame(struct rtw_adapter *adapter,
 		/*  filter packets that SA is myself or multicast or broadcast */
 		if (ether_addr_equal(myhwaddr, pattrib->src)) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 (" SA == myself\n"));
+				 "SA == myself\n");
 			ret = _FAIL;
 			goto exit;
 		}
@@ -793,8 +783,7 @@ static int sta2sta_data_frame(struct rtw_adapter *adapter,
 		    and DA is my mac-address */
 		if (!ether_addr_equal(pattrib->bssid, pattrib->src)) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("bssid != TA under STATION_MODE; drop "
-				  "pkt\n"));
+				 "bssid != TA under STATION_MODE; drop pkt\n");
 			ret = _FAIL;
 			goto exit;
 		}
@@ -836,7 +825,8 @@ static int sta2sta_data_frame(struct rtw_adapter *adapter,
 		*psta = rtw_get_stainfo23a(pstapriv, sta_addr); /*  get ap_info */
 
 	if (*psta == NULL) {
-		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_, ("can't get psta under sta2sta_data_frame ; drop pkt\n"));
+		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
+			 "can't get psta under sta2sta_data_frame ; drop pkt\n");
 		ret = _FAIL;
 		goto exit;
 	}
@@ -872,7 +862,7 @@ int ap2sta_data_frame(struct rtw_adapter *adapter,
 		/* filter packets that SA is myself or multicast or broadcast */
 		if (ether_addr_equal(myhwaddr, pattrib->src)) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 (" SA == myself\n"));
+				 "SA == myself\n");
 			ret = _FAIL;
 			goto exit;
 		}
@@ -880,8 +870,8 @@ int ap2sta_data_frame(struct rtw_adapter *adapter,
 		/*  da should be for me */
 		if (!ether_addr_equal(myhwaddr, pattrib->dst) && !bmcast) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-				 (" ap2sta_data_frame:  compare DA fail; DA=%pM\n",
-				  pattrib->dst));
+				 "ap2sta_data_frame:  compare DA failed; DA=%pM\n",
+				 pattrib->dst);
 			ret = _FAIL;
 			goto exit;
 		}
@@ -891,10 +881,10 @@ int ap2sta_data_frame(struct rtw_adapter *adapter,
 		    ether_addr_equal(mybssid, "\x0\x0\x0\x0\x0\x0") ||
 		    !ether_addr_equal(pattrib->bssid, mybssid)) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-				(" ap2sta_data_frame:  compare BSSID fail ; BSSID=%pM\n",
-				 pattrib->bssid));
+				 "ap2sta_data_frame:  compare BSSID failed; BSSID=%pM\n",
+				 pattrib->bssid);
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-				 ("mybssid=%pM\n", mybssid));
+				 "mybssid=%pM\n", mybssid);
 
 			if (!bmcast) {
 				DBG_8723A("issue_deauth23a to the nonassociated ap=%pM for the reason(7)\n",
@@ -915,8 +905,7 @@ int ap2sta_data_frame(struct rtw_adapter *adapter,
 
 		if (*psta == NULL) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("ap2sta: can't get psta under STATION_MODE ;"
-				  " drop pkt\n"));
+				 "ap2sta: can't get psta under STATION_MODE; drop pkt\n");
 			ret = _FAIL;
 			goto exit;
 		}
@@ -944,7 +933,7 @@ int ap2sta_data_frame(struct rtw_adapter *adapter,
 		*psta = rtw_get_stainfo23a(pstapriv, pattrib->bssid);
 		if (*psta == NULL) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("can't get psta under MP_MODE ; drop pkt\n"));
+				 "can't get psta under MP_MODE ; drop pkt\n");
 			ret = _FAIL;
 			goto exit;
 		}
@@ -1001,7 +990,7 @@ int sta2ap_data_frame(struct rtw_adapter *adapter,
 		*psta = rtw_get_stainfo23a(pstapriv, pattrib->src);
 		if (*psta == NULL) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("can't get psta under AP_MODE; drop pkt\n"));
+				 "can't get psta under AP_MODE; drop pkt\n");
 			DBG_8723A("issue_deauth23a to sta=%pM for the reason(7)\n",
 				  pattrib->src);
 
@@ -1204,12 +1193,12 @@ static int validate_recv_mgnt_frame(struct rtw_adapter *padapter,
 	/* struct mlme_priv *pmlmepriv = &adapter->mlmepriv; */
 
 	RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-		 ("+validate_recv_mgnt_frame\n"));
+		 "+validate_recv_mgnt_frame\n");
 
 	precv_frame = recvframe_chk_defrag23a(padapter, precv_frame);
 	if (precv_frame == NULL) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_notice_,
-			 ("%s: fragment packet\n", __func__));
+			 "%s: fragment packet\n", __func__);
 		return _SUCCESS;
 	}
 
@@ -1295,7 +1284,7 @@ static int validate_recv_data_frame(struct rtw_adapter *adapter,
 		ether_addr_copy(pattrib->ra, hdr->addr1);
 		ether_addr_copy(pattrib->ta, hdr->addr2);
 		ret = _FAIL;
-		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_, (" case 3\n"));
+		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_, "case 3\n");
 		break;
 	}
 
@@ -1304,7 +1293,7 @@ static int validate_recv_data_frame(struct rtw_adapter *adapter,
 
 	if (!psta) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-			 (" after to_fr_ds_chk; psta == NULL\n"));
+			 "after to_fr_ds_chk; psta == NULL\n");
 		ret = _FAIL;
 		goto exit;
 	}
@@ -1347,26 +1336,25 @@ static int validate_recv_data_frame(struct rtw_adapter *adapter,
 	if (recv_decache(precv_frame, bretry, &psta->sta_recvpriv.rxcache) ==
 	    _FAIL) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-			 ("decache : drop pkt\n"));
+			 "decache : drop pkt\n");
 		ret = _FAIL;
 		goto exit;
 	}
 
 	if (pattrib->privacy) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-			 ("validate_recv_data_frame:pattrib->privacy =%x\n",
-			 pattrib->privacy));
+			 "validate_recv_data_frame:pattrib->privacy =%x\n",
+			 pattrib->privacy);
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-			 ("\n ^^^^^^^^^^^is_multicast_ether_addr"
-			  "(pattrib->ra(0x%02x)) =%d^^^^^^^^^^^^^^^6\n",
-			  pattrib->ra[0],
-			  is_multicast_ether_addr(pattrib->ra)));
+			 "^^^^^^^^^^^is_multicast_ether_addr(pattrib->ra(0x%02x)) =%d^^^^^^^^^^^^^^^6\n",
+			 pattrib->ra[0],
+			 is_multicast_ether_addr(pattrib->ra));
 
 		GET_ENCRY_ALGO(psecuritypriv, psta, pattrib->encrypt,
 			       is_multicast_ether_addr(pattrib->ra));
 
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-			 ("\n pattrib->encrypt =%d\n", pattrib->encrypt));
+			 "pattrib->encrypt =%d\n", pattrib->encrypt);
 
 		switch (pattrib->encrypt) {
 		case WLAN_CIPHER_SUITE_WEP40:
@@ -1447,7 +1435,7 @@ static int validate_recv_frame(struct rtw_adapter *adapter,
 	/* add version chk */
 	if (ver != 0) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-			 ("validate_recv_data_frame fail! (ver!= 0)\n"));
+			 "validate_recv_data_frame fail! (ver!= 0)\n");
 		retval = _FAIL;
 		goto exit;
 	}
@@ -1472,7 +1460,7 @@ static int validate_recv_frame(struct rtw_adapter *adapter,
 		retval = validate_recv_mgnt_frame(adapter, precv_frame);
 		if (retval == _FAIL) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("validate_recv_mgnt_frame fail\n"));
+				 "validate_recv_mgnt_frame fail\n");
 		}
 		retval = _FAIL; /*  only data frame return _SUCCESS */
 		break;
@@ -1480,7 +1468,7 @@ static int validate_recv_frame(struct rtw_adapter *adapter,
 		retval = validate_recv_ctrl_frame(adapter, precv_frame);
 		if (retval == _FAIL) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("validate_recv_ctrl_frame fail\n"));
+				 "validate_recv_ctrl_frame fail\n");
 		}
 		retval = _FAIL; /*  only data frame return _SUCCESS */
 		break;
@@ -1489,13 +1477,13 @@ static int validate_recv_frame(struct rtw_adapter *adapter,
 		retval = validate_recv_data_frame(adapter, precv_frame);
 		if (retval == _FAIL) {
 			struct recv_priv *precvpriv = &adapter->recvpriv;
-			/* RT_TRACE(_module_rtl871x_recv_c_, _drv_err_, ("validate_recv_data_frame fail\n")); */
+
 			precvpriv->rx_drop++;
 		}
 		break;
 	default:
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-			 ("validate_recv_data_frame fail! type = 0x%x\n", type));
+			 "validate_recv_data_frame fail! type = 0x%x\n", type);
 		retval = _FAIL;
 		break;
 	}
@@ -1542,8 +1530,8 @@ static int wlanhdr_to_ethhdr (struct recv_frame *precvframe)
 	len = skb->len - hdrlen;
 
 	RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-		 ("\n === pattrib->hdrlen: %x,  pattrib->iv_len:%x ===\n\n",
-		  pattrib->hdrlen,  pattrib->iv_len));
+		 "=== pattrib->hdrlen: %x,  pattrib->iv_len:%x ===\n",
+		 pattrib->hdrlen,  pattrib->iv_len);
 
 	pattrib->eth_type = eth_type;
 	if (check_fwstate(pmlmepriv, WIFI_MP_STATE)) {
@@ -1655,7 +1643,7 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 	rtw_free_recvframe23a_queue(defrag_q);
 
 	RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-		 ("Performance defrag!!!!!\n"));
+		 "Performance defrag!!!!!\n");
 
 
 
@@ -1726,8 +1714,8 @@ struct recv_frame *recvframe_chk_defrag23a(struct rtw_adapter *padapter,
 			/* spin_unlock(&pdefrag_q->lock); */
 
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-				 ("Enqueuq: ismfrag = %d, fragnum = %d\n",
-				  ismfrag, fragnum));
+				 "Enqueuq: ismfrag = %d, fragnum = %d\n",
+				 ismfrag, fragnum);
 
 			prtnframe = NULL;
 
@@ -1737,8 +1725,8 @@ struct recv_frame *recvframe_chk_defrag23a(struct rtw_adapter *padapter,
 			rtw_free_recvframe23a(precv_frame);
 			prtnframe = NULL;
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("Free because pdefrag_q == NULL: ismfrag = "
-				  "%d, fragnum = %d\n", ismfrag, fragnum));
+				 "Free because pdefrag_q == NULL: ismfrag = %d, fragnum = %d\n",
+				 ismfrag, fragnum);
 		}
 	}
 
@@ -1753,8 +1741,8 @@ struct recv_frame *recvframe_chk_defrag23a(struct rtw_adapter *padapter,
 
 			/* call recvframe_defrag to defrag */
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-				 ("defrag: ismfrag = %d, fragnum = %d\n",
-				  ismfrag, fragnum));
+				 "defrag: ismfrag = %d, fragnum = %d\n",
+				 ismfrag, fragnum);
 			precv_frame = recvframe_defrag(padapter, pdefrag_q);
 			prtnframe = precv_frame;
 		} else {
@@ -1763,8 +1751,8 @@ struct recv_frame *recvframe_chk_defrag23a(struct rtw_adapter *padapter,
 			rtw_free_recvframe23a(precv_frame);
 			prtnframe = NULL;
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("Free because pdefrag_q == NULL: ismfrag = "
-				  "%d, fragnum = %d\n", ismfrag, fragnum));
+				 "Free because pdefrag_q == NULL: ismfrag = %d, fragnum = %d\n",
+				 ismfrag, fragnum);
 		}
 
 	}
@@ -1773,8 +1761,7 @@ struct recv_frame *recvframe_chk_defrag23a(struct rtw_adapter *padapter,
 		/* after defrag we must check tkip mic code */
 		if (recvframe_chkmic(padapter,  prtnframe) == _FAIL) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("recvframe_chkmic(padapter,  prtnframe) =="
-				  "_FAIL\n"));
+				 "recvframe_chkmic(padapter,  prtnframe) ==_FAIL\n");
 			rtw_free_recvframe23a(prtnframe);
 			prtnframe = NULL;
 		}
@@ -1873,7 +1860,6 @@ static int enqueue_reorder_recvframe23a(struct recv_reorder_ctrl *preorder_ctrl,
 			continue;
 		} else if (SN_EQUAL(pnextattrib->seq_num, pattrib->seq_num)) {
 			/* Duplicate entry is found!! Do not insert current entry. */
-			/* RT_TRACE(COMP_RX_REORDER, DBG_TRACE, ("InsertRxReorderList(): Duplicate packet is dropped!! IndicateSeq: %d, NewSeq: %d\n", pTS->RxIndicateSeq, SeqNum)); */
 
 			/* spin_unlock_irqrestore(&ppending_recvframe_queue->lock); */
 			return false;
@@ -1894,7 +1880,6 @@ static int enqueue_reorder_recvframe23a(struct recv_reorder_ctrl *preorder_ctrl,
 	/* spin_unlock_ex(&ppending_recvframe_queue->lock); */
 	/* spin_unlock_irqrestore(&ppending_recvframe_queue->lock); */
 
-	/* RT_TRACE(COMP_RX_REORDER, DBG_TRACE, ("InsertRxReorderList(): Pkt insert into buffer!! IndicateSeq: %d, NewSeq: %d\n", pTS->RxIndicateSeq, SeqNum)); */
 	return true;
 }
 
@@ -1946,10 +1931,9 @@ int recv_indicatepkts_in_order(struct rtw_adapter *padapter,
 
 		if (!SN_LESS(preorder_ctrl->indicate_seq, pattrib->seq_num)) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_notice_,
-				 ("recv_indicatepkts_in_order: indicate =%d "
-				  "seq =%d amsdu =%d\n",
-				  preorder_ctrl->indicate_seq,
-				  pattrib->seq_num, pattrib->amsdu));
+				 "recv_indicatepkts_in_order: indicate =%d seq =%d amsdu =%d\n",
+				 preorder_ctrl->indicate_seq,
+				 pattrib->seq_num, pattrib->amsdu);
 
 			plist = plist->next;
 			list_del_init(&prframe->list);
@@ -2011,8 +1995,7 @@ int recv_indicatepkt_reorder(struct rtw_adapter *padapter,
 			if ((padapter->bDriverStopped == false) &&
 			    (padapter->bSurpriseRemoved == false)) {
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_notice_,
-					 ("@@@@  recv_indicatepkt_reorder -"
-					  "recv_func recv_indicatepkt\n"));
+					 "@@@@  recv_indicatepkt_reorder -recv_func recv_indicatepkt\n");
 
 				rtw_recv_indicatepkt23a(padapter, prframe);
 				return _SUCCESS;
@@ -2045,8 +2028,8 @@ int recv_indicatepkt_reorder(struct rtw_adapter *padapter,
 	spin_lock_bh(&ppending_recvframe_queue->lock);
 
 	RT_TRACE(_module_rtl871x_recv_c_, _drv_notice_,
-		 ("recv_indicatepkt_reorder: indicate =%d seq =%d\n",
-		  preorder_ctrl->indicate_seq, pattrib->seq_num));
+		 "recv_indicatepkt_reorder: indicate =%d seq =%d\n",
+		 preorder_ctrl->indicate_seq, pattrib->seq_num);
 
 	/* s2. check if winstart_b(indicate_seq) needs to been updated */
 	if (!check_indicate_seq(preorder_ctrl, pattrib->seq_num)) {
@@ -2139,7 +2122,7 @@ int process_recv_indicatepkts(struct rtw_adapter *padapter,
 		retval = wlanhdr_to_ethhdr(prframe);
 		if (retval != _SUCCESS) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("wlanhdr_to_ethhdr: drop pkt\n"));
+				 "wlanhdr_to_ethhdr: drop pkt\n");
 			return retval;
 		}
 
@@ -2147,19 +2130,16 @@ int process_recv_indicatepkts(struct rtw_adapter *padapter,
 		    (padapter->bSurpriseRemoved == false)) {
 			/* indicate this recv_frame */
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_notice_,
-				 ("@@@@ process_recv_indicatepkts- "
-				  "recv_func recv_indicatepkt\n"));
+				 "@@@@ process_recv_indicatepkts- recv_func recv_indicatepkt\n");
 			rtw_recv_indicatepkt23a(padapter, prframe);
 		} else {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_notice_,
-				 ("@@@@ process_recv_indicatepkts- "
-				  "recv_func free_indicatepkt\n"));
+				 "@@@@ process_recv_indicatepkts- recv_func free_indicatepkt\n");
 
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_notice_,
-				 ("recv_func:bDriverStopped(%d) OR "
-				  "bSurpriseRemoved(%d)",
-				  padapter->bDriverStopped,
-				  padapter->bSurpriseRemoved));
+				 "recv_func:bDriverStopped(%d) OR bSurpriseRemoved(%d)\n",
+				 padapter->bDriverStopped,
+				 padapter->bSurpriseRemoved);
 			retval = _FAIL;
 			return retval;
 		}
@@ -2178,7 +2158,7 @@ static int recv_func_prehandle(struct rtw_adapter *padapter,
 	ret = validate_recv_frame(padapter, rframe);
 	if (ret != _SUCCESS) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-			 ("recv_func: validate_recv_frame fail! drop pkt\n"));
+			 "recv_func: validate_recv_frame fail! drop pkt\n");
 		rtw_free_recvframe23a(rframe);
 		goto exit;
 	}
@@ -2198,7 +2178,7 @@ static int recv_func_posthandle(struct rtw_adapter *padapter,
 	prframe = decryptor(padapter, prframe);
 	if (prframe == NULL) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-			 ("decryptor: drop pkt\n"));
+			 "decryptor: drop pkt\n");
 		ret = _FAIL;
 		goto _recv_data_drop;
 	}
@@ -2206,7 +2186,7 @@ static int recv_func_posthandle(struct rtw_adapter *padapter,
 	prframe = recvframe_chk_defrag23a(padapter, prframe);
 	if (!prframe) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-			 ("recvframe_chk_defrag23a: drop pkt\n"));
+			 "recvframe_chk_defrag23a: drop pkt\n");
 		goto _recv_data_drop;
 	}
 
@@ -2225,7 +2205,7 @@ static int recv_func_posthandle(struct rtw_adapter *padapter,
 	prframe = portctrl(padapter, prframe);
 	if (!prframe) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-			 ("portctrl: drop pkt\n"));
+			 "portctrl: drop pkt\n");
 		ret = _FAIL;
 		goto _recv_data_drop;
 	}
@@ -2235,7 +2215,7 @@ static int recv_func_posthandle(struct rtw_adapter *padapter,
 	ret = process_recv_indicatepkts(padapter, prframe);
 	if (ret != _SUCCESS) {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-			 ("recv_func: process_recv_indicatepkts fail!\n"));
+			 "recv_func: process_recv_indicatepkts fail!\n");
 		rtw_free_recvframe23a(orig_prframe);/* free this recv_frame */
 		goto _recv_data_drop;
 	}
diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 045a24c..ea670af 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -248,14 +248,11 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
 	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] ||
 	    crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload"
-			  "[length-1](%x) || crc[2](%x)!= payload[length-2](%x)"
-			  " || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)"
-			  "!= payload[length-4](%x)\n",
-			  crc[3], payload[length - 1],
-			  crc[2], payload[length - 2],
-			  crc[1], payload[length - 3],
-			  crc[0], payload[length - 4]));
+			 "rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
+			 crc[3], payload[length - 1],
+			 crc[2], payload[length - 2],
+			 crc[1], payload[length - 3],
+			 crc[0], payload[length - 4]);
 	}
 }
 
@@ -644,7 +641,8 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 				return _FAIL;
 			}
 
-			RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_encrypt23a: stainfo!= NULL!!!\n"));
+			RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+				 "rtw_tkip_encrypt23a: stainfo!= NULL!!!\n");
 
 			if (is_multicast_ether_addr(pattrib->ra))
 				prwskey = psecuritypriv->dot118021XGrpKey[psecuritypriv->dot118021XGrpKeyid].skey;
@@ -668,7 +666,10 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 
 				if ((curfragnum+1) == pattrib->nr_frags) {	/* 4 the last fragment */
 					length = pattrib->last_txcmdsz-pattrib->hdrlen-pattrib->iv_len- pattrib->icv_len;
-					RT_TRACE(_module_rtl871x_security_c_, _drv_info_, ("pattrib->iv_len =%x, pattrib->icv_len =%x\n", pattrib->iv_len, pattrib->icv_len));
+					RT_TRACE(_module_rtl871x_security_c_, _drv_info_,
+						 "pattrib->iv_len =%x, pattrib->icv_len =%x\n",
+						 pattrib->iv_len,
+						 pattrib->icv_len);
 					*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));/* modified by Amy*/
 
 					arcfour_init(&mycontext, rc4key, 16);
@@ -690,7 +691,8 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 
 		}
 		else{
-			RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_encrypt23a: stainfo == NULL!!!\n"));
+			RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+				 "rtw_tkip_encrypt23a: stainfo == NULL!!!\n");
 			DBG_8723A("%s, psta == NUL\n", __func__);
 			res = _FAIL;
 		}
@@ -738,7 +740,8 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 				prwskey = psecuritypriv->dot118021XGrpKey[prxattrib->key_index].skey;
 				prwskeylen = 16;
 			} else {
-			        RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_decrypt23a: stainfo!= NULL!!!\n"));
+				RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+					 "rtw_tkip_decrypt23a: stainfo!= NULL!!!\n");
 				prwskey = &stainfo->dot118021x_UncstKey.skey[0];
 				prwskeylen = 16;
 			}
@@ -763,12 +766,17 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 
 			if (crc[3]!= payload[length-1] || crc[2]!= payload[length-2] || crc[1]!= payload[length-3] || crc[0]!= payload[length-4])
 			{
-			    RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
-						crc[3], payload[length-1], crc[2], payload[length-2], crc[1], payload[length-3], crc[0], payload[length-4]));
+				RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+					 "rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
+					 crc[3], payload[length-1],
+					 crc[2], payload[length-2],
+					 crc[1], payload[length-3],
+					 crc[0], payload[length-4]);
 				res = _FAIL;
 			}
 		} else {
-			RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_decrypt23a: stainfo == NULL!!!\n"));
+			RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+				 "rtw_tkip_decrypt23a: stainfo == NULL!!!\n");
 			res = _FAIL;
 		}
 	}
@@ -1304,7 +1312,7 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 
 	if (!stainfo) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 ("rtw_aes_encrypt23a: stainfo == NULL!!!\n"));
+			 "rtw_aes_encrypt23a: stainfo == NULL!!!\n");
 		DBG_8723A("%s, psta == NUL\n", __func__);
 		res = _FAIL;
 		goto out;
@@ -1315,7 +1323,7 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 		return _FAIL;
 	}
 	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-		 ("rtw_aes_encrypt23a: stainfo!= NULL!!!\n"));
+		 "rtw_aes_encrypt23a: stainfo!= NULL!!!\n");
 
 	if (is_multicast_ether_addr(pattrib->ra))
 		prwskey = psecuritypriv->dot118021XGrpKey[psecuritypriv->dot118021XGrpKeyid].skey;
@@ -1544,8 +1552,9 @@ static int aes_decipher(u8 *key, uint	hdrlen,
 	for (i = 0; i < 8; i++) {
 		if (pframe[hdrlen+8+plen-8+i] != message[hdrlen+8+plen-8+i]) {
 			RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-				 ("aes_decipher:mic check error mic[%d]: pframe(%x) != message(%x)\n",
-				 i, pframe[hdrlen+8+plen-8+i], message[hdrlen+8+plen-8+i]));
+				 "aes_decipher:mic check error mic[%d]: pframe(%x) != message(%x)\n",
+				 i, pframe[hdrlen + 8 + plen - 8 + i],
+				 message[hdrlen + 8 + plen - 8 + i]);
 			DBG_8723A("aes_decipher:mic check error mic[%d]: pframe(%x) != message(%x)\n",
 				  i, pframe[hdrlen+8+plen-8+i], message[hdrlen+8+plen-8+i]);
 			res = _FAIL;
@@ -1573,13 +1582,13 @@ int rtw_aes_decrypt23a(struct rtw_adapter *padapter,
 	stainfo = rtw_get_stainfo23a(&padapter->stapriv, &prxattrib->ta[0]);
 	if (!stainfo) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 ("rtw_aes_encrypt23a: stainfo == NULL!!!\n"));
+			 "rtw_aes_encrypt23a: stainfo == NULL!!!\n");
 		res = _FAIL;
 		goto exit;
 	}
 
 	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-		 ("rtw_aes_decrypt23a: stainfo!= NULL!!!\n"));
+		 "rtw_aes_decrypt23a: stainfo!= NULL!!!\n");
 
 	if (is_multicast_ether_addr(prxattrib->ra)) {
 		/* in concurrent we should use sw decrypt in group key,
@@ -1613,9 +1622,10 @@ void rtw_use_tkipkey_handler23a(void *FunctionContext)
 {
 	struct rtw_adapter *padapter = (struct rtw_adapter *)FunctionContext;
 
-	RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("^^^rtw_use_tkipkey_handler23a ^^^\n"));
+	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+		 "^^^rtw_use_tkipkey_handler23a ^^^\n");
 	padapter->securitypriv.busetkipkey = 1;
 	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-		 ("^^^rtw_use_tkipkey_handler23a padapter->securitypriv.busetkipkey =%d^^^\n",
-		 padapter->securitypriv.busetkipkey));
+		 "^^^rtw_use_tkipkey_handler23a padapter->securitypriv.busetkipkey =%d^^^\n",
+		 padapter->securitypriv.busetkipkey);
 }
diff --git a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
index d17998d..b06bff7 100644
--- a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
@@ -136,10 +136,10 @@ rtw_alloc_stainfo23a(struct sta_priv *pstapriv, const u8 *hwaddr, gfp_t gfp)
 	index = wifi_mac_hash(hwaddr);
 
 	RT_TRACE(_module_rtl871x_sta_mgt_c_, _drv_info_,
-		 ("rtw_alloc_stainfo23a: index  = %x", index));
+		 "rtw_alloc_stainfo23a: index  = %x\n", index);
 	if (index >= NUM_STA) {
 		RT_TRACE(_module_rtl871x_sta_mgt_c_, _drv_err_,
-			 ("ERROR => rtw_alloc_stainfo23a: index >= NUM_STA"));
+			 "ERROR => rtw_alloc_stainfo23a: index >= NUM_STA\n");
 		psta = NULL;
 		goto exit;
 	}
@@ -160,8 +160,8 @@ rtw_alloc_stainfo23a(struct sta_priv *pstapriv, const u8 *hwaddr, gfp_t gfp)
 			&wRxSeqInitialValue, 2);
 
 	RT_TRACE(_module_rtl871x_sta_mgt_c_, _drv_info_,
-		 ("alloc number_%d stainfo  with hwaddr = %pM\n",
-		 pstapriv->asoc_sta_count, hwaddr));
+		 "alloc number_%d stainfo  with hwaddr = %pM\n",
+		 pstapriv->asoc_sta_count, hwaddr);
 
 	init_addba_retry_timer23a(psta);
 
@@ -249,10 +249,8 @@ int rtw_free_stainfo23a(struct rtw_adapter *padapter, struct sta_info *psta)
 
 	list_del_init(&psta->hash_list);
 	RT_TRACE(_module_rtl871x_sta_mgt_c_, _drv_err_,
-		("\n free number_%d stainfo  with hwaddr = 0x%.2x 0x%.2x 0x%.2x 0x%.2x 0x%.2x 0x%.2x\n",
-			pstapriv->asoc_sta_count, psta->hwaddr[0],
-			psta->hwaddr[1], psta->hwaddr[2], psta->hwaddr[3],
-			psta->hwaddr[4], psta->hwaddr[5]));
+		 "free number_%d stainfo  with hwaddr = %pM\n",
+		 pstapriv->asoc_sta_count, psta->hwaddr);
 	pstapriv->asoc_sta_count--;
 
 	/*  re-init sta_info; 20061114  will be init in alloc_stainfo */
@@ -397,7 +395,7 @@ int rtw_init_bcmc_stainfo23a(struct rtw_adapter *padapter)
 	if (psta == NULL) {
 		res = _FAIL;
 		RT_TRACE(_module_rtl871x_sta_mgt_c_, _drv_err_,
-			 ("rtw_alloc_stainfo23a fail"));
+			 "rtw_alloc_stainfo23a fail\n");
 		return res;
 	}
 	/*  default broadcast & multicast use macid 1 */
diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
index 829bba7..5280338 100644
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -926,10 +926,9 @@ int rtw_check_bcn_info23a(struct rtw_adapter *Adapter,
 	}
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("%s bssid.Ssid.Ssid:%s bssid.Ssid.SsidLength:%d "
-		  "cur_network->network.Ssid.Ssid:%s len:%d\n", __func__,
-		  ssid, ssid_len, cur_network->network.Ssid.ssid,
-		  cur_network->network.Ssid.ssid_len));
+		 "%s bssid.Ssid.Ssid:%s bssid.Ssid.SsidLength:%d cur_network->network.Ssid.Ssid:%s len:%d\n",
+		 __func__, ssid, ssid_len, cur_network->network.Ssid.ssid,
+		 cur_network->network.Ssid.ssid_len);
 
 	if (ssid_len != cur_network->network.Ssid.ssid_len || ssid_len > 32 ||
 	    (ssid_len &&
@@ -947,8 +946,8 @@ int rtw_check_bcn_info23a(struct rtw_adapter *Adapter,
 		privacy = 0;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-		 ("%s(): cur_network->network.Privacy is %d, bssid.Privacy "
-		  "is %d\n", __func__, cur_network->network.Privacy, privacy));
+		 "%s(): cur_network->network.Privacy is %d, bssid.Privacy is %d\n",
+		 __func__, cur_network->network.Privacy, privacy);
 	if (cur_network->network.Privacy != privacy) {
 		DBG_8723A("%s(), privacy is not match return FAIL\n", __func__);
 		goto _mismatch;
@@ -962,10 +961,9 @@ int rtw_check_bcn_info23a(struct rtw_adapter *Adapter,
 						 &pairwise_cipher, &is_8021x);
 			if (r == _SUCCESS)
 				RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-					 ("%s pnetwork->pairwise_cipher: %d, "
-					  "pnetwork->group_cipher: %d, is_802x "
-					  ": %d\n", __func__, pairwise_cipher,
-					  group_cipher, is_8021x));
+					 "%s pnetwork->pairwise_cipher: %d, pnetwork->group_cipher: %d, is_802x : %d\n",
+					 __func__, pairwise_cipher,
+					 group_cipher, is_8021x);
 			}
 	} else {
 		p = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
@@ -977,10 +975,9 @@ int rtw_check_bcn_info23a(struct rtw_adapter *Adapter,
 						&pairwise_cipher, &is_8021x);
 			if (r == _SUCCESS)
 				RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
-					 ("%s pnetwork->pairwise_cipher: %d, "
-					  "group_cipher is %d, is_8021x is "
-					  "%d\n", __func__, pairwise_cipher,
-					  group_cipher, is_8021x));
+					 "%s pnetwork->pairwise_cipher: %d, group_cipher is %d, is_8021x is %d\n",
+					 __func__, pairwise_cipher,
+					 group_cipher, is_8021x);
 		} else {
 			if (privacy)
 				crypto = ENCRYP_PROTOCOL_WEP;
@@ -996,8 +993,8 @@ int rtw_check_bcn_info23a(struct rtw_adapter *Adapter,
 
 	if (crypto == ENCRYP_PROTOCOL_WPA || crypto == ENCRYP_PROTOCOL_WPA2) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-			 ("%s cur_network->group_cipher is %d: %d\n", __func__,
-			  cur_network->BcnInfo.group_cipher, group_cipher));
+			 "%s cur_network->group_cipher is %d: %d\n", __func__,
+			 cur_network->BcnInfo.group_cipher, group_cipher);
 		if (pairwise_cipher != cur_network->BcnInfo.pairwise_cipher ||
 		    group_cipher != cur_network->BcnInfo.group_cipher) {
 			DBG_8723A("%s pairwise_cipher(%x:%x) or group_cipher "
diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
index 98602d9..a4b6bb6 100644
--- a/drivers/staging/rtl8723au/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
@@ -463,9 +463,7 @@ static int update_attrib(struct rtw_adapter *padapter,
 					/*  67 : UDP BOOTP server */
 					RT_TRACE(_module_rtl871x_xmit_c_,
 						 _drv_err_,
-						 ("======================"
-						  "update_attrib: get DHCP "
-						  "Packet\n"));
+						 "======================update_attrib: get DHCP Packet\n");
 					pattrib->dhcp_pkt = 1;
 				}
 			}
@@ -493,8 +491,8 @@ static int update_attrib(struct rtw_adapter *padapter,
 		psta = rtw_get_stainfo23a(pstapriv, pattrib->ra);
 		if (psta == NULL) { /*  if we cannot get psta => drrp the pkt */
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_alert_,
-				 ("\nupdate_attrib => get sta_info fail, ra:%pM\n",
-				  pattrib->ra));
+				 "update_attrib => get sta_info fail, ra:%pM\n",
+				 pattrib->ra);
 			res = _FAIL;
 			goto exit;
 		} else if (check_fwstate(pmlmepriv, WIFI_AP_STATE) &&
@@ -511,8 +509,8 @@ static int update_attrib(struct rtw_adapter *padapter,
 	} else {
 		/*  if we cannot get psta => drop the pkt */
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_alert_,
-			 ("\nupdate_attrib => get sta_info fail, ra:%pM\n",
-			  pattrib->ra));
+			 "update_attrib => get sta_info fail, ra:%pM\n",
+			 pattrib->ra);
 		res = _FAIL;
 		goto exit;
 	}
@@ -544,16 +542,15 @@ static int update_attrib(struct rtw_adapter *padapter,
 
 	if (psta->ieee8021x_blocked == true) {
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-			 ("\n psta->ieee8021x_blocked == true\n"));
+			 "psta->ieee8021x_blocked == true\n");
 
 		pattrib->encrypt = 0;
 
 		if ((pattrib->ether_type != ETH_P_PAE) &&
 		    !check_fwstate(pmlmepriv, WIFI_MP_STATE)) {
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-				 ("\npsta->ieee8021x_blocked == true,  "
-				  "pattrib->ether_type(%.4x) != 0x888e\n",
-				  pattrib->ether_type));
+				 "psta->ieee8021x_blocked == true,  pattrib->ether_type(%.4x) != 0x888e\n",
+				 pattrib->ether_type);
 			res = _FAIL;
 			goto exit;
 		}
@@ -594,9 +591,8 @@ static int update_attrib(struct rtw_adapter *padapter,
 
 		if (!padapter->securitypriv.busetkipkey) {
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-				 ("\npadapter->securitypriv.busetkip"
-				  "key(%d) == false drop packet\n",
-				  padapter->securitypriv.busetkipkey));
+				 "padapter->securitypriv.busetkipkey(%d) == false drop packet\n",
+				 padapter->securitypriv.busetkipkey);
 			res = _FAIL;
 			goto exit;
 		}
@@ -604,8 +600,8 @@ static int update_attrib(struct rtw_adapter *padapter,
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
-			 ("pattrib->encrypt =%d (WLAN_CIPHER_SUITE_CCMP)\n",
-			  pattrib->encrypt));
+			 "pattrib->encrypt =%d (WLAN_CIPHER_SUITE_CCMP)\n",
+			 pattrib->encrypt);
 		pattrib->iv_len = IEEE80211_CCMP_HDR_LEN;
 		pattrib->icv_len = IEEE80211_CCMP_MIC_LEN;
 		break;
@@ -617,17 +613,17 @@ static int update_attrib(struct rtw_adapter *padapter,
 	}
 
 	RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
-		 ("update_attrib: encrypt =%d\n", pattrib->encrypt));
+		 "update_attrib: encrypt =%d\n", pattrib->encrypt);
 
 	if (pattrib->encrypt && !psecuritypriv->hw_decrypted) {
 		pattrib->bswenc = true;
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-			 ("update_attrib: encrypt =%d bswenc = true\n",
-			  pattrib->encrypt));
+			 "update_attrib: encrypt =%d bswenc = true\n",
+			 pattrib->encrypt);
 	} else {
 		pattrib->bswenc = false;
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
-			 ("update_attrib: bswenc = false\n"));
+			 "update_attrib: bswenc = false\n");
 	}
 	update_attrib_phy_info(pattrib, psta);
 
@@ -726,20 +722,18 @@ static int xmitframe_addmic(struct rtw_adapter *padapter,
 			     curfragnum++) {
 				payload = PTR_ALIGN(payload, 4);
 				RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-					 ("=== curfragnum =%d, pframe = 0x%.2x, "
-					  "0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x"
-					  "%.2x, 0x%.2x, 0x%.2x,!!!\n",
-					  curfragnum, *payload, *(payload + 1),
-					  *(payload + 2), *(payload + 3),
-					  *(payload + 4), *(payload + 5),
-					  *(payload + 6), *(payload + 7)));
+					 "=== curfragnum =%d, pframe = 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x,!!!\n",
+					 curfragnum, *payload, *(payload + 1),
+					 *(payload + 2), *(payload + 3),
+					 *(payload + 4), *(payload + 5),
+					 *(payload + 6), *(payload + 7));
 
 				payload = payload + pattrib->hdrlen +
 					pattrib->iv_len;
 				RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-					 ("curfragnum =%d pattrib->hdrlen =%d "
-					  "pattrib->iv_len =%d", curfragnum,
-					  pattrib->hdrlen, pattrib->iv_len));
+					 "curfragnum =%d pattrib->hdrlen =%d pattrib->iv_len =%d\n",
+					 curfragnum,
+					 pattrib->hdrlen, pattrib->iv_len);
 				if ((curfragnum + 1) == pattrib->nr_frags) {
 					length = pattrib->last_txcmdsz -
 						pattrib->hdrlen -
@@ -761,25 +755,21 @@ static int xmitframe_addmic(struct rtw_adapter *padapter,
 						pattrib->icv_len;
 					RT_TRACE(_module_rtl871x_xmit_c_,
 						 _drv_err_,
-						 ("curfragnum =%d length =%d "
-						  "pattrib->icv_len =%d",
-						  curfragnum, length,
-						  pattrib->icv_len));
+						 "curfragnum =%d length =%d pattrib->icv_len =%d\n",
+						 curfragnum, length,
+						 pattrib->icv_len);
 				}
 			}
 			rtw_secgetmic23a(&micdata, &mic[0]);
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-				 ("xmitframe_addmic: before add mic code!!\n"));
+				 "xmitframe_addmic: before add mic code!!\n");
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-				 ("xmitframe_addmic: pattrib->last_txcmdsz ="
-				  "%d!!!\n", pattrib->last_txcmdsz));
+				 "xmitframe_addmic: pattrib->last_txcmdsz =%d!!!\n",
+				 pattrib->last_txcmdsz);
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-				 ("xmitframe_addmic: mic[0]= 0x%.2x , mic[1]="
-				  "0x%.2x , mic[2]= 0x%.2x , mic[3]= 0x%.2x\n"
-				  "mic[4]= 0x%.2x , mic[5]= 0x%.2x , mic[6]= 0x%.2x "
-				  ", mic[7]= 0x%.2x !!!!\n", mic[0], mic[1],
-				  mic[2], mic[3], mic[4], mic[5], mic[6],
-				  mic[7]));
+				 "xmitframe_addmic: mic[0]= 0x%.2x , mic[1]=0x%.2x , mic[2]= 0x%.2x , mic[3]= 0x%.2x\nmic[4]= 0x%.2x , mic[5]= 0x%.2x , mic[6]= 0x%.2x , mic[7]= 0x%.2x !!!!\n",
+				 mic[0], mic[1], mic[2], mic[3],
+				 mic[4], mic[5], mic[6], mic[7]);
 			/* add mic code  and add the mic code length
 			   in last_txcmdsz */
 
@@ -787,25 +777,24 @@ static int xmitframe_addmic(struct rtw_adapter *padapter,
 			pattrib->last_txcmdsz += 8;
 
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
-				 ("\n ======== last pkt ========\n"));
+				 "======== last pkt ========\n");
 			payload = payload - pattrib->last_txcmdsz + 8;
 			for (curfragnum = 0; curfragnum < pattrib->last_txcmdsz;
-			     curfragnum = curfragnum + 8)
+			     curfragnum = curfragnum + 8) {
 				RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
-					 (" %.2x,  %.2x,  %.2x,  %.2x,  %.2x, "
-					  " %.2x,  %.2x,  %.2x ",
-					  *(payload + curfragnum),
-					  *(payload + curfragnum + 1),
-					  *(payload + curfragnum + 2),
-					  *(payload + curfragnum + 3),
-					  *(payload + curfragnum + 4),
-					  *(payload + curfragnum + 5),
-					  *(payload + curfragnum + 6),
-					  *(payload + curfragnum + 7)));
-			} else {
-				RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-					 ("xmitframe_addmic: rtw_get_stainfo23a =="
-					  "NULL!!!\n"));
+					 "%.2x,  %.2x,  %.2x,  %.2x,  %.2x,  %.2x,  %.2x,  %.2x\n",
+					 *(payload + curfragnum),
+					 *(payload + curfragnum + 1),
+					 *(payload + curfragnum + 2),
+					 *(payload + curfragnum + 3),
+					 *(payload + curfragnum + 4),
+					 *(payload + curfragnum + 5),
+					 *(payload + curfragnum + 6),
+					 *(payload + curfragnum + 7));
+			}
+		} else {
+			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
+				 "xmitframe_addmic: rtw_get_stainfo23a ==NULL!!!\n");
 		}
 	}
 
@@ -821,7 +810,7 @@ static int xmitframe_swencrypt(struct rtw_adapter *padapter,
 	if (pattrib->bswenc) {
 		/* DBG_8723A("start xmitframe_swencrypt\n"); */
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_alert_,
-			 ("### xmitframe_swencrypt\n"));
+			 "### xmitframe_swencrypt\n");
 		switch (pattrib->encrypt) {
 		case WLAN_CIPHER_SUITE_WEP40:
 		case WLAN_CIPHER_SUITE_WEP104:
@@ -839,7 +828,7 @@ static int xmitframe_swencrypt(struct rtw_adapter *padapter,
 
 	} else {
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_notice_,
-			 ("### xmitframe_hwencrypt\n"));
+			 "### xmitframe_hwencrypt\n");
 	}
 
 	return _SUCCESS;
@@ -916,7 +905,9 @@ static int rtw_make_wlanhdr(struct rtw_adapter *padapter, u8 *hdr,
 				qos_option = true;
 		}
 		else {
-			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_, ("fw_state:%x is not allowed to xmit frame\n", get_fwstate(pmlmepriv)));
+			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
+				 "fw_state:%x is not allowed to xmit frame\n",
+				 get_fwstate(pmlmepriv));
 			res = _FAIL;
 			goto exit;
 		}
@@ -1117,7 +1108,7 @@ int rtw_xmitframe_coalesce23a(struct rtw_adapter *padapter, struct sk_buff *skb,
 
 	if (rtw_make_wlanhdr(padapter, mem_start, pattrib) == _FAIL) {
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-			 ("%s: rtw_make_wlanhdr fail; drop pkt\n", __func__));
+			 "%s: rtw_make_wlanhdr fail; drop pkt\n", __func__);
 		res = _FAIL;
 		goto exit;
 	}
@@ -1172,11 +1163,10 @@ int rtw_xmitframe_coalesce23a(struct rtw_adapter *padapter, struct sk_buff *skb,
 			memcpy(pframe, pattrib->iv, pattrib->iv_len);
 
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_notice_,
-				 ("rtw_xmiaframe_coalesce23a: keyid =%d pattrib"
-				  "->iv[3]=%.2x pframe =%.2x %.2x %.2x %.2x\n",
-				  padapter->securitypriv.dot11PrivacyKeyIndex,
-				  pattrib->iv[3], *pframe, *(pframe+1),
-				  *(pframe+2), *(pframe+3)));
+				 "rtw_xmiaframe_coalesce23a: keyid =%d pattrib->iv[3]=%.2x pframe =%.2x %.2x %.2x %.2x\n",
+				 padapter->securitypriv.dot11PrivacyKeyIndex,
+				 pattrib->iv[3], *pframe, *(pframe+1),
+				 *(pframe+2), *(pframe+3));
 			pframe += pattrib->iv_len;
 			mpdu_len -= pattrib->iv_len;
 		}
@@ -1223,8 +1213,8 @@ int rtw_xmitframe_coalesce23a(struct rtw_adapter *padapter, struct sk_buff *skb,
 			break;
 		} else {
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-				 ("%s: There're still something in packet!\n",
-				  __func__));
+				 "%s: There're still something in packet!\n",
+				 __func__);
 		}
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
 
@@ -1234,7 +1224,7 @@ int rtw_xmitframe_coalesce23a(struct rtw_adapter *padapter, struct sk_buff *skb,
 
 	if (xmitframe_addmic(padapter, pxmitframe) == _FAIL) {
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-			 ("xmitframe_addmic(padapter, pxmitframe) == _FAIL\n"));
+			 "xmitframe_addmic(padapter, pxmitframe) == _FAIL\n");
 		DBG_8723A("xmitframe_addmic(padapter, pxmitframe) == _FAIL\n");
 		res = _FAIL;
 		goto exit;
@@ -1462,8 +1452,8 @@ static struct xmit_frame *rtw_alloc_xmitframe(struct xmit_priv *pxmitpriv)
 
 	if (list_empty(&pfree_xmit_queue->queue)) {
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
-			 ("rtw_alloc_xmitframe:%d\n",
-			  pxmitpriv->free_xmitframe_cnt));
+			 "rtw_alloc_xmitframe:%d\n",
+			 pxmitpriv->free_xmitframe_cnt);
 		pxframe =  NULL;
 	} else {
 		phead = get_list_head(pfree_xmit_queue);
@@ -1475,8 +1465,8 @@ static struct xmit_frame *rtw_alloc_xmitframe(struct xmit_priv *pxmitpriv)
 		list_del_init(&pxframe->list);
 		pxmitpriv->free_xmitframe_cnt--;
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
-			 ("rtw_alloc_xmitframe():free_xmitframe_cnt =%d\n",
-			  pxmitpriv->free_xmitframe_cnt));
+			 "rtw_alloc_xmitframe():free_xmitframe_cnt =%d\n",
+			 pxmitpriv->free_xmitframe_cnt);
 	}
 
 	spin_unlock_bh(&pfree_xmit_queue->lock);
@@ -1495,7 +1485,9 @@ struct xmit_frame *rtw_alloc_xmitframe23a_ext(struct xmit_priv *pxmitpriv)
 	spin_lock_bh(&queue->lock);
 
 	if (list_empty(&queue->queue)) {
-		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("rtw_alloc_xmitframe23a_ext:%d\n", pxmitpriv->free_xframe_ext_cnt));
+		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
+			 "rtw_alloc_xmitframe23a_ext:%d\n",
+			 pxmitpriv->free_xframe_ext_cnt);
 		pxframe =  NULL;
 	} else {
 		phead = get_list_head(queue);
@@ -1504,7 +1496,9 @@ struct xmit_frame *rtw_alloc_xmitframe23a_ext(struct xmit_priv *pxmitpriv)
 
 		list_del_init(&pxframe->list);
 		pxmitpriv->free_xframe_ext_cnt--;
-		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("rtw_alloc_xmitframe23a_ext():free_xmitframe_cnt =%d\n", pxmitpriv->free_xframe_ext_cnt));
+		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
+			 "rtw_alloc_xmitframe23a_ext():free_xmitframe_cnt =%d\n",
+			 pxmitpriv->free_xframe_ext_cnt);
 	}
 
 	spin_unlock_bh(&queue->lock);
@@ -1521,7 +1515,8 @@ s32 rtw_free_xmitframe23a(struct xmit_priv *pxmitpriv, struct xmit_frame *pxmitf
 	struct sk_buff *pndis_pkt = NULL;
 
 	if (pxmitframe == NULL) {
-		RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_, ("====== rtw_free_xmitframe23a():pxmitframe == NULL!!!!!!!!!!\n"));
+		RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
+			 "====== rtw_free_xmitframe23a():pxmitframe == NULL!!!!!!!!!!\n");
 		goto exit;
 	}
 
@@ -1543,10 +1538,14 @@ s32 rtw_free_xmitframe23a(struct xmit_priv *pxmitpriv, struct xmit_frame *pxmitf
 	list_add_tail(&pxmitframe->list, get_list_head(queue));
 	if (pxmitframe->ext_tag == 0) {
 		pxmitpriv->free_xmitframe_cnt++;
-		RT_TRACE(_module_rtl871x_xmit_c_, _drv_debug_, ("rtw_free_xmitframe23a():free_xmitframe_cnt =%d\n", pxmitpriv->free_xmitframe_cnt));
+		RT_TRACE(_module_rtl871x_xmit_c_, _drv_debug_,
+			 "rtw_free_xmitframe23a():free_xmitframe_cnt =%d\n",
+			 pxmitpriv->free_xmitframe_cnt);
 	} else if (pxmitframe->ext_tag == 1) {
 		pxmitpriv->free_xframe_ext_cnt++;
-		RT_TRACE(_module_rtl871x_xmit_c_, _drv_debug_, ("rtw_free_xmitframe23a():free_xframe_ext_cnt =%d\n", pxmitpriv->free_xframe_ext_cnt));
+		RT_TRACE(_module_rtl871x_xmit_c_, _drv_debug_,
+			 "rtw_free_xmitframe23a():free_xframe_ext_cnt =%d\n",
+			 pxmitpriv->free_xframe_ext_cnt);
 	}
 
 	spin_unlock_bh(&queue->lock);
@@ -1585,8 +1584,7 @@ int rtw_xmitframe_enqueue23a(struct rtw_adapter *padapter,
 {
 	if (rtw_xmit23a_classifier(padapter, pxmitframe) == _FAIL) {
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-			 ("rtw_xmitframe_enqueue23a: drop xmit pkt for "
-			  "classifier fail\n"));
+			 "rtw_xmitframe_enqueue23a: drop xmit pkt for classifier fail\n");
 		return _FAIL;
 	}
 
@@ -1675,26 +1673,30 @@ struct tx_servq *rtw_get_sta_pending23a(struct rtw_adapter *padapter, struct sta
 	case 2:
 		ptxservq = &psta->sta_xmitpriv.bk_q;
 		*(ac) = 3;
-		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("rtw_get_sta_pending23a : BK\n"));
+		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
+			 "rtw_get_sta_pending23a : BK\n");
 		break;
 	case 4:
 	case 5:
 		ptxservq = &psta->sta_xmitpriv.vi_q;
 		*(ac) = 1;
-		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("rtw_get_sta_pending23a : VI\n"));
+		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
+			 "rtw_get_sta_pending23a : VI\n");
 		break;
 	case 6:
 	case 7:
 		ptxservq = &psta->sta_xmitpriv.vo_q;
 		*(ac) = 0;
-		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("rtw_get_sta_pending23a : VO\n"));
+		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
+			 "rtw_get_sta_pending23a : VO\n");
 		break;
 	case 0:
 	case 3:
 	default:
 		ptxservq = &psta->sta_xmitpriv.be_q;
 		*(ac) = 2;
-		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("rtw_get_sta_pending23a : BE\n"));
+		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
+			 "rtw_get_sta_pending23a : BE\n");
 		break;
 	}
 	return ptxservq;
@@ -1725,7 +1727,7 @@ int rtw_xmit23a_classifier(struct rtw_adapter *padapter,
 		res = _FAIL;
 		DBG_8723A("rtw_xmit23a_classifier: psta == NULL\n");
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-			 ("rtw_xmit23a_classifier: psta == NULL\n"));
+			 "rtw_xmit23a_classifier: psta == NULL\n");
 		goto exit;
 	}
 	if (!(psta->state & _FW_LINKED)) {
@@ -1876,14 +1878,15 @@ int rtw_xmit23a(struct rtw_adapter *padapter, struct sk_buff *skb)
 
 	if (pxmitframe == NULL) {
 		RT_TRACE(_module_xmit_osdep_c_, _drv_err_,
-			 ("rtw_xmit23a: no more pxmitframe\n"));
+			 "rtw_xmit23a: no more pxmitframe\n");
 		return -1;
 	}
 
 	res = update_attrib(padapter, skb, &pxmitframe->attrib);
 
 	if (res == _FAIL) {
-		RT_TRACE(_module_xmit_osdep_c_, _drv_err_, ("rtw_xmit23a: update attrib fail\n"));
+		RT_TRACE(_module_xmit_osdep_c_, _drv_err_,
+			 "rtw_xmit23a: update attrib fail\n");
 		rtw_free_xmitframe23a(pxmitpriv, pxmitframe);
 		return -1;
 	}
diff --git a/drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c b/drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c
index 2dc1856..ae090ab 100644
--- a/drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c
+++ b/drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c
@@ -59,17 +59,15 @@ u8 HalPwrSeqCmdParsing23a(struct rtw_adapter *padapter, u8 CutVersion,
 		PwrCfgCmd = PwrSeqCmd[AryIdx];
 
 		RT_TRACE(_module_hal_init_c_, _drv_info_,
-			 ("HalPwrSeqCmdParsing23a: offset(%#x) cut_msk(%#x) "
-			  "fab_msk(%#x) interface_msk(%#x) base(%#x) cmd(%#x) "
-			  "msk(%#x) value(%#x)\n",
-			  GET_PWR_CFG_OFFSET(PwrCfgCmd),
-			  GET_PWR_CFG_CUT_MASK(PwrCfgCmd),
-			  GET_PWR_CFG_FAB_MASK(PwrCfgCmd),
-			  GET_PWR_CFG_INTF_MASK(PwrCfgCmd),
-			  GET_PWR_CFG_BASE(PwrCfgCmd),
-			  GET_PWR_CFG_CMD(PwrCfgCmd),
-			  GET_PWR_CFG_MASK(PwrCfgCmd),
-			  GET_PWR_CFG_VALUE(PwrCfgCmd)));
+			 "HalPwrSeqCmdParsing23a: offset(%#x) cut_msk(%#x) fab_msk(%#x) interface_msk(%#x) base(%#x) cmd(%#x) msk(%#x) value(%#x)\n",
+			 GET_PWR_CFG_OFFSET(PwrCfgCmd),
+			 GET_PWR_CFG_CUT_MASK(PwrCfgCmd),
+			 GET_PWR_CFG_FAB_MASK(PwrCfgCmd),
+			 GET_PWR_CFG_INTF_MASK(PwrCfgCmd),
+			 GET_PWR_CFG_BASE(PwrCfgCmd),
+			 GET_PWR_CFG_CMD(PwrCfgCmd),
+			 GET_PWR_CFG_MASK(PwrCfgCmd),
+			 GET_PWR_CFG_VALUE(PwrCfgCmd));
 
 		/* 2 Only Handle the command whose FAB, CUT, and Interface are
 		   matched */
@@ -79,14 +77,12 @@ u8 HalPwrSeqCmdParsing23a(struct rtw_adapter *padapter, u8 CutVersion,
 			switch (GET_PWR_CFG_CMD(PwrCfgCmd)) {
 			case PWR_CMD_READ:
 				RT_TRACE(_module_hal_init_c_, _drv_info_,
-					 ("HalPwrSeqCmdParsing23a: "
-					  "PWR_CMD_READ\n"));
+					 "HalPwrSeqCmdParsing23a: PWR_CMD_READ\n");
 				break;
 
 			case PWR_CMD_WRITE:
 				RT_TRACE(_module_hal_init_c_, _drv_info_,
-					 ("HalPwrSeqCmdParsing23a: "
-					  "PWR_CMD_WRITE\n"));
+					 "HalPwrSeqCmdParsing23a: PWR_CMD_WRITE\n");
 				offset = GET_PWR_CFG_OFFSET(PwrCfgCmd);
 
 				/*  Read the value from system register */
@@ -102,8 +98,7 @@ u8 HalPwrSeqCmdParsing23a(struct rtw_adapter *padapter, u8 CutVersion,
 
 			case PWR_CMD_POLLING:
 				RT_TRACE(_module_hal_init_c_, _drv_info_,
-					 ("HalPwrSeqCmdParsing23a: "
-					  "PWR_CMD_POLLING\n"));
+					 "HalPwrSeqCmdParsing23a: PWR_CMD_POLLING\n");
 
 				bPollingBit = false;
 				offset = GET_PWR_CFG_OFFSET(PwrCfgCmd);
@@ -131,8 +126,7 @@ u8 HalPwrSeqCmdParsing23a(struct rtw_adapter *padapter, u8 CutVersion,
 
 			case PWR_CMD_DELAY:
 				RT_TRACE(_module_hal_init_c_, _drv_info_,
-					 ("HalPwrSeqCmdParsing23a: "
-					  "PWR_CMD_DELAY\n"));
+					 "HalPwrSeqCmdParsing23a: PWR_CMD_DELAY\n");
 				if (GET_PWR_CFG_VALUE(PwrCfgCmd) ==
 				    PWRSEQ_DELAY_US)
 					udelay(GET_PWR_CFG_OFFSET(PwrCfgCmd));
@@ -145,14 +139,12 @@ u8 HalPwrSeqCmdParsing23a(struct rtw_adapter *padapter, u8 CutVersion,
 				/*  When this command is parsed, end
 				    the process */
 				RT_TRACE(_module_hal_init_c_, _drv_info_,
-					 ("HalPwrSeqCmdParsing23a: "
-					  "PWR_CMD_END\n"));
+					 "HalPwrSeqCmdParsing23a: PWR_CMD_END\n");
 				return true;
 
 			default:
 				RT_TRACE(_module_hal_init_c_, _drv_err_,
-					 ("HalPwrSeqCmdParsing23a: "
-					  "Unknown CMD!!\n"));
+					 "HalPwrSeqCmdParsing23a: Unknown CMD!!\n");
 				break;
 			}
 		}
diff --git a/drivers/staging/rtl8723au/hal/hal_com.c b/drivers/staging/rtl8723au/hal/hal_com.c
index db7d57e..530db57 100644
--- a/drivers/staging/rtl8723au/hal/hal_com.c
+++ b/drivers/staging/rtl8723au/hal/hal_com.c
@@ -395,9 +395,6 @@ rtl8723a_set_ampdu_min_space(struct rtw_adapter *padapter, u8 MinSpacingToSet)
 		if (MinSpacingToSet < SecMinSpace)
 			MinSpacingToSet = SecMinSpace;
 
-		/* RT_TRACE(COMP_MLME, DBG_LOUD,
-		   ("Set HW_VAR_AMPDU_MIN_SPACE: %#x\n",
-		   padapter->MgntInfo.MinSpaceCfg)); */
 		MinSpacingToSet |=
 			rtl8723au_read8(padapter, REG_AMPDU_MIN_SPACE) & 0xf8;
 		rtl8723au_write8(padapter, REG_AMPDU_MIN_SPACE,
@@ -437,9 +434,6 @@ void rtl8723a_set_ampdu_factor(struct rtw_adapter *padapter, u8 FactorToSet)
 			rtl8723au_write8(padapter, REG_AGGLEN_LMT + index,
 					 pRegToSet[index]);
 		}
-
-		/* RT_TRACE(COMP_MLME, DBG_LOUD,
-		   ("Set HW_VAR_AMPDU_FACTOR: %#x\n", FactorToSet)); */
 	}
 }
 
@@ -624,14 +618,8 @@ void rtl8723a_cam_empty_entry(struct rtw_adapter *padapter, u8 ucIndex)
 		/*  write content 0 is equall to mark invalid */
 		/* delay_ms(40); */
 		rtl8723au_write32(padapter, WCAMI, ulContent);
-		/* RT_TRACE(COMP_SEC, DBG_LOUD,
-		   ("rtl8723a_cam_empty_entry(): WRITE A4: %lx\n",
-		   ulContent));*/
 		/* delay_ms(40); */
 		rtl8723au_write32(padapter, REG_CAMCMD, ulCommand);
-		/* RT_TRACE(COMP_SEC, DBG_LOUD,
-		   ("rtl8723a_cam_empty_entry(): WRITE A0: %lx\n",
-		   ulCommand));*/
 	}
 }
 
diff --git a/drivers/staging/rtl8723au/hal/odm_debug.c b/drivers/staging/rtl8723au/hal/odm_debug.c
index c912ab8..cb2bdda 100644
--- a/drivers/staging/rtl8723au/hal/odm_debug.c
+++ b/drivers/staging/rtl8723au/hal/odm_debug.c
@@ -22,3 +22,18 @@ void ODM_InitDebugSetting23a(struct dm_odm_t *pDM_Odm)
 }
 
 u32 GlobalDebugLevel23A;
+
+void rt_trace(int comp, int level, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	pr_info(DRIVER_PREFIX " [0x%08x,%d] %pV", comp, level, &vaf);
+
+	va_end(args);
+}
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
index 7f091da..cf15f80 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
@@ -1554,7 +1554,8 @@ static void bthci_ResetBtSec(struct rtw_adapter *padapter, struct bt_security *p
 		pBtSec->bUsedHwEncrypt = true;
 	else
 		pBtSec->bUsedHwEncrypt = false;
-	RT_TRACE(_module_rtl871x_security_c_, _drv_info_, ("%s: bUsedHwEncrypt =%d\n", __func__, pBtSec->bUsedHwEncrypt));
+	RT_TRACE(_module_rtl871x_security_c_, _drv_info_,
+		 "%s: bUsedHwEncrypt =%d\n", __func__, pBtSec->bUsedHwEncrypt);
 
 	pBtSec->RSNIE.Octet = pBtSec->RSNIEBuf;
 }
@@ -4518,8 +4519,8 @@ bthci_StateConnecting(struct rtw_adapter *padapter,
 		RTPRINT(FIOCTL, IOCTL_STATE, ("STATE_CMD_MAC_CONNECT_COMPLETE\n"));
 
 		if (pBTInfo->BtAsocEntry[EntryNum].AMPRole == AMP_BTAP_JOINER) {
-			RT_TRACE(_module_rtl871x_security_c_,
-				 _drv_info_, ("StateConnecting \n"));
+			RT_TRACE(_module_rtl871x_security_c_, _drv_info_,
+				 "StateConnecting\n");
 		}
 		break;
 	case STATE_CMD_DISCONNECT_PHY_LINK:
@@ -11196,15 +11197,17 @@ void rtl8723a_BT_init_hal_vars(struct rtw_adapter *padapter)
 	pHalData->bt_coexist.bt_radiosharedtype = pHalData->EEPROMBluetoothRadioShared;
 
 	RT_TRACE(_module_hal_init_c_, _drv_info_,
-		 ("BT Coexistance = 0x%x\n", rtl8723a_BT_coexist(padapter)));
+		 "BT Coexistance = 0x%x\n", rtl8723a_BT_coexist(padapter));
 
 	if (rtl8723a_BT_coexist(padapter)) {
 		if (pHalData->bt_coexist.BT_Ant_Num == Ant_x2) {
 			BTDM_SetBtCoexCurrAntNum(padapter, 2);
-			RT_TRACE(_module_hal_init_c_, _drv_info_, ("BlueTooth BT_Ant_Num = Antx2\n"));
+			RT_TRACE(_module_hal_init_c_, _drv_info_,
+				 "BlueTooth BT_Ant_Num = Antx2\n");
 		} else if (pHalData->bt_coexist.BT_Ant_Num == Ant_x1) {
 			BTDM_SetBtCoexCurrAntNum(padapter, 1);
-			RT_TRACE(_module_hal_init_c_, _drv_info_, ("BlueTooth BT_Ant_Num = Antx1\n"));
+			RT_TRACE(_module_hal_init_c_, _drv_info_,
+				 "BlueTooth BT_Ant_Num = Antx1\n");
 		}
 		pHalData->bt_coexist.bBTBusyTraffic = false;
 		pHalData->bt_coexist.bBTTrafficModeSet = false;
@@ -11213,8 +11216,8 @@ void rtl8723a_BT_init_hal_vars(struct rtw_adapter *padapter)
 		pHalData->bt_coexist.PreviousState = 0;
 
 		RT_TRACE(_module_hal_init_c_, _drv_info_,
-			 ("bt_radiosharedType = 0x%x\n",
-			 pHalData->bt_coexist.bt_radiosharedtype));
+			 "bt_radiosharedType = 0x%x\n",
+			 pHalData->bt_coexist.bt_radiosharedtype);
 	}
 }
 
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
index d3dc24b..04d0183 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
@@ -95,7 +95,7 @@ static int _WriteFW(struct rtw_adapter *padapter, void *buffer, u32 size)
 			goto exit;
 	}
 	RT_TRACE(_module_hal_init_c_, _drv_info_,
-		 ("_WriteFW Done- for Normal chip.\n"));
+		 "_WriteFW Done- for Normal chip.\n");
 
 exit:
 	return ret;
@@ -115,13 +115,13 @@ static int _FWFreeToGo(struct rtw_adapter *padapter)
 
 	if (counter >= POLLING_READY_TIMEOUT_COUNT) {
 		RT_TRACE(_module_hal_init_c_, _drv_err_,
-			 ("%s: chksum report fail! REG_MCUFWDL:0x%08x\n",
-			  __func__, value32));
+			 "%s: chksum report fail! REG_MCUFWDL:0x%08x\n",
+			 __func__, value32);
 		return _FAIL;
 	}
 	RT_TRACE(_module_hal_init_c_, _drv_info_,
-		 ("%s: Checksum report OK! REG_MCUFWDL:0x%08x\n", __func__,
-		  value32));
+		 "%s: Checksum report OK! REG_MCUFWDL:0x%08x\n", __func__,
+		 value32);
 
 	value32 = rtl8723au_read32(padapter, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
@@ -134,17 +134,16 @@ static int _FWFreeToGo(struct rtw_adapter *padapter)
 		value32 = rtl8723au_read32(padapter, REG_MCUFWDL);
 		if (value32 & WINTINI_RDY) {
 			RT_TRACE(_module_hal_init_c_, _drv_info_,
-				 ("%s: Polling FW ready success!! "
-				  "REG_MCUFWDL:0x%08x\n",
-				  __func__, value32));
+				 "%s: Polling FW ready success!! REG_MCUFWDL:0x%08x\n",
+				 __func__, value32);
 			return _SUCCESS;
 		}
 		udelay(5);
 	} while (counter++ < POLLING_READY_TIMEOUT_COUNT);
 
 	RT_TRACE(_module_hal_init_c_, _drv_err_,
-		 ("%s: Polling FW ready fail!! REG_MCUFWDL:0x%08x\n",
-		  __func__, value32));
+		 "%s: Polling FW ready fail!! REG_MCUFWDL:0x%08x\n",
+		 __func__, value32);
 	return _FAIL;
 }
 
@@ -173,8 +172,8 @@ void rtl8723a_FirmwareSelfReset(struct rtw_adapter *padapter)
 			u1bTmp = rtl8723au_read8(padapter, REG_SYS_FUNC_EN + 1);
 		}
 		RT_TRACE(_module_hal_init_c_, _drv_info_,
-			 ("-%s: 8051 reset success (%d)\n", __func__,
-			  Delay));
+			 "-%s: 8051 reset success (%d)\n", __func__,
+			 Delay);
 
 		if ((Delay == 0)) {
 			/* force firmware reset */
@@ -206,13 +205,12 @@ int rtl8723a_FirmwareDownload(struct rtw_adapter *padapter)
 	int fw_size;
 	static int log_version;
 
-	RT_TRACE(_module_hal_init_c_, _drv_info_, ("+%s\n", __func__));
+	RT_TRACE(_module_hal_init_c_, _drv_info_, "+%s\n", __func__);
 
 	if (IS_8723A_A_CUT(pHalData->VersionID)) {
 		fw_name = "rtlwifi/rtl8723aufw_A.bin";
 		RT_TRACE(_module_hal_init_c_, _drv_info_,
-			 ("rtl8723a_FirmwareDownload: R8723FwImageArray_UMC "
-			  "for RTL8723A A CUT\n"));
+			 "rtl8723a_FirmwareDownload: R8723FwImageArray_UMC for RTL8723A A CUT\n");
 	} else if (IS_8723A_B_CUT(pHalData->VersionID)) {
 		/*  WLAN Fw. */
 		if (padapter->registrypriv.wifi_spec == 1) {
@@ -234,7 +232,7 @@ int rtl8723a_FirmwareDownload(struct rtw_adapter *padapter)
 		/*  <Roger_TODO> We should download proper RAM Code here
 		    to match the ROM code. */
 		RT_TRACE(_module_hal_init_c_, _drv_err_,
-			 ("%s: unknow version!\n", __func__));
+			 "%s: unknown version!\n", __func__);
 		rtStatus = _FAIL;
 		goto Exit;
 	}
@@ -319,11 +317,11 @@ int rtl8723a_FirmwareDownload(struct rtw_adapter *padapter)
 	rtStatus = _FWFreeToGo(padapter);
 	if (_SUCCESS != rtStatus) {
 		RT_TRACE(_module_hal_init_c_, _drv_err_,
-			 ("DL Firmware failed!\n"));
+			 "DL Firmware failed!\n");
 		goto Exit;
 	}
 	RT_TRACE(_module_hal_init_c_, _drv_info_,
-		 ("Firmware is ready to run!\n"));
+		 "Firmware is ready to run!\n");
 
 Exit:
 	kfree(firmware_buf);
@@ -819,7 +817,7 @@ static void ResumeTxBeacon(struct rtw_adapter *padapter)
 	    we record the value */
 	/*  which should be read from register to a global variable. */
 
-	RT_TRACE(_module_hci_hal_init_c_, _drv_info_, ("+ResumeTxBeacon\n"));
+	RT_TRACE(_module_hci_hal_init_c_, _drv_info_, "+ResumeTxBeacon\n");
 
 	pHalData->RegFwHwTxQCtrl |= BIT(6);
 	rtl8723au_write8(padapter, REG_FWHW_TXQ_CTRL + 2,
@@ -837,7 +835,7 @@ static void StopTxBeacon(struct rtw_adapter *padapter)
 	    we record the value */
 	/*  which should be read from register to a global variable. */
 
-	RT_TRACE(_module_hci_hal_init_c_, _drv_info_, ("+StopTxBeacon\n"));
+	RT_TRACE(_module_hci_hal_init_c_, _drv_info_, "+StopTxBeacon\n");
 
 	pHalData->RegFwHwTxQCtrl &= ~BIT(6);
 	rtl8723au_write8(padapter, REG_FWHW_TXQ_CTRL + 2,
@@ -983,7 +981,7 @@ int c2h_handler_8723a(struct rtw_adapter *padapter, struct c2h_evt_hdr *c2h_evt)
 	switch (c2h_evt->id) {
 	case C2H_DBG:
 		RT_TRACE(_module_hal_init_c_, _drv_info_,
-			 ("C2HCommandHandler: %s\n", c2h_evt->payload));
+			 "C2HCommandHandler: %s\n", c2h_evt->payload);
 		break;
 
 	case C2H_CCX_TX_RPT:
@@ -993,22 +991,22 @@ int c2h_handler_8723a(struct rtw_adapter *padapter, struct c2h_evt_hdr *c2h_evt)
 		break;
 	case C2H_HW_INFO_EXCH:
 		RT_TRACE(_module_hal_init_c_, _drv_info_,
-			 ("[BT], C2H_HW_INFO_EXCH\n"));
+			 "[BT], C2H_HW_INFO_EXCH\n");
 		for (i = 0; i < c2h_evt->plen; i++) {
 			RT_TRACE(_module_hal_init_c_, _drv_info_,
-				 ("[BT], tmpBuf[%d]= 0x%x\n", i,
-				  c2h_evt->payload[i]));
+				 "[BT], tmpBuf[%d]= 0x%x\n", i,
+				 c2h_evt->payload[i]);
 		}
 		break;
 
 	case C2H_C2H_H2C_TEST:
 		RT_TRACE(_module_hal_init_c_, _drv_info_,
-			 ("[BT], C2H_H2C_TEST\n"));
+			 "[BT], C2H_H2C_TEST\n");
 		RT_TRACE(_module_hal_init_c_, _drv_info_,
-			 ("[BT], tmpBuf[0]/[1]/[2]/[3]/[4]= 0x%x/ 0x%x/ "
-			  "0x%x/ 0x%x/ 0x%x\n", c2h_evt->payload[0],
-			  c2h_evt->payload[1], c2h_evt->payload[2],
-			  c2h_evt->payload[3], c2h_evt->payload[4]));
+			 "[BT], tmpBuf[0]/[1]/[2]/[3]/[4]= 0x%x/ 0x%x/ 0x%x/ 0x%x/ 0x%x\n",
+			 c2h_evt->payload[0],
+			 c2h_evt->payload[1], c2h_evt->payload[2],
+			 c2h_evt->payload[3], c2h_evt->payload[4]);
 		break;
 
 	case C2H_BT_INFO:
@@ -1141,8 +1139,8 @@ static int _LLTWrite(struct rtw_adapter *padapter, u32 address, u32 data)
 
 		if (count > POLLING_LLT_THRESHOLD) {
 			RT_TRACE(_module_hal_init_c_, _drv_err_,
-				 ("Failed to polling write LLT done at "
-				  "address %d!\n", address));
+				 "Failed to polling write LLT done at address %d!\n",
+				 address);
 			status = _FAIL;
 			break;
 		}
@@ -1254,8 +1252,6 @@ e.	SYS_FUNC_EN 0x02[7:0] = 0x14		reset BB state machine
 
 	/*  2010/08/12 MH We need to set BB/GLBAL reset to save power
 	    for SS mode. */
-
-/*	RT_TRACE(COMP_INIT, DBG_LOUD, ("======> RF off and reset BB.\n")); */
 }
 
 static void _ResetDigitalProcedure1_92C(struct rtw_adapter *padapter,
@@ -1384,8 +1380,6 @@ static void _DisableAnalog(struct rtw_adapter *padapter, bool bWithoutHWSM)
 		value8 = rtl8723au_read8(padapter, REG_LDOV12D_CTRL);
 		value8 &= ~LDV12_EN;
 		rtl8723au_write8(padapter, REG_LDOV12D_CTRL, value8);
-/*		RT_TRACE(COMP_INIT, DBG_LOUD,
-		(" REG_LDOV12D_CTRL Reg0x21:0x%02x.\n", value8)); */
 	}
 
 	/*****************************
@@ -1433,7 +1427,7 @@ int CardDisableHWSM(struct rtw_adapter *padapter, u8 resetMCU)
 	_DisableAnalog(padapter, false);
 
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-		 ("======> Card disable finished.\n"));
+		 "======> Card disable finished.\n");
 
 	return _SUCCESS;
 }
@@ -1459,8 +1453,6 @@ int CardDisableWithoutHWSM(struct rtw_adapter *padapter)
 	/*   ==== Disable analog sequence === */
 	_DisableAnalog(padapter, true);
 
-	/* RT_TRACE(COMP_INIT, DBG_LOUD,
-	   ("<====== Card Disable Without HWSM .\n")); */
 	return _SUCCESS;
 }
 
@@ -1477,7 +1469,7 @@ void Hal_InitPGData(struct rtw_adapter *padapter, u8 *PROMContent)
 		}
 	} else {
 		RT_TRACE(_module_hci_hal_init_c_, _drv_notice_,
-			 ("AutoLoad Fail reported from CR9346!!\n"));
+			 "AutoLoad Fail reported from CR9346!!\n");
 		/* update to default value 0xFF */
 		if (!pEEPROM->EepromOrEfuse)
 			EFUSE_ShadowMapUpdate23a(padapter, EFUSE_WIFI);
@@ -1502,7 +1494,7 @@ void Hal_EfuseParseIDCode(struct rtw_adapter *padapter, u8 *hwinfo)
 	}
 
 	RT_TRACE(_module_hal_init_c_, _drv_info_,
-		 ("EEPROM ID = 0x%04x\n", EEPROMId));
+		 "EEPROM ID = 0x%04x\n", EEPROMId);
 }
 
 static void Hal_EEValueCheck(u8 EEType, void *pInValue, void *pOutValue)
@@ -1517,9 +1509,8 @@ static void Hal_EEValueCheck(u8 EEType, void *pInValue, void *pOutValue)
 			*pOut = *pIn;
 		else {
 			RT_TRACE(_module_hci_hal_init_c_, _drv_err_,
-				 ("EETYPE_TX_PWR, value =%d is invalid, set "
-				  "to default = 0x%x\n",
-				  *pIn, EEPROM_Default_TxPowerLevel));
+				 "EETYPE_TX_PWR, value =%d is invalid, set to default = 0x%x\n",
+				 *pIn, EEPROM_Default_TxPowerLevel);
 			*pOut = EEPROM_Default_TxPowerLevel;
 		}
 	}
@@ -1657,35 +1648,34 @@ Hal_EfuseParsetxpowerinfo_8723A(struct rtw_adapter *padapter,
 	for (rfPath = 0; rfPath < RF_PATH_MAX; rfPath++) {
 		for (ch = 0; ch < CHANNEL_MAX_NUMBER; ch++) {
 			RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-				 ("RF(%u)-Ch(%u) [CCK / HT40_1S / HT40_2S] = "
-				  "[0x%x / 0x%x / 0x%x]\n",
-				  rfPath, ch,
-				  pHalData->TxPwrLevelCck[rfPath][ch],
-				  pHalData->TxPwrLevelHT40_1S[rfPath][ch],
-				  pHalData->TxPwrLevelHT40_2S[rfPath][ch]));
+				 "RF(%u)-Ch(%u) [CCK / HT40_1S / HT40_2S] = [0x%x / 0x%x / 0x%x]\n",
+				 rfPath, ch,
+				 pHalData->TxPwrLevelCck[rfPath][ch],
+				 pHalData->TxPwrLevelHT40_1S[rfPath][ch],
+				 pHalData->TxPwrLevelHT40_2S[rfPath][ch]);
 
 		}
 	}
 	for (ch = 0; ch < CHANNEL_MAX_NUMBER; ch++) {
 		RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-			 ("RF-A Ht20 to HT40 Diff[%u] = 0x%x(%d)\n", ch,
-			  pHalData->TxPwrHt20Diff[RF_PATH_A][ch],
-			  pHalData->TxPwrHt20Diff[RF_PATH_A][ch]));
+			 "RF-A Ht20 to HT40 Diff[%u] = 0x%x(%d)\n", ch,
+			 pHalData->TxPwrHt20Diff[RF_PATH_A][ch],
+			 pHalData->TxPwrHt20Diff[RF_PATH_A][ch]);
 	}
 	for (ch = 0; ch < CHANNEL_MAX_NUMBER; ch++)
 		RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-			 ("RF-A Legacy to Ht40 Diff[%u] = 0x%x\n", ch,
-			  pHalData->TxPwrLegacyHtDiff[RF_PATH_A][ch]));
+			 "RF-A Legacy to Ht40 Diff[%u] = 0x%x\n", ch,
+			 pHalData->TxPwrLegacyHtDiff[RF_PATH_A][ch]);
 	for (ch = 0; ch < CHANNEL_MAX_NUMBER; ch++) {
 		RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-			 ("RF-B Ht20 to HT40 Diff[%u] = 0x%x(%d)\n", ch,
-			  pHalData->TxPwrHt20Diff[RF_PATH_B][ch],
-			  pHalData->TxPwrHt20Diff[RF_PATH_B][ch]));
+			 "RF-B Ht20 to HT40 Diff[%u] = 0x%x(%d)\n", ch,
+			 pHalData->TxPwrHt20Diff[RF_PATH_B][ch],
+			 pHalData->TxPwrHt20Diff[RF_PATH_B][ch]);
 	}
 	for (ch = 0; ch < CHANNEL_MAX_NUMBER; ch++)
 		RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-			 ("RF-B Legacy to HT40 Diff[%u] = 0x%x\n", ch,
-			  pHalData->TxPwrLegacyHtDiff[RF_PATH_B][ch]));
+			 "RF-B Legacy to HT40 Diff[%u] = 0x%x\n", ch,
+			 pHalData->TxPwrLegacyHtDiff[RF_PATH_B][ch]);
 	if (!AutoLoadFail) {
 		struct registry_priv *registry_par = &padapter->registrypriv;
 		if (registry_par->regulatory_tid == 0xff) {
@@ -1702,7 +1692,7 @@ Hal_EfuseParsetxpowerinfo_8723A(struct rtw_adapter *padapter,
 		pHalData->EEPROMRegulatory = 0;
 	}
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-		 ("EEPROMRegulatory = 0x%x\n", pHalData->EEPROMRegulatory));
+		 "EEPROMRegulatory = 0x%x\n", pHalData->EEPROMRegulatory);
 
 	if (!AutoLoadFail)
 		pHalData->bTXPowerDataReadFromEEPORM = true;
@@ -1752,8 +1742,8 @@ Hal_EfuseParseEEPROMVer(struct rtw_adapter *padapter,
 	else
 		pHalData->EEPROMVersion = 1;
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-		 ("Hal_EfuseParseEEPROMVer(), EEVer = %d\n",
-		  pHalData->EEPROMVersion));
+		 "Hal_EfuseParseEEPROMVer(), EEVer = %d\n",
+		 pHalData->EEPROMVersion);
 }
 
 void
@@ -1786,10 +1776,10 @@ Hal_EfuseParseCustomerID(struct rtw_adapter *padapter,
 		pHalData->EEPROMSubCustomerID = 0;
 	}
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-		 ("EEPROM Customer ID: 0x%2x\n", pHalData->EEPROMCustomerID));
+		 "EEPROM Customer ID: 0x%2x\n", pHalData->EEPROMCustomerID);
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-		 ("EEPROM SubCustomer ID: 0x%02x\n",
-		  pHalData->EEPROMSubCustomerID));
+		 "EEPROM SubCustomer ID: 0x%02x\n",
+		 pHalData->EEPROMSubCustomerID);
 }
 
 void
@@ -1818,8 +1808,8 @@ Hal_EfuseParseXtal_8723A(struct rtw_adapter *pAdapter,
 		pHalData->CrystalCap = EEPROM_Default_CrystalCap_8723A;
 	}
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-		 ("%s: CrystalCap = 0x%2x\n", __func__,
-		  pHalData->CrystalCap));
+		 "%s: CrystalCap = 0x%2x\n", __func__,
+		 pHalData->CrystalCap);
 }
 
 void
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c b/drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c
index 38f8c3d..46a3065 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c
@@ -121,8 +121,6 @@ PHY_SetBBReg(struct rtw_adapter *Adapter, u32 RegAddr, u32 BitMask, u32	Data)
 {
 	u32 OriginalValue, BitShift;
 
-	/* RT_TRACE(COMP_RF, DBG_TRACE, ("--->PHY_SetBBReg(): RegAddr(%#lx), BitMask(%#lx), Data(%#lx)\n", RegAddr, BitMask, Data)); */
-
 	if (BitMask != bMaskDWord) {/* if not "double word" write */
 		OriginalValue = rtl8723au_read32(Adapter, RegAddr);
 		BitShift = phy_CalculateBitShift(BitMask);
@@ -132,7 +130,6 @@ PHY_SetBBReg(struct rtw_adapter *Adapter, u32 RegAddr, u32 BitMask, u32	Data)
 	rtl8723au_write32(Adapter, RegAddr, Data);
 
 	/* RTPRINT(FPHY, PHY_BBW, ("BBW MASK = 0x%lx Addr[0x%lx]= 0x%lx\n", BitMask, RegAddr, Data)); */
-	/* RT_TRACE(COMP_RF, DBG_TRACE, ("<---PHY_SetBBReg(): RegAddr(%#lx), BitMask(%#lx), Data(%#lx)\n", RegAddr, BitMask, Data)); */
 }
 
 /*  */
@@ -548,131 +545,51 @@ storePwrIndexDiffRateOffset(struct rtw_adapter *Adapter, u32 RegAddr,
 
 	if (RegAddr == rTxAGC_A_Rate18_06) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][0] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][0] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][0])); */
 	}
 	if (RegAddr == rTxAGC_A_Rate54_24) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][1] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][1] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][1])); */
 	}
 	if (RegAddr == rTxAGC_A_CCK1_Mcs32) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][6] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][6] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][6])); */
 	}
 	if (RegAddr == rTxAGC_B_CCK11_A_CCK2_11 && BitMask == 0xffffff00) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][7] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][7] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][7])); */
 	}
 	if (RegAddr == rTxAGC_A_Mcs03_Mcs00) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][2] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][2] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][2])); */
 	}
 	if (RegAddr == rTxAGC_A_Mcs07_Mcs04) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][3] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][3] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][3])); */
 	}
 	if (RegAddr == rTxAGC_A_Mcs11_Mcs08) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][4] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][4] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][4])); */
 	}
 	if (RegAddr == rTxAGC_A_Mcs15_Mcs12) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][5] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][5] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][5])); */
 	}
 	if (RegAddr == rTxAGC_B_Rate18_06) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][8] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][8] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][8])); */
 	}
 	if (RegAddr == rTxAGC_B_Rate54_24) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][9] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][9] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][9])); */
 	}
 	if (RegAddr == rTxAGC_B_CCK1_55_Mcs32) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][14] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][14] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][14])); */
 	}
 	if (RegAddr == rTxAGC_B_CCK11_A_CCK2_11 && BitMask == 0x000000ff) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][15] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][15] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][15])); */
 	}
 	if (RegAddr == rTxAGC_B_Mcs03_Mcs00) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][10] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][10] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][10])); */
 	}
 	if (RegAddr == rTxAGC_B_Mcs07_Mcs04) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][11] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][11] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][11])); */
 	}
 	if (RegAddr == rTxAGC_B_Mcs11_Mcs08) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][12] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][12] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][12])); */
 	}
 	if (RegAddr == rTxAGC_B_Mcs15_Mcs12) {
 		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][13] = Data;
-		/* RT_TRACE(COMP_INIT, DBG_TRACE,
-		   ("MCSTxPowerLevelOriginalOffset[%d][13] = 0x%lx\n",
-		   pHalData->pwrGroupCnt, */
-		/*	pHalData->MCSTxPowerLevelOriginalOffset[
-			pHalData->pwrGroupCnt][13])); */
 		pHalData->pwrGroupCnt++;
 	}
 }
@@ -974,10 +891,7 @@ _PHY_SetBWMode23a92C(struct rtw_adapter *Adapter)
 		break;
 
 	default:
-		/*RT_TRACE(COMP_DBG, DBG_LOUD,
-		  ("PHY_SetBWMode23aCallback8192C(): unknown Bandwidth: %#X\n" \
-		  , pHalData->CurrentChannelBW));*/
-			break;
+		break;
 	}
 	/* Skip over setting of J-mode in BB register here. Default value
 	   is "None J mode". Emily 20070315 */
@@ -986,13 +900,8 @@ _PHY_SetBWMode23a92C(struct rtw_adapter *Adapter)
 	/* NowL = PlatformEFIORead4Byte(Adapter, TSFR); */
 	/* NowH = PlatformEFIORead4Byte(Adapter, TSFR+4); */
 	/* EndTime = ((u64)NowH << 32) + NowL; */
-	/* RT_TRACE(COMP_SCAN, DBG_LOUD, ("SetBWMode23aCallback8190Pci: time
-	   of SetBWMode23a = %I64d us!\n", (EndTime - BeginTime))); */
 
 	rtl8723a_phy_rf6052set_bw(Adapter, pHalData->CurrentChannelBW);
-
-	/* RT_TRACE(COMP_SCAN, DBG_LOUD,
-	   ("<== PHY_SetBWMode23aCallback8192C() \n")); */
 }
 
  /*-----------------------------------------------------------------------------
diff --git a/drivers/staging/rtl8723au/hal/rtl8723au_recv.c b/drivers/staging/rtl8723au/hal/rtl8723au_recv.c
index aae433f..0fec84b 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723au_recv.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723au_recv.c
@@ -48,7 +48,7 @@ int rtl8723au_init_recv_priv(struct rtw_adapter *padapter)
 	if (!precvpriv->precv_buf) {
 		res = _FAIL;
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-			 ("alloc recv_buf fail!\n"));
+			 "alloc recv_buf fail!\n");
 		goto exit;
 	}
 
diff --git a/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c b/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
index 1759487..2496ea6 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
@@ -272,7 +272,8 @@ static s32 update_txdesc(struct xmit_frame *pxmitframe, u8 *pmem, s32 sz, u8 bag
 	if (bmcst)
 		ptxdesc->txdw0 |= cpu_to_le32(BIT(24));
 
-	RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("offset0-txdesc = 0x%x\n", ptxdesc->txdw0));
+	RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
+		 "offset0-txdesc = 0x%x\n", ptxdesc->txdw0);
 
 	/* offset 4 */
 	/*  pkt_offset, unit:8 bytes padding */
@@ -303,7 +304,7 @@ static int rtw_dump_xframe(struct rtw_adapter *padapter,
 
 	mem_addr = pxmitframe->buf_addr;
 
-	RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("rtw_dump_xframe()\n"));
+	RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, "rtw_dump_xframe()\n");
 
 	for (t = 0; t < pattrib->nr_frags; t++) {
 		if (inner_ret != _SUCCESS && ret == _SUCCESS)
@@ -311,7 +312,7 @@ static int rtw_dump_xframe(struct rtw_adapter *padapter,
 
 		if (t != (pattrib->nr_frags - 1)) {
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
-				 ("pattrib->nr_frags =%d\n", pattrib->nr_frags));
+				 "pattrib->nr_frags =%d\n", pattrib->nr_frags);
 
 			sz = pxmitpriv->frag_len;
 			sz = sz - 4 - pattrib->icv_len;
@@ -338,7 +339,7 @@ static int rtw_dump_xframe(struct rtw_adapter *padapter,
 		rtw_count_tx_stats23a(padapter, pxmitframe, sz);
 
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
-			 ("rtw_write_port, w_sz =%d\n", w_sz));
+			 "rtw_write_port, w_sz =%d\n", w_sz);
 
 		mem_addr += w_sz;
 
@@ -365,7 +366,7 @@ bool rtl8723au_xmitframe_complete(struct rtw_adapter *padapter,
 	phwxmits = pxmitpriv->hwxmits;
 	hwentry = pxmitpriv->hwxmit_entry;
 
-	RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("xmitframe_complete()\n"));
+	RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, "xmitframe_complete()\n");
 
 	if (pxmitbuf == NULL) {
 		pxmitbuf = rtw_alloc_xmitbuf23a(pxmitpriv);
@@ -388,7 +389,8 @@ bool rtl8723au_xmitframe_complete(struct rtw_adapter *padapter,
 			rtw_os_xmit_complete23a(padapter, pxmitframe);/* always return ndis_packet after rtw_xmitframe_coalesce23a */
 		}
 
-		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("xmitframe_complete(): rtw_dump_xframe\n"));
+		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
+			 "xmitframe_complete(): rtw_dump_xframe\n");
 
 		if (res == _SUCCESS) {
 			rtw_dump_xframe(padapter, pxmitframe);
@@ -481,7 +483,7 @@ enqueue:
 
 	if (res != _SUCCESS) {
 		RT_TRACE(_module_xmit_osdep_c_, _drv_err_,
-			 ("pre_xmitframe: enqueue xmitframe fail\n"));
+			 "pre_xmitframe: enqueue xmitframe fail\n");
 		rtw_free_xmitframe23a(pxmitpriv, pxmitframe);
 
 		/*  Trick, make the statistics correct */
diff --git a/drivers/staging/rtl8723au/hal/usb_halinit.c b/drivers/staging/rtl8723au/hal/usb_halinit.c
index 0d08863..42ae29d 100644
--- a/drivers/staging/rtl8723au/hal/usb_halinit.c
+++ b/drivers/staging/rtl8723au/hal/usb_halinit.c
@@ -516,7 +516,7 @@ int rtl8723au_hal_init(struct rtw_adapter *Adapter)
 	/*  Check if MAC has already power on. by tynli. 2011.05.27. */
 	val8 = rtl8723au_read8(Adapter, REG_CR);
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-		 ("%s: REG_CR 0x100 = 0x%02x\n", __func__, val8));
+		 "%s: REG_CR 0x100 = 0x%02x\n", __func__, val8);
 	/* Fix 92DU-VC S3 hang with the reason is that secondary mac is not
 	   initialized. */
 	/* 0x100 value of first mac is 0xEA while 0x100 value of secondary
@@ -526,13 +526,13 @@ int rtl8723au_hal_init(struct rtw_adapter *Adapter)
 	} else {
 		mac_on = true;
 		RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-			 ("%s: MAC has already power on\n", __func__));
+			 "%s: MAC has already power on\n", __func__);
 	}
 
 	status = _InitPowerOn(Adapter);
 	if (status == _FAIL) {
 		RT_TRACE(_module_hci_hal_init_c_, _drv_err_,
-			 ("Failed to init power on!\n"));
+			 "Failed to init power on!\n");
 		goto exit;
 	}
 
@@ -547,7 +547,7 @@ int rtl8723au_hal_init(struct rtw_adapter *Adapter)
 		status =  InitLLTTable23a(Adapter, boundary);
 		if (status == _FAIL) {
 			RT_TRACE(_module_hci_hal_init_c_, _drv_err_,
-				 ("Failed to init LLT table\n"));
+				 "Failed to init LLT table\n");
 			goto exit;
 		}
 	}
@@ -623,8 +623,8 @@ int rtl8723au_hal_init(struct rtw_adapter *Adapter)
 	rtl8723au_write32(Adapter, rFPGA0_XA_RFInterfaceOE, 0x66F60210);
 
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-		 ("%s: 0x870 = value 0x%x\n", __func__,
-		  rtl8723au_read32(Adapter, 0x870)));
+		 "%s: 0x870 = value 0x%x\n", __func__,
+		 rtl8723au_read32(Adapter, 0x870));
 
 	/*  */
 	/*  Joseph Note: Keep RfRegChnlVal for later use. */
@@ -744,7 +744,8 @@ int rtl8723au_hal_init(struct rtw_adapter *Adapter)
 	if (((rtl8723au_read32(Adapter, rFPGA0_RFMOD) & 0xFF000000) !=
 	     0x83000000)) {
 		PHY_SetBBReg(Adapter, rFPGA0_RFMOD, BIT(24), 1);
-		RT_TRACE(_module_hci_hal_init_c_, _drv_err_, ("%s: IQK fail recorver\n", __func__));
+		RT_TRACE(_module_hci_hal_init_c_, _drv_err_,
+			 "%s: IQK fail recover\n", __func__);
 	}
 
 	/* ack for xmit mgmt frames. */
@@ -817,7 +818,7 @@ static void phy_SsPwrSwitch92CU(struct rtw_adapter *Adapter,
 		else
 			sps0 &= ~(BIT(0) | BIT(3));
 
-		RT_TRACE(_module_hal_init_c_, _drv_err_, ("SS LVL1\n"));
+		RT_TRACE(_module_hal_init_c_, _drv_err_, "SS LVL1\n");
 		/*  Disable RF and BB only for SelectSuspend. */
 
 		/*  1. Set BB/RF to shutdown. */
@@ -933,14 +934,14 @@ int rtl8723au_inirp_init(struct rtw_adapter *Adapter)
 
 	status = _SUCCESS;
 
-	RT_TRACE(_module_hci_hal_init_c_, _drv_info_, ("===> usb_inirp_init\n"));
+	RT_TRACE(_module_hci_hal_init_c_, _drv_info_, "===> usb_inirp_init\n");
 
 	/* issue Rx irp to receive data */
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
 	for (i = 0; i < NR_RECVBUFF; i++) {
 		if (rtl8723au_read_port(Adapter, 0, precvbuf) == _FAIL) {
 			RT_TRACE(_module_hci_hal_init_c_, _drv_err_,
-				 ("usb_rx_init: usb_read_port error\n"));
+				 "usb_rx_init: usb_read_port error\n");
 			status = _FAIL;
 			goto exit;
 		}
@@ -948,7 +949,7 @@ int rtl8723au_inirp_init(struct rtw_adapter *Adapter)
 	}
 	if (rtl8723au_read_interrupt(Adapter) == _FAIL) {
 		RT_TRACE(_module_hci_hal_init_c_, _drv_err_,
-			 ("%s: usb_read_interrupt error\n", __func__));
+			 "%s: usb_read_interrupt error\n", __func__);
 		status = _FAIL;
 	}
 	pHalData->IntrMask[0] = rtl8723au_read32(Adapter, REG_USB_HIMR);
@@ -957,7 +958,7 @@ int rtl8723au_inirp_init(struct rtw_adapter *Adapter)
 	rtl8723au_write32(Adapter, REG_USB_HIMR, pHalData->IntrMask[0]);
 exit:
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-		 ("<=== usb_inirp_init\n"));
+		 "<=== usb_inirp_init\n");
 	return status;
 }
 
@@ -966,7 +967,7 @@ int rtl8723au_inirp_deinit(struct rtw_adapter *Adapter)
 	struct hal_data_8723a	*pHalData = GET_HAL_DATA(Adapter);
 
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-		 ("\n ===> usb_rx_deinit\n"));
+		 "===> usb_rx_deinit\n");
 	rtl8723au_read_port_cancel(Adapter);
 	pHalData->IntrMask[0] = rtl8723au_read32(Adapter, REG_USB_HIMR);
 	MSG_8723A("%s pHalData->IntrMask = 0x%04x\n", __func__,
@@ -974,7 +975,7 @@ int rtl8723au_inirp_deinit(struct rtw_adapter *Adapter)
 	pHalData->IntrMask[0] = 0x0;
 	rtl8723au_write32(Adapter, REG_USB_HIMR, pHalData->IntrMask[0]);
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_,
-		 ("\n <=== usb_rx_deinit\n"));
+		 "<=== usb_rx_deinit\n");
 	return _SUCCESS;
 }
 
@@ -1021,11 +1022,10 @@ static void Hal_EfuseParseMACAddr_8723AU(struct rtw_adapter *padapter,
 	}
 
 	RT_TRACE(_module_hci_hal_init_c_, _drv_notice_,
-		 ("Hal_EfuseParseMACAddr_8723AU: Permanent Address =%02x:%02x:"
-		  "%02x:%02x:%02x:%02x\n",
-		  pEEPROM->mac_addr[0], pEEPROM->mac_addr[1],
-		  pEEPROM->mac_addr[2], pEEPROM->mac_addr[3],
-		  pEEPROM->mac_addr[4], pEEPROM->mac_addr[5]));
+		 "Hal_EfuseParseMACAddr_8723AU: Permanent Address =%02x:%02x:%02x:%02x:%02x:%02x\n",
+		 pEEPROM->mac_addr[0], pEEPROM->mac_addr[1],
+		 pEEPROM->mac_addr[2], pEEPROM->mac_addr[3],
+		 pEEPROM->mac_addr[4], pEEPROM->mac_addr[5]);
 }
 
 static void readAdapterInfo(struct rtw_adapter *padapter)
@@ -1165,8 +1165,6 @@ int GetHalDefVar8192CUsb(struct rtw_adapter *Adapter,
 	}
 		break;
 	default:
-		/* RT_TRACE(COMP_INIT, DBG_WARNING, ("GetHalDefVar8192CUsb(): "
-		   "Unkown variable: %d!\n", eVariable)); */
 		bResult = _FAIL;
 		break;
 	}
diff --git a/drivers/staging/rtl8723au/hal/usb_ops_linux.c b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
index a6d16ad..371e6b3 100644
--- a/drivers/staging/rtl8723au/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
@@ -297,14 +297,12 @@ urb_submit:
 		case -ENODEV:
 		case -ESHUTDOWN:
 			RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-				 ("usb_read_port_complete:bSurpriseRemoved ="
-				  "true\n"));
+				 "usb_read_port_complete:bSurpriseRemoved =true\n");
 			/* Fall Through here */
 		case -ENOENT:
 			padapter->bDriverStopped = true;
 			RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-				 ("usb_read_port_complete:bDriverStopped ="
-				  "true\n"));
+				 "usb_read_port_complete:bDriverStopped =true\n");
 			break;
 		case -EPROTO:
 			break;
@@ -367,16 +365,16 @@ static int recvbuf2recvframe(struct rtw_adapter *padapter, struct sk_buff *pskb)
 
 	do {
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-			 ("recvbuf2recvframe: rxdesc = offsset 0:0x%08x, "
-			  "4:0x%08x, 8:0x%08x, C:0x%08x\n", prxstat->rxdw0,
-			  prxstat->rxdw1, prxstat->rxdw2, prxstat->rxdw4));
+			 "recvbuf2recvframe: rxdesc = offsset 0:0x%08x, 4:0x%08x, 8:0x%08x, C:0x%08x\n",
+			 prxstat->rxdw0, prxstat->rxdw1,
+			 prxstat->rxdw2, prxstat->rxdw4);
 
 		prxstat = (struct recv_stat *)pbuf;
 
 		precvframe = rtw_alloc_recvframe23a(pfree_recv_queue);
 		if (!precvframe) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("recvbuf2recvframe: precvframe == NULL\n"));
+				 "recvbuf2recvframe: precvframe == NULL\n");
 			DBG_8723A("%s()-%d: rtw_alloc_recvframe23a() failed! RX "
 				  "Drop!\n", __func__, __LINE__);
 			goto _exit_recvbuf2recvframe;
@@ -400,7 +398,7 @@ static int recvbuf2recvframe(struct rtw_adapter *padapter, struct sk_buff *pskb)
 
 		if (pattrib->pkt_len <= 0 || pkt_offset > transfer_len) {
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
-				 ("recvbuf2recvframe: pkt_len<= 0\n"));
+				 "recvbuf2recvframe: pkt_len<= 0\n");
 			DBG_8723A("%s()-%d: RX Warning!\n",
 				  __func__, __LINE__);
 			rtw_free_recvframe23a(precvframe);
@@ -471,8 +469,7 @@ static int recvbuf2recvframe(struct rtw_adapter *padapter, struct sk_buff *pskb)
 
 		if (rtw_recv_entry23a(precvframe) != _SUCCESS)
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-				 ("recvbuf2recvframe: rtw_recv_entry23a"
-				  "(precvframe) != _SUCCESS\n"));
+				 "recvbuf2recvframe: rtw_recv_entry23a(precvframe) != _SUCCESS\n");
 
 		pkt_cnt--;
 		transfer_len -= pkt_offset;
@@ -520,16 +517,15 @@ static void usb_read_port_complete(struct urb *purb)
 	struct recv_priv *precvpriv = &padapter->recvpriv;
 
 	RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-		 ("usb_read_port_complete!!!\n"));
+		 "usb_read_port_complete!!!\n");
 
 	precvpriv->rx_pending_cnt--;
 
 	if (padapter->bSurpriseRemoved || padapter->bDriverStopped ||
 	    padapter->bReadPortCancel) {
 		RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-			 ("usb_read_port_complete:bDriverStopped(%d) OR "
-			  "bSurpriseRemoved(%d)\n", padapter->bDriverStopped,
-			  padapter->bSurpriseRemoved));
+			 "usb_read_port_complete:bDriverStopped(%d) OR bSurpriseRemoved(%d)\n",
+			 padapter->bDriverStopped, padapter->bSurpriseRemoved);
 
 		DBG_8723A("%s()-%d: RX Warning! bDriverStopped(%d) OR "
 			  "bSurpriseRemoved(%d) bReadPortCancel(%d)\n",
@@ -542,9 +538,7 @@ static void usb_read_port_complete(struct urb *purb)
 		if (purb->actual_length > MAX_RECVBUF_SZ ||
 		    purb->actual_length < RXDESC_SIZE) {
 			RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-				 ("usb_read_port_complete: (purb->actual_"
-				  "length > MAX_RECVBUF_SZ) || (purb->actual_"
-				  "length < RXDESC_SIZE)\n"));
+				 "usb_read_port_complete: (purb->actual_length > MAX_RECVBUF_SZ) || (purb->actual_length < RXDESC_SIZE)\n");
 			rtl8723au_read_port(padapter, 0, precvbuf);
 			DBG_8723A("%s()-%d: RX Warning!\n",
 				  __func__, __LINE__);
@@ -564,8 +558,8 @@ static void usb_read_port_complete(struct urb *purb)
 		}
 	} else {
 		RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-			 ("usb_read_port_complete : purb->status(%d) != 0 \n",
-			  purb->status));
+			 "usb_read_port_complete : purb->status(%d) != 0\n",
+			 purb->status);
 		skb_put(precvbuf->pskb, purb->actual_length);
 		precvbuf->pskb = NULL;
 
@@ -583,14 +577,12 @@ static void usb_read_port_complete(struct urb *purb)
 		case -ENODEV:
 		case -ESHUTDOWN:
 			RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-				 ("usb_read_port_complete:bSurprise"
-				  "Removed = true\n"));
+				 "usb_read_port_complete:bSurpriseRemoved = true\n");
 			/* Intentional fall through here */
 		case -ENOENT:
 			padapter->bDriverStopped = true;
 			RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-				 ("usb_read_port_complete:"
-				  "bDriverStopped = true\n"));
+				 "usb_read_port_complete:bDriverStopped = true\n");
 			break;
 		case -EPROTO:
 		case -EOVERFLOW:
@@ -620,14 +612,13 @@ int rtl8723au_read_port(struct rtw_adapter *adapter, u32 cnt,
 
 	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
 		RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-			 ("usb_read_port:(padapter->bDriverStopped ||"
-			  "padapter->bSurpriseRemoved)!!!\n"));
+			 "usb_read_port:(padapter->bDriverStopped ||padapter->bSurpriseRemoved)!!!\n");
 		return _FAIL;
 	}
 
 	if (!precvbuf) {
 		RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-			 ("usb_read_port:precvbuf == NULL\n"));
+			 "usb_read_port:precvbuf == NULL\n");
 		return _FAIL;
 	}
 
@@ -638,7 +629,8 @@ int rtl8723au_read_port(struct rtw_adapter *adapter, u32 cnt,
 	if (!precvbuf->pskb) {
 		precvbuf->pskb = netdev_alloc_skb(adapter->pnetdev, MAX_RECVBUF_SZ + RECVBUFF_ALIGN_SZ);
 		if (precvbuf->pskb == NULL) {
-			RT_TRACE(_module_hci_ops_os_c_, _drv_err_, ("init_recvbuf(): alloc_skb fail!\n"));
+			RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
+				 "init_recvbuf(): alloc_skb fail!\n");
 			return _FAIL;
 		}
 
@@ -661,8 +653,8 @@ int rtl8723au_read_port(struct rtw_adapter *adapter, u32 cnt,
 	err = usb_submit_urb(purb, GFP_ATOMIC);
 	if ((err) && (err != -EPERM)) {
 		RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-			 ("cannot submit rx in-token(err = 0x%.8x), URB_STATUS "
-			  "= 0x%.8x", err, purb->status));
+			 "cannot submit rx in-token(err = 0x%.8x), URB_STATUS = 0x%.8x\n",
+			 err, purb->status);
 		DBG_8723A("cannot submit rx in-token(err = 0x%08x), urb_status "
 			  "= %d\n", err, purb->status);
 		ret = _FAIL;
diff --git a/drivers/staging/rtl8723au/include/rtw_debug.h b/drivers/staging/rtl8723au/include/rtw_debug.h
index b6b0173..159183e 100644
--- a/drivers/staging/rtl8723au/include/rtw_debug.h
+++ b/drivers/staging/rtl8723au/include/rtw_debug.h
@@ -163,14 +163,13 @@
 
 extern u32 GlobalDebugLevel23A;
 
+__printf(3, 4)
+void rt_trace(int comp, int level, const char *fmt, ...);
 
-#define RT_TRACE(_Comp, _Level, Fmt)					\
+#define RT_TRACE(_Comp, _Level, Fmt, ...)				\
 do {									\
-	if (_Level <= GlobalDebugLevel23A) {				\
-		pr_info("%s [0x%08x,%d]", DRIVER_PREFIX,		\
-			 (unsigned int)_Comp, _Level);			\
-		pr_info Fmt;						\
-	}								\
+	if (_Level <= GlobalDebugLevel23A)				\
+		rt_trace(_Comp, _Level, Fmt, ##__VA_ARGS__);		\
 } while (0)
 
 #define RT_PRINT_DATA(_Comp, _Level, _TitleString, _HexData,		\
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index f925170..b139ed4 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -729,7 +729,7 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, u8 key_index,
 	if (keyparms->cipher == WLAN_CIPHER_SUITE_WEP40 ||
 	    keyparms->cipher == WLAN_CIPHER_SUITE_WEP104) {
 		RT_TRACE(_module_rtl871x_ioctl_os_c, _drv_err_,
-			 ("wpa_set_encryption, crypt.alg = WEP\n"));
+			 "wpa_set_encryption, crypt.alg = WEP\n");
 		DBG_8723A("wpa_set_encryption, crypt.alg = WEP\n");
 
 		if (psecuritypriv->bWepDefaultKeyIdxSet == 0) {
@@ -1127,14 +1127,14 @@ static int cfg80211_infrastructure_mode(struct rtw_adapter *padapter,
 	old_mode = cur_network->network.ifmode;
 
 	RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_notice_,
-		 ("+%s: old =%d new =%d fw_state = 0x%08x\n", __func__,
-		  old_mode, ifmode, get_fwstate(pmlmepriv)));
+		 "+%s: old =%d new =%d fw_state = 0x%08x\n", __func__,
+		 old_mode, ifmode, get_fwstate(pmlmepriv));
 
 	if (old_mode != ifmode) {
 		spin_lock_bh(&pmlmepriv->lock);
 
 		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-			 (" change mode!"));
+			 "change mode!\n");
 
 		if (old_mode == NL80211_IFTYPE_AP ||
 		    old_mode == NL80211_IFTYPE_P2P_GO) {
@@ -1194,10 +1194,6 @@ static int cfg80211_infrastructure_mode(struct rtw_adapter *padapter,
 
 		/* SecClearAllKeys(adapter); */
 
-		/* RT_TRACE(COMP_OID_SET, DBG_LOUD,
-		   ("set_infrastructure: fw_state:%x after changing mode\n", */
-		/* get_fwstate(pmlmepriv))); */
-
 		spin_unlock_bh(&pmlmepriv->lock);
 	}
 
@@ -1602,7 +1598,7 @@ static int rtw_cfg80211_set_wpa_ie(struct rtw_adapter *padapter, const u8 *pie,
 			  pie[i + 4], pie[i + 5], pie[i + 6], pie[i + 7]);
 	if (ielen < RSN_HEADER_LEN) {
 		RT_TRACE(_module_rtl871x_ioctl_os_c, _drv_err_,
-			 ("Ie len too short %d\n", (int)ielen));
+			 "Ie len too short %d\n", (int)ielen);
 		ret = -1;
 		goto exit;
 	}
@@ -1725,11 +1721,10 @@ static int rtw_cfg80211_set_wpa_ie(struct rtw_adapter *padapter, const u8 *pie,
 		rtl8723a_off_rcr_am(padapter);
 
 	RT_TRACE(_module_rtl871x_ioctl_os_c, _drv_info_,
-		 ("rtw_set_wpa_ie: pairwise_cipher = 0x%08x padapter->"
-		  "securitypriv.ndisencryptstatus =%d padapter->"
-		  "securitypriv.ndisauthtype =%d\n", pairwise_cipher,
-		  padapter->securitypriv.ndisencryptstatus,
-		  padapter->securitypriv.ndisauthtype));
+		 "rtw_set_wpa_ie: pairwise_cipher = 0x%08x padapter->securitypriv.ndisencryptstatus =%d padapter->securitypriv.ndisauthtype =%d\n",
+		 pairwise_cipher,
+		 padapter->securitypriv.ndisencryptstatus,
+		 padapter->securitypriv.ndisauthtype);
 
 exit:
 	if (ret)
@@ -1745,7 +1740,7 @@ static int rtw_cfg80211_add_wep(struct rtw_adapter *padapter,
 
 	if (keyid >= NUM_WEP_KEYS) {
 		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-			 ("%s:keyid>4 =>fail\n", __func__));
+			 "%s:keyid>4 =>fail\n", __func__);
 		res = _FAIL;
 		goto exit;
 	}
@@ -1754,45 +1749,45 @@ static int rtw_cfg80211_add_wep(struct rtw_adapter *padapter,
 	case WLAN_KEY_LEN_WEP40:
 		psecuritypriv->dot11PrivacyAlgrthm = WLAN_CIPHER_SUITE_WEP40;
 		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-			 ("%s:wep->KeyLength = 5\n", __func__));
+			 "%s:wep->KeyLength = 5\n", __func__);
 		break;
 	case WLAN_KEY_LEN_WEP104:
 		psecuritypriv->dot11PrivacyAlgrthm = WLAN_CIPHER_SUITE_WEP104;
 		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-			 ("%s:wep->KeyLength = 13\n", __func__));
+			 "%s:wep->KeyLength = 13\n", __func__);
 		break;
 	default:
 		psecuritypriv->dot11PrivacyAlgrthm = 0;
 		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-			 ("%s:wep->KeyLength!= 5 or 13\n", __func__));
+			 "%s:wep->KeyLength!= 5 or 13\n", __func__);
 		res = _FAIL;
 		goto exit;
 	}
 
 	RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-		 ("%s:before memcpy, wep->KeyLength = 0x%x keyid =%x\n",
-		  __func__, wep->keylen, keyid));
+		 "%s:before memcpy, wep->KeyLength = 0x%x keyid =%x\n",
+		 __func__, wep->keylen, keyid);
 
 	memcpy(&psecuritypriv->wep_key[keyid], wep, sizeof(struct rtw_wep_key));
 
 	psecuritypriv->dot11PrivacyKeyIndex = keyid;
 
 	RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-		 ("%s:security key material : "
-		  "%x %x %x %x %x %x %x %x %x %x %x %x %x\n", __func__,
-		  psecuritypriv->wep_key[keyid].key[0],
-		  psecuritypriv->wep_key[keyid].key[1],
-		  psecuritypriv->wep_key[keyid].key[2],
-		  psecuritypriv->wep_key[keyid].key[3],
-		  psecuritypriv->wep_key[keyid].key[4],
-		  psecuritypriv->wep_key[keyid].key[5],
-		  psecuritypriv->wep_key[keyid].key[6],
-		  psecuritypriv->wep_key[keyid].key[7],
-		  psecuritypriv->wep_key[keyid].key[8],
-		  psecuritypriv->wep_key[keyid].key[9],
-		  psecuritypriv->wep_key[keyid].key[10],
-		  psecuritypriv->wep_key[keyid].key[11],
-		  psecuritypriv->wep_key[keyid].key[12]));
+		 "%s:security key material : %x %x %x %x %x %x %x %x %x %x %x %x %x\n",
+		 __func__,
+		 psecuritypriv->wep_key[keyid].key[0],
+		 psecuritypriv->wep_key[keyid].key[1],
+		 psecuritypriv->wep_key[keyid].key[2],
+		 psecuritypriv->wep_key[keyid].key[3],
+		 psecuritypriv->wep_key[keyid].key[4],
+		 psecuritypriv->wep_key[keyid].key[5],
+		 psecuritypriv->wep_key[keyid].key[6],
+		 psecuritypriv->wep_key[keyid].key[7],
+		 psecuritypriv->wep_key[keyid].key[8],
+		 psecuritypriv->wep_key[keyid].key[9],
+		 psecuritypriv->wep_key[keyid].key[10],
+		 psecuritypriv->wep_key[keyid].key[11],
+		 psecuritypriv->wep_key[keyid].key[12]);
 
 	res = rtw_set_key23a(padapter, psecuritypriv, keyid, 1);
 
@@ -1814,7 +1809,7 @@ static int rtw_set_ssid(struct rtw_adapter *padapter,
 
 	if (padapter->hw_init_completed == false) {
 		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-			 ("set_ssid: hw_init_completed == false =>exit!!!\n"));
+			 "set_ssid: hw_init_completed == false =>exit!!!\n");
 		status = _FAIL;
 		goto exit;
 	}
@@ -1827,7 +1822,7 @@ static int rtw_set_ssid(struct rtw_adapter *padapter,
 
 	if (check_fwstate(pmlmepriv, _FW_LINKED|WIFI_ADHOC_MASTER_STATE)) {
 		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-			 ("set_ssid: _FW_LINKED||WIFI_ADHOC_MASTER_STATE\n"));
+			 "set_ssid: _FW_LINKED||WIFI_ADHOC_MASTER_STATE\n");
 
 		if (pmlmepriv->assoc_ssid.ssid_len ==
 		    newnetwork->network.Ssid.ssid_len &&
@@ -1836,9 +1831,9 @@ static int rtw_set_ssid(struct rtw_adapter *padapter,
 			    newnetwork->network.Ssid.ssid_len)) {
 			if (!check_fwstate(pmlmepriv, WIFI_STATION_STATE)) {
 				RT_TRACE(_module_rtl871x_ioctl_set_c_,
-					 _drv_err_, ("New SSID is same SSID, "
-						     "fw_state = 0x%08x\n",
-						     get_fwstate(pmlmepriv)));
+					 _drv_err_,
+					 "New SSID is same SSID, fw_state = 0x%08x\n",
+					 get_fwstate(pmlmepriv));
 
 				if (rtw_is_same_ibss23a(padapter, pnetwork)) {
 					/*
@@ -1874,15 +1869,15 @@ static int rtw_set_ssid(struct rtw_adapter *padapter,
 			}
 		} else {
 			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-				 ("Set SSID not the same ssid\n"));
+				 "Set SSID not the same ssid\n");
 			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-				 ("set_ssid =[%s] len = 0x%x\n",
-				  newnetwork->network.Ssid.ssid,
-				  newnetwork->network.Ssid.ssid_len));
+				 "set_ssid =[%s] len = 0x%x\n",
+				 newnetwork->network.Ssid.ssid,
+				 newnetwork->network.Ssid.ssid_len);
 			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-				 ("assoc_ssid =[%s] len = 0x%x\n",
-				  pmlmepriv->assoc_ssid.ssid,
-				  pmlmepriv->assoc_ssid.ssid_len));
+				 "assoc_ssid =[%s] len = 0x%x\n",
+				 pmlmepriv->assoc_ssid.ssid,
+				 pmlmepriv->assoc_ssid.ssid_len);
 
 			rtw_disassoc_cmd23a(padapter, 0, true);
 
@@ -1946,7 +1941,7 @@ release_mlme_lock:
 
 exit:
 	RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-		 ("-%s: status =%d\n", __func__, status));
+		 "-%s: status =%d\n", __func__, status);
 
 	return status;
 }
diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
index 8f732d9..8369636 100644
--- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
@@ -342,7 +342,7 @@ int rtw_init_netdev23a_name23a(struct net_device *pnetdev, const char *ifname)
 {
 	if (dev_alloc_name(pnetdev, ifname) < 0) {
 		RT_TRACE(_module_os_intfs_c_, _drv_err_,
-			 ("dev_alloc_name, fail!\n"));
+			 "dev_alloc_name, fail!\n");
 	}
 	netif_carrier_off(pnetdev);
 	return 0;
@@ -357,7 +357,7 @@ struct net_device *rtw_init_netdev23a(struct rtw_adapter *old_padapter)
 	struct rtw_adapter *padapter;
 	struct net_device *pnetdev;
 
-	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("+init_net_dev\n"));
+	RT_TRACE(_module_os_intfs_c_, _drv_info_, "+init_net_dev\n");
 
 	pnetdev = alloc_etherdev_mq(sizeof(struct rtw_adapter), 4);
 	if (!pnetdev)
@@ -456,11 +456,11 @@ int rtw_init_drv_sw23a(struct rtw_adapter *padapter)
 {
 	int ret8 = _SUCCESS;
 
-	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("+rtw_init_drv_sw23a\n"));
+	RT_TRACE(_module_os_intfs_c_, _drv_info_, "+rtw_init_drv_sw23a\n");
 
 	if (rtw_init_cmd_priv23a(&padapter->cmdpriv) == _FAIL) {
 		RT_TRACE(_module_os_intfs_c_, _drv_err_,
-			 ("\n Can't init cmd_priv\n"));
+			 "Can't init cmd_priv\n");
 		ret8 = _FAIL;
 		goto exit;
 	}
@@ -469,14 +469,14 @@ int rtw_init_drv_sw23a(struct rtw_adapter *padapter)
 
 	if (rtw_init_evt_priv23a(&padapter->evtpriv) == _FAIL) {
 		RT_TRACE(_module_os_intfs_c_, _drv_err_,
-			 ("\n Can't init evt_priv\n"));
+			 "Can't init evt_priv\n");
 		ret8 = _FAIL;
 		goto exit;
 	}
 
 	if (rtw_init_mlme_priv23a(padapter) == _FAIL) {
 		RT_TRACE(_module_os_intfs_c_, _drv_err_,
-			 ("\n Can't init mlme_priv\n"));
+			 "Can't init mlme_priv\n");
 		ret8 = _FAIL;
 		goto exit;
 	}
@@ -484,7 +484,7 @@ int rtw_init_drv_sw23a(struct rtw_adapter *padapter)
 
 	if (init_mlme_ext_priv23a(padapter) == _FAIL) {
 		RT_TRACE(_module_os_intfs_c_, _drv_err_,
-			 ("\n Can't init mlme_ext_priv\n"));
+			 "Can't init mlme_ext_priv\n");
 		ret8 = _FAIL;
 		goto exit;
 	}
@@ -521,40 +521,40 @@ int rtw_init_drv_sw23a(struct rtw_adapter *padapter)
 
 exit:
 
-	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("-rtw_init_drv_sw23a\n"));
+	RT_TRACE(_module_os_intfs_c_, _drv_info_, "-rtw_init_drv_sw23a\n");
 	return ret8;
 }
 
 void rtw_cancel_all_timer23a(struct rtw_adapter *padapter)
 {
 	RT_TRACE(_module_os_intfs_c_, _drv_info_,
-		 ("+rtw_cancel_all_timer23a\n"));
+		 "+rtw_cancel_all_timer23a\n");
 
 	del_timer_sync(&padapter->mlmepriv.assoc_timer);
 	RT_TRACE(_module_os_intfs_c_, _drv_info_,
-		 ("%s:cancel association timer complete!\n", __func__));
+		 "%s:cancel association timer complete!\n", __func__);
 
 	del_timer_sync(&padapter->mlmepriv.scan_to_timer);
 	RT_TRACE(_module_os_intfs_c_, _drv_info_,
-		 ("%s:cancel scan_to_timer!\n", __func__));
+		 "%s:cancel scan_to_timer!\n", __func__);
 
 	del_timer_sync(&padapter->mlmepriv.dynamic_chk_timer);
 	RT_TRACE(_module_os_intfs_c_, _drv_info_,
-		 ("%s:cancel dynamic_chk_timer!\n", __func__));
+		 "%s:cancel dynamic_chk_timer!\n", __func__);
 
 	del_timer_sync(&padapter->pwrctrlpriv.pwr_state_check_timer);
 
 	del_timer_sync(&padapter->mlmepriv.set_scan_deny_timer);
 	rtw_clear_scan_deny(padapter);
 	RT_TRACE(_module_os_intfs_c_, _drv_info_,
-		 ("%s:cancel set_scan_deny_timer!\n", __func__));
+		 "%s:cancel set_scan_deny_timer!\n", __func__);
 
 	del_timer_sync(&padapter->recvpriv.signal_stat_timer);
 }
 
 int rtw_free_drv_sw23a(struct rtw_adapter *padapter)
 {
-	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("==>rtw_free_drv_sw23a"));
+	RT_TRACE(_module_os_intfs_c_, _drv_info_, "==>rtw_free_drv_sw23a\n");
 
 	free_mlme_ext_priv23a(&padapter->mlmeextpriv);
 
@@ -574,7 +574,7 @@ int rtw_free_drv_sw23a(struct rtw_adapter *padapter)
 	kfree(padapter->HalData);
 	padapter->HalData = NULL;
 
-	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("-rtw_free_drv_sw23a\n"));
+	RT_TRACE(_module_os_intfs_c_, _drv_info_, "-rtw_free_drv_sw23a\n");
 	return _SUCCESS;
 }
 
@@ -647,7 +647,7 @@ int netdev_open23a(struct net_device *pnetdev)
 	int ret = 0;
 	int status;
 
-	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("+871x_drv - dev_open\n"));
+	RT_TRACE(_module_os_intfs_c_, _drv_info_, "+871x_drv - dev_open\n");
 	DBG_8723A("+871x_drv - drv_open, bup =%d\n", padapter->bup);
 
 	mutex_lock(&adapter_to_dvobj(padapter)->hw_init_mutex);
@@ -662,7 +662,7 @@ int netdev_open23a(struct net_device *pnetdev)
 		status = rtl8723au_hal_init(padapter);
 		if (status == _FAIL) {
 			RT_TRACE(_module_os_intfs_c_, _drv_err_,
-				 ("rtl871x_hal_init(): Can't init h/w!\n"));
+				 "rtl871x_hal_init(): Can't init h/w!\n");
 			goto netdev_open23a_error;
 		}
 
@@ -694,7 +694,7 @@ int netdev_open23a(struct net_device *pnetdev)
 	else
 		netif_tx_wake_all_queues(pnetdev);
 
-	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("-871x_drv - dev_open\n"));
+	RT_TRACE(_module_os_intfs_c_, _drv_info_, "-871x_drv - dev_open\n");
 	DBG_8723A("-871x_drv - drv_open, bup =%d\n", padapter->bup);
 exit:
 	mutex_unlock(&adapter_to_dvobj(padapter)->hw_init_mutex);
@@ -707,7 +707,7 @@ netdev_open23a_error:
 	netif_tx_stop_all_queues(pnetdev);
 
 	RT_TRACE(_module_os_intfs_c_, _drv_err_,
-		 ("-871x_drv - dev_open, fail!\n"));
+		 "-871x_drv - dev_open, fail!\n");
 	DBG_8723A("-871x_drv - drv_open fail, bup =%d\n", padapter->bup);
 
 	ret = -1;
@@ -728,7 +728,7 @@ static int ips_netdrv_open(struct rtw_adapter *padapter)
 	status = rtl8723au_hal_init(padapter);
 	if (status == _FAIL) {
 		RT_TRACE(_module_os_intfs_c_, _drv_err_,
-			 ("ips_netdrv_open(): Can't init h/w!\n"));
+			 "ips_netdrv_open(): Can't init h/w!\n");
 		goto netdev_open23a_error;
 	}
 
@@ -806,7 +806,7 @@ static int netdev_close(struct net_device *pnetdev)
 {
 	struct rtw_adapter *padapter = netdev_priv(pnetdev);
 
-	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("+871x_drv - drv_close\n"));
+	RT_TRACE(_module_os_intfs_c_, _drv_info_, "+871x_drv - drv_close\n");
 
 	padapter->net_closed = true;
 
@@ -834,7 +834,7 @@ static int netdev_close(struct net_device *pnetdev)
 
 	rtw_scan_abort23a(padapter);
 
-	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("-871x_drv - drv_close\n"));
+	RT_TRACE(_module_os_intfs_c_, _drv_info_, "-871x_drv - drv_close\n");
 	DBG_8723A("-871x_drv - drv_close, bup =%d\n", padapter->bup);
 
 	return 0;
diff --git a/drivers/staging/rtl8723au/os_dep/recv_linux.c b/drivers/staging/rtl8723au/os_dep/recv_linux.c
index bcd970b..084b506 100644
--- a/drivers/staging/rtl8723au/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8723au/os_dep/recv_linux.c
@@ -81,19 +81,19 @@ int rtw_recv_indicatepkt23a(struct rtw_adapter *padapter,
 	skb = precv_frame->pkt;
 	if (!skb) {
 		RT_TRACE(_module_recv_osdep_c_, _drv_err_,
-			 ("rtw_recv_indicatepkt23a():skb == NULL!!!!\n"));
+			 "rtw_recv_indicatepkt23a():skb == NULL!!!!\n");
 		goto _recv_indicatepkt_drop;
 	}
 
 	RT_TRACE(_module_recv_osdep_c_, _drv_info_,
-		 ("rtw_recv_indicatepkt23a():skb != NULL !!!\n"));
+		 "rtw_recv_indicatepkt23a():skb != NULL !!!\n");
 	RT_TRACE(_module_recv_osdep_c_, _drv_info_,
-		 ("rtw_recv_indicatepkt23a():precv_frame->hdr.rx_data =%p\n",
-		  precv_frame->pkt->data));
+		 "rtw_recv_indicatepkt23a():precv_frame->hdr.rx_data =%p\n",
+		 precv_frame->pkt->data);
 	RT_TRACE(_module_recv_osdep_c_, _drv_info_,
-		 ("\n skb->head =%p skb->data =%p skb->tail =%p skb->end =%p skb->len =%d\n",
-		  skb->head, skb->data,
-		  skb_tail_pointer(skb), skb_end_pointer(skb), skb->len));
+		 "skb->head =%p skb->data =%p skb->tail =%p skb->end =%p skb->len =%d\n",
+		 skb->head, skb->data,
+		 skb_tail_pointer(skb), skb_end_pointer(skb), skb->len);
 
 	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) == true) {
 		struct sk_buff *pskb2 = NULL;
@@ -148,7 +148,7 @@ _recv_indicatepkt_end:
 	rtw_free_recvframe23a(precv_frame);
 
 	RT_TRACE(_module_recv_osdep_c_, _drv_info_,
-		 ("\n rtw_recv_indicatepkt23a :after netif_rx!!!!\n"));
+		 "rtw_recv_indicatepkt23a :after netif_rx!!!!\n");
 	return _SUCCESS;
 
 _recv_indicatepkt_drop:
diff --git a/drivers/staging/rtl8723au/os_dep/usb_intf.c b/drivers/staging/rtl8723au/os_dep/usb_intf.c
index bab0699..27b3a5b 100644
--- a/drivers/staging/rtl8723au/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8723au/os_dep/usb_intf.c
@@ -159,7 +159,7 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 
 	if (rtw_init_intf_priv(pdvobjpriv) == _FAIL) {
 		RT_TRACE(_module_os_intfs_c_, _drv_err_,
-			 ("\n Can't INIT rtw_init_intf_priv\n"));
+			 "Can't INIT rtw_init_intf_priv\n");
 		goto free_dvobj;
 	}
 	/* 3 misc */
@@ -213,7 +213,7 @@ static void usb_dvobj_deinit(struct usb_interface *usb_intf)
 
 void rtl8723a_usb_intf_stop(struct rtw_adapter *padapter)
 {
-	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+usb_intf_stop\n"));
+	RT_TRACE(_module_hci_intfs_c_, _drv_err_, "+usb_intf_stop\n");
 
 	/* disable_hw_interrupt */
 	if (!padapter->bSurpriseRemoved) {
@@ -221,7 +221,7 @@ void rtl8723a_usb_intf_stop(struct rtw_adapter *padapter)
 		 * TODO:
 		 */
 		RT_TRACE(_module_hci_intfs_c_, _drv_err_,
-			 ("SurpriseRemoved == false\n"));
+			 "SurpriseRemoved == false\n");
 	}
 
 	/* cancel in irp */
@@ -231,14 +231,14 @@ void rtl8723a_usb_intf_stop(struct rtw_adapter *padapter)
 	rtl8723au_write_port_cancel(padapter);
 
 	/* todo:cancel other irps */
-	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("-usb_intf_stop\n"));
+	RT_TRACE(_module_hci_intfs_c_, _drv_err_, "-usb_intf_stop\n");
 }
 
 static void rtw_dev_unload(struct rtw_adapter *padapter)
 {
 	struct submit_ctx *pack_tx_ops = &padapter->xmitpriv.ack_tx_ops;
 
-	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_dev_unload\n"));
+	RT_TRACE(_module_hci_intfs_c_, _drv_err_, "+rtw_dev_unload\n");
 
 	if (padapter->bup) {
 		DBG_8723A("===> rtw_dev_unload\n");
@@ -262,10 +262,10 @@ static void rtw_dev_unload(struct rtw_adapter *padapter)
 		padapter->bup = false;
 	} else {
 		RT_TRACE(_module_hci_intfs_c_, _drv_err_,
-			 ("r871x_dev_unload():padapter->bup == false\n"));
+			 "r871x_dev_unload():padapter->bup == false\n");
 	}
 	DBG_8723A("<=== rtw_dev_unload\n");
-	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("-rtw_dev_unload\n"));
+	RT_TRACE(_module_hci_intfs_c_, _drv_err_, "-rtw_dev_unload\n");
 }
 
 static int rtw_suspend(struct usb_interface *pusb_intf, pm_message_t message)
@@ -436,7 +436,7 @@ static struct rtw_adapter *rtw_usb_if1_init(struct dvobj_priv *dvobj,
 	/* step 5. */
 	if (rtw_init_drv_sw23a(padapter) == _FAIL) {
 		RT_TRACE(_module_hci_intfs_c_, _drv_err_,
-			 ("Initialize driver software resource Failed!\n"));
+			 "Initialize driver software resource Failed!\n");
 		goto free_hal_data;
 	}
 
@@ -534,13 +534,13 @@ static int rtw_drv_init(struct usb_interface *pusb_intf,
 	struct dvobj_priv *dvobj;
 	int status = _FAIL;
 
-	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_init\n"));
+	RT_TRACE(_module_hci_intfs_c_, _drv_err_, "+rtw_drv_init\n");
 
 	/* Initialize dvobj_priv */
 	dvobj = usb_dvobj_init(pusb_intf);
 	if (!dvobj) {
 		RT_TRACE(_module_hci_intfs_c_, _drv_err_,
-			 ("initialize device object priv Failed!\n"));
+			 "initialize device object priv Failed!\n");
 		goto exit;
 	}
 
@@ -555,7 +555,7 @@ static int rtw_drv_init(struct usb_interface *pusb_intf,
 	if (status != _SUCCESS)
 		goto free_if1;
 	RT_TRACE(_module_hci_intfs_c_, _drv_err_,
-		 ("-871x_drv - drv_init, success!\n"));
+		 "-871x_drv - drv_init, success!\n");
 
 	status = _SUCCESS;
 
@@ -587,7 +587,7 @@ static void rtw_disconnect(struct usb_interface *pusb_intf)
 
 	usb_set_intfdata(pusb_intf, NULL);
 
-	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+dev_remove()\n"));
+	RT_TRACE(_module_hci_intfs_c_, _drv_err_, "+dev_remove()\n");
 
 	rtw_pm_set_ips23a(padapter, IPS_NONE);
 	rtw_pm_set_lps23a(padapter, PS_MODE_ACTIVE);
@@ -598,19 +598,19 @@ static void rtw_disconnect(struct usb_interface *pusb_intf)
 
 	usb_dvobj_deinit(pusb_intf);
 
-	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("-dev_remove()\n"));
+	RT_TRACE(_module_hci_intfs_c_, _drv_err_, "-dev_remove()\n");
 	DBG_8723A("-r871xu_dev_remove, done\n");
 }
 
 static int __init rtw_drv_entry(void)
 {
-	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_entry\n"));
+	RT_TRACE(_module_hci_intfs_c_, _drv_err_, "+rtw_drv_entry\n");
 	return usb_register(usb_drv);
 }
 
 static void __exit rtw_drv_halt(void)
 {
-	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_halt\n"));
+	RT_TRACE(_module_hci_intfs_c_, _drv_err_, "+rtw_drv_halt\n");
 	DBG_8723A("+rtw_drv_halt\n");
 
 	usb_deregister(usb_drv);
diff --git a/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c b/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
index 3e19b3b..0cdaef0 100644
--- a/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
@@ -58,9 +58,8 @@ static void usb_write_port23a_complete(struct urb *purb)
 	if (padapter->bSurpriseRemoved || padapter->bDriverStopped ||
 	    padapter->bWritePortCancel) {
 		RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-			 ("usb_write_port23a_complete:bDriverStopped(%d) OR "
-			  "bSurpriseRemoved(%d)", padapter->bDriverStopped,
-			  padapter->bSurpriseRemoved));
+			 "usb_write_port23a_complete:bDriverStopped(%d) OR bSurpriseRemoved(%d)\n",
+			 padapter->bDriverStopped, padapter->bSurpriseRemoved);
 		DBG_8723A("%s(): TX Warning! bDriverStopped(%d) OR "
 			  "bSurpriseRemoved(%d) bWritePortCancel(%d) "
 			  "pxmitbuf->ext_tag(%x)\n", __func__,
@@ -72,14 +71,14 @@ static void usb_write_port23a_complete(struct urb *purb)
 
 	if (purb->status) {
 		RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-			 ("usb_write_port23a_complete : purb->status(%d) "
-			  "!= 0\n", purb->status));
+			 "usb_write_port23a_complete : purb->status(%d) != 0\n",
+			 purb->status);
 		DBG_8723A("###=> urb_write_port_complete status(%d)\n",
 			  purb->status);
 		if (purb->status == -EPIPE || purb->status == -EPROTO) {
 		} else if (purb->status == -EINPROGRESS) {
 			RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-				 ("usb_write_port23a_complete: EINPROGESS\n"));
+				 "usb_write_port23a_complete: EINPROGESS\n");
 			goto check_completion;
 		} else if (purb->status == -ENOENT) {
 			DBG_8723A("%s: -ENOENT\n", __func__);
@@ -89,18 +88,16 @@ static void usb_write_port23a_complete(struct urb *purb)
 			goto check_completion;
 		} else if (purb->status == -ESHUTDOWN) {
 			RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-				 ("usb_write_port23a_complete: ESHUTDOWN\n"));
+				 "usb_write_port23a_complete: ESHUTDOWN\n");
 			padapter->bDriverStopped = true;
 			RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-				 ("usb_write_port23a_complete:bDriverStopped "
-				  "= true\n"));
+				 "usb_write_port23a_complete:bDriverStopped = true\n");
 			goto check_completion;
 		} else {
 			padapter->bSurpriseRemoved = true;
 			DBG_8723A("bSurpriseRemoved = true\n");
 			RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-				 ("usb_write_port23a_complete:bSurpriseRemoved "
-				  "= true\n"));
+				 "usb_write_port23a_complete:bSurpriseRemoved = true\n");
 			goto check_completion;
 		}
 	}
@@ -132,12 +129,12 @@ int rtl8723au_write_port(struct rtw_adapter *padapter, u32 addr, u32 cnt,
 	int status;
 	int ret = _FAIL;
 
-	RT_TRACE(_module_hci_ops_os_c_, _drv_err_, ("+usb_write_port23a\n"));
+	RT_TRACE(_module_hci_ops_os_c_, _drv_err_, "+usb_write_port23a\n");
 
 	if (padapter->bDriverStopped || padapter->bSurpriseRemoved) {
 		RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-			 ("%s:(padapter->bDriverStopped || "
-			  "padapter->bSurpriseRemoved)!!!\n", __func__));
+			 "%s:(padapter->bDriverStopped || padapter->bSurpriseRemoved)!!!\n",
+			 __func__);
 		rtw23a_sctx_done_err(&pxmitbuf->sctx, RTW_SCTX_DONE_TX_DENY);
 		goto exit;
 	}
@@ -188,8 +185,8 @@ int rtl8723au_write_port(struct rtw_adapter *padapter, u32 addr, u32 cnt,
 				     RTW_SCTX_DONE_WRITE_PORT_ERR);
 		DBG_8723A("usb_write_port23a, status =%d\n", status);
 		RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
-			 ("usb_write_port23a(): usb_submit_urb, status =%x\n",
-			 status));
+			 "usb_write_port23a(): usb_submit_urb, status =%x\n",
+			 status);
 
 		switch (status) {
 		case -ENODEV:
@@ -201,7 +198,7 @@ int rtl8723au_write_port(struct rtw_adapter *padapter, u32 addr, u32 cnt,
 		goto exit;
 	}
 	ret = _SUCCESS;
-	RT_TRACE(_module_hci_ops_os_c_, _drv_err_, ("-usb_write_port23a\n"));
+	RT_TRACE(_module_hci_ops_os_c_, _drv_err_, "-usb_write_port23a\n");
 
 exit:
 	if (ret != _SUCCESS)
diff --git a/drivers/staging/rtl8723au/os_dep/xmit_linux.c b/drivers/staging/rtl8723au/os_dep/xmit_linux.c
index 69f8884..9a14074 100644
--- a/drivers/staging/rtl8723au/os_dep/xmit_linux.c
+++ b/drivers/staging/rtl8723au/os_dep/xmit_linux.c
@@ -123,11 +123,11 @@ int rtw_xmit23a_entry23a(struct sk_buff *skb, struct net_device *pnetdev)
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 	int res = 0;
 
-	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("+xmit_enry\n"));
+	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, "+xmit_enry\n");
 
 	if (!rtw_if_up23a(padapter)) {
 		RT_TRACE(_module_xmit_osdep_c_, _drv_err_,
-			 ("rtw_xmit23a_entry23a: rtw_if_up23a fail\n"));
+			 "rtw_xmit23a_entry23a: rtw_if_up23a fail\n");
 		goto drop_packet;
 	}
 
@@ -139,16 +139,16 @@ int rtw_xmit23a_entry23a(struct sk_buff *skb, struct net_device *pnetdev)
 
 	pxmitpriv->tx_pkts++;
 	RT_TRACE(_module_xmit_osdep_c_, _drv_info_,
-		 ("rtw_xmit23a_entry23a: tx_pkts=%d\n",
-		 (u32)pxmitpriv->tx_pkts));
+		 "rtw_xmit23a_entry23a: tx_pkts=%d\n",
+		 (u32)pxmitpriv->tx_pkts);
 	goto exit;
 
 drop_packet:
 	pxmitpriv->tx_drop++;
 	dev_kfree_skb_any(skb);
 	RT_TRACE(_module_xmit_osdep_c_, _drv_notice_,
-		 ("rtw_xmit23a_entry23a: drop, tx_drop=%d\n",
-		 (u32)pxmitpriv->tx_drop));
+		 "rtw_xmit23a_entry23a: drop, tx_drop=%d\n",
+		 (u32)pxmitpriv->tx_drop);
 exit:
 	return 0;
 }
-- 
2.1.2



