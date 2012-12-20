Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:46646 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592Ab2LTMno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 07:43:44 -0500
Message-ID: <50D307FD.9010508@posedge.com> (sfid-20121220_134347_822750_3A567BF2)
Date: Thu, 20 Dec 2012 18:13:41 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: Fix MAX MTU Calculation
References: <201212201236.qBKCakFZ011657@chaitanya-desktop>
In-Reply-To: <201212201236.qBKCakFZ011657@chaitanya-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the MTU calculation, we should check for data_len+ mesh hdr len
and shouldn't include any header lengths.

ToDo: Get the MAX_DATA_LEN based on driver's AMSDU capability.

Signed-off-by: T Krishna Chaitanya <chaitanyatk@posedge.com>

---

 net/mac80211/iface.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 54fb7f9..da74ef9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -214,8 +214,23 @@ static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 
 	/* FIX: what would be proper limits for MTU?
 	 * This interface uses 802.3 frames. */
+	/* Fixed: MTU needn't worry about headers*/
+
+	/* 802.11-2012: 8.2.3: The maximum frame body size is determined by
+	1. The maximum MSDU size (2304 octets),
+	2. plus the length of the Mesh Control field (6, 12, or 18 octets)
+		if present,
+	3. the maximum unencrypted MMPDU size excluding the MAC header and
+		FCS (2304 octets) or
+	4. the maximum A- MSDU size (3839 or 7935 octets),
+		plus any overhead from security encapsulation.
+	Note1: IEEE80211_MAX_DATA_LEN doesnt include any headers (2304),
+		so it can be used directly+ Mesh HDR Len
+	Note2: In Other places (like skb_alloc) its handled properly.
+	 */
+
 	if (new_mtu < 256 ||
-	    new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
+	    new_mtu > IEEE80211_MAX_DATA_LEN + meshhdrlen) {
 		return -EINVAL;
 	}
 




