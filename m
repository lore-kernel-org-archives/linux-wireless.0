Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39215 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab1KKSpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 13:45:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] brcmsmac: fix warning in _initvars_srom_pci
Date: Fri, 11 Nov 2011 13:31:32 -0500
Message-Id: <1321036292-32218-1-git-send-email-linville@tuxdriver.com> (sfid-20111111_194525_741560_FECA83A9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/srom.o
drivers/net/wireless/brcm80211/brcmsmac/srom.c: In function ‘_initvars_srom_pci’:
drivers/net/wireless/brcm80211/brcmsmac/srom.c:641:6: warning: ‘val’ may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/srom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.c b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
index 3a9b81d..b6987ea 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
@@ -638,7 +638,7 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, struct list_head *var_list)
 	struct brcms_srom_list_head *entry;
 	enum brcms_srom_id id;
 	u16 w;
-	u32 val;
+	u32 val = 0;
 	const struct brcms_sromvar *srv;
 	uint width;
 	uint flags;
-- 
1.7.4.4

