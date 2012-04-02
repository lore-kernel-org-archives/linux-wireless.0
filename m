Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41557 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2DBUlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 16:41:00 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] wireless:  Add more info to mlme WARNing.
Date: Mon,  2 Apr 2012 13:40:48 -0700
Message-Id: <1333399248-23180-1-git-send-email-greearb@candelatech.com> (sfid-20120402_224105_516724_DA7781A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 205f81a... 59bed1f... M	net/wireless/mlme.c
 net/wireless/mlme.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 205f81a..59bed1f 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -364,7 +364,8 @@ void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr)
 		}
 	}
 
-	WARN_ON(!done);
+	WARN(!done, "%s: MLME: Failed to send assoc-timeout, state: %i\n",
+	     dev->name, wdev->sme_state);
 
 	wdev_unlock(wdev);
 }
-- 
1.7.3.4

