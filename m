Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:9049 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaI3IXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 04:23:24 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/6] brcmfmac: assure P2P discovery is disabled when setting P2P_DEVICE mac address
Date: Tue, 30 Sep 2014 10:23:16 +0200
Message-ID: <1412065398-14316-5-git-send-email-arend@broadcom.com> (sfid-20140930_102339_633270_409DB5EC)
In-Reply-To: <1412065398-14316-1-git-send-email-arend@broadcom.com>
References: <1412065398-14316-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to provision the P2P_DEVICE mac address using p2p_da_override iovar
the discovery interface must be disabled. On some targets setting the mac
address failed so disable the discovery interface to be certain.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 1d78a91..d54c58a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -440,8 +440,11 @@ static int brcmf_p2p_set_firmware(struct brcmf_if *ifp, u8 *p2p_mac)
 
 	/* In case of COB type, firmware has default mac address
 	 * After Initializing firmware, we have to set current mac address to
-	 * firmware for P2P device address
+	 * firmware for P2P device address. This must be done with discovery
+	 * disabled.
 	 */
+	brcmf_fil_iovar_int_set(ifp, "p2p_disc", 0);
+
 	ret = brcmf_fil_iovar_data_set(ifp, "p2p_da_override", p2p_mac,
 				       ETH_ALEN);
 	if (ret)
-- 
1.9.1

