Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:35257 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab0AaAzX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 19:55:23 -0500
Subject: [PATCH 1/2] mac80211: reduce stack usage in sta_ht_capa_read()
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Sat, 30 Jan 2010 19:55:09 -0500
Message-ID: <20100131005509.22303.74752.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The maximal size of the "ht_capa" file is 430 bytes.  In most cases,
it's much shorter.  Use a 512 byte long buffer.  1024 bytes is too much
and causes a warning with CONFIG_FRAME_WARN=1024.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 net/mac80211/debugfs_sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 0d4a759..84865e7 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -165,7 +165,7 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 	if (_cond) \
 			p += scnprintf(p, sizeof(buf)+buf-p, "\t" _str "\n"); \
 	} while (0)
-	char buf[1024], *p = buf;
+	char buf[512], *p = buf;
 	int i;
 	struct sta_info *sta = file->private_data;
 	struct ieee80211_sta_ht_cap *htc = &sta->sta.ht_cap;
