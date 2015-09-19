Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34380 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbbISCkR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 22:40:17 -0400
Message-ID: <55FCCB0E.3000807@linux.intel.com> (sfid-20150919_044058_223684_9E302AC2)
Date: Sat, 19 Sep 2015 10:40:14 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] net/wireless: enable wiphy device to suspend/resume asynchronously
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now, PM core supports asynchronous suspend/resume mode for devices
during system suspend/resume, and the power state transition of one
device may be completed in separate kernel thread. PM core ensures
all power state transition timing dependency between devices. This
patch enables wiphy device to suspend/resume asynchronously. This can
take advantage of multicore and improve system suspend/resume speed.

Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
---
Changes in v2:
- Amend commit message.

 net/wireless/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3893409..f223026 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -419,6 +419,7 @@ use_default_name:
 	device_initialize(&rdev->wiphy.dev);
 	rdev->wiphy.dev.class = &ieee80211_class;
 	rdev->wiphy.dev.platform_data = rdev;
+	device_enable_async_suspend(&rdev->wiphy.dev);
 
 	INIT_LIST_HEAD(&rdev->destroy_list);
 	spin_lock_init(&rdev->destroy_list_lock);
-- 1.7.1

