Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:59285 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaCGHTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 02:19:14 -0500
Received: by mail-ee0-f43.google.com with SMTP id e53so1542594eek.30
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 23:19:13 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: fix possible NULL dereference
Date: Fri,  7 Mar 2014 08:09:38 +0100
Message-Id: <1394176178-8504-1-git-send-email-michal.kazior@tieto.com> (sfid-20140307_081917_832980_7F46CC38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If chanctx is missing on a given vif then the band
is assumed to be 2GHz. However if hw doesn't
support 2GHz band then mac80211 ended up with a
NULL dereference.

This fixes a splat:

[ 4605.207223] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[ 4605.210789] IP: [<ffffffffa07b5635>] ieee80211_parse_bitrates+0x65/0x110 [mac80211]

The splat was preceeded by WARN_ON(!chanctx_conf)
in ieee80211_get_sdata_band().

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aaa59d7..5513bec 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2002,6 +2002,9 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 
 	band = ieee80211_get_sdata_band(sdata);
 
+	if (WARN_ON(!wiphy->bands[band]))
+		return -EINVAL;
+
 	if (params->use_cts_prot >= 0) {
 		sdata->vif.bss_conf.use_cts_prot = params->use_cts_prot;
 		changed |= BSS_CHANGED_ERP_CTS_PROT;
-- 
1.8.5.3

