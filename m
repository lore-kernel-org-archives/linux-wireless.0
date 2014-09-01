Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37402 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaIAIz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 04:55:57 -0400
Received: by mail-ob0-f171.google.com with SMTP id wn1so3693099obc.30
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 01:55:57 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Croce <matteo@openwrt.org>
Date: Mon, 1 Sep 2014 10:55:17 +0200
Message-ID: <CAFnufp09nXuaobS_u7Bh5JcLGgpkPfMbqMfG0HVJYd_mLVR49A@mail.gmail.com> (sfid-20140901_105600_962562_9E15DB4E)
Subject: [PATCH] mac80211: Format connected time
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Format connected_time in the form hh:mm:ss

Signed-off-by: Matteo Croce <matteo@openwrt.org>

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
