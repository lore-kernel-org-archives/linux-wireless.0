Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA733C001DC
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jul 2023 02:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjG1Cvj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Jul 2023 22:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjG1Cvi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2023 22:51:38 -0400
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D4B2686;
        Thu, 27 Jul 2023 19:51:32 -0700 (PDT)
Received: from local
        by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1qPDZc-000096-2m;
        Fri, 28 Jul 2023 02:51:24 +0000
Date:   Fri, 28 Jul 2023 03:51:16 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 2/2] wifi: mt76: support per-band MAC addresses from OF
 child nodes
Message-ID: <4958730e4f88b91442fa96365785d467fad502de.1690512516.git.daniel@makrotopia.org>
References: <6e9cfac5758dd06429fadf6c1c70c569c86f3a95.1690512516.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e9cfac5758dd06429fadf6c1c70c569c86f3a95.1690512516.git.daniel@makrotopia.org>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

With dual-band-dual-congruent front-ends which appear as two independent
radios it is desirable to assign a per-band MAC address from device-tree,
eg. using nvmem-cells.
Support specifying MAC-address related properties in band-specific child
nodes, e.g.
        mt7915@0,0 {
                reg = <0x0000 0 0 0 0>;
                #addr-cells = <1>;
                #size-cells = <0>;

                band@0 {
                        /* 2.4 GHz */
                        reg = <0>;
                        nvmem-cells = <&macaddr 2>;
                        nvmem-cell-names = "mac-address";
                };

                band@1 {
                        /* 5 GHz */
                        reg = <1>;
                        nvmem-cells = <&macaddr 3>;
                        nvmem-cell-names = "mac-address";
                };
        };

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index 36564930aef12..c2b3386cada1c 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -161,9 +161,25 @@ void
 mt76_eeprom_override(struct mt76_phy *phy)
 {
 	struct mt76_dev *dev = phy->dev;
-	struct device_node *np = dev->dev->of_node;
+	struct device_node *np = dev->dev->of_node, *band_np;
+	bool found_mac = false;
+	u32 reg;
+	int ret;
+
+	for_each_child_of_node(np, band_np) {
+		ret = of_property_read_u32(band_np, "reg", &reg);
+		if (ret)
+			continue;
+
+		if (reg == phy->band_idx) {
+			found_mac = !of_get_mac_address(band_np, phy->macaddr);
+			of_node_put(band_np);
+			break;
+		}
+	}
 
-	of_get_mac_address(np, phy->macaddr);
+	if (!found_mac)
+		of_get_mac_address(np, phy->macaddr);
 
 	if (!is_valid_ether_addr(phy->macaddr)) {
 		eth_random_addr(phy->macaddr);
-- 
2.41.0
