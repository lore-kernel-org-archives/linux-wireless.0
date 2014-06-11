Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:63984 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbaFKOSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:18:48 -0400
Received: by mail-we0-f178.google.com with SMTP id p10so7161856wes.9
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 07:18:47 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 09/10] mac80211: make sure TDLS peer STA exists during setup
Date: Wed, 11 Jun 2014 17:18:26 +0300
Message-Id: <1402496307-32522-9-git-send-email-arik@wizery.com> (sfid-20140611_161854_089952_59DDDAF6)
In-Reply-To: <1402496307-32522-1-git-send-email-arik@wizery.com>
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure userspace added a TDLS peer station before invoking the
transmission of the first setup frame. This ensures packets to the peer
won't go through the AP path.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 009601a..f100c12 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -332,6 +332,19 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 		goto exit;
 	}
 
+	/*
+	 * make sure we have a STA representing the peer so we drop or buffer
+	 * non-TDLS-setup frames to the peer. We can't send other packets
+	 * during setup through the AP path
+	 */
+	rcu_read_lock();
+	if (!sta_info_get(sdata, peer)) {
+		rcu_read_unlock();
+		ret = -ENOLINK;
+		goto exit;
+	}
+	rcu_read_unlock();
+
 	ieee80211_flush_queues(local, sdata);
 
 	ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer, action_code,
-- 
1.9.1

