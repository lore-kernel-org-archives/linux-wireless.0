Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58878 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767951Ab2KOOIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:30 -0500
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
Subject: [PATCH v2 07/22] brcmsmac: Use correct descriptor count when calculating next rx descriptor
Date: Thu, 15 Nov 2012 08:07:57 -0600
Message-Id: <1352988492-21340-8-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150840_795833_3922540B)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nextrxd() is calling txd(), which means that the tx descriptor count is
used to determine when to wrap for determining the next ring buffer
entry. This has worked so far since the driver has been using the same
number of rx and tx descriptors, but it's obviously going to be a
problem if different numbers of descriptors are used.

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 426b9a9..d7ce1ac 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -361,7 +361,7 @@ static uint prevtxd(struct dma_info *di, uint i)
 
 static uint nextrxd(struct dma_info *di, uint i)
 {
-	return txd(di, i + 1);
+	return rxd(di, i + 1);
 }
 
 static uint ntxdactive(struct dma_info *di, uint h, uint t)
-- 
1.7.9.5

