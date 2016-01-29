Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:33017 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbcA2R3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 12:29:03 -0500
Date: Fri, 29 Jan 2016 22:59:08 +0530
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
Subject: [PATCH] staging: rtl8723au: Fixes unnecessary return warning
Message-ID: <20160129172908.GA14077@Karyakshetra> (sfid-20160129_182907_819283_5F2CA294)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes checkpatch.pl warning in rtw_mlme_ext.c file.
WARNING: void function return statements are not generally useful

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index d28f29a..e8a16b9 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -2657,7 +2657,6 @@ static void issue_probersp(struct rtw_adapter *padapter, unsigned char *da)

 	dump_mgntframe23a(padapter, pmgntframe);

-	return;
 }

 static int _issue_probereq(struct rtw_adapter *padapter,
@@ -2958,7 +2957,6 @@ static void issue_auth(struct rtw_adapter *padapter, struct sta_info *psta,
 	DBG_8723A("%s\n", __func__);
 	dump_mgntframe23a(padapter, pmgntframe);

-	return;
 }

 #ifdef CONFIG_8723AU_AP_MODE
@@ -3339,7 +3337,6 @@ exit:
 	} else
 		kfree(pmlmepriv->assoc_req);

-	return;
 }

 /* when wait_ack is true, this function should be called at process context */
@@ -4103,7 +4100,6 @@ static void rtw_site_survey(struct rtw_adapter *padapter)
 		pmlmeext->sitesurvey_res.state = SCAN_DISABLE;
 	}

-	return;
 }

 /* collect bss info from Beacon and Probe request/response frames. */
@@ -4760,7 +4756,6 @@ void report_survey_event23a(struct rtw_adapter *padapter,

 	pmlmeext->sitesurvey_res.bss_cnt++;

-	return;
 }

 void report_surveydone_event23a(struct rtw_adapter *padapter)
@@ -4803,7 +4798,6 @@ void report_surveydone_event23a(struct rtw_adapter *padapter)

 	rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);

-	return;
 }

 void report_join_res23a(struct rtw_adapter *padapter, int res)
@@ -4851,7 +4845,6 @@ void report_join_res23a(struct rtw_adapter *padapter, int res)

 	rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);

-	return;
 }

 void report_del_sta_event23a(struct rtw_adapter *padapter,
@@ -4907,7 +4900,6 @@ void report_del_sta_event23a(struct rtw_adapter *padapter,

 	rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);

-	return;
 }

 void report_add_sta_event23a(struct rtw_adapter *padapter,
@@ -4952,7 +4944,6 @@ void report_add_sta_event23a(struct rtw_adapter *padapter,

 	rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);

-	return;
 }

 /****************************************************************************
@@ -5395,7 +5386,6 @@ static void link_timer_hdl(unsigned long data)
 		set_link_timer(pmlmeext, REASSOC_TO);
 	}

-	return;
 }

 static void addba_timer_hdl(unsigned long data)
--
2.1.4

