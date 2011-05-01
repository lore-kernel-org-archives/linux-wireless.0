Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61617 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab1EACan (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 22:30:43 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 19:30:16 -0700
From: Naveen Singh <sningh@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	Naveen Singh <nsingh@atheros.com>
Subject: 
Date: Sat, 30 Apr 2011 19:30:38 -0700
Message-ID: <1304217038-1654-1-git-send-email-sningh@atheros.com> (sfid-20110501_043058_891986_1A574C4C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Singh <nsingh@atheros.com>

The WPA-PSK association was not going through with 2.6.38
kernel. It was found that supplicant was not able to set
the PTK key. On further analysis it was found that the function
nl80211_set_key in file net/wireless/nl80211.c is returning with
code as -EOPNOTSUPP. This function has been modified to check for
the flag "WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS"in wiphy
struct. If this flag is not set in the driver init, it returns
from here thereby causing the association to fail. The solution
is to set this flag in driver init as there would be separate
default keys for unicast and multicast packets.

Signed-off-by: Naveen Singh <nsingh@atheros.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index e87d3aa..ec22408 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -1455,6 +1455,11 @@ ar6k_cfg80211_init(struct device *dev)
     wdev->wiphy->cipher_suites = cipher_suites;
     wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
+    /*Support the seprate keys for unicast and multicast packets
+     *This flag is needed because because nl80211 checks for this
+     *flag before calling cfg ops for setting the key.*/
+    wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS;
+
     ret = wiphy_register(wdev->wiphy);
     if(ret < 0) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
-- 
1.7.0.4

