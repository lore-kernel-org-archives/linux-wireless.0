Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758238AbZEWAJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 20:09:51 -0400
Subject: [PATCH 5/5] libertas: fix WPA adhoc network creation
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 22 May 2009 20:09:58 -0400
Message-Id: <1243037398.2495.14.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oddly enough, the firmware's JOIN/START commands don't appear to have
any facility for setting custom IEs, thus the started adhoc network
doesn't advertise its WPA capability in the beacon.  Whee!

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index cb73720..b9b3741 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -711,11 +711,13 @@ static int lbs_adhoc_start(struct lbs_private *priv,
 
 	/* set capability info */
 	tmpcap = WLAN_CAPABILITY_IBSS;
-	if (assoc_req->secinfo.wep_enabled) {
-		lbs_deb_join("ADHOC_START: WEP enabled, setting privacy on\n");
+	if (assoc_req->secinfo.wep_enabled ||
+	    assoc_req->secinfo.WPAenabled ||
+	    assoc_req->secinfo.WPA2enabled) {
+		lbs_deb_join("ADHOC_START: WEP/WPA enabled, privacy on\n");
 		tmpcap |= WLAN_CAPABILITY_PRIVACY;
 	} else
-		lbs_deb_join("ADHOC_START: WEP disabled, setting privacy off\n");
+		lbs_deb_join("ADHOC_START: WEP disabled, privacy off\n");
 
 	cmd.capability = cpu_to_le16(tmpcap);
 

