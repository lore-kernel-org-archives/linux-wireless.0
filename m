Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51674 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbYCMSGQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 14:06:16 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: Tkip fix sparse endianity complain in tkip code
Date: Thu, 13 Mar 2008 20:05:53 +0200
Message-Id: <1205431553-20567-1-git-send-email-tomas.winkler@intel.com> (sfid-20080313_180623_712651_6B75C784)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix wrong cast in tkip code

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/tkip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index f61f1dd..0ce2a84 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -118,7 +118,7 @@ static u8 *set_ext_iv(u8 *pos, u16 iv16)
 
 static u8 *set_tkip_iv(u8 *pos, u32 iv32)
 {
-	*((u32 *)pos) = cpu_to_le32(iv32);
+	*((__le32 *)pos) = cpu_to_le32(iv32);
 	return pos + 4;
 }
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

