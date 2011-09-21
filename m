Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18075 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab1IUNNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 09:13:19 -0400
Date: Wed, 21 Sep 2011 16:13:07 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Fix validation of AKM suites
Message-ID: <20110921131307.GA12668@jouni.qca.qualcomm.com> (sfid-20110921_151323_249908_3F82DFA3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Incorrect variable was used in validating the akm_suites array from
NL80211_ATTR_AKM_SUITES. In addition, there was no explicit
validation of the array length (we only have room for
NL80211_MAX_NR_AKM_SUITES).

This can result in a buffer write overflow for stack variables with
arbitrary data from user space. The nl80211 commands using the affected
functionality require GENL_ADMIN_PERM, so this is only exposed to admin
users.

Cc: stable@kernel.org
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/nl80211.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9e38e2c..6b6c60c5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4304,9 +4304,12 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 		if (len % sizeof(u32))
 			return -EINVAL;
 
+		if (settings->n_akm_suites > NL80211_MAX_NR_AKM_SUITES)
+			return -EINVAL;
+
 		memcpy(settings->akm_suites, data, len);
 
-		for (i = 0; i < settings->n_ciphers_pairwise; i++)
+		for (i = 0; i < settings->n_akm_suites; i++)
 			if (!nl80211_valid_akm_suite(settings->akm_suites[i]))
 				return -EINVAL;
 	}
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
