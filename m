Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41792 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3JWSzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 14:55:40 -0400
Received: by mail-wg0-f45.google.com with SMTP id z12so1287354wgg.12
        for <linux-wireless@vger.kernel.org>; Wed, 23 Oct 2013 11:55:39 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC] cfg80211: make genregdb.awk skip antenna gain
Date: Wed, 23 Oct 2013 20:55:36 +0200
Message-Id: <1382554536-27943-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131023_205543_502092_B6A69099)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that wireless-regdb doesn't include
antenna gain lets skip parsing it completely
for when CONFIG_CFG80211_INTERNAL_REGDB is
enabled.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/genregdb.awk | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)
 mode change 100644 => 100755 net/wireless/genregdb.awk

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
old mode 100644
new mode 100755
index c808619..3e241e4e
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -63,14 +63,11 @@ active && /^[ \t]*\(/ {
 	end = $3
 	bw = $5
 	sub(/\),/, "", bw)
-	gain = $6
-	sub(/\(/, "", gain)
-	sub(/,/, "", gain)
-	power = $7
-	sub(/\)/, "", power)
+	power = $6
+	sub(/\(/, "", power)
 	sub(/,/, "", power)
 	# power might be in mW...
-	units = $8
+	units = $7
 	sub(/\)/, "", units)
 	sub(/,/, "", units)
 	if (units == "mW") {
@@ -87,7 +84,7 @@ active && /^[ \t]*\(/ {
 		}
 	}
 	flagstr = ""
-	for (i=8; i<=NF; i++)
+	for (i=7; i<=NF; i++)
 		flagstr = flagstr $i
 	split(flagstr, flagarray, ",")
 	flags = ""
-- 
1.8.4.rc3

