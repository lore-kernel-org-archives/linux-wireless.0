Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52577 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbaKDPPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 10:15:16 -0500
Received: by mail-lb0-f172.google.com with SMTP id w7so4146404lbi.17
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 07:15:14 -0800 (PST)
From: Henning Rogge <hrogge@gmail.com>
To: "linux-wireless @ vger . kernel . org"
	<linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: [PATCH] cfg80211: fix nl80211 cmd id in nl80211_send_mpath()
Date: Tue,  4 Nov 2014 16:14:58 +0100
Message-Id: <1415114098-25517-1-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20141104_161521_331754_66B15464)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Netlink command for nl80211_send_mpath() should be NL80211_CMD_NEW_MPATH.

Signed-off-by: Henning Rogge <henning.rogge@fkie.fraunhofer.de>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cb9f5a4..7c20040 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4423,7 +4423,7 @@ static int nl80211_send_mpath(struct sk_buff *msg, u32 portid, u32 seq,
 	void *hdr;
 	struct nlattr *pinfoattr;
 
-	hdr = nl80211hdr_put(msg, portid, seq, flags, NL80211_CMD_NEW_STATION);
+	hdr = nl80211hdr_put(msg, portid, seq, flags, NL80211_CMD_NEW_MPATH);
 	if (!hdr)
 		return -1;
 
-- 
2.1.0

