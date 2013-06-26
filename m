Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1760 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab3FZMUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 08:20:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 7/9] brcmfmac: cleanup debug messages in
 brcmf_fws_hdrpush()
Date: Wed, 26 Jun 2013 14:20:20 +0200
Message-ID: <1372249222-4858-8-git-send-email-arend@broadcom.com> (sfid-20130626_142044_434174_66C52E26)
In-Reply-To: <1372249222-4858-1-git-send-email-arend@broadcom.com>
References: <1372249222-4858-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trivial cleanup of debug messages.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 2b078a1..9c6d182 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -796,9 +796,8 @@ static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
 	u8 fillers;
 	__le32 pkttag = cpu_to_le32(brcmf_skbcb(skb)->htod);
 
-	brcmf_dbg(TRACE, "enter: ea=%pM, ifidx=%u (%u), pkttag=0x%08X, hslot=%d\n",
-		  entry->ea, entry->interface_id,
-		  brcmf_skb_if_flags_get_field(skb, INDEX),
+	brcmf_dbg(TRACE, "enter: %s, idx=%d pkttag=0x%08X, hslot=%d\n",
+		  entry->name, brcmf_skb_if_flags_get_field(skb, INDEX),
 		  le32_to_cpu(pkttag), (le32_to_cpu(pkttag) >> 8) & 0xffff);
 	if (entry->send_tim_signal)
 		data_offset += 2 + BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
@@ -822,8 +821,8 @@ static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
 		wlh[1] = BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
 		wlh[2] = entry->mac_handle;
 		wlh[3] = entry->traffic_pending_bmp;
-		brcmf_dbg(TRACE, "adding TIM info: %02X:%02X:%02X:%02X\n",
-			  wlh[0], wlh[1], wlh[2], wlh[3]);
+		brcmf_dbg(TRACE, "adding TIM info: handle %d bmp 0x%X\n",
+			  entry->mac_handle, entry->traffic_pending_bmp);
 		wlh += BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN + 2;
 		entry->traffic_lastreported_bmp = entry->traffic_pending_bmp;
 	}
-- 
1.7.10.4


