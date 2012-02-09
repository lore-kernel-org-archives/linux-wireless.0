Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4419 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867Ab2BIUJa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:30 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/15] brcm80211: fmac: change allocation flag in
 brcmf_enq_event() function
Date: Thu, 9 Feb 2012 21:09:06 +0100
Message-ID: <1328818149-4826-13-git-send-email-arend@broadcom.com> (sfid-20120209_210951_887449_A55D0592)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the function is called from atomic context it should not do the
kzalloc call with GFP_KERNEL.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Kan Yan <kanyan@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index e95a883..285fa19 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3297,7 +3297,9 @@ static struct brcmf_cfg80211_event_q *brcmf_deq_event(
 }
 
 /*
-** push event to tail of the queue
+*	push event to tail of the queue
+*
+*	remark: this function may not sleep as it is called in atomic context.
 */
 
 static s32
@@ -3307,7 +3309,7 @@ brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
 	struct brcmf_cfg80211_event_q *e;
 	s32 err = 0;
 
-	e = kzalloc(sizeof(struct brcmf_cfg80211_event_q), GFP_KERNEL);
+	e = kzalloc(sizeof(struct brcmf_cfg80211_event_q), GFP_ATOMIC);
 	if (!e)
 		return -ENOMEM;
 
-- 
1.7.5.4


