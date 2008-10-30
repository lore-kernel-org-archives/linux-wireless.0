Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22490 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbYJ3UeC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:34:02 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 13:34:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/5] cfg80211: make print_regdomain_info() static
Date: Thu, 30 Oct 2008 13:33:54 -0700
Message-ID: <1225398836-28633-4-git-send-email-lrodriguez@atheros.com> (sfid-20081030_213407_168215_B7CFE232)
In-Reply-To: <1225398836-28633-3-git-send-email-lrodriguez@atheros.com>
References: <1225398836-28633-1-git-send-email-lrodriguez@atheros.com>
 <1225398836-28633-2-git-send-email-lrodriguez@atheros.com>
 <1225398836-28633-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thix fixes this sparse warning:

net/wireless/reg.c:782:6: warning: symbol 'print_regdomain_info' was not
declared. Should it be static?

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 92af64c..3f18a1d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -779,7 +779,7 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 	print_rd_rules(rd);
 }
 
-void print_regdomain_info(const struct ieee80211_regdomain *rd)
+static void print_regdomain_info(const struct ieee80211_regdomain *rd)
 {
 	printk(KERN_INFO "cfg80211: Regulatory domain: %c%c\n",
 		rd->alpha2[0], rd->alpha2[1]);
-- 
1.5.6.3

