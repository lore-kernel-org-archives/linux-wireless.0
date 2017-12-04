Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36919 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751631AbdLDSMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 13:12:50 -0500
Received: by mail-oi0-f66.google.com with SMTP id y75so12353020oie.4
        for <linux-wireless@vger.kernel.org>; Mon, 04 Dec 2017 10:12:50 -0800 (PST)
MIME-Version: 1.0
From: Gabriele Gristina <gabriele.gristina@gmail.com>
Date: Mon, 4 Dec 2017 19:12:48 +0100
Message-ID: <CAAQoy1SjfdOsLqNXXZwNydvSTRQ5LQARwvSoPs8+Vjnt+gXVsQ@mail.gmail.com> (sfid-20171204_191254_621766_9C84BBE0)
Subject: [PATCH] rtl8187: add master mode
To: linux-wireless@vger.kernel.org
Cc: Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add the master mode to rtl8187 wireless driver.

Signed-off-by: Gabriele Gristina <gabriele.gristina@gmail.com>

---

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index 121b94f09714..8ef22f4382ae 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -1113,6 +1113,7 @@ static int rtl8187_add_interface(struct ieee80211_hw *dev,
  goto exit;

  switch (vif->type) {
+ case NL80211_IFTYPE_AP:
  case NL80211_IFTYPE_STATION:
  case NL80211_IFTYPE_ADHOC:
  break;
@@ -1602,7 +1603,8 @@ static int rtl8187_probe(struct usb_interface *intf,
  priv->rfkill_mask = RFKILL_MASK_8198;
  }
  dev->vif_data_size = sizeof(struct rtl8187_vif);
- dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+ dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_AP) |
+       BIT(NL80211_IFTYPE_STATION) |
        BIT(NL80211_IFTYPE_ADHOC) ;

  wiphy_ext_feature_set(dev->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
