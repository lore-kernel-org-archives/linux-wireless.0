Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:42534 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755820AbeARNbx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 08:31:53 -0500
From: =?UTF-8?q?Christopher=20D=C3=ADaz=20Riveros?= <chrisadr@gentoo.org>
To: johannes@sipsolutions.net, davem@davemloft.net
Cc: =?UTF-8?q?Christopher=20D=C3=ADaz=20Riveros?= <chrisadr@gentoo.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH-next] mac80211: Remove unneeded semicolons
Date: Thu, 18 Jan 2018 08:31:05 -0500
Message-Id: <20180118133105.26432-1-chrisadr@gentoo.org> (sfid-20180118_143156_729962_5E84D29B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trivial fix removes unneeded semicolons after switch blocks.

This issue was detected by using the Coccinelle software.

Signed-off-by: Christopher Díaz Riveros <chrisadr@gentoo.org>
---
 net/mac80211/debugfs_sta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index b15412c21ac9..444ea8d127fe 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -420,7 +420,7 @@ static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
 		default:
 			p += scnprintf(p, sizeof(buf) + buf - p,
 				       "\t\tMAX-MPDU-UNKNOWN\n");
-		};
+		}
 		switch (vhtc->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) {
 		case 0:
 			p += scnprintf(p, sizeof(buf) + buf - p,
@@ -438,7 +438,7 @@ static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
 			p += scnprintf(p, sizeof(buf) + buf - p,
 				       "\t\tUNKNOWN-MHZ: 0x%x\n",
 				       (vhtc->cap >> 2) & 0x3);
-		};
+		}
 		PFLAG(RXLDPC, "RXLDPC");
 		PFLAG(SHORT_GI_80, "SHORT-GI-80");
 		PFLAG(SHORT_GI_160, "SHORT-GI-160");
-- 
2.15.1
