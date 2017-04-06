Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:36795 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755494AbdDFXcC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 19:32:02 -0400
Received: by mail-pg0-f53.google.com with SMTP id g2so48263028pge.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 16:32:02 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>,
        Greg Hackmann <ghackmann@google.com>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v2] mac80211: Fix clang warning about constant operand in logical operation
Date: Thu,  6 Apr 2017 16:31:41 -0700
Message-Id: <20170406233141.123098-1-mka@chromium.org> (sfid-20170407_013213_004570_CC54F883)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When clang detects a non-boolean constant in a logical operation it
generates a 'constant-logical-operand' warning. In
ieee80211_try_rate_control_ops_get() the result of strlen(<const str>)
is used in a logical operation, clang resolves the expression to an
(integer) constant at compile time when clang's builtin strlen function
is used.

Change the condition to check for strlen() > 0 to make the constant
operand boolean and thus avoid the warning.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v2:
- Changed expression to strlen() > 0 to make constant operand boolean
  instead of splitting up condition
- Updated commit message

 net/mac80211/rate.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 206698bc93f4..694faf6ab574 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -173,9 +173,11 @@ ieee80211_rate_control_ops_get(const char *name)
 		/* try default if specific alg requested but not found */
 		ops = ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
 
-	/* try built-in one if specific alg requested but not found */
-	if (!ops && strlen(CONFIG_MAC80211_RC_DEFAULT))
+	/* Note: check for > 0 is intentional to avoid clang warning */
+	if (!ops && (strlen(CONFIG_MAC80211_RC_DEFAULT) > 0))
+		/* try built-in one if specific alg requested but not found */
 		ops = ieee80211_try_rate_control_ops_get(CONFIG_MAC80211_RC_DEFAULT);
+
 	kernel_param_unlock(THIS_MODULE);
 
 	return ops;
-- 
2.12.2.715.g7642488e1d-goog
