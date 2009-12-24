Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZLXBDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 20:03:30 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	johannes@sipsolutions.net
Subject: [PATCH 2/5] mac80211: fix propagation of failed hardware reconfigurations
Date: Wed, 23 Dec 2009 20:03:26 -0500
Message-Id: <1261616609-518-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
References: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
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
Cc: johannes@sipsolutions.net
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/util.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index b019725..57c2c39 100644
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
+			     "upon resume likely due to a bug on mac80211, "
+			     "your driver or a bus issue\n");
+			return res;
+		}
 
 		ieee80211_led_radio(local, true);
 	}
-- 
1.6.3.3

