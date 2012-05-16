Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965873Ab2EPJGv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 05:06:51 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Herton Ronaldo Krzesinski" <herton@canonical.com>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] rtl8187: ->brightness_set can not sleep
Date: Wed, 16 May 2012 11:06:21 +0200
Message-Id: <1337159181-4466-1-git-send-email-sgruszka@redhat.com> (sfid-20120516_110658_270721_EB2F0812)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix:

BUG: sleeping function called from invalid context at kernel/workqueue.c:2547
in_atomic(): 1, irqs_disabled(): 0, pid: 629, name: wpa_supplicant
2 locks held by wpa_supplicant/629:
 #0:  (rtnl_mutex){+.+.+.}, at: [<c08b2b84>] rtnl_lock+0x14/0x20
 #1:  (&trigger->leddev_list_lock){.+.?..}, at: [<c0867f41>] led_trigger_event+0x21/0x80
Pid: 629, comm: wpa_supplicant Not tainted 3.3.0-0.rc3.git5.1.fc17.i686
Call Trace:
 [<c046a9f6>] __might_sleep+0x126/0x1d0
 [<c0457d6c>] wait_on_work+0x2c/0x1d0
 [<c045a09a>] __cancel_work_timer+0x6a/0x120
 [<c045a160>] cancel_delayed_work_sync+0x10/0x20
 [<f7dd3c22>] rtl8187_led_brightness_set+0x82/0xf0 [rtl8187]
 [<c0867f7c>] led_trigger_event+0x5c/0x80
 [<f7ff5e6d>] ieee80211_led_radio+0x1d/0x40 [mac80211]
 [<f7ff3583>] ieee80211_stop_device+0x13/0x230 [mac80211]

Removing _sync is ok, because if led_on work is currently running
it will be finished before led_off work start to perform, since
they are always queued on the same mac80211 local->workqueue.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=795176

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rtl818x/rtl8187/leds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187/leds.c b/drivers/net/wireless/rtl818x/rtl8187/leds.c
index 2e0de2f..c2d5b49 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/leds.c
@@ -117,7 +117,7 @@ static void rtl8187_led_brightness_set(struct led_classdev *led_dev,
 			radio_on = true;
 		} else if (radio_on) {
 			radio_on = false;
-			cancel_delayed_work_sync(&priv->led_on);
+			cancel_delayed_work(&priv->led_on);
 			ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
 		}
 	} else if (radio_on) {
-- 
1.7.1

