Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47719 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181Ab0GBMp2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 08:45:28 -0400
Message-ID: <4C2DDF62.6050503@openwrt.org>
Date: Fri, 02 Jul 2010 14:45:22 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] ath9k: fix crash with WEP in ad-hoc mode
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit eed8e22f0133e8278b1f8079fcb452f1f9692f9d added support for using
multicast key lookup to support per-vif/sta keys for AP and ad-hoc.
Unfortunately, it also introduced a crash in ad-hoc mode when the sta
pointer is NULL, which happens when setting up an interface with WEP
keys. This patch fixes it by falling back to the assigned key index.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -319,6 +319,10 @@ int ath9k_cmn_key_config(struct ath_comm
 			idx = ath_reserve_key_cache_slot(common, key->alg);
 			break;
 		case NL80211_IFTYPE_ADHOC:
+			if (!sta) {
+				idx = key->keyidx;
+				break;
+			}
 			memcpy(gmac, sta->addr, ETH_ALEN);
 			gmac[0] |= 0x01;
 			mac = gmac;
