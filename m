Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:48923 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1GHA1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 20:27:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix minor issue in debugfs command 'info'
Date: Thu,  7 Jul 2011 17:33:20 -0700
Message-Id: <1310085200-18865-2-git-send-email-bzhao@marvell.com> (sfid-20110708_022756_966139_38E01385)
In-Reply-To: <1310085200-18865-1-git-send-email-bzhao@marvell.com>
References: <1310085200-18865-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Debugfs command 'info' shows wrong interface type. The regression
occurred due to commit eecd8250e (mwifiex: remove MWIFIEX_BSS_MODE_
macros) in which we replaced MWIFIEX_BSS_MODE_* macros by
NL80211_IFTYPE_*, for example,

MWIFIEX_BSS_MODE_IBSS (2) --> NL80211_IFTYPE_ADHOC (1)

The issue is fixed by swapping static character array used to
display interface type information.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 46d65e0..1bcf9ea 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -27,8 +27,8 @@ static struct dentry *mwifiex_dfs_dir;
 
 static char *bss_modes[] = {
 	"Unknown",
-	"Managed",
 	"Ad-hoc",
+	"Managed",
 	"Auto"
 };
 
-- 
1.7.0.2

