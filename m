Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbdKUHIi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 02:08:38 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v7,1/3] dt-bindings: net: add mt76 wireless device binding
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171120193549.80831-2-nbd@nbd.name>
References: <20171120193549.80831-2-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Message-Id: <20171121070837.F1BCF607F4@smtp.codeaurora.org> (sfid-20171121_080842_276351_607E44BA)
Date: Tue, 21 Nov 2017 07:08:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> Add documentation describing how device tree can be used to configure
> wireless chips supported by the mt76 driver.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Acked-by: Rob Herring <robh@kernel.org>

Fails to compile:

drivers/net/wireless/mediatek/mt76/mac80211.c: In function ‘mt76_led_init’:
drivers/net/wireless/mediatek/mt76/mac80211.c:111:7: error: implicit declaration of function ‘of_get_child_by_name’ [-Werror=implicit-function-declaration]
  np = of_get_child_by_name(np, "led");
       ^
drivers/net/wireless/mediatek/mt76/mac80211.c:111:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
  np = of_get_child_by_name(np, "led");
     ^
drivers/net/wireless/mediatek/mt76/mac80211.c:113:8: error: implicit declaration of function ‘of_property_read_u32’ [-Werror=implicit-function-declaration]
   if (!of_property_read_u32(np, "led-sources", &led_pin))
        ^
drivers/net/wireless/mediatek/mt76/mac80211.c:115:17: error: implicit declaration of function ‘of_property_read_bool’ [-Werror=implicit-function-declaration]
   dev->led_al = of_property_read_bool(np, "led-active-low");
                 ^
cc1: some warnings being treated as errors
make[5]: *** [drivers/net/wireless/mediatek/mt76/mac80211.o] Error 1
make[5]: *** Waiting for unfinished jobs....
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c: In function ‘mt76x2_mac_process_rate’:
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:49:20: error: ‘RX_FLAG_SHORTPRE’ undeclared (first use in this function)
    status->flag |= RX_FLAG_SHORTPRE;
                    ^
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:49:20: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:58:19: error: ‘RX_FLAG_HT_GF’ undeclared (first use in this function)
   status->flag |= RX_FLAG_HT_GF;
                   ^
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:61:19: error: ‘RX_FLAG_HT’ undeclared (first use in this function)
   status->flag |= RX_FLAG_HT;
                   ^
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:65:19: error: ‘RX_FLAG_VHT’ undeclared (first use in this function)
   status->flag |= RX_FLAG_VHT;
                   ^
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:67:9: error: ‘struct ieee80211_rx_status’ has no member named ‘vht_nss’
   status->vht_nss = FIELD_GET(MT_RATE_INDEX_VHT_NSS, idx) + 1;
         ^
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:75:19: error: ‘RX_FLAG_LDPC’ undeclared (first use in this function)
   status->flag |= RX_FLAG_LDPC;
                   ^
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:78:19: error: ‘RX_FLAG_SHORT_GI’ undeclared (first use in this function)
   status->flag |= RX_FLAG_SHORT_GI;
                   ^
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:81:24: error: ‘RX_FLAG_STBC_SHIFT’ undeclared (first use in this function)
   status->flag |= 1 << RX_FLAG_STBC_SHIFT;
                        ^
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:87:19: error: ‘RX_FLAG_40MHZ’ undeclared (first use in this function)
   status->flag |= RX_FLAG_40MHZ;
                   ^
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:90:9: error: ‘struct ieee80211_rx_status’ has no member named ‘vht_flag’
   status->vht_flag |= RX_VHT_FLAG_80MHZ;
         ^
drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:90:23: error: ‘RX_VHT_FLAG_80MHZ’ undeclared (first use in this function)
   status->vht_flag |= RX_VHT_FLAG_80MHZ;
                       ^
make[5]: *** [drivers/net/wireless/mediatek/mt76/mt76x2_mac.o] Error 1
make[4]: *** [drivers/net/wireless/mediatek/mt76] Error 2
make[3]: *** [drivers/net/wireless/mediatek] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

3 patches set to Changes Requested.

10067143 [v7,1/3] dt-bindings: net: add mt76 wireless device binding
10067141 [v7,2/3] mt76: add common code shared between multiple chipsets
10067145 [v7,3/3] mt76: add driver code for MT76x2e

-- 
https://patchwork.kernel.org/patch/10067143/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
