Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbZCUDxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 23:53:13 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Quentin@armitage.org.uk,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH 1/5] cfg80211: force last_request to be set for OLD_REG if regdom is EU
Date: Fri, 20 Mar 2009 23:53:04 -0400
Message-Id: <1237607588-6316-2-git-send-email-lrodriguez@atheros.com> (sfid-20090321_045324_871863_36895D53)
In-Reply-To: <1237607588-6316-1-git-send-email-lrodriguez@atheros.com>
References: <1237607588-6316-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although EU is a bogus alpha2 we need to process the send request
as our code depends on last_request being set.

Cc: stable@kernel.org
Reported-by: Quentin Armitage <Quentin@armitage.org.uk>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index eb8b8ed..ead9dcc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2135,11 +2135,14 @@ int regulatory_init(void)
 	/*
 	 * The old code still requests for a new regdomain and if
 	 * you have CRDA you get it updated, otherwise you get
-	 * stuck with the static values. We ignore "EU" code as
-	 * that is not a valid ISO / IEC 3166 alpha2
+	 * stuck with the static values. Since "EU" is not a valid
+	 * ISO / IEC 3166 alpha2 code we can't expect userpace to
+	 * give us a regulatory domain for it. We need last_request
+	 * iniitalized though so lets just send a request which we
+	 * know will be ignored... this crap will be removed once
+	 * OLD_REG dies.
 	 */
-	if (ieee80211_regdom[0] != 'E' || ieee80211_regdom[1] != 'U')
-		err = regulatory_hint_core(ieee80211_regdom);
+	err = regulatory_hint_core(ieee80211_regdom);
 #else
 	cfg80211_regdomain = cfg80211_world_regdom;
 
-- 
1.6.0.6

