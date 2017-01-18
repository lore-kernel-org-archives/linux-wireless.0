Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33069 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbdARKtW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 05:49:22 -0500
Received: by mail-lf0-f67.google.com with SMTP id x1so1185534lff.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 02:49:21 -0800 (PST)
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
Subject: [PATCH V2 2/4] brcmfmac: move brcmf_c_set_joinpref_default declaration to common.h
Date: Wed, 18 Jan 2017 11:48:52 +0100
Message-Id: <20170118104854.32231-2-zajec5@gmail.com> (sfid-20170118_114925_637168_436A1448)
In-Reply-To: <20170118104854.32231-1-zajec5@gmail.com>
References: <20170118104854.32231-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Function brcmf_c_set_joinpref_default is in common.c, so move it to the
related header.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
V2: Move brcmf_c_set_joinpref_default only
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h   | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index bd095ab..a62f8e7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -65,6 +65,8 @@ struct brcmf_mp_device {
 	} bus;
 };
 
+void brcmf_c_set_joinpref_default(struct brcmf_if *ifp);
+
 struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
 					       enum brcmf_bus_type bus_type,
 					       u32 chip, u32 chiprev);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index c94dcab..de3197b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -216,7 +216,6 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
-void brcmf_c_set_joinpref_default(struct brcmf_if *ifp);
 int __init brcmf_core_init(void);
 void __exit brcmf_core_exit(void);
 
-- 
2.10.1
