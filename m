Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2571 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab3ABOXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:14 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/18] brcmfmac: remove unused event related definitions
Date: Wed, 2 Jan 2013 15:22:45 +0100
Message-ID: <1357136572-18273-13-git-send-email-arend@broadcom.com> (sfid-20130102_155322_135291_312A6E66)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver had some global definitions in dhd.h to map event
identifiers to event names. With redesign of firmware event
processing this has all moved to fweh module so these definitions
can be removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 4937bf4..0388599 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -520,11 +520,6 @@ struct brcmf_pub {
 #endif
 };
 
-struct bcmevent_name {
-	uint event;
-	const char *name;
-};
-
 struct brcmf_if_event {
 	u8 ifidx;
 	u8 action;
@@ -564,8 +559,6 @@ static inline s32 brcmf_ndev_bssidx(struct net_device *ndev)
 	return ifp->bssidx;
 }
 
-extern const struct bcmevent_name bcmevent_names[];
-
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
 /* Return pointer to interface name */
-- 
1.7.10.4


