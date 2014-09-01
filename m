Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42793 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaIAI0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 04:26:38 -0400
Received: by mail-oa0-f46.google.com with SMTP id m19so3563007oag.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 01:26:37 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Croce <matteo@openwrt.org>
Date: Mon, 1 Sep 2014 10:25:57 +0200
Message-ID: <CAFnufp1YWig-j_5bK=Vkp+w2F6vDy=HH5U=OVVYo2bzQ4aXrBg@mail.gmail.com> (sfid-20140901_102647_533334_6314F4FD)
Subject: Format connected time
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Format connected_time in the form hh:mm:ss

--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -130,7 +130,7 @@ static ssize_t sta_connected_time_read(struct file
*file, char __user *userbuf,
  result.tm_year -= 70;
  result.tm_mday -= 1;
  res = scnprintf(buf, sizeof(buf),
- "years  - %ld\nmonths - %d\ndays   - %d\nclock  - %d:%d:%d\n\n",
+ "years  - %ld\nmonths - %d\ndays   - %d\nclock  - %02d:%02d:%02d\n\n",
  result.tm_year, result.tm_mon, result.tm_mday,
  result.tm_hour, result.tm_min, result.tm_sec);
  return simple_read_from_buffer(userbuf, count, ppos, buf, res);

-- 
Matteo Croce
OpenWrt Developer
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 BARRIER BREAKER
 -----------------------------------------------------
  * 1/2 oz Galliano         Pour all ingredients into
  * 4 oz cold Coffee        an irish coffee mug filled
  * 1 1/2 oz Dark Rum       with crushed ice. Stir.
  * 2 tsp. Creme de Cacao
 -----------------------------------------------------
