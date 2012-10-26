Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290Ab2JZOXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:23:55 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 03/18] brcmsmac: Reduce number of entries in tx DMA rings
Date: Fri, 26 Oct 2012 09:23:18 -0500
Message-Id: <1351261413-20821-4-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162400_714407_BA0D1FB8)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently up to 256 frames can be queued for each DMA ring. This is
excessive, and now that we have better flow control we can get by with
less. Experimentation has shown 64 to work well.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 2dd0e4f..9b6b1e7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -238,8 +238,8 @@
 
 #define MAX_DMA_SEGS			4
 
-/* Max # of entries in Tx FIFO based on 4kb page size */
-#define NTXD				256
+/* # of entries in Tx FIFO */
+#define NTXD				64
 /* Max # of entries in Rx FIFO based on 4kb page size */
 #define NRXD				256
 
-- 
1.7.9.5

