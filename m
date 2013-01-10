Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3544 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab3AJKVB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 05:21:01 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>, stable@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.8] brcmsmac: increase timer reference count for
 new timers only
Date: Thu, 10 Jan 2013 11:20:48 +0100
Message-ID: <1357813248-10630-1-git-send-email-arend@broadcom.com> (sfid-20130110_112109_014127_7F2E2F69)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

On hardware reintialization reference count of
already existing timers would be increased again.
This leads to problems on module unloading.

Cc: stable@vger.kernel.org
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

This patch fixes driver unload issue after driver restart due
to fatal hardware problem. Because for 3.8 brcmsmac has been
reported to restart (looking into that) this fix may be helpful
to at least get the driver removed.

Gr. AvS
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 1fbd8ec..0f71d1d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1407,9 +1407,10 @@ void brcms_add_timer(struct brcms_timer *t, uint ms, int periodic)
 #endif
 	t->ms = ms;
 	t->periodic = (bool) periodic;
-	t->set = true;
-
-	atomic_inc(&t->wl->callbacks);
+	if (!t->set) {
+		t->set = true;
+		atomic_inc(&t->wl->callbacks);
+	}
 
 	ieee80211_queue_delayed_work(hw, &t->dly_wrk, msecs_to_jiffies(ms));
 }
-- 
1.7.10.4


