Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:53771 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808AbbELVzC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 17:55:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Brett Rudley <brudley@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH] brcmfmac: avoid gcc-5.1 warning
Date: Tue, 12 May 2015 23:54:25 +0200
Message-ID: <2201884.BixNBcLJhn@wuerfel> (sfid-20150512_235511_719637_BF90E75E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc-5.0 gained a new warning in the fwsignal portion of the brcmfmac
driver:

drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c: In function 'brcmf_fws_txs_process':
drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c:1478:8: warning: 'skb' may be used uninitialized in this function [-Wmaybe-uninitialized]

This is a false positive, and marking the brcmf_fws_hanger_poppkt function
as 'static inline' makes the warning go away. I have checked the object
file output and while a little code gets moved around, the size of
the binary remains identical.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Found while building the ARM imx_v6_v7_defconfig configuration with gcc-5.
We try to get all ARM defconfigs to build without warnings normally.

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index f0dda0ecd23b..5017eaa4af45 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -635,7 +635,7 @@ static int brcmf_fws_hanger_pushpkt(struct brcmf_fws_hanger *h,
 	return 0;
 }
 
-static int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
+static inline int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
 					  u32 slot_id, struct sk_buff **pktout,
 					  bool remove_item)
 {

