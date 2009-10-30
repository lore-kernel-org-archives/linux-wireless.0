Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:34311 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936AbZJ3Vyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:54:54 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1770220fgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 14:54:57 -0700 (PDT)
Subject: [PATCH 2/2] nl80211: allow to authenticate to access point that we
 already authenticated
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
In-Reply-To: <1256939391.31271.11.camel@maxim-laptop>
References: <1256939391.31271.11.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 23:54:54 +0200
Message-ID: <1256939694.31271.16.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 02be2525b95ec3c57323dda1a9e0c6da3a9817e6 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 30 Oct 2009 23:50:27 +0200
Subject: [PATCH 2/2] nl80211: allow to authenticate to access point that we already authenticated

This is permitted by standards, and used by driver_nl80211 of wpa_supplicant
Just start new authentication as if we weren't authenticated before
---
 net/wireless/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 83c2a28..3d91b4e 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -372,7 +372,7 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 		if (wdev->auth_bsses[i] &&
 		    memcmp(bssid, wdev->auth_bsses[i]->pub.bssid,
 						ETH_ALEN) == 0)
-			return -EALREADY;
+			wdev->auth_bsses[i] = NULL;
 	}
 
 	memset(&req, 0, sizeof(req));
-- 
1.6.3.3


