Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35795 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbdAQQfw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 11:35:52 -0500
Received: by mail-lf0-f65.google.com with SMTP id v186so17008429lfa.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2017 08:35:51 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/2] brcmfmac: drop unneeded function declarations from headers
Date: Tue, 17 Jan 2017 17:34:18 +0100
Message-Id: <20170117163419.1184-1-zajec5@gmail.com> (sfid-20170117_173555_489132_BF8B0779)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Functions brcmf_c_prec_enq and brcmf_sdio_init don't exist so we
really don't need their declarations. Function brcmf_parse_tlvs is used
in cfg80211.c only so make it static and drop from header as well.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h      | 4 ----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h | 2 --
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index e21f760..b5bb971 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -218,9 +218,6 @@ int brcmf_bus_get_memdump(struct brcmf_bus *bus, void *data, size_t len)
  * interface functions from common layer
  */
 
-bool brcmf_c_prec_enq(struct device *dev, struct pktq *q, struct sk_buff *pkt,
-		      int prec);
-
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
 void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_event);
 /* Receive async event packet from firmware. Callee disposes of rxp. */
@@ -247,7 +244,6 @@ void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
 
 #ifdef CONFIG_BRCMFMAC_SDIO
 void brcmf_sdio_exit(void);
-void brcmf_sdio_init(void);
 void brcmf_sdio_register(void);
 #endif
 #ifdef CONFIG_BRCMFMAC_USB
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 729bf33..ec1171c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -326,7 +326,7 @@ u16 channel_to_chanspec(struct brcmu_d11inf *d11inf,
  * triples, returning a pointer to the substring whose first element
  * matches tag
  */
-const struct brcmf_tlv *
+static const struct brcmf_tlv *
 brcmf_parse_tlvs(const void *buf, int buflen, uint key)
 {
 	const struct brcmf_tlv *elt = buf;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 0c9a708..8f19d95 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -396,8 +396,6 @@ void brcmf_free_vif(struct brcmf_cfg80211_vif *vif);
 s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			  const u8 *vndr_ie_buf, u32 vndr_ie_len);
 s32 brcmf_vif_clear_mgmt_ies(struct brcmf_cfg80211_vif *vif);
-const struct brcmf_tlv *
-brcmf_parse_tlvs(const void *buf, int buflen, uint key);
 u16 channel_to_chanspec(struct brcmu_d11inf *d11inf,
 			struct ieee80211_channel *ch);
 bool brcmf_get_vif_state_any(struct brcmf_cfg80211_info *cfg,
-- 
2.10.1
