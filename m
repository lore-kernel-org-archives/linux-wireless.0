Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726963AbeHJN2T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Aug 2018 09:28:19 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] cfg80211: allow to build without CFG80211_REQUIRE_SIGNED_REGDB
Date: Fri, 10 Aug 2018 12:55:47 +0200
Message-Id: <1533898547-14449-1-git-send-email-sgruszka@redhat.com> (sfid-20180810_125902_042211_A5A70028)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to kconfig-language.txt conditional dependency should be
expressed 2 times:

        bool "foo" if BAR
        default y if BAR

Indeed, without additional if expression we always build with
CFG80211_REQUIRE_SIGNED_REGDB even when CFG80211_CERTIFICATION_ONUS
is not set.

Fixes: 90a53e4432b1 ("cfg80211: implement regdb signature checking")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/wireless/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 4172204..bd63b73 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -89,7 +89,7 @@ config CFG80211_CERTIFICATION_ONUS
 
 config CFG80211_REQUIRE_SIGNED_REGDB
 	bool "require regdb signature" if CFG80211_CERTIFICATION_ONUS
-	default y
+	default y if CFG80211_CERTIFICATION_ONUS
 	select SYSTEM_DATA_VERIFICATION
 	help
 	  Require that in addition to the "regulatory.db" file a
-- 
1.7.1
