Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56167 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbaDKMaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 08:30:06 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so4058915eek.41
        for <linux-wireless@vger.kernel.org>; Fri, 11 Apr 2014 05:30:02 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linux@eikelenboom.it, collen@cozybit.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC/RFT] cfg80211: reg: track crda request
Date: Fri, 11 Apr 2014 14:29:34 +0200
Message-Id: <1397219374-3280-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140411_143012_505755_969E6734)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Track CRDA requests and handle timeout
when no answer from CRDA.
This could happen during startup when
crda binary is not available.

Tested using:
chmod 644 /sbin/crda

Tested scenarios:

1)
chmod 644 /sbin/crda
modprobe cfg80211
wait about 20 seconds
chmod 755 /sbin/crda
-> CORE request handled correctly after crda became
   available, world regd

2)
chmod 644 /sbin/crda
modprobe cfg80211
wait about 10 seconds
modprobe ath10k_pci (DRIVER hint with US)
wait about 10 seconds
chmod 755 /sbin/crda
-> CORE request handled (world)
-> next DRIVER request handled (US)

3)
chmod 644 /sbin/crda
modprobe cfg80211
wait about 10 seconds
modprobe ath10k_pci (DRIVER hint with US)
wait about 10 seconds
iw reg set PL
wait about 10 seconds
chmod 755 /sbin/crda
-> CORE request handled
-> next DRIVER request handled (US)
-> next USER request handled (PL)

4)
chmod 644 /sbin/crda
modprobe cfg80211
wait about 10 seconds
iw reg set PL
wait about 10 seconds
modprobe ath10k_pci (DRIVER hint with US)
wait about 10 seconds
chmod 755 /sbin/crda
-> CORE request handled
-> next USER request handled (PL)
-> next DRIVER request handled (intersected DRIVER and USER)
Not sure this is as should be - intersection :)

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
This is instead of:
cfg80211: fix processing world regdomain when non modular

@Sander @Colleen - could you chec this one?

 net/wireless/reg.c |   46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 220c4a2..17ec820 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -512,6 +512,10 @@ reg_call_crda(struct regulatory_request *request)
 {
 	if (call_crda(request->alpha2))
 		return REG_REQ_IGNORE;
+
+	/* Setup timeout to check if CRDA is alive */
+	queue_delayed_work(system_power_efficient_wq,
+			   &reg_timeout, msecs_to_jiffies(3142));
 	return REG_REQ_OK;
 }
 
@@ -1542,8 +1546,7 @@ static void reg_set_request_processed(void)
 		need_more_processing = true;
 	spin_unlock(&reg_requests_lock);
 
-	if (lr->initiator == NL80211_REGDOM_SET_BY_USER)
-		cancel_delayed_work(&reg_timeout);
+	cancel_delayed_work(&reg_timeout);
 
 	if (need_more_processing)
 		schedule_work(&reg_work);
@@ -1810,6 +1813,9 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	struct wiphy *wiphy = NULL;
 	enum reg_request_treatment treatment;
 
+	REG_DBG_PRINT("Process regulatory hint called by %s\n",
+		      reg_initiator_name(reg_request->initiator));
+
 	if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
@@ -1818,12 +1824,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		reg_process_hint_core(reg_request);
 		return;
 	case NL80211_REGDOM_SET_BY_USER:
-		treatment = reg_process_hint_user(reg_request);
-		if (treatment == REG_REQ_IGNORE ||
-		    treatment == REG_REQ_ALREADY_SET)
-			return;
-		queue_delayed_work(system_power_efficient_wq,
-				   &reg_timeout, msecs_to_jiffies(3142));
+		reg_process_hint_user(reg_request);
 		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (!wiphy)
@@ -1864,7 +1865,8 @@ static void reg_process_pending_hints(void)
 
 	/* When last_request->processed becomes true this will be rescheduled */
 	if (lr && !lr->processed) {
-		REG_DBG_PRINT("Pending regulatory request, waiting for it to be processed...\n");
+		REG_DBG_PRINT("Pending %s regulatory request, waiting for it to be processed...\n",
+			      reg_initiator_name(lr->initiator));
 		return;
 	}
 
@@ -2615,9 +2617,31 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 
 static void reg_timeout_work(struct work_struct *work)
 {
-	REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
+	struct regulatory_request *lr;
+
 	rtnl_lock();
-	restore_regulatory_settings(true);
+
+	lr = get_last_request();
+	REG_DBG_PRINT("Timeout while waiting for CRDA to reply %s request, restoring regulatory settings\n",
+		      reg_initiator_name(lr->initiator));
+
+	switch (lr->initiator) {
+	case NL80211_REGDOM_SET_BY_CORE:
+	case NL80211_REGDOM_SET_BY_DRIVER:
+		/* Call CRDA again for last request */
+		/* TODO add counter and back to default if required */
+		reg_process_hint(lr);
+		break;
+	case NL80211_REGDOM_SET_BY_USER:
+		restore_regulatory_settings(true);
+		break;
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		restore_regulatory_settings(false);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
 	rtnl_unlock();
 }
 
-- 
1.7.9.5

