Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61163 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2H0Kjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 06:39:51 -0400
Received: by pbbrr13 with SMTP id rr13so7209181pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2012 03:39:51 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] cfg80211: allow software encryption of aes cmac in mesh
Date: Mon, 27 Aug 2012 18:38:07 +0800
Message-Id: <1346063887-29078-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120827_123956_109139_7E756E21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Secured mesh requires the key installation using cipher
suite AES CMAC for multicast management frame. This patch
will allow the key installation to proceed. Otherwise, it
will be rejected due to hw encryption is not supported.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/wireless/util.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index ef35f4e..1b665a7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -253,7 +253,9 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 		}
 	}
 
-	if (!cfg80211_supported_cipher_suite(&rdev->wiphy, params->cipher))
+	if (!cfg80211_supported_cipher_suite(&rdev->wiphy, params->cipher) &&
+	    !(params->cipher == WLAN_CIPHER_SUITE_AES_CMAC &&
+	      (rdev->wiphy.flags & WIPHY_FLAG_MESH_AUTH)))
 		return -EINVAL;
 
 	return 0;
-- 
1.7.0.4

