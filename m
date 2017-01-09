Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f177.google.com ([209.85.210.177]:33114 "EHLO
        mail-wj0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932881AbdAIO0G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 09:26:06 -0500
Received: by mail-wj0-f177.google.com with SMTP id kq3so20326858wjc.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2017 06:26:06 -0800 (PST)
From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
To: jorge.ramirez-ortiz@linaro.org, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, daniel.lezcano@linaro.org,
        daniel.thompson@linaro.org
Subject: [PATCH] cfg80211: wext does not need to set monitor channel in managed mode
Date: Mon,  9 Jan 2017 15:25:49 +0100
Message-Id: <1483971949-10014-1-git-send-email-jorge.ramirez-ortiz@linaro.org> (sfid-20170109_152659_127924_AA496DD8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is not a valid reason to attempt setting the monitor channel
while in managed mode. Since this code path only deals with this mode,
remove the code block.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
---
 net/wireless/wext-sme.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 9951638..c434f19 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -105,30 +105,7 @@ int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 			goto out;
 	}
 
-
 	wdev->wext.connect.channel = chan;
-
-	/*
-	 * SSID is not set, we just want to switch monitor channel,
-	 * this is really just backward compatibility, if the SSID
-	 * is set then we use the channel to select the BSS to use
-	 * to connect to instead. If we were connected on another
-	 * channel we disconnected above and reconnect below.
-	 */
-	if (chan && !wdev->wext.connect.ssid_len) {
-		struct cfg80211_chan_def chandef = {
-			.width = NL80211_CHAN_WIDTH_20_NOHT,
-			.center_freq1 = freq,
-		};
-
-		chandef.chan = ieee80211_get_channel(&rdev->wiphy, freq);
-		if (chandef.chan)
-			err = cfg80211_set_monitor_channel(rdev, &chandef);
-		else
-			err = -EINVAL;
-		goto out;
-	}
-
 	err = cfg80211_mgd_wext_connect(rdev, wdev);
  out:
 	wdev_unlock(wdev);
-- 
2.7.4
