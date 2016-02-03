Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 22/28] rtl8xxxu: rtl8xxxu_set_linktype(): Be consistent aboutregister size REG_MSR
Date: Wed,  3 Feb 2016 13:39:56 -0500
Message-Id: <1454524802-26763-23-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194758_894419_E1199002)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 1b7ff74..c8ba698 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1599,9 +1599,9 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 static void rtl8xxxu_set_linktype(struct rtl8xxxu_priv *priv,
 				  enum nl80211_iftype linktype)
 {
-	u16 val8;
+	u8 val8;
 
-	val8 = rtl8xxxu_read16(priv, REG_MSR);
+	val8 = rtl8xxxu_read8(priv, REG_MSR);
 	val8 &= ~MSR_LINKTYPE_MASK;
 
 	switch (linktype) {
-- 
2.5.0

