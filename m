Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:37053 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAPNew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 08:34:52 -0500
Received: by mail-lb0-f171.google.com with SMTP id c11so1927422lbj.30
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 05:34:51 -0800 (PST)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Reset split_start on error path when split dump is not used
Date: Thu, 16 Jan 2014 14:34:39 +0100
Message-Id: <1389879279-20832-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20140116_143456_492094_8458AFAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the netlink skb is exhausted split_start is left set. In the
subsequent retry, with a larger buffer, the dump is continued from the
failing point instead of from the beginning.

This was causing my rt28xx based USB dongle to now show up when
running "iw list" with an old iw version without split dump support.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

Supersedes "nl80211: Don't touch split_start when split dump is not used"

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d0afd82..ba6d438 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1631,6 +1631,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
+	if (!state->split)
+		state->split_start = 0;
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
 }
-- 
1.8.3.2

