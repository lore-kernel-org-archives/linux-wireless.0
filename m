Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f173.google.com ([209.85.210.173]:44455 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3ACFLa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 00:11:30 -0500
Received: by mail-ia0-f173.google.com with SMTP id w21so12528002iac.18
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 21:11:30 -0800 (PST)
Date: Thu, 3 Jan 2013 00:09:46 -0500
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix mesh_hwmp kerneldoc
Message-ID: <20130103050945.GE13185@localhost> (sfid-20130103_061135_213095_26262EF6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


One of the function names was wrong and some parameters were
missing.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_hwmp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 47aeee2..f0b384e 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -219,12 +219,14 @@ static void prepare_frame_for_deferred_tx(struct ieee80211_sub_if_data *sdata,
 }
 
 /**
- * mesh_send_path error - Sends a PERR mesh management frame
+ * mesh_path_error_tx - Sends a PERR mesh management frame
  *
+ * @ttl: allowed remaining hops
  * @target: broken destination
  * @target_sn: SN of the broken destination
  * @target_rcode: reason code for this PERR
  * @ra: node this frame is addressed to
+ * @sdata: local mesh subif
  *
  * Note: This function may be called with driver locks taken that the driver
  * also acquires in the TX path.  To avoid a deadlock we don't transmit the
@@ -350,6 +352,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
  * @sdata: local mesh subif
  * @mgmt: mesh management frame
  * @hwmp_ie: hwmp information element (PREP or PREQ)
+ * @action: type of hwmp ie
  *
  * This function updates the path routing information to the originator and the
  * transmitter of a HWMP PREQ or PREP frame.
-- 
1.7.10.4

-- 
Bob Copeland %% www.bobcopeland.com
