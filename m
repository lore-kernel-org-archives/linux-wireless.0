Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:39216 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457Ab3BYBTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 20:19:49 -0500
Received: by mail-bk0-f54.google.com with SMTP id w5so1045647bku.41
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2013 17:19:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5127778F.8070005@broadcom.com>
References: <CAPgLHd8kCr1-vGNzpf5wb36bYaHYd3=x5oSC_xeBcRb7DANB1w@mail.gmail.com>
	<5127778F.8070005@broadcom.com>
Date: Mon, 25 Feb 2013 09:19:47 +0800
Message-ID: <CAPgLHd8h-8Lnmmit7pm=RnSBnnUUjMfR_x8qKq7p4vnPu7+T1w@mail.gmail.com> (sfid-20130225_021952_875279_D51E6470)
Subject: [PATCH -next v2] brcmfmac: fix missing unlock on error in brcmf_notify_vif_event()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: arend@broadcom.com
Cc: brudley@broadcom.com, meuleman@broadcom.com,
	linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function brcmf_notify_vif_event()
in the error handling case.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Arend van Spriel <arend@broadcom.com>
---
v1 -> v2: add Reported-by and Acked-by
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index cecc3ef..2af9c0f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4615,8 +4615,10 @@ static s32 brcmf_notify_vif_event(struct brcmf_if *ifp,
 	switch (ifevent->action) {
 	case BRCMF_E_IF_ADD:
 		/* waiting process may have timed out */
-		if (!cfg->vif_event.vif)
+		if (!cfg->vif_event.vif) {
+			mutex_unlock(&event->vif_event_lock);
 			return -EBADF;
+		}
 
 		ifp->vif = vif;
 		vif->ifp = ifp;






