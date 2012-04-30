Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64951 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab2D3Gy7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 02:54:59 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] cfg80211: fix BSS comparison
Date: Mon, 30 Apr 2012 09:53:46 +0300
Message-Id: <1335768826-12529-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20120430_085503_426561_40869931)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the BSS table is organized in a RB tree, the BSSs need to be
comparable. This means that we must define a < and > operator to
the BSS object.
compare_ethr_addr isn't enough since it returns only a binary value.

Since Felix's

cfg80211: use compare_ether_addr on MAC addresses instead of memcmp

    Because of the constant size and guaranteed 16 bit alignment, the inline
    compare_ether_addr function is much cheaper than calling memcmp.

    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

The BSS table is corrupted: rb_find_bss can't find the bss.
As a result BSSes are duplicated in the BSS table, and we get stuck
while probing an AP before associating (in STA mode).

CC: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
Since this patch fixes a very annoying issue I send it upstream directly
---
 net/wireless/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index bd6a0ee..8c8b550 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -378,7 +378,7 @@ static int cmp_bss_core(struct cfg80211_bss *a,
 			       b->len_information_elements);
 	}
 
-	return compare_ether_addr(a->bssid, b->bssid);
+	return memcmp(a->bssid, b->bssid, sizeof(a->bssid));
 }
 
 static int cmp_bss(struct cfg80211_bss *a,
-- 
1.7.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

