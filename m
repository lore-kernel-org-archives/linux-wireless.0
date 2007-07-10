Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:56667 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760691AbXGJBhl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 21:37:41 -0400
Date: Mon, 09 Jul 2007 20:37:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] softmac: Fix ESSID problem
Message-ID: <4692e2e0.u/1KuH/5hSPtXvF9%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean Tourrilhes <jt@hpl.hp.com>

Victor Porton reported that the SoftMAC layer had random problem when setting the ESSID :
http://bugzilla.kernel.org/show_bug.cgi?id=8686 After investigation, it turned out to be
worse, the SoftMAC layer is left in an inconsistent state. The fix is pretty trivial.

Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
Acked-by: Michael Buesch <mb@bu3sch.df>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 ieee80211softmac_assoc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/net/ieee80211/softmac/ieee80211softmac_assoc.c
===================================================================
--- linux-2.6.orig/net/ieee80211/softmac/ieee80211softmac_assoc.c
+++ linux-2.6/net/ieee80211/softmac/ieee80211softmac_assoc.c
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

----

