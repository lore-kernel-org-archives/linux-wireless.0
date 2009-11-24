Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10115 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbZKXLx5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 06:53:57 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 03:54:04 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Clear encryption privacy when key off is done.
Date: Tue, 24 Nov 2009 17:23:47 +0530
Message-ID: <1259063627-20033-3-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1259063627-20033-2-git-send-email-vnatarajan@atheros.com>
References: <1259063627-20033-1-git-send-email-vnatarajan@atheros.com>
 <1259063627-20033-2-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the current_bss is not set, 'iwconfig <iface> key off' does not
clear the private flag. Hence after we connect with WEP to an AP and
then try to connect with another non-WEP AP, it does not work.
This issue will not be seen if supplicant is used.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/wireless/wext-compat.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 29091ac..000df52 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -479,6 +479,7 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 			}
 			err = rdev->ops->del_key(&rdev->wiphy, dev, idx, addr);
 		}
+		wdev->wext.connect.privacy = false;
 		/*
 		 * Applications using wireless extensions expect to be
 		 * able to delete keys that don't exist, so allow that.
-- 
1.6.0.4

