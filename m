Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.uludag.org.tr ([193.140.100.220]:49925 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753256AbYBNPjO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:14 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 09/14] net/mac80211/: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:47 +0200
Message-Id: <1203003412-11594-10-git-send-email-caglar@pardus.org.tr> (sfid-20080214_153925_376134_BACA57E7)
In-Reply-To: y
References: y
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions time_before, time_before_eq, time_after, and time_after_e=
q are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined =
at linux/jiffies.h, which deals with wrapping correctly

Cc: linux-wireless@vger.kernel.org
Signed-off-by: S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
---
 net/mac80211/rc80211_simple.c |    3 ++-
 net/mac80211/rx.c             |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_simple.c b/net/mac80211/rc80211_simpl=
e.c
index 9a78b11..91bbff1 100644
--- a/net/mac80211/rc80211_simple.c
+++ b/net/mac80211/rc80211_simple.c
@@ -7,6 +7,7 @@
  * published by the Free Software Foundation.
  */
=20
+#include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/types.h>
@@ -177,7 +178,7 @@ static void rate_control_simple_tx_status(void *pri=
v, struct net_device *dev,
 		rate_control_rate_dec(local, sta);
 	}
=20
-	if (srctrl->avg_rate_update + 60 * HZ < jiffies) {
+	if (time_after(jiffies, srctrl->avg_rate_update + 60 * HZ)) {
 		srctrl->avg_rate_update =3D jiffies;
 		if (srctrl->tx_avg_rate_num > 0) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 535407d..592581a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
=20
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
@@ -801,7 +802,7 @@ ieee80211_reassemble_find(struct ieee80211_sub_if_d=
ata *sdata,
 		    compare_ether_addr(hdr->addr2, f_hdr->addr2) !=3D 0)
 			continue;
=20
-		if (entry->first_frag_time + 2 * HZ < jiffies) {
+		if (time_after(jiffies, entry->first_frag_time + 2 * HZ)) {
 			__skb_queue_purge(&entry->skb_list);
 			continue;
 		}
--=20
1.5.3.7

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
