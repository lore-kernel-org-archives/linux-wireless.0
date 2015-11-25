Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34115 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbbKYN7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 08:59:35 -0500
Received: by wmvv187 with SMTP id v187so258364103wmv.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2015 05:59:34 -0800 (PST)
From: Sven Eckelmann <sven@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Julian Calaby <julian.calaby@gmail.com>,
	Sven Eckelmann <sven@open-mesh.com>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH v3 4/4] iw: print NOHT always as last in usage texts
Date: Wed, 25 Nov 2015 14:59:18 +0100
Message-Id: <1448459959-23641-4-git-send-email-sven@open-mesh.com> (sfid-20151125_145938_478165_095C8225)
In-Reply-To: <1448459959-23641-1-git-send-email-sven@open-mesh.com>
References: <1448459959-23641-1-git-send-email-sven@open-mesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
v3:
 * split patch into two different patches (0001/0002) as request by
   Julian Calaby <julian.calaby@gmail.com>
 * change join_ocb to also use get_cf1
 * move NOHT to the last entry in the mesh/ibss join usage texts as
   requested by Julian Calaby <julian.calaby@gmail.com>
v2:
 * rebase from v4.3-ish version to current master

 ibss.c | 2 +-
 mesh.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ibss.c b/ibss.c
index a761794..58c3bcd 100644
--- a/ibss.c
+++ b/ibss.c
@@ -192,7 +192,7 @@ COMMAND(ibss, leave, NULL,
 	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
 	"Leave the current IBSS cell.");
 COMMAND(ibss, join,
-	"<SSID> <freq in MHz> [HT20|HT40+|HT40-|NOHT|5MHz|10MHz|80MHz] [fixed-freq] [<fixed bssid>] [beacon-interval <TU>]"
+	"<SSID> <freq in MHz> [HT20|HT40+|HT40-|5MHz|10MHz|80MHz|NOHT] [fixed-freq] [<fixed bssid>] [beacon-interval <TU>]"
 	" [basic-rates <rate in Mbps,rate2,...>] [mcast-rate <rate in Mbps>] "
 	"[key d:0:abcde]",
 	NL80211_CMD_JOIN_IBSS, 0, CIB_NETDEV, join_ibss,
diff --git a/mesh.c b/mesh.c
index d674d61..76b9fa8 100644
--- a/mesh.c
+++ b/mesh.c
@@ -608,7 +608,7 @@ static int join_mesh(struct nl80211_state *state,
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(mesh, join, "<mesh ID> [[freq <freq in MHz> <HT20|HT40+|HT40-|NOHT|80MHz>]"
+COMMAND(mesh, join, "<mesh ID> [[freq <freq in MHz> <HT20|HT40+|HT40-|80MHz|NOHT>]"
 	" [basic-rates <rate in Mbps,rate2,...>]], [mcast-rate <rate in Mbps>]"
 	" [beacon-interval <time in TUs>] [dtim-period <value>]"
 	" [vendor_sync on|off] [<param>=<value>]*",
-- 
2.6.2

