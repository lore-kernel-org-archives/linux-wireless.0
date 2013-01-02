Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4241 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab3ABOXD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:03 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/18] brcmsmac: use perimeter lock in add_interface()
 callback
Date: Wed, 2 Jan 2013 15:22:35 +0100
Message-ID: <1357136572-18273-3-git-send-email-arend@broadcom.com> (sfid-20130102_152306_747364_40728900)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All callbacks that access driver functions should do that under
perimeter lock protection. The add_interface() callback was lacking
this lock.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 0f71d1d..9d1b26d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -362,8 +362,10 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		return -EOPNOTSUPP;
 	}
 
+	spin_lock_bh(&wl->lock);
 	wl->mute_tx = false;
 	brcms_c_mute(wl->wlc, false);
+	spin_unlock_bh(&wl->lock);
 
 	return 0;
 }
-- 
1.7.10.4


