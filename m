Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:3132 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbXDRRHQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2007 13:07:16 -0400
Message-ID: <462649E3.4000208@canonical.com>
Date: Wed, 18 Apr 2007 10:40:03 -0600
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: kernel-team@lists.ubuntu.com, Ben Collins <ben.collins@ubuntu.com>,
	mjg59@cavan.codon.org.uk
Subject: [PATCH] Fix NetworkManager/wpa_supplicant race condition
Content-Type: multipart/mixed;
 boundary="------------020403000603050301020700"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020403000603050301020700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch fixes an assumption made by wpa_supplicant. Any time
wpa_supplicant requests to set an ESSID (e.g., associate), it expects an
event notifying that association has completed. If the Networkmanager
has already setup an association, such as for an open auth AP, then the
request to associate by wpa_supplicant will be ignored.

If Networkmanager is requested to restart the connection, such as by
clicking on the SSID, then wpa_supplicant is allowed to build the
association from scratch, which always works.

https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/103768

By always emitting this event, am I causing any unintended side effects?

rtg
-- 
Tim Gardner tim.gardner@ubuntu.com

--------------020403000603050301020700
Content-Type: text/plain;
 name="bug_103768"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bug_103768"

diff --git a/net/ieee80211/softmac/ieee80211softmac_wx.c b/net/ieee80211/softmac/ieee80211softmac_wx.c
index fa2f7da..cc2e8ba 100644
--- a/net/ieee80211/softmac/ieee80211softmac_wx.c
+++ b/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -88,6 +88,13 @@ ieee80211softmac_wx_set_essid(struct net_device *net_dev,
 		   !memcmp(n->essid.data, extra, n->essid.len)) {
 			dprintk(KERN_INFO PFX "Already associating or associated to "MAC_FMT"\n",
 				MAC_ARG(sm->associnfo.bssid));
+			/* wpa_supplicant expects an association event, regardless of prior
+			 * association state. If associating, then the associnfo.work task
+			 * will send the appropriate event.
+			 */
+			if (sm->associnfo.associated)
+				ieee80211softmac_call_events_locked(sm,
+					IEEE80211SOFTMAC_EVENT_ASSOCIATED, n);
 			goto out;
 		} else {
 			dprintk(KERN_INFO PFX "Canceling existing associate request!\n");

--------------020403000603050301020700--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
