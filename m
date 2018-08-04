Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr720047.outbound.protection.outlook.com ([40.107.72.47]:52960
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727127AbeHDWdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Aug 2018 18:33:23 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH] scan: fix crash when driver doesn't report frame type
Date: Sat,  4 Aug 2018 23:31:11 +0300
Message-Id: <20180804203111.31768-1-sergey.matyukevich.os@quantenna.com> (sfid-20180804_223140_853315_083622DC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If driver does not know what kind of frame has been received from BSS,
then it is possible to specify CFG80211_BSS_FTYPE_UNKNOWN
in cfg80211_inform_bss[_width].

In this case neither NL80211_BSS_BEACON_IES nor NL80211_BSS_PRESP_DATA
will be reported to userspace.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scan.c b/scan.c
index 09b04a5..d9681f3 100644
--- a/scan.c
+++ b/scan.c
@@ -2188,8 +2188,8 @@ static int print_bss_handler(struct nl_msg *msg, void *arg)
 		struct nlattr *bcnies = bss[NL80211_BSS_BEACON_IES];
 
 		if (bss[NL80211_BSS_PRESP_DATA] ||
-		    nla_len(ies) != nla_len(bcnies) ||
-		    memcmp(nla_data(ies), nla_data(bcnies), nla_len(ies)))
+		    (bcnies && (nla_len(ies) != nla_len(bcnies) ||
+		    memcmp(nla_data(ies), nla_data(bcnies), nla_len(ies)))))
 			printf("\tInformation elements from Probe Response "
 			       "frame:\n");
 		print_ies(nla_data(ies), nla_len(ies),
-- 
2.11.0
