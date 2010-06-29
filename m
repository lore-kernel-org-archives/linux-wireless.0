Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx04.teleca.com ([212.92.145.6]:34034 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab0F2Kux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 06:50:53 -0400
From: Yuri Ershov <ext-yuri.ershov@nokia.com>
To: johannes@sipsolutions.net
Cc: ext-yuri.kululin@nokia.com, linux-wireless@vger.kernel.org
Subject: [RFC 2/3] nl80211: Fix memory leaks
Date: Tue, 29 Jun 2010 15:08:07 +0400
Message-Id: <8123f79aa6e6c6d5634ae86396cfd020c0e2bbb9.1277808543.git.ext-yuri.ershov@nokia.com>
In-Reply-To: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
References: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
In-Reply-To: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
References: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of errors during message composing msg should be freed after canceling.

Signed-off-by: Yuri Kululin <ext-yuri.kululin@nokia.com>
Signed-off-by: Yuri Ershov <ext-yuri.ershov@nokia.com>
---
 net/wireless/nl80211.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a999fc1..c6bff6b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2769,6 +2769,7 @@ static int nl80211_get_mesh_params(struct sk_buff *skb,
 
  nla_put_failure:
 	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
 	err = -EMSGSIZE;
  out:
 	/* Cleanup */
@@ -2960,6 +2961,7 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 
 nla_put_failure:
 	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
 	err = -EMSGSIZE;
 out:
 	mutex_unlock(&cfg80211_mutex);
-- 
1.7.0.4

