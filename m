Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34269 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab0FAS2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 14:28:32 -0400
Received: by fxm8 with SMTP id 8so1236339fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 11:28:30 -0700 (PDT)
Subject: Re: Path for fixed channel issue in aircrack-ng suite [V2]
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Joker Joker <jokesareonyou@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4C000B68.9000305@gmail.com>
References: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>
	 <1274775071.3635.4.camel@jlt3.sipsolutions.net>
	 <AANLkTilPIt59FhAuVlhisUR7QDabCtnZwahjxWbUysiG@mail.gmail.com>
	 <1274860275.3658.0.camel@jlt3.sipsolutions.net>
	 <4C000B68.9000305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 21:28:27 +0300
Message-ID: <1275416907.3778.11.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While debugging recent wireless problems, I gave the aircrack suite a
shot, and found this thread.

How about this patch to fix this issue:


commit fffd6e63ea75850dafbf2ccfb38a4189f43c0282
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Tue Jun 1 15:43:21 2010 +0300

    wireless: allow to retrieve the channel set on monitor interface
    
    This will allow to preserve compatibility with userspace
    
    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index b01a6f6..09d979b 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -49,9 +49,12 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 {
 	struct ieee80211_channel *chan;
 	int result;
+	struct wireless_dev *mon_dev = NULL;
 
-	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
+	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR) {
+		mon_dev = wdev;
 		wdev = NULL;
+	}
 
 	if (wdev) {
 		ASSERT_WDEV_LOCK(wdev);
@@ -76,5 +79,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 	if (wdev)
 		wdev->channel = chan;
 
+	if (mon_dev)
+		mon_dev->channel = chan;
+
 	return 0;
 }


