Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38644 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab3C3Nwi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Mar 2013 09:52:38 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/3] rt2x00: introduce rt2x00_set_{rt,rf} helpers
Date: Sat, 30 Mar 2013 14:53:08 +0100
Message-Id: <1364651590-29710-2-git-send-email-juhosg@openwrt.org> (sfid-20130330_145250_938394_355CBA46)
In-Reply-To: <1364651590-29710-1-git-send-email-juhosg@openwrt.org>
References: <1364651590-29710-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new helpers can be used to set the type of the
RT and RF chipsets separately.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index cdf26ed..0d02d16 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1106,6 +1106,23 @@ static inline void rt2x00_set_chip(struct rt2x00_dev *rt2x00dev,
 	     rt2x00dev->chip.rt, rt2x00dev->chip.rf, rt2x00dev->chip.rev);
 }
 
+static inline void rt2x00_set_rt(struct rt2x00_dev *rt2x00dev,
+				 const u16 rt, const u16 rev)
+{
+	rt2x00dev->chip.rt = rt;
+	rt2x00dev->chip.rev = rev;
+
+	INFO(rt2x00dev, "RT chipset %04x, rev %04x detected\n",
+	     rt2x00dev->chip.rt, rt2x00dev->chip.rev);
+}
+
+static inline void rt2x00_set_rf(struct rt2x00_dev *rt2x00dev, const u16 rf)
+{
+	rt2x00dev->chip.rf = rf;
+
+	INFO(rt2x00dev, "RF chipset %04x detected\n", rt2x00dev->chip.rf);
+}
+
 static inline bool rt2x00_rt(struct rt2x00_dev *rt2x00dev, const u16 rt)
 {
 	return (rt2x00dev->chip.rt == rt);
-- 
1.7.10

