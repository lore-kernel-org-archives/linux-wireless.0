Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54934 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753249AbZEKS6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 14:58:49 -0400
Message-Id: <20090511185842.074874801@atheros.com>
References: <20090511185754.653711567@atheros.com>
Date: Mon, 11 May 2009 21:57:55 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 1/4] nl80211: Validate MFP flag type when parsing STA flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_STA_FLAG_MFP was forgotten from sta_flags_policy. The previous
version added the flag due to the loop used in parse_station_flags,
but the proper behavior would be to allow nla_parse_nested() to go
through the policy for all flags.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/wireless/nl80211.c |    1 +
 1 file changed, 1 insertion(+)

--- uml.orig/net/wireless/nl80211.c	2009-05-11 21:39:23.000000000 +0300
+++ uml/net/wireless/nl80211.c	2009-05-11 21:39:23.000000000 +0300
@@ -1331,6 +1331,7 @@ static const struct nla_policy sta_flags
 	[NL80211_STA_FLAG_AUTHORIZED] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_SHORT_PREAMBLE] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_WME] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_MFP] = { .type = NLA_FLAG },
 };
 
 static int parse_station_flags(struct nlattr *nla, u32 *staflags)

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
