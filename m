Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab0BCJsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 04:48:00 -0500
Subject: [PATCH v2] mac80211_hwsim: add fake hw scan handler
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <201002031036.19942.holgerschurig@gmail.com>
References: <1265188851.29119.84.camel@johannes.local>
	 <201002031036.19942.holgerschurig@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 10:47:55 +0100
Message-ID: <1265190475.29119.89.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For debugging hardware scan trigger/complete
functionality, it was useful to have code in
hwsim that pretends to do a hardware scan.

This code could be extended to actually do the
scan, but for now it was sufficient for me to
only pretend. Since hwsim was written to ease
debugging, it only makes sense to add it to it
permanently.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |   44 +++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-02-03 09:53:12.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-02-03 10:47:16.000000000 +0100
@@ -32,6 +32,10 @@ static int radios = 2;
 module_param(radios, int, 0444);
 MODULE_PARM_DESC(radios, "Number of simulated radios");
 
+static bool fake_hw_scan;
+module_param(fake_hw_scan, bool, 0444);
+MODULE_PARM_DESC(fake_hw_scan, "Install fake (no-op) hw-scan handler");
+
 /**
  * enum hwsim_regtest - the type of regulatory tests we offer
  *
@@ -909,8 +913,43 @@ static void mac80211_hwsim_flush(struct 
 	 */
 }
 
+struct hw_scan_done {
+	struct delayed_work w;
+	struct ieee80211_hw *hw;
+};
 
-static const struct ieee80211_ops mac80211_hwsim_ops =
+static void hw_scan_done(struct work_struct *work)
+{
+	struct hw_scan_done *hsd =
+		container_of(work, struct hw_scan_done, w.work);
+
+	ieee80211_scan_completed(hsd->hw, false);
+	kfree(hsd);
+}
+
+static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
+				  struct cfg80211_scan_request *req)
+{
+	struct hw_scan_done *hsd = kzalloc(sizeof(*hsd), GFP_KERNEL);
+	int i;
+
+	if (!hsd)
+		return -ENOMEM;
+
+	hsd->hw = hw;
+	INIT_DELAYED_WORK(&hsd->w, hw_scan_done);
+
+	printk(KERN_DEBUG "hwsim scan request\n");
+	for (i = 0; i < req->n_channels; i++)
+		printk(KERN_DEBUG "hwsim scan freq %d\n",
+			req->channels[i]->center_freq);
+
+	ieee80211_queue_delayed_work(hw, &hsd->w, 2 * HZ);
+
+	return 0;
+}
+
+static struct ieee80211_ops mac80211_hwsim_ops =
 {
 	.tx = mac80211_hwsim_tx,
 	.start = mac80211_hwsim_start,
@@ -1120,6 +1159,9 @@ static int __init init_mac80211_hwsim(vo
 	if (radios < 1 || radios > 100)
 		return -EINVAL;
 
+	if (fake_hw_scan)
+		mac80211_hwsim_ops.hw_scan = mac80211_hwsim_hw_scan;
+
 	spin_lock_init(&hwsim_radio_lock);
 	INIT_LIST_HEAD(&hwsim_radios);
 


