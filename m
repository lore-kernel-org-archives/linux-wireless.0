Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:49771 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161186AbbBDTKn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 14:10:43 -0500
Message-ID: <54D26EA9.6020301@users.sourceforge.net> (sfid-20150204_201107_140807_1741A6AD)
Date: Wed, 04 Feb 2015 20:10:33 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] HostAP: Delete an unnecessary check before the function call
 "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 4 Feb 2015 20:06:39 +0100

The kfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/hostap/hostap_ap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index 5965255..fd8d83d 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -145,7 +145,7 @@ static void ap_free_sta(struct ap_data *ap, struct sta_info *sta)
 	if (sta->aid > 0)
 		ap->sta_aid[sta->aid - 1] = NULL;
 
-	if (!sta->ap && sta->u.sta.challenge)
+	if (!sta->ap)
 		kfree(sta->u.sta.challenge);
 	del_timer_sync(&sta->timer);
 #endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
-- 
2.2.2

