Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:35008 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbYGUJgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 05:36:52 -0400
Received: by nf-out-0910.google.com with SMTP id d3so428461nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 02:36:51 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Force full register config after start()
Date: Mon, 21 Jul 2008 11:52:44 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807211152.44208.IvDoorn@gmail.com> (sfid-20080721_113656_059493_F1BF835E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00 will only perform configuration changes from
mac80211 when the configuration option has changed.
This means it keeps track of the current active configuration
and will check these values when the config() callback function
is used.

However this causes breakage when the interface has been
brought down and up again, since all stored active values
aren't reset while the registers might have.
This is for example the case with rt61pci antenna registers which
will jump to invalid values when the interface has been started.

To make sure a full configuration takes place after the start()
callback function, a new flag is added which will be checked
during config() and skips the "what's changed" phase.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, please queue for 2.6.27, this prevents dead hardware after
an ifdown & ifup sequence.

 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c |    7 ++++---
 drivers/net/wireless/rt2x00/rt2x00mac.c |   13 ++++++++++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index fe5ee8a..37c9968 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -600,6 +600,7 @@ enum rt2x00_flags {
 	DEVICE_STARTED_SUSPEND,
 	DEVICE_ENABLED_RADIO,
 	DEVICE_DISABLED_RADIO_HW,
+	DEVICE_DIRTY_CONFIG,
 
 	/*
 	 * Driver features
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 8c93eb8..f42283a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1013,6 +1013,7 @@ int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->intf_associated = 0;
 
 	__set_bit(DEVICE_STARTED, &rt2x00dev->flags);
+	__set_bit(DEVICE_DIRTY_CONFIG, &rt2x00dev->flags);
 
 	return 0;
 }
@@ -1237,9 +1238,9 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Reconfigure device.
 	 */
-	rt2x00lib_config(rt2x00dev, &rt2x00dev->hw->conf, 1);
-	if (!rt2x00dev->hw->conf.radio_enabled)
-		rt2x00lib_disable_radio(rt2x00dev);
+	retval = rt2x00mac_config(rt2x00dev->hw, &rt2x00dev->hw->conf);
+	if (retval)
+		goto exit;
 
 	/*
 	 * Iterator over each active interface to
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 64a4fc6..f7fd995 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -310,6 +310,7 @@ EXPORT_SYMBOL_GPL(rt2x00mac_remove_interface);
 int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
+	int force_reconfig;
 
 	/*
 	 * Mac80211 might be calling this function while we are trying
@@ -329,7 +330,17 @@ int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 			rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 	}
 
-	rt2x00lib_config(rt2x00dev, conf, 0);
+	/*
+	 * When the DEVICE_DIRTY_CONFIG flag is set, the device has recently
+	 * been started and the configuration must be forced upon the hardware.
+	 * Otherwise registers will not be intialized correctly and could
+	 * result in non-working hardware because essential registers aren't
+	 * initialized.
+	 */
+	force_reconfig =
+	    __test_and_clear_bit(DEVICE_DIRTY_CONFIG, &rt2x00dev->flags);
+
+	rt2x00lib_config(rt2x00dev, conf, force_reconfig);
 
 	/*
 	 * Reenable RX only if the radio should be on.
-- 
1.5.6.1

