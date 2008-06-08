Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:56974 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758277AbYFHLNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 07:13:46 -0400
Received: by mu-out-0910.google.com with SMTP id w8so1182075mue.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 04:13:44 -0700 (PDT)
Date: Sun, 8 Jun 2008 13:13:06 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	ipw3945-devel@lists.sourceforge.net
Subject: [PATCH v2] iwlwifi: fix oops in iwl3945_led_brightness_set
Message-ID: <20080608111302.GB5856@joi> (sfid-20080608_131351_023543_C5E0F7ED)
References: <20080608084855.GA8167@joi> <1ba2fa240806080318g45a8042csb4eec293a3d1ee5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240806080318g45a8042csb4eec293a3d1ee5b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 08, 2008 at 01:18:36PM +0300, Tomas Winkler wrote:
> On Sun, Jun 8, 2008 at 11:48 AM, Marcin Slusarz
> <marcin.slusarz@gmail.com> wrote:
> > fix race between:
> > ieee80211_open->ieee80211_led_radio->led_trigger_event->led_set_brightness->iwl3945_led_brightness_set
> > (which assumes that "led->priv" is not NULL)
> > and
> > iwl3945_pci_probe->iwl3945_setup_deferred_work->(...)->iwl3945_bg_alive_start->iwl3945_alive_start->iwl3945_led_register->iwl3945_led_register_led
> > which sets priv field in struct iwl3945_led
> > after
> > led->led_dev.brightness_set = iwl3945_led_brightness_set;
> > (...)
> > led_classdev_register(device, &led->led_dev);
> >
> > http://kerneloops.org/guilty.php?guilty=iwl3945_led_brightness_set&version=2.6.25-release&start=1671168&end=1703935&class=oops
> >
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Zhu Yi <yi.zhu@intel.com>
> > Cc: Reinette Chatre <reinette.chatre@intel.com>
> > Cc: Tomas Winkler <tomas.winkler@intel.com>
> > Cc: John W. Linville <linville@tuxdriver.com>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: ipw3945-devel@lists.sourceforge.net
> > ---
> >
> > Compile tested only. Please review and test on real hardware.
> >
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-3945-led.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
> > index d200d08..9f08568 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
> > @@ -185,6 +185,8 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
> >                                               struct iwl3945_led, led_dev);
> >        struct iwl3945_priv *priv = led->priv;
> >
> > +       if (!led->registered)
> > +               return;
> >        if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> >                return;
> >
> > --
> > 1.5.4.5
> >
> NACK
> Just need to revert the order in registration command as done in
> iwl_leds_register_led.

Thanks for a review!
Updated patch below.

---
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
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index d200d08..8b1528e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -229,14 +229,15 @@ static int iwl3945_led_register_led(struct iwl3945_priv *priv,
 	led->led_dev.brightness_set = iwl3945_led_brightness_set;
 	led->led_dev.default_trigger = trigger;
 
+	led->priv = priv;
+	led->type = type;
+
 	ret = led_classdev_register(device, &led->led_dev);
 	if (ret) {
 		IWL_ERROR("Error: failed to register led handler.\n");
 		return ret;
 	}
 
-	led->priv = priv;
-	led->type = type;
 	led->registered = 1;
 
 	if (set_led && led->led_on)
-- 
1.5.4.5

