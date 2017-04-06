Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35355 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756255AbdDFS45 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 14:56:57 -0400
Received: by mail-it0-f43.google.com with SMTP id y18so107032819itc.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 11:56:57 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>,
        Greg Hackmann <ghackmann@google.com>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] mac80211: Fix clang warning about constant operand in logical operation
Date: Thu,  6 Apr 2017 11:56:33 -0700
Message-Id: <20170406185633.91065-1-mka@chromium.org> (sfid-20170406_205719_473802_3BB6915E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clang raises a warning about the expression 'strlen(CONFIG_XXX)' being
used in a logical operation. Clangs' builtin strlen function resolves the
expression to a constant at compile time, which causes clang to generate
a 'constant-logical-operand' warning.

Split the if statement in two to avoid using the const expression in a
logical operation.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 net/mac80211/rate.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 206698bc93f4..68ff202d6380 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -173,9 +173,14 @@ ieee80211_rate_control_ops_get(const char *name)
 		/* try default if specific alg requested but not found */
 		ops = ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
 
+	if (ops)
+		goto unlock;
+
 	/* try built-in one if specific alg requested but not found */
-	if (!ops && strlen(CONFIG_MAC80211_RC_DEFAULT))
+	if (strlen(CONFIG_MAC80211_RC_DEFAULT))
 		ops = ieee80211_try_rate_control_ops_get(CONFIG_MAC80211_RC_DEFAULT);
+
+unlock:
 	kernel_param_unlock(THIS_MODULE);
 
 	return ops;
-- 
2.12.2.715.g7642488e1d-goog
