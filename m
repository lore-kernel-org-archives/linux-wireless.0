Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from goliath.siemens.de ([192.35.17.28]:24293 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab0C3IA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 04:00:59 -0400
Received: from mail3.siemens.de (localhost [127.0.0.1])
	by goliath.siemens.de (8.12.11.20060308/8.12.11) with ESMTP id o2U80v1n010565
	for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 10:00:58 +0200
Received: from [139.25.3.102] (marco-laptop.mchp.siemens.de [139.25.3.102] (may be forged))
	by mail3.siemens.de (8.12.11.20060308/8.12.11) with ESMTP id o2U80vLj004713
	for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 10:00:57 +0200
Message-ID: <4BB1AF90.3050104@siemens.com>
Date: Tue, 30 Mar 2010 10:00:16 +0200
From: Marco Porsch <marco.porsch@siemens.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] nl80211: reenable station del for mesh
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iw dev <devname> station del <MAC address> is quiet useful in mesh mode and should be possible.

Signed-off-by: Marco Porsch <marco.porsch@siemens.com>
---
net/wireless/nl80211.c |  3 ++-
1 files changed, 2 insertions(+), 1 deletions(-)

--- a/net/wireless/nl80211.c	2010-03-29 16:05:15.000000000 +0200
+++ b/net/wireless/nl80211.c	2010-03-29 17:10:29.000000000 +0200
@@ -2105,7 +2105,8 @@ static int nl80211_del_station(struct sk
 		goto out_rtnl;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-		dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN) {
+		dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+		dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
 		err = -EINVAL;
 		goto out;
 	}

