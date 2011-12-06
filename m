Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63073 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933074Ab1LFKPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 05:15:00 -0500
Received: by mail-lpp01m010-f46.google.com with SMTP id p5so1487299lag.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2011 02:14:59 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] wl12xx: send testmode reply in wl1271_tm_cmd_interrogate
Date: Tue,  6 Dec 2011 12:15:07 +0200
Message-Id: <1323166507-32470-3-git-send-email-eliad@wizery.com> (sfid-20111206_111505_593892_2633CE6D)
In-Reply-To: <1323166507-32470-1-git-send-email-eliad@wizery.com>
References: <1323166507-32470-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1271_tm_cmd_interrogate creates a reply skb, but doesn't
send it (and thus just leaks it).
Add the missing cfg80211_testmode_reply() call.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/testmode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
index 8d970d0..25093c0 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -177,6 +177,9 @@ static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
 	}
 
 	NLA_PUT(skb, WL1271_TM_ATTR_DATA, sizeof(*cmd), cmd);
+	ret = cfg80211_testmode_reply(skb);
+	if (ret < 0)
+		goto out_free;
 
 out_free:
 	kfree(cmd);
-- 
1.7.6.401.g6a319

