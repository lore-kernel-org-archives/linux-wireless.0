Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39693 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3CKQp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 12:45:26 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k: Allow over-riding reg-domain.
Date: Mon, 11 Mar 2013 09:45:06 -0700
Message-Id: <1363020306-924-1-git-send-email-greearb@candelatech.com> (sfid-20130311_174530_308273_3D70EC12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, can't get the Sparklan AR9380 NICs to be
5Ghz APs, since they are in world-roaming domain by
default.  Add this to /etc/modprobe.d/ath9k.conf:

options ath9k override_eeprom_regdomain=0

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 af932c9... dee91a2... M	drivers/net/wireless/ath/ath9k/init.c
 drivers/net/wireless/ath/ath9k/init.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index af932c9..dee91a2 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -56,6 +56,12 @@ static int ath9k_enable_diversity;
 module_param_named(enable_diversity, ath9k_enable_diversity, int, 0444);
 MODULE_PARM_DESC(enable_diversity, "Enable Antenna diversity for AR9565");
 
+static int modparam_override_eeprom_regdomain = -1;
+module_param_named(override_eeprom_regdomain,
+		   modparam_override_eeprom_regdomain, int, 0444);
+MODULE_PARM_DESC(override_eeprom_regdomain, "Override regdomain hardcoded in EEPROM with this value (DANGEROUS).");
+
+
 bool is_ath9k_unloaded;
 /* We use the hw_value as an index into our private channel structure */
 
@@ -740,6 +746,21 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
+	if (modparam_override_eeprom_regdomain != -1) {
+#ifdef CONFIG_CFG80211_CERTIFICATION_ONUS
+		struct ath_regulatory *regulatory = ath9k_hw_regulatory(sc->sc_ah);
+		printk(KERN_ERR "ath9k: DANGER! You're overriding EEPROM-defined regulatory domain,"
+		       "\nfrom: 0x%x to 0x%x\n",
+		       regulatory->current_rd, modparam_override_eeprom_regdomain);
+		printk(KERN_ERR "ath9k: Your card was not certified to operate in the domain you chose.\n");
+		printk(KERN_ERR "ath9k: This might result in a violation of your local regulatory rules.\n");
+		printk(KERN_ERR "ath9k: Do not ever do this unless you really know what you are doing!\n");
+		regulatory->current_rd = modparam_override_eeprom_regdomain;
+#else
+		printk(KERN_ERR "ath9k: ERROR:  override_eeprom_regdomain request will be ignored because CF80211_CERTIFICATION_ONUS was not selected when compiling the kernel.\n");
+#endif
+	}
+
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
-- 
1.7.3.4

