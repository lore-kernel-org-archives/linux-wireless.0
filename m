Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63464 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab0LTRDA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 12:03:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 09:02:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <kathy.giori@atheros.com>, <amod.bodas@atheros.com>,
	<david.quan@atheros.com>, <michael.green@atheros.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] iw: fix country print
Date: Mon, 20 Dec 2010 12:02:33 -0500
Message-ID: <1292864555-28661-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using a %s to pring the alpha2 may give us some extra
data which will spew out when printing. Fix it by only
printing the two characters we know we will get.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/reg.c b/reg.c
index 7f82e08..c4ee1c4 100644
--- a/reg.c
+++ b/reg.c
@@ -132,7 +132,7 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 	}
 
 	alpha2 = nla_data(tb_msg[NL80211_ATTR_REG_ALPHA2]);
-	printf("country %s:\n", alpha2);
+	printf("country %c%c:\n", alpha2[0], alpha2[1]);
 
 	nla_for_each_nested(nl_rule, tb_msg[NL80211_ATTR_REG_RULES], rem_rule) {
 		struct nlattr *tb_rule[NL80211_FREQUENCY_ATTR_MAX + 1];
-- 
1.7.3.2.90.gd4c43

