Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3069 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab2ISUVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/13] brcmsmac: don't start device when RfKill is
 engaged
Date: Wed, 19 Sep 2012 22:21:15 +0200
Message-ID: <1348086078-19183-11-git-send-email-arend@broadcom.com> (sfid-20120919_222143_991595_2C4731DE)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

This patch fixes a bug when device is being started
while RfKill switch is engaged, leading to hang
due to partial initialization of hardware.

Tested-by: <dragonn@op.pl>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 718da8d..a744ea5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -304,7 +304,10 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
 	wl->mute_tx = true;
 
 	if (!wl->pub->up)
-		err = brcms_up(wl);
+		if (!blocked)
+			err = brcms_up(wl);
+		else
+			err = -ERFKILL;
 	else
 		err = -ENODEV;
 	spin_unlock_bh(&wl->lock);
-- 
1.7.9.5


