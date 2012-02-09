Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3973 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867Ab2BIUJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/15] brcm80211: fmac: use spinlock calls saving irq
 flags in brcmf_enq_event()
Date: Thu, 9 Feb 2012 21:09:07 +0100
Message-ID: <1328818149-4826-14-git-send-email-arend@broadcom.com> (sfid-20120209_210958_701826_59C91D06)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is executed within irq context. The call spin_unlock_irq
does enable interrupts which is not desired in the irq context. This patch
replaces them using the spin_loc_irqsave and spin_unlock_irqrestore
functions.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Kan Yan <kanyan@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 285fa19..15d7f00 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3308,6 +3308,7 @@ brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
 {
 	struct brcmf_cfg80211_event_q *e;
 	s32 err = 0;
+	ulong flags;
 
 	e = kzalloc(sizeof(struct brcmf_cfg80211_event_q), GFP_ATOMIC);
 	if (!e)
@@ -3316,9 +3317,9 @@ brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
 	e->etype = event;
 	memcpy(&e->emsg, msg, sizeof(struct brcmf_event_msg));
 
-	spin_lock_irq(&cfg_priv->evt_q_lock);
+	spin_lock_irqsave(&cfg_priv->evt_q_lock, flags);
 	list_add_tail(&e->evt_q_list, &cfg_priv->evt_q_list);
-	spin_unlock_irq(&cfg_priv->evt_q_lock);
+	spin_unlock_irqrestore(&cfg_priv->evt_q_lock, flags);
 
 	return err;
 }
-- 
1.7.5.4


