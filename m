Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbZFCShS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:37:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/6] iwl3945/iwlwifi: fix led bug when SW rfkill
Date: Wed,  3 Jun 2009 11:44:09 -0700
Message-Id: <1244054652-19451-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244054652-19451-3-git-send-email-reinette.chatre@intel.com>
References: <1244054652-19451-1-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-2-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch fixes the bug at
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1903

when SW rfkill is invoked by 'iwconfig txpower off',
the existing connection disassociates and led off command is sent
to the device which returns error as rfkill is 'true'.

Patch fixes this by just avoiding sending the led off/on command when
disassociated. The main purpose of the led_disassociate callback
is to start or stop the blinking.
There are three states in led
1) Always on when radio is on
2) Always off when radio is off
3) blink when associated and if there is some traffic.

In this callback 'allow_blinking' needs to be set false
when associated, as LED will be always on.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |    4 ----
 drivers/net/wireless/iwlwifi/iwl-led.c      |    4 ----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index bd7e520..225e5f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -167,10 +167,6 @@ static int iwl3945_led_disassociate(struct iwl_priv *priv, int led_id)
 	IWL_DEBUG_LED(priv, "Disassociated\n");
 
 	priv->allow_blinking = 0;
-	if (iwl_is_rfkill(priv))
-		iwl3945_led_off(priv, led_id);
-	else
-		iwl3945_led_on(priv, led_id);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 19680f7..5e64252 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -176,10 +176,6 @@ static int iwl_led_associate(struct iwl_priv *priv, int led_id)
 static int iwl_led_disassociate(struct iwl_priv *priv, int led_id)
 {
 	priv->allow_blinking = 0;
-	if (iwl_is_rfkill(priv))
-		iwl4965_led_off_reg(priv, led_id);
-	else
-		iwl4965_led_on_reg(priv, led_id);
 
 	return 0;
 }
-- 
1.5.6.3

