Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34723 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbYJ3BUA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 21:20:00 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 18:20:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/6] cfg80211: make print_regdomain_info() static
Date: Wed, 29 Oct 2008 18:19:51 -0700
Message-ID: <1225329594-21704-4-git-send-email-lrodriguez@atheros.com> (sfid-20081030_022007_637677_4EB3ABEC)
In-Reply-To: <1225329594-21704-3-git-send-email-lrodriguez@atheros.com>
References: <1225329594-21704-1-git-send-email-lrodriguez@atheros.com>
 <1225329594-21704-2-git-send-email-lrodriguez@atheros.com>
 <1225329594-21704-3-git-send-email-lrodriguez@atheros.com>
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
index c996a74..be6667a 100644
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

