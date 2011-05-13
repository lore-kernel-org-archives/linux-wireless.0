Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab1EMJJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 05:09:06 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.75)
	(envelope-from <johannes@sipsolutions.net>)
	id 1QKoMr-0005kt-8Y
	for linux-wireless@vger.kernel.org; Fri, 13 May 2011 11:09:05 +0200
Subject: [RFC] rt2x00: advertise interface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 11:09:04 +0200
Message-ID: <1305277744.3487.8.camel@jlt3.sipsolutions.net> (sfid-20110513_110911_416469_3A7B3BF5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make rt2x00 advertise that it potentially supports
more than one AP interface.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I don't have any rt2x00 HW so this is completely untested. It compiles
though ;-)

 drivers/net/wireless/rt2x00/rt2x00.h    |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   19 +++++++++++++++++++
 2 files changed, 25 insertions(+)

--- a/drivers/net/wireless/rt2x00/rt2x00.h	2011-05-13 11:02:38.000000000 +0200
+++ b/drivers/net/wireless/rt2x00/rt2x00.h	2011-05-13 11:03:28.000000000 +0200
@@ -960,6 +960,12 @@ struct rt2x00_dev {
 	 * Protect the interrupt mask register.
 	 */
 	spinlock_t irqmask_lock;
+
+	/*
+	 * Interface combinations
+	 */
+	struct ieee80211_iface_limit ap_limit;
+	struct ieee80211_iface_combination ap_combination;
 };
 
 /*
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c	2011-05-13 11:00:28.000000000 +0200
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c	2011-05-13 11:08:04.000000000 +0200
@@ -942,6 +942,25 @@ static int rt2x00lib_probe_hw(struct rt2
 #undef RT2X00_TASKLET_INIT
 
 	/*
+	 * Initialise supported virtual interface combinations
+	 *
+	 * Since currently, max_sta_intf is always 1, ignore it.
+	 */
+	WARN_ON(rt2x00dev->ops->max_sta_intf != 1);
+	if (rt2x00dev->ops->max_ap_intf > 1) {
+		rt2x00dev->ap_limit.max = rt2x00dev->ops->max_ap_intf;
+		rt2x00dev->ap_limit.types = BIT(NL80211_IFTYPE_AP);
+		rt2x00dev->ap_combination.num_different_channels = 1;
+		rt2x00dev->ap_combination.max_interfaces =
+						rt2x00dev->ops->max_ap_intf;
+		rt2x00dev->ap_combination.limits = &rt2x00dev->ap_limit;
+		rt2x00dev->ap_combination.n_limits = 1;
+		rt2x00dev->hw->wiphy->iface_combinations =
+						&rt2x00dev->ap_combination;
+		rt2x00dev->hw->wiphy->n_iface_combinations = 1;
+	}
+
+	/*
 	 * Register HW.
 	 */
 	status = ieee80211_register_hw(rt2x00dev->hw);


