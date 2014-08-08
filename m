Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50579 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427AbaHHKMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 06:12:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix wmi service bitmap debug
References: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 8 Aug 2014 13:11:57 +0300
In-Reply-To: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 29 Jul 2014 12:03:59 +0200")
Message-ID: <87d2cbz3wy.fsf@kamboji.qca.qualcomm.com> (sfid-20140808_121214_088939_D67355AB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The 10.x and main firmware branches have
> conflicting WMI service bitmap definitions.
>
> This also fixes WMI services parsing on big-endian
> hosts and changes debugfs output to be more human
> friendly.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Based on Joe's suggestion, I'm planning to change the macro like below.
Are you ok with that?

It actually adds a new checkpatch warning but I'm going to ignore that
for now:

drivers/net/wireless/ath/ath10k/wmi.h:177: ERROR: Macros with complex values should be enclosed in parenthesis

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 109ea684f88f..e70836586756 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -174,46 +174,48 @@ enum wmi_main_service {
 
 static inline char *wmi_service_name(int service_id)
 {
-#define SVCSTR(x) { case x: return #x; }
+#define SVCSTR(x) case x: return #x
+
 	switch (service_id) {
-	SVCSTR(WMI_SERVICE_BEACON_OFFLOAD)
-	SVCSTR(WMI_SERVICE_SCAN_OFFLOAD)
-	SVCSTR(WMI_SERVICE_ROAM_OFFLOAD)
-	SVCSTR(WMI_SERVICE_BCN_MISS_OFFLOAD)
-	SVCSTR(WMI_SERVICE_STA_PWRSAVE)
-	SVCSTR(WMI_SERVICE_STA_ADVANCED_PWRSAVE)
-	SVCSTR(WMI_SERVICE_AP_UAPSD)
-	SVCSTR(WMI_SERVICE_AP_DFS)
-	SVCSTR(WMI_SERVICE_11AC)
-	SVCSTR(WMI_SERVICE_BLOCKACK)
-	SVCSTR(WMI_SERVICE_PHYERR)
-	SVCSTR(WMI_SERVICE_BCN_FILTER)
-	SVCSTR(WMI_SERVICE_RTT)
-	SVCSTR(WMI_SERVICE_RATECTRL)
-	SVCSTR(WMI_SERVICE_WOW)
-	SVCSTR(WMI_SERVICE_RATECTRL_CACHE)
-	SVCSTR(WMI_SERVICE_IRAM_TIDS)
-	SVCSTR(WMI_SERVICE_ARPNS_OFFLOAD)
-	SVCSTR(WMI_SERVICE_NLO)
-	SVCSTR(WMI_SERVICE_GTK_OFFLOAD)
-	SVCSTR(WMI_SERVICE_SCAN_SCH)
-	SVCSTR(WMI_SERVICE_CSA_OFFLOAD)
-	SVCSTR(WMI_SERVICE_CHATTER)
-	SVCSTR(WMI_SERVICE_COEX_FREQAVOID)
-	SVCSTR(WMI_SERVICE_PACKET_POWER_SAVE)
-	SVCSTR(WMI_SERVICE_FORCE_FW_HANG)
-	SVCSTR(WMI_SERVICE_GPIO)
-	SVCSTR(WMI_SERVICE_STA_DTIM_PS_MODULATED_DTIM)
-	SVCSTR(WMI_SERVICE_STA_UAPSD_BASIC_AUTO_TRIG)
-	SVCSTR(WMI_SERVICE_STA_UAPSD_VAR_AUTO_TRIG)
-	SVCSTR(WMI_SERVICE_STA_KEEP_ALIVE)
-	SVCSTR(WMI_SERVICE_TX_ENCAP)
-	SVCSTR(WMI_SERVICE_BURST)
-	SVCSTR(WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT)
-	SVCSTR(WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT)
+	SVCSTR(WMI_SERVICE_BEACON_OFFLOAD);
+	SVCSTR(WMI_SERVICE_SCAN_OFFLOAD);
+	SVCSTR(WMI_SERVICE_ROAM_OFFLOAD);
+	SVCSTR(WMI_SERVICE_BCN_MISS_OFFLOAD);
+	SVCSTR(WMI_SERVICE_STA_PWRSAVE);
+	SVCSTR(WMI_SERVICE_STA_ADVANCED_PWRSAVE);
+	SVCSTR(WMI_SERVICE_AP_UAPSD);
+	SVCSTR(WMI_SERVICE_AP_DFS);
+	SVCSTR(WMI_SERVICE_11AC);
+	SVCSTR(WMI_SERVICE_BLOCKACK);
+	SVCSTR(WMI_SERVICE_PHYERR);
+	SVCSTR(WMI_SERVICE_BCN_FILTER);
+	SVCSTR(WMI_SERVICE_RTT);
+	SVCSTR(WMI_SERVICE_RATECTRL);
+	SVCSTR(WMI_SERVICE_WOW);
+	SVCSTR(WMI_SERVICE_RATECTRL_CACHE);
+	SVCSTR(WMI_SERVICE_IRAM_TIDS);
+	SVCSTR(WMI_SERVICE_ARPNS_OFFLOAD);
+	SVCSTR(WMI_SERVICE_NLO);
+	SVCSTR(WMI_SERVICE_GTK_OFFLOAD);
+	SVCSTR(WMI_SERVICE_SCAN_SCH);
+	SVCSTR(WMI_SERVICE_CSA_OFFLOAD);
+	SVCSTR(WMI_SERVICE_CHATTER);
+	SVCSTR(WMI_SERVICE_COEX_FREQAVOID);
+	SVCSTR(WMI_SERVICE_PACKET_POWER_SAVE);
+	SVCSTR(WMI_SERVICE_FORCE_FW_HANG);
+	SVCSTR(WMI_SERVICE_GPIO);
+	SVCSTR(WMI_SERVICE_STA_DTIM_PS_MODULATED_DTIM);
+	SVCSTR(WMI_SERVICE_STA_UAPSD_BASIC_AUTO_TRIG);
+	SVCSTR(WMI_SERVICE_STA_UAPSD_VAR_AUTO_TRIG);
+	SVCSTR(WMI_SERVICE_STA_KEEP_ALIVE);
+	SVCSTR(WMI_SERVICE_TX_ENCAP);
+	SVCSTR(WMI_SERVICE_BURST);
+	SVCSTR(WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT);
+	SVCSTR(WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT);
 	default:
 		return NULL;
 	}
+
 #undef SVCSTR
 }

-- 
Kalle Valo
