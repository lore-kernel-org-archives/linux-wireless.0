Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbcDDSPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 14:15:22 -0400
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
From: Jeff Mahoney <jeffm@suse.com>
Subject: =?UTF-8?Q?[PATCH]_mac80211:_fix_=22warning:_=e2=80=98target=5fmetri?=
 =?UTF-8?Q?c=e2=80=99_may_be_used_uninitialized=22?=
Message-ID: <5702AF3B.1070507@suse.com> (sfid-20160404_201525_372943_AA6833DD)
Date: Mon, 4 Apr 2016 14:15:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes:

net/mac80211/mesh_hwmp.c:603:26: warning: ‘target_metric’ may be used
uninitialized in this function

target_metric is only consumed when reply = true so no bug exists here,
but gcc doesn't notice that.  Initializing to 0 clears the warning.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 net/mac80211/mesh_hwmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -530,7 +530,7 @@ static void hwmp_preq_frame_process(stru
 	const u8 *target_addr, *orig_addr;
 	const u8 *da;
 	u8 target_flags, ttl, flags;
-	u32 orig_sn, target_sn, lifetime, target_metric;
+	u32 orig_sn, target_sn, lifetime, target_metric = 0;
 	bool reply = false;
 	bool forward = true;
 	bool root_is_gate;

-- 
Jeff Mahoney
SUSE Labs
