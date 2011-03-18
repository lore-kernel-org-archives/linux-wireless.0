Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:41075 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237Ab1CRDKY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 23:10:24 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 20:10:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Naveen Singh <nsingh@atheros.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: [RTF] iwmc3200wifi: fix device registration ordering for cfg80211
Date: Thu, 17 Mar 2011 20:10:20 -0700
Message-ID: <1300417820-19029-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this you can get a race against udev and userspace daemons
which will try to poke the device even before netdev ops and friends
are available. Device initialization will fail without this.

Cc: stable@kernel.org
Cc: Naveen Singh <nsingh@atheros.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I'm pretty sure this is correct, I noticed ath6kl followed the same path as
iwmc3200wifi and I spotted a bug on ath6kl with this path.. so I'm pretty damn
sure this bug is also present on iwmc3200wifi. Please test.

 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    9 ---------
 drivers/net/wireless/iwmc3200wifi/netdev.c   |    6 ++++++
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index ed57e44..2f48f72 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -837,17 +837,8 @@ struct wireless_dev *iwm_wdev_alloc(int sizeof_bus, struct device *dev)
 	wdev->wiphy->cipher_suites = cipher_suites;
 	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
-	ret = wiphy_register(wdev->wiphy);
-	if (ret < 0) {
-		dev_err(dev, "Couldn't register wiphy device\n");
-		goto out_err_register;
-	}
-
 	return wdev;
 
- out_err_register:
-	wiphy_free(wdev->wiphy);
-
  out_err_new:
 	kfree(wdev);
 
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index 5091d77..731058e 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -145,6 +145,12 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 
 	iwm_init_default_profile(iwm, iwm->umac_profile);
 
+	ret = wiphy_register(wdev->wiphy);
+	if (ret < 0) {
+		dev_err(dev, "Couldn't register wiphy device\n");
+		goto out_profile;
+	}
+
 	return iwm;
 
  out_profile:
-- 
1.7.4.15.g7811d

