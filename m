Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27449 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZBNFeg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 00:34:36 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 21:34:36 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 04/10] nl80211: disallow user requests prior to regulatory_init()
Date: Fri, 13 Feb 2009 21:33:41 -0800
Message-ID: <1234589627-16977-5-git-send-email-lrodriguez@atheros.com> (sfid-20090214_063440_955532_AE18692E)
In-Reply-To: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If cfg80211 is built into the kernel there is perhaps a small
time window betwen nl80211_init() and regulatory_init() where
cfg80211_regdomain hasn't yet been initialized to let the
wireless core do its work. During that rare case and time
frame (if its even possible) we don't allow user regulatory
changes as cfg80211 is working on enabling its first regulatory
domain.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index db973f2..6f4dedb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1876,6 +1876,15 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	int r;
 	char *data = NULL;
 
+	/*
+	 * You should only get this when cfg80211 hasn't yet initialized
+	 * completely when built-in to the kernel right between the time
+	 * window between nl80211_init() and regulatory_init(), if that is
+	 * even possible.
+	 */
+	if (!cfg80211_regdomain)
+		return -EINPROGRESS;
+
 	if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
 		return -EINVAL;
 
-- 
1.6.1.2.253.ga34a

