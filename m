Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36813 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbcA3F5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 00:57:41 -0500
Date: Sat, 30 Jan 2016 11:27:47 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: rtl8723au: Fixes unnecessary return warning
Message-ID: <20160130055747.GA16656@Karyakshetra> (sfid-20160130_065848_410029_36A0FF3C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes checkpatch.pl warning in rtw_mlme_ext.c file.
WARNING: void function return statements are not generally useful

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 Changes in v2:
   - Removed the unnecessary blank lines.
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index d28f29a..7cd0052 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -2656,8 +2656,6 @@ static void issue_probersp(struct rtw_adapter *padapter, unsigned char *da)
 	pattrib->last_txcmdsz = pattrib->pktlen;

 	dump_mgntframe23a(padapter, pmgntframe);
-
-	return;
 }

 static int _issue_probereq(struct rtw_adapter *padapter,
@@ -2957,8 +2955,6 @@ static void issue_auth(struct rtw_adapter *padapter, struct sta_info *psta,
 	rtw_wep_encrypt23a(padapter, pmgntframe);
 	DBG_8723A("%s\n", __func__);
 	dump_mgntframe23a(padapter, pmgntframe);
-
-	return;
 }

 #ifdef CONFIG_8723AU_AP_MODE
@@ -3338,8 +3334,6 @@ exit:
 		}
 	} else
 		kfree(pmlmepriv->assoc_req);
-
-	return;
 }

 /* when wait_ack is true, this function should be called at process context */
@@ -4102,8 +4096,6 @@ static void rtw_site_survey(struct rtw_adapter *padapter)
 		pmlmeext->chan_scan_time = SURVEY_TO;
 		pmlmeext->sitesurvey_res.state = SCAN_DISABLE;
 	}
-
-	return;
 }

 /* collect bss info from Beacon and Probe request/response frames. */
@@ -4759,8 +4751,6 @@ void report_survey_event23a(struct rtw_adapter *padapter,
 	rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);

 	pmlmeext->sitesurvey_res.bss_cnt++;
-
-	return;
 }

 void report_surveydone_event23a(struct rtw_adapter *padapter)
@@ -4802,8 +4792,6 @@ void report_surveydone_event23a(struct rtw_adapter *padapter)
 	DBG_8723A("survey done event(%x)\n", psurveydone_evt->bss_cnt);

 	rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);
-
-	return;
 }

 void report_join_res23a(struct rtw_adapter *padapter, int res)
@@ -4850,8 +4838,6 @@ void report_join_res23a(struct rtw_adapter *padapter, int res)
 	rtw_joinbss_event_prehandle23a(padapter, (u8 *)&pjoinbss_evt->network);

 	rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);
-
-	return;
 }

 void report_del_sta_event23a(struct rtw_adapter *padapter,
@@ -4906,8 +4892,6 @@ void report_del_sta_event23a(struct rtw_adapter *padapter,
 	DBG_8723A("report_del_sta_event23a: delete STA, mac_id =%d\n", mac_id);

 	rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);
-
-	return;
 }

 void report_add_sta_event23a(struct rtw_adapter *padapter,
@@ -4951,8 +4935,6 @@ void report_add_sta_event23a(struct rtw_adapter *padapter,
 	DBG_8723A("report_add_sta_event23a: add STA\n");

 	rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);
-
-	return;
 }

 /****************************************************************************
@@ -5394,8 +5376,6 @@ static void link_timer_hdl(unsigned long data)
 		issue_assocreq(padapter);
 		set_link_timer(pmlmeext, REASSOC_TO);
 	}
-
-	return;
 }

 static void addba_timer_hdl(unsigned long data)
--
2.1.4

