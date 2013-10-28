Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:43337 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3J1CTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 22:19:54 -0400
Received: by mail-wg0-f53.google.com with SMTP id y10so6000296wgg.20
        for <linux-wireless@vger.kernel.org>; Sun, 27 Oct 2013 19:19:52 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] cfg80211: add function helpers to genregdb.awk
Date: Mon, 28 Oct 2013 03:19:45 +0100
Message-Id: <1382926786-7904-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_031957_852866_1B0B052C)
In-Reply-To: <1382926786-7904-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382926786-7904-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has no functional change, this just lets us reuse
helpers at a later time.

Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/genregdb.awk | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 3e241e4e..95baf61 100755
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -33,15 +33,7 @@ BEGIN {
 	regdb = "const struct ieee80211_regdomain *reg_regdb[] = {\n"
 }
 
-/^[ \t]*#/ {
-	# Ignore
-}
-
-!active && /^[ \t]*$/ {
-	# Ignore
-}
-
-!active && /country/ {
+function parse_country_head() {
 	country=$2
 	sub(/:/, "", country)
 	printf "static const struct ieee80211_regdomain regdom_%s = {\n", country
@@ -57,7 +49,8 @@ BEGIN {
 	regdb = regdb "\t&regdom_" country ",\n"
 }
 
-active && /^[ \t]*\(/ {
+function parse_reg_rule()
+{
 	start = $1
 	sub(/\(/, "", start)
 	end = $3
@@ -117,7 +110,8 @@ active && /^[ \t]*\(/ {
 	rules++
 }
 
-active && /^[ \t]*$/ {
+function print_tail_country()
+{
 	active = 0
 	printf "\t},\n"
 	printf "\t.n_reg_rules = %d\n", rules
@@ -125,6 +119,26 @@ active && /^[ \t]*$/ {
 	rules = 0;
 }
 
+/^[ \t]*#/ {
+	# Ignore
+}
+
+!active && /^[ \t]*$/ {
+	# Ignore
+}
+
+!active && /country/ {
+	parse_country_head()
+}
+
+active && /^[ \t]*\(/ {
+	parse_reg_rule()
+}
+
+active && /^[ \t]*$/ {
+	print_tail_country()
+}
+
 END {
 	print regdb "};"
 	print ""
-- 
1.8.4.rc3

