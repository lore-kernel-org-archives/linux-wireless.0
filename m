Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52233 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0EYFHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 01:07:54 -0400
Received: by iwn6 with SMTP id 6so4356206iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 22:07:53 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 May 2010 01:07:53 -0400
Message-ID: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>
Subject: Path for fixed channel issue in aircrack-ng suite
From: Joker Joker <jokesareonyou@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Below is a patch to fix monitor mode channel issue for aircrack-ng suit
(fixed channel mon0: -1)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index d92d088..93f6c19 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -48,6 +48,7 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
                      enum nl80211_channel_type channel_type)
 {
        struct ieee80211_channel *chan;
+       struct wireless_dev *old_wdev = wdev;
        int result;

        if (wdev->iftype == NL80211_IFTYPE_MONITOR)
@@ -73,8 +74,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
        if (result)
                return result;

-       if (wdev)
-               wdev->channel = chan;
+       wdev = old_wdev;
+       wdev->channel = chan;

        return 0;
 }
