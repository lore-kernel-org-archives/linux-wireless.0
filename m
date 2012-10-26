Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268Ab2JZOXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:23:53 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 02/18] brcmsmac: Use correct descriptor count when calculating next rx descriptor
Date: Fri, 26 Oct 2012 09:23:17 -0500
Message-Id: <1351261413-20821-3-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162359_141259_430E1942)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nextrxd() is calling txd(), which means that the tx descriptor count is
used to determine when to wrap for determining the next ring buffer
entry. This has worked so far since the driver has been using the same
number of rx and tx descriptors, but it's obviously going to be a
problem if different numbers of descriptors are used.

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

