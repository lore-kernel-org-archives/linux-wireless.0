Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36754 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbbLQPAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 10:00:53 -0500
From: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>
To: johannes@sipsolutions.net, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>
Subject: [PATCH 1/1] mac80211: improve the contiguous mask checking
Date: Thu, 17 Dec 2015 22:59:52 +0800
Message-Id: <1450364392-76874-1-git-send-email-zhaoxiu.zeng@gmail.com> (sfid-20151217_160115_385859_67B4B1F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the result of adding the first set bit to the mask is power of 2,
the mask must be contiguous. "mask & -mask" can get the first set bit
of mask gracefully.

Signed-off-by: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>
---
 net/mac80211/iface.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c9e325d..4c896e8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1628,7 +1628,9 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
 			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
 
-		if (__ffs64(mask) + hweight64(mask) != fls64(mask)) {
+		inc = (mask & -mask);
+		val = mask + inc;
+		if ((val & (val - 1)) != 0) {
 			/* not a contiguous mask ... not handled now! */
 			pr_info("not contiguous\n");
 			break;
@@ -1649,7 +1651,6 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
 			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
 
-		inc = 1ULL<<__ffs64(mask);
 		val = (start & mask);
 		addr = (start & ~mask) | (val & mask);
 		do {
-- 
2.5.0

