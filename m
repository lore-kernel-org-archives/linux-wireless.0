Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3006 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423097AbXDXUwA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2007 16:52:00 -0400
Date: Tue, 24 Apr 2007 16:20:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'for-jgarzik' branch of wireless-2.6.git
Message-ID: <20070424202040.GG22681@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff, this should fix the build issue you are now seeing in
netdev-2.6#upstream -- sorry I wasn't quicker!

---

The following changes since commit cd6a413099e67ee25b1af0b542d4877d90958474:
  John W. Linville (1):
        Merge branch 'from-linus' into upstream

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git for-jgarzik

Larry Finger (1):
      ieee80211: add missing global needed by IEEE80211_DEBUG_XXXX

 net/ieee80211/ieee80211_module.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ieee80211/ieee80211_module.c b/net/ieee80211/ieee80211_module.c
index 7630434..7ec6610 100644
--- a/net/ieee80211/ieee80211_module.c
+++ b/net/ieee80211/ieee80211_module.c
@@ -229,6 +229,7 @@ void free_ieee80211(struct net_device *dev)
 
 static int debug = 0;
 u32 ieee80211_debug_level = 0;
+EXPORT_SYMBOL_GPL(ieee80211_debug_level);
 static struct proc_dir_entry *ieee80211_proc = NULL;
 
 static int show_debug_level(char *page, char **start, off_t offset,
-- 
John W. Linville
linville@tuxdriver.com
