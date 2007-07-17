Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:63003 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935121AbXGQPqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2007 11:46:50 -0400
Message-ID: <469CE459.4070300@lwfinger.net>
Date: Tue, 17 Jul 2007 10:46:33 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: stable@kernel.org
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] softmac: Fix ESSID problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

This patch is now in Linus's tree and should now be added to 2.6.22.Y.

Larry

  ieee80211softmac_assoc.c |    5 ++++-
  1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/net/ieee80211/softmac/ieee80211softmac_assoc.c
===================================================================
--- linux-2.6.orig/net/ieee80211/softmac/ieee80211softmac_assoc.c
+++ linux-2.6/net/ieee80211/softmac/ieee80211softmac_assoc.c
@@ -271,8 +271,11 @@ ieee80211softmac_assoc_work(struct work_
  			 */
  			dprintk(KERN_INFO PFX "Associate: Scanning for networks first.\n");
  			ieee80211softmac_notify(mac->dev, IEEE80211SOFTMAC_EVENT_SCAN_FINISHED, 
ieee80211softmac_assoc_notify_scan, NULL);
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


