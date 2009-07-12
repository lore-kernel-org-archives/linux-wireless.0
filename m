Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57915 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZGLADu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2009 20:03:50 -0400
Received: by fxm18 with SMTP id 18so1572491fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2009 17:03:48 -0700 (PDT)
From: =?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	=?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
Subject: [PATCH] cfg80211: fix disabling WPA via wext (SIOCSIWAUTH)
Date: Sun, 12 Jul 2009 02:03:48 +0200
Message-Id: <1247357028-4421-1-git-send-email-netrolller.3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_set_wpa_version completely missed the use case when disabling
WPA, considering IW_AUTH_WPA_VERSION_DISABLED an invalid argument. This
caused weird error messages in wpa_supplicant.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 net/wireless/wext-compat.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index aa80c0c..e6731bf 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -880,9 +880,19 @@ static int cfg80211_set_wpa_version(struct wireless_dev *wdev, u32 wpa_versions)
 	wdev->wext.connect.crypto.wpa_versions = 0;
 
 	if (wpa_versions & ~(IW_AUTH_WPA_VERSION_WPA |
-			     IW_AUTH_WPA_VERSION_WPA2))
+			     IW_AUTH_WPA_VERSION_WPA2|
+		             IW_AUTH_WPA_VERSION_DISABLED))
 		return -EINVAL;
 
+	if ((wpa_versions & IW_AUTH_WPA_VERSION_DISABLED) &&
+	    (wpa_versions & (IW_AUTH_WPA_VERSION_WPA|
+			     IW_AUTH_WPA_VERSION_WPA2)))
+		return -EINVAL;
+
+	if (wpa_versions & IW_AUTH_WPA_VERSION_DISABLED)
+		wdev->wext.connect.crypto.wpa_versions &=
+			~(NL80211_WPA_VERSION_1|NL80211_WPA_VERSION_2);
+
 	if (wpa_versions & IW_AUTH_WPA_VERSION_WPA)
 		wdev->wext.connect.crypto.wpa_versions |=
 			NL80211_WPA_VERSION_1;
-- 
1.5.4.5

