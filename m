Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:56759 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaGJITD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 04:19:03 -0400
Received: by mail-lb0-f179.google.com with SMTP id z11so5833757lbi.10
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 01:19:02 -0700 (PDT)
From: Tom Gundersen <teg@jklm.no>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
	David Herrmann <dh.herrmann@gmail.com>,
	Kay Sievers <kay@vrfy.org>, Tom Gundersen <teg@jklm.no>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: [PATCH v7 29/33] net: brcmfmac - set name assign type
Date: Thu, 10 Jul 2014 10:17:34 +0200
Message-Id: <1404980258-30853-30-git-send-email-teg@jklm.no> (sfid-20140710_102102_536559_71959EFD)
In-Reply-To: <1404980258-30853-1-git-send-email-teg@jklm.no>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The name is given by the firmware, so we assume it is predictable.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>
Cc: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list@broadcom.com
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index f6990f2..8d32721 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -201,7 +201,8 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		brcmf_dbg(EVENT, "adding %s (%pM)\n", emsg->ifname,
 			  emsg->addr);
 		ifp = brcmf_add_if(drvr, ifevent->bssidx, ifevent->ifidx,
-				   emsg->ifname, NET_NAME_UNKNOWN, emsg->addr);
+				   emsg->ifname, NET_NAME_PREDICTABLE,
+				   emsg->addr);
 		if (IS_ERR(ifp))
 			return;
 		brcmf_fws_add_interface(ifp);
-- 
1.9.3

