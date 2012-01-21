Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39170 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab2AUNns (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 08:43:48 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: rename path_lookup
Date: Sat, 21 Jan 2012 14:43:36 +0100
Message-Id: <1327153416-27834-3-git-send-email-hauke@hauke-m.de> (sfid-20120121_144354_095806_AA598697)
In-Reply-To: <1327153416-27834-1-git-send-email-hauke@hauke-m.de>
References: <1327153416-27834-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

path_lookup in net/mac80211/mesh_pathtbl.c consolidates with
path_lookup in include/linux/namei.h used in old kernel versions.

This should also go into compat-wireless-stable-3.3.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/49-rename_path_lookup.patch |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 patches/49-rename_path_lookup.patch

diff --git a/patches/49-rename_path_lookup.patch b/patches/49-rename_path_lookup.patch
new file mode 100644
index 0000000..a5c69c6
--- /dev/null
+++ b/patches/49-rename_path_lookup.patch
@@ -0,0 +1,14 @@
+path_lookup in net/mac80211/mesh_pathtbl.c consolidates with 
+path_lookup in include/linux/namei.h used in old kernel versions.
+
+--- a/net/mac80211/mesh_pathtbl.c
++++ b/net/mac80211/mesh_pathtbl.c
+@@ -18,6 +18,8 @@
+ #include "ieee80211_i.h"
+ #include "mesh.h"
+ 
++#define path_lookup general_path_lookup
++
+ #ifdef CONFIG_MAC80211_VERBOSE_MPATH_DEBUG
+ #define mpath_dbg(fmt, args...)	printk(KERN_DEBUG fmt, ##args)
+ #else
-- 
1.7.5.4

