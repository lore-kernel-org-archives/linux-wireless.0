Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41367 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2CaSbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 14:31:49 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so3022823pbc.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2012 11:31:48 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] mac80211: Allow tsf increments via debugfs
Date: Sat, 31 Mar 2012 11:31:31 -0700
Message-Id: <1333218693-30093-3-git-send-email-javier@cozybit.com> (sfid-20120331_203151_728689_C74BE0AF)
In-Reply-To: <1333218693-30093-1-git-send-email-javier@cozybit.com>
References: <1333218693-30093-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reading and writing back the tsf value via tsf is too slow if one wants
to make small increments to this timer.  With this change you can use
the syntax "+=<some value>" or "-=<some value>" to add or substract a
value from the tsf counter.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/debugfs_netdev.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index a32eeda..a2ba9bf 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -424,6 +424,7 @@ static ssize_t ieee80211_if_parse_tsf(
 	struct ieee80211_local *local = sdata->local;
 	unsigned long long tsf;
 	int ret;
+	int tsf_is_delta = 0;
 
 	if (strncmp(buf, "reset", 5) == 0) {
 		if (local->ops->reset_tsf) {
@@ -431,9 +432,20 @@ static ssize_t ieee80211_if_parse_tsf(
 			wiphy_info(local->hw.wiphy, "debugfs reset TSF\n");
 		}
 	} else {
+		if (buflen > 10 && buf[1] == '=') {
+			if (buf[0] == '+')
+				tsf_is_delta = 1;
+			else if (buf[0] == '-')
+				tsf_is_delta = -1;
+			else
+				return -EINVAL;
+			buf += 2;
+		}
 		ret = kstrtoull(buf, 10, &tsf);
 		if (ret < 0)
 			return -EINVAL;
+		if (tsf_is_delta)
+			tsf = drv_get_tsf(local, sdata) + tsf_is_delta * tsf;
 		if (local->ops->set_tsf) {
 			drv_set_tsf(local, sdata, tsf);
 			wiphy_info(local->hw.wiphy,
-- 
1.7.5.4

