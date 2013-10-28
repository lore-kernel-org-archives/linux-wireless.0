Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:40392 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab3J1QmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 12:42:23 -0400
Received: by mail-wg0-f54.google.com with SMTP id c11so6889029wgh.33
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 09:42:22 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 2/6] crda: fix -pedantic gcc compilation
Date: Mon, 28 Oct 2013 17:42:02 +0100
Message-Id: <1382978526-23929-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_174227_384081_6546DB0D)
In-Reply-To: <1382978526-23929-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382978526-23929-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc likes to complain about this, fix that as we're
going to get a bit more anal with code here soon as
we're moving towards making a library out of reglib.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 crda.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crda.c b/crda.c
index 2a601eb..4751a39 100644
--- a/crda.c
+++ b/crda.c
@@ -141,13 +141,15 @@ int main(int argc, char **argv)
 {
 	int fd = -1;
 	int i = 0, j, r;
-	char alpha2[3] = {}; /* NUL-terminate */
+	char alpha2[3];
 	char *env_country;
 	struct nl80211_state nlstate;
 	struct nl_cb *cb = NULL;
 	struct nl_msg *msg;
 	int finished = 0;
 
+	memset(alpha2, 0, 3);
+
 	struct nlattr *nl_reg_rules;
 	const struct ieee80211_regdomain *rd = NULL;
 
-- 
1.8.4.rc3

