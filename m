Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:43851 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbeAQWzc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 17:55:32 -0500
Received: by mail-pf0-f172.google.com with SMTP id y26so5059385pfi.10
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jan 2018 14:55:32 -0800 (PST)
Date: Wed, 17 Jan 2018 14:55:23 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Johannes Berg <johannes.berg@intel.com>
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cfg80211: stop demanding lots of new stuff
Message-ID: <alpine.LSU.2.11.1801171448510.5433@eggly.anvils> (sfid-20180117_235601_216213_A3BA62CE)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"make oldconfig" from 4.14 (when CONFIG_CFG80211_CERTIFICATION_ONUS
is not set) to 4.15-rc, gets into asking lots of new questions, and
configuring in unwanted stuff: I'm unsure of my Kconfig skills, but
it looks like CFG80211_REQUIRE_SIGNED_REGDB's "default y" needs to
be toned down when we don't even have CFG80211_CERTIFICATION_ONUS.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 net/wireless/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 4.15-rc8/net/wireless/Kconfig	2017-12-03 10:22:51.928845056 -0800
+++ linux/net/wireless/Kconfig	2018-01-14 19:20:22.595472965 -0800
@@ -89,7 +89,7 @@ config CFG80211_CERTIFICATION_ONUS
 
 config CFG80211_REQUIRE_SIGNED_REGDB
 	bool "require regdb signature" if CFG80211_CERTIFICATION_ONUS
-	default y
+	default CFG80211_CERTIFICATION_ONUS
 	select SYSTEM_DATA_VERIFICATION
 	help
 	  Require that in addition to the "regulatory.db" file a
