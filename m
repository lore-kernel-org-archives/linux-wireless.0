Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.itconnect.no ([80.89.32.22]:41196 "EHLO mail.itconnect.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbYHYScX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 14:32:23 -0400
Received: from enterprise.localnet.radiotube.org (80-89-52-37.network.itconnect.no [80.89.52.37])
	by mail.itconnect.no (8.13.1/8.13.1) with ESMTP id m7PIWDdq015303
	for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 20:32:15 +0200
Received: from enterprise.localnet.radiotube.org (localhost [127.0.0.1])
	by enterprise.localnet.radiotube.org (8.14.2/8.14.2) with ESMTP id m7PIW6sH071702
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 20:32:07 +0200 (CEST)
	(envelope-from sigsegv@radiotube.org)
Received: (from root@localhost)
	by enterprise.localnet.radiotube.org (8.14.2/8.14.2/Submit) id m7PIW6kA071701
	for linux-wireless@vger.kernel.org; Mon, 25 Aug 2008 20:32:06 +0200 (CEST)
	(envelope-from sigsegv@radiotube.org)
Message-Id: <200808251832.m7PIW6kA071701@enterprise.localnet.radiotube.org> (sfid-20080825_203228_415204_3D9B0922)
Date: Mon, 25 Aug 2008 20:29:22 +0200
From: Jan-Espen Pettersen <sigsegv@radiotube.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.27-rc4] mac80211: don't send empty extended rates IE
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The association request includes a list of supported data rates.

802.11b: 4 supported rates.
802.11g: 12 (8 + 4) supported rates.
802.11a: 8 supported rates.

The rates tag of the assoc request has room for only 8 rates. In case of
802.11g an extended rate tag is appended. However in net/wireless/mlme.c
an extended (empty) rate tag is also appended if the number of rates is
exact 8. This empty (length=0) extended rates tag causes some APs to
deny association with code 18 (unsupported rates). These APs include my
ZyXEL G-570U, and according to Tomas Winkler som Cisco APs.

'If count == 8' has been used to check for the need for an extended rates
tag. But count would also be equal to 8 if the for loop exited because of
no more supported rates. Therefore a check for count being less than
rates_len would seem more correct.

Thanks to:
 * Dan Williams for newbie guidance
 * Tomas Winkler for confirming the problem

Signed-off-by: Jan-Espen Pettersen <sigsegv@radiotube.org>

--- a/net/mac80211/mlme.c	2008-08-25 00:19:30.000000000 +0200
+++ b/net/mac80211/mlme.c	2008-08-25 18:30:48.000000000 +0200
@@ -813,7 +813,7 @@
 		}
 	}
 
-	if (count == 8) {
+	if (rates_len > count) {
 		pos = skb_put(skb, rates_len - count + 2);
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = rates_len - count;
