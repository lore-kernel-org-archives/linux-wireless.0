Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40951 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZLXUiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 15:38:24 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH v3 2/5] mac80211: fix propagation of failed hardware reconfigurations
Date: Thu, 24 Dec 2009 15:38:22 -0500
Message-Id: <1261687102-19563-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 does not propagate failed hardware reconfiguration
requests. For suspend and resume this is important due to all
the possible issues that can come out of the suspend <-> resume
cycle. Not propagating the error means cfg80211 will assume
the resume for the device went through fine and mac80211 will
continue on trying to poke at the hardware, enable timers,
queue work, and so on for a device which is completley
unfunctional.

The least we can do is to propagate device start issues and
warn when this occurs upon resume. A side effect of this patch
is we also now propagate the start errors upon harware
reconfigurations (non-suspend), but this should also be desirable
anyway, there is not point in continuing to reconfigure a
device if mac80211 was unable to start the device.

For further details refer to the thread:

http://marc.info/?t=126151038700001&r=1&w=2

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This should make more sense for the warning.

 net/mac80211/util.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index b019725..227b428 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1047,7 +1047,19 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 
 	/* restart hardware */
 	if (local->open_count) {
+		/*
+		 * Upon resume hardware can sometimes be goofy due to
+		 * various platform / driver / bus issues, so restarting
+		 * the device may at times not work immediately. Propagate
+		 * the error.
+		 */
 		res = drv_start(local);
+		if (res) {
+			WARN(local->suspended, "Harware became unavailable "
+			     "upon resume. This is could be a software issue"
+			     "prior to suspend or a harware issue\n");
+			return res;
+		}
 
 		ieee80211_led_radio(local, true);
 	}
-- 
1.6.3.3

