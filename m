Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:47567 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3ECCgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:23 -0400
Received: by mail-da0-f44.google.com with SMTP id z8so587459daj.31
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:22 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [RFC 06/12] mac80211: notify bridge when leaving mesh
Date: Thu,  2 May 2013 19:33:56 -0700
Message-Id: <1367548442-8229-7-git-send-email-thomas@cozybit.com> (sfid-20130503_043626_076542_16643620)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After turning carrier off, any parent bridge interface
needs to be notified. Otherwise we would see a panic when
attempting to transmit frames on a mesh interface which
hadn't yet been put down.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index eac9988..271ddc9 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -993,6 +993,9 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	struct beacon_data *bcn;
 
 	netif_carrier_off(sdata->dev);
+	if (sdata->dev->priv_flags & IFF_BRIDGE_PORT)
+		/* stop bridge transmissions */
+		call_netdevice_notifiers(NETDEV_CHANGE, sdata->dev);
 
 	/* stop the beacon */
 	ifmsh->mesh_id_len = 0;
-- 
1.7.10.4

