Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57662 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2GJVNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 17:13:54 -0400
Received: by wgbdr13 with SMTP id dr13so370568wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 14:13:53 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] cfg80211: replace snprintf with scnprintf
Date: Wed, 11 Jul 2012 00:13:50 +0300
Message-Id: <1341954831-10313-2-git-send-email-eliad@wizery.com> (sfid-20120710_231358_052694_E9B2D077)
In-Reply-To: <1341954831-10313-1-git-send-email-eliad@wizery.com>
References: <1341954831-10313-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return value of snprintf was used incorrectly (given
as param to simple_read_from_buffer, without checking
it against max buffer size). use scnprintf instead.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/wireless/debugfs.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 920cabe..fa669c7 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -43,21 +43,20 @@ DEBUGFS_READONLY_FILE(long_retry_limit, 20, "%d",
 static int ht_print_chan(struct ieee80211_channel *chan,
 			 char *buf, int buf_size, int offset)
 {
-	if (WARN_ON(offset > buf_size))
-		return 0;
-
-	if (chan->flags & IEEE80211_CHAN_DISABLED)
-		return snprintf(buf + offset,
-				buf_size - offset,
-				"%d Disabled\n",
-				chan->center_freq);
-
-	return snprintf(buf + offset,
-			buf_size - offset,
-			"%d HT40 %c%c\n",
-			chan->center_freq,
-			(chan->flags & IEEE80211_CHAN_NO_HT40MINUS) ? ' ' : '-',
-			(chan->flags & IEEE80211_CHAN_NO_HT40PLUS)  ? ' ' : '+');
+	u32 flags = chan->flags;
+
+	if (flags & IEEE80211_CHAN_DISABLED)
+		return scnprintf(buf + offset,
+				 buf_size - offset,
+				 "%d Disabled\n",
+				 chan->center_freq);
+
+	return scnprintf(buf + offset,
+			 buf_size - offset,
+			 "%d HT40 %c%c\n",
+			 chan->center_freq,
+			 (flags & IEEE80211_CHAN_NO_HT40MINUS) ? ' ' : '-',
+			 (flags & IEEE80211_CHAN_NO_HT40PLUS)  ? ' ' : '+');
 }
 
 static ssize_t ht40allow_map_read(struct file *file,
-- 
1.7.6.401.g6a319

