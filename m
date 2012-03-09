Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45682 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2CIQZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 11:25:34 -0500
Subject: [PATCH] mac80211: add auth/assoc/deauth flow diagram
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Mar 2012 17:25:33 +0100
Message-ID: <1331310333.3491.5.camel@jlt3.sipsolutions.net> (sfid-20120309_172537_459872_CF903AC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

I've been working on some documentation, so let's
add this diagram to the kernel tree where at least
it has a chance of being maintained :-)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/networking/mac80211-auth-assoc-deauth.txt |   99 ++++++++++++++++
 1 file changed, 99 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/Documentation/networking/mac80211-auth-assoc-deauth.txt	2012-03-09 17:24:54.000000000 +0100
@@ -0,0 +1,99 @@
+#
+# This outlines the Linux authentication/association and
+# deauthentication/disassociation flows.
+#
+# This can be converted into a diagram using the service
+# at http://www.websequencediagrams.com/
+#
+
+participant userspace
+participant mac80211
+participant driver
+
+alt authentication needed (not FT)
+userspace->mac80211: authenticate
+
+alt authenticated/authenticating already
+mac80211->driver: sta_state(AP, not-exist)
+mac80211->driver: bss_info_changed(clear BSSID)
+else associated
+note over mac80211,driver
+like deauth/disassoc, without sending the
+BA session stop & deauth/disassoc frames
+end note
+end
+
+mac80211->driver: config(channel, non-HT)
+mac80211->driver: bss_info_changed(set BSSID, basic rate bitmap)
+mac80211->driver: sta_state(AP, exists)
+
+alt no probe request data known
+mac80211->driver: TX directed probe request
+driver->mac80211: RX probe response
+end
+
+mac80211->driver: TX auth frame
+driver->mac80211: RX auth frame
+
+alt WEP shared key auth
+mac80211->driver: TX auth frame
+driver->mac80211: RX auth frame
+end
+
+mac80211->driver: sta_state(AP, authenticated)
+mac80211->userspace: RX auth frame
+
+end
+
+userspace->mac80211: associate
+alt authenticated or associated
+note over mac80211,driver: cleanup like for authenticate
+end
+
+alt not previously authenticated (FT)
+mac80211->driver: config(channel, non-HT)
+mac80211->driver: bss_info_changed(set BSSID, basic rate bitmap)
+mac80211->driver: sta_state(AP, exists)
+mac80211->driver: sta_state(AP, authenticated)
+end
+mac80211->driver: TX assoc
+driver->mac80211: RX assoc response
+note over mac80211: init rate control
+mac80211->driver: sta_state(AP, associated)
+
+alt not using WPA
+mac80211->driver: sta_state(AP, authorized)
+end
+
+mac80211->driver: set up QoS parameters
+
+alt is HT channel
+mac80211->driver: config(channel, HT params)
+end
+
+mac80211->driver: bss_info_changed(QoS, HT, associated with AID)
+mac80211->userspace: associated
+
+note left of userspace: associated now
+
+alt using WPA
+note over userspace
+do 4-way-handshake
+(data frames)
+end note
+userspace->mac80211: authorized
+mac80211->driver: sta_state(AP, authorized)
+end
+
+userspace->mac80211: deauthenticate/disassociate
+mac80211->driver: stop BA sessions
+mac80211->driver: TX deauth/disassoc
+mac80211->driver: flush frames
+mac80211->driver: sta_state(AP,associated)
+mac80211->driver: sta_state(AP,authenticated)
+mac80211->driver: sta_state(AP,exist)
+mac80211->driver: sta_state(AP,not-exist)
+mac80211->driver: turn off powersave
+mac80211->driver: bss_info_changed(clear BSSID, not associated, no QoS, ...)
+mac80211->driver: config(non-HT channel type)
+mac80211->userspace: disconnected


