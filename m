Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:44601 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754943Ab1AaSuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:50:08 -0500
Subject: [PATCH 19/22] zd1211rw: reset device when CR_BCN_FIFO_SEMAPHORE
	freezes in beacon setup
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:50:02 +0200
Message-ID: <20110131185002.10044.3635.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When driver fails to acquire device semaphore lock, device usually
freezes soon afterwards. So failing to acquire lock indicates us that
not everything is going right in device/fw. So reset device when
this happens.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index a590a94..beaa969 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -703,7 +703,7 @@ static int zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
 				dev_err(zd_mac_dev(mac),
 						"Giving up beacon config.\n");
 				r = -ETIMEDOUT;
-				goto release_sema;
+				goto reset_device;
 			}
 		}
 		msleep(20);
@@ -770,6 +770,17 @@ out:
 	mutex_unlock(&mac->chip.mutex);
 	kfree(ioreqs);
 	return r;
+
+reset_device:
+	mutex_unlock(&mac->chip.mutex);
+	kfree(ioreqs);
+
+	/* semaphore stuck, reset device to avoid fw freeze later */
+	dev_warn(zd_mac_dev(mac), "CR_BCN_FIFO_SEMAPHORE stuck, "
+				  "reseting device...");
+	usb_queue_reset_device(mac->chip.usb.intf);
+
+	return r;
 }
 
 static int fill_ctrlset(struct zd_mac *mac,

