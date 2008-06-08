Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:27440 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbYFHIti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 04:49:38 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1151554fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 01:49:37 -0700 (PDT)
Date: Sun, 8 Jun 2008 10:48:58 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	ipw3945-devel@lists.sourceforge.net
Subject: [PATCH] iwlwifi: fix oops in iwl3945_led_brightness_set
Message-ID: <20080608084855.GA8167@joi> (sfid-20080608_104946_297656_3BC1EAC2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix race between:
ieee80211_open->ieee80211_led_radio->led_trigger_event->led_set_brightness->iwl3945_led_brightness_set
(which assumes that "led->priv" is not NULL)
and
iwl3945_pci_probe->iwl3945_setup_deferred_work->(...)->iwl3945_bg_alive_start->iwl3945_alive_start->iwl3945_led_register->iwl3945_led_register_led
which sets priv field in struct iwl3945_led
after
led->led_dev.brightness_set = iwl3945_led_brightness_set;
(...)
led_classdev_register(device, &led->led_dev);

http://kerneloops.org/guilty.php?guilty=iwl3945_led_brightness_set&version=2.6.25-release&start=1671168&end=1703935&class=oops

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Cc: ipw3945-devel@lists.sourceforge.net
---

Compile tested only. Please review and test on real hardware.

---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index d200d08..9f08568 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -185,6 +185,8 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
 					       struct iwl3945_led, led_dev);
 	struct iwl3945_priv *priv = led->priv;
 
+	if (!led->registered)
+		return;
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-- 
1.5.4.5

