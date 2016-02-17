Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:10090
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161102AbcBQK1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:25 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/21] brcmfmac: check return for ARP ip setting iovar
Date: Wed, 17 Feb 2016 11:26:56 +0100
Message-Id: <1455704830-10088-8-git-send-email-arend@broadcom.com> (sfid-20160217_112743_077507_E4031138)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

The return value of iovar set function should be saved and checked.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 9507cc9..dcf9393 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1039,14 +1039,14 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 				return NOTIFY_OK;
 			}
 			for (i = 0; i < ARPOL_MAX_ENTRIES; i++) {
-				if (addr_table[i] != 0) {
-					brcmf_fil_iovar_data_set(ifp,
-						"arp_hostip", &addr_table[i],
-						sizeof(addr_table[i]));
-					if (ret)
-						brcmf_err("add arp ip err %d\n",
-							  ret);
-				}
+				if (addr_table[i] == 0)
+					continue;
+				ret = brcmf_fil_iovar_data_set(ifp, "arp_hostip",
+							       &addr_table[i],
+							       sizeof(addr_table[i]));
+				if (ret)
+					brcmf_err("add arp ip err %d\n",
+						  ret);
 			}
 		}
 		break;
-- 
1.9.1

