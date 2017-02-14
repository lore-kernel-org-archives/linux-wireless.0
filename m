Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33277 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdBNFV2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 00:21:28 -0500
Received: by mail-oi0-f66.google.com with SMTP id j15so1872124oih.0
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2017 21:21:27 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] iw: Fix bitrate output when no rate info found
Date: Tue, 14 Feb 2017 14:21:03 +0900
Message-Id: <1487049663-2942-1-git-send-email-masashi.honma@gmail.com> (sfid-20170214_062131_708043_65BE0564)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, bitrate showed uninitialized buffer when no rate info found.
This patch fixes the issue.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 station.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/station.c b/station.c
index f3e3da8..9d3eb4d 100644
--- a/station.c
+++ b/station.c
@@ -151,6 +151,10 @@ void parse_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen)
 	if (rate > 0)
 		pos += snprintf(pos, buflen - (pos - buf),
 				"%d.%d MBit/s", rate / 10, rate % 10);
+	else {
+		snprintf(buf, buflen, "No rate info found!");
+		return;
+	}
 
 	if (rinfo[NL80211_RATE_INFO_MCS])
 		pos += snprintf(pos, buflen - (pos - buf),
-- 
2.7.4
