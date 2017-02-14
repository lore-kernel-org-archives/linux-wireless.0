Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33570 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752573AbdBNJjJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 04:39:09 -0500
Received: by mail-oi0-f65.google.com with SMTP id j15so2497161oih.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 01:39:09 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH v2] iw: Fix bitrate output when no rate info found
Date: Tue, 14 Feb 2017 18:38:58 +0900
Message-Id: <1487065138-4892-1-git-send-email-masashi.honma@gmail.com> (sfid-20170214_103945_964926_393DEED5)
In-Reply-To: <1487049663-2942-1-git-send-email-masashi.honma@gmail.com>
References: <1487049663-2942-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, bitrate showed uninitialized buffer when no rate info found.
This patch fixes the issue.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 station.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/station.c b/station.c
index f3e3da8..4885dc0 100644
--- a/station.c
+++ b/station.c
@@ -151,6 +151,8 @@ void parse_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen)
 	if (rate > 0)
 		pos += snprintf(pos, buflen - (pos - buf),
 				"%d.%d MBit/s", rate / 10, rate % 10);
+	else
+		pos += snprintf(pos, buflen - (pos - buf), "(unknown)");
 
 	if (rinfo[NL80211_RATE_INFO_MCS])
 		pos += snprintf(pos, buflen - (pos - buf),
-- 
2.7.4
