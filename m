Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58766 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3BVNcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 08:32:22 -0500
Received: by mail-bk0-f52.google.com with SMTP id jk13so291450bkc.11
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2013 05:32:21 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 22 Feb 2013 21:32:20 +0800
Message-ID: <CAPgLHd8kCr1-vGNzpf5wb36bYaHYd3=x5oSC_xeBcRb7DANB1w@mail.gmail.com> (sfid-20130222_143228_191141_519CF8ED)
Subject: [PATCH -next] brcmfmac: fix missing unlock on error in brcmf_notify_vif_event()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: brudley@broadcom.com, arend@broadcom.com, meuleman@broadcom.com,
	linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function brcmf_notify_vif_event()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
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


