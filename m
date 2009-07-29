Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbZG2UIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 16:08:17 -0400
Subject: [PATCH 2.6.31] cfg80211: add two missing NULL pointer checks
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 22:07:44 +0200
Message-Id: <1248898064.16728.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These pointers can be NULL, the is_mesh() case isn't
ever hit in the current kernel, but cmp_ies() can be
hit under certain conditions.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org [2.6.29, 2.6.30]
---
 net/wireless/scan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/scan.c	2009-07-29 21:53:49.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-07-29 21:57:27.000000000 +0200
@@ -141,7 +141,7 @@ static int cmp_ies(u8 num, u8 *ies1, siz
 
 	if (!ie1 && !ie2)
 		return 0;
-	if (!ie1)
+	if (!ie1 || !ie2)
 		return -1;
 
 	r = memcmp(ie1 + 2, ie2 + 2, min(ie1[1], ie2[1]));
@@ -194,6 +194,8 @@ static bool is_mesh(struct cfg80211_bss 
 	ie = find_ie(WLAN_EID_MESH_CONFIG,
 		     a->information_elements,
 		     a->len_information_elements);
+	if (!ie)
+		return false;
 	if (ie[1] != IEEE80211_MESH_CONFIG_LEN)
 		return false;
 


