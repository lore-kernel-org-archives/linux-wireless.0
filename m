Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58886 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767951Ab2KOOIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:32 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 08/22] brcmsmac: Reduce number of entries in tx DMA rings
Date: Thu, 15 Nov 2012 08:07:58 -0600
Message-Id: <1352988492-21340-9-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150841_507287_BE035CB6)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
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
index 2b8987c..ca93214 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -232,8 +232,8 @@
 
 #define MAX_DMA_SEGS			4
 
-/* Max # of entries in Tx FIFO based on 4kb page size */
-#define NTXD				256
+/* # of entries in Tx FIFO */
+#define NTXD				64
 /* Max # of entries in Rx FIFO based on 4kb page size */
 #define NRXD				256
 
-- 
1.7.9.5

