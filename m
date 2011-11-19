Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56366 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1KSIvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 03:51:36 -0500
Received: by wwe5 with SMTP id 5so6787741wwe.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 00:51:34 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: dereference RCU protected probe_resp pointer correctly
Date: Sat, 19 Nov 2011 10:51:26 +0200
Message-Id: <1321692686-9530-1-git-send-email-arik@wizery.com> (sfid-20111119_095148_861226_ECDE0F30)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a sparse warning:

cfg.c:502:13: warning: incorrect type in assignment (different address spaces)
cfg.c:502:13:    expected struct sk_buff *old
cfg.c:502:13:    got struct sk_buff [noderef] <asn:4>*probe_resp

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/cfg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1063a7e..abc8386 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -499,7 +499,7 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	if (!resp || !resp_len)
 		return -EINVAL;
 
-	old = sdata->u.ap.probe_resp;
+	old = rtnl_dereference(sdata->u.ap.probe_resp);
 
 	new = dev_alloc_skb(resp_len);
 	if (!new)
-- 
1.7.5.4

