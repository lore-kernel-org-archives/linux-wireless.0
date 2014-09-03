Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:43358 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbaICNeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:34:14 -0400
Received: by mail-ob0-f181.google.com with SMTP id vb8so6054632obc.40
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 06:34:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409744533.911.1.camel@jlt4.sipsolutions.net>
References: <CAFnufp09nXuaobS_u7Bh5JcLGgpkPfMbqMfG0HVJYd_mLVR49A@mail.gmail.com>
 <1409744533.911.1.camel@jlt4.sipsolutions.net>
From: Matteo Croce <matteo@openwrt.org>
Date: Wed, 3 Sep 2014 15:33:33 +0200
Message-ID: <CAFnufp2pb4k3amoZoQ3bc5PSXXVzORZDAF2TZoZjmBfGPUKT2Q@mail.gmail.com> (sfid-20140903_153527_623684_D7A8C513)
Subject: Re: [PATCH] mac80211: Format connected time
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, gmail wrapped the line with the C function.
Here is a fixed patch

Format connected_time in the form hh:mm:ss

Signed-off-by: Matteo Croce <matteo@openwrt.org>

--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -130,7 +130,7 @@
  result.tm_year -= 70;
  result.tm_mday -= 1;
  res = scnprintf(buf, sizeof(buf),
- "years  - %ld\nmonths - %d\ndays   - %d\nclock  - %d:%d:%d\n\n",
+ "years  - %ld\nmonths - %d\ndays   - %d\nclock  - %02d:%02d:%02d\n\n",
  result.tm_year, result.tm_mon, result.tm_mday,
  result.tm_hour, result.tm_min, result.tm_sec);
  return simple_read_from_buffer(userbuf, count, ppos, buf, res);
