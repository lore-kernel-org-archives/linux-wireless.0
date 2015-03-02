Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:42713 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbbCBJ6z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 04:58:55 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 2/2] mesh_plink: fixup type of timeout to match usage
Date: Mon,  2 Mar 2015 04:54:14 -0500
Message-Id: <1425290054-26631-2-git-send-email-hofrat@osadl.org> (sfid-20150302_105920_255328_BB501938)
In-Reply-To: <1425290054-26631-1-git-send-email-hofrat@osadl.org>
References: <1425290054-26631-1-git-send-email-hofrat@osadl.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

timeout was being passed as int but assigned from u32/u16 values and used 
as unsigned type. This is really only for better readability.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

After review of the use locations of mesh_plink_timer_set() and declarations 
in sta_info.h this should not be breaking any integer promotions.

This patch applies on top of 
"[PATCH 1/2] mesh_plink: use msecs_to_jiffies for proper time conversion"

Patch was only compile tested with x86_64_defconfig + CONFIG_MAC80211_MESH=y

Patch is against 4.0-rc1 (localversion-next is -next-20150302)

 net/mac80211/mesh_plink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4eefd5d..8465c05 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -621,7 +621,7 @@ static void mesh_plink_timer(unsigned long data)
 				    sta->llid, sta->plid, reason);
 }
 
-static inline void mesh_plink_timer_set(struct sta_info *sta, int timeout)
+static inline void mesh_plink_timer_set(struct sta_info *sta, u32 timeout)
 {
 	sta->plink_timer.expires = jiffies + msecs_to_jiffies(timeout);
 	sta->plink_timer.data = (unsigned long) sta;
-- 
1.7.10.4

