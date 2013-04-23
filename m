Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3456 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab3DWKzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 06:55:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/5] brcmfmac: flush queue upon MACDESC_DEL firmware
 signal
Date: Tue, 23 Apr 2013 12:53:13 +0200
Message-ID: <1366714395-13416-4-git-send-email-arend@broadcom.com> (sfid-20130423_125518_502131_9DD25349)
In-Reply-To: <1366714395-13416-1-git-send-email-arend@broadcom.com>
References: <1366714395-13416-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When firmware signals the driver to remove a destination entry
it may have sk_buff packets queued for it. These should be freed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 66cdc45..b0591e3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -871,9 +871,10 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 	entry = &fws->desc.nodes[mac_handle & 0x1F];
 	if (type == BRCMF_FWS_TYPE_MACDESC_DEL) {
 		brcmf_dbg(TRACE, "deleting mac %pM idx %d\n", addr, ifidx);
-		if (entry->occupied)
+		if (entry->occupied) {
+			brcmf_fws_mac_desc_cleanup(fws, entry, -1);
 			brcmf_fws_clear_mac_descriptor(entry);
-		else
+		} else
 			fws->stats.mac_update_failed++;
 		return 0;
 	}
-- 
1.7.10.4


