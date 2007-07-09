Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:55777 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbXGIWf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 18:35:28 -0400
Date: Mon, 9 Jul 2007 15:19:22 -0700
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2.6] SoftMAC : fix ESSID problem
Message-ID: <20070709221922.GB1381@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi,

	Victor Porton reported that the SoftMAC layer had random
problem when setting the ESSID :
		http://bugzilla.kernel.org/show_bug.cgi?id=8686
	After investigation, it turned out to be worse, the SoftMAC
layer is left in an inconsistent state. The fix is pretty trivial.
        John : would you mind pushing that to 2.6.23 ?
        Thanks...

        Jean

Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>

-----------------------------------------------------------

--- linux/net/ieee80211/softmac/ieee80211softmac_assoc.j1.c	2007-07-09 13:56:13.000000000 -0700
+++ linux/net/ieee80211/softmac/ieee80211softmac_assoc.c	2007-07-09 13:56:41.000000000 -0700
@@ -271,8 +271,11 @@ ieee80211softmac_assoc_work(struct work_
 			 */
 			dprintk(KERN_INFO PFX "Associate: Scanning for networks first.\n");
 			ieee80211softmac_notify(mac->dev, IEEE80211SOFTMAC_EVENT_SCAN_FINISHED, ieee80211softmac_assoc_notify_scan, NULL);
-			if (ieee80211softmac_start_scan(mac))
+			if (ieee80211softmac_start_scan(mac)) {
 				dprintk(KERN_INFO PFX "Associate: failed to initiate scan. Is device up?\n");
+				mac->associnfo.associating = 0;
+				mac->associnfo.associated = 0;
+			}
 			goto out;
 		} else {
 			mac->associnfo.associating = 0;

