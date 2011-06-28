Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:64825 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1F1TtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 15:49:02 -0400
Received: by fxd18 with SMTP id 18so542113fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 12:49:00 -0700 (PDT)
Message-ID: <4E0A2F8A.8010102@fedoraproject.org> (sfid-20110628_214907_826293_D4E80570)
Date: Tue, 28 Jun 2011 21:46:18 +0200
From: Michel Alexandre Salim <salimma@fedoraproject.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] ath9k: add module option for disabling 11n functionality
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some wireless base stations implement 802.11n mode in ways that 
open-source drivers cannot handle properly, resulting in very unstable 
connections. This patch introduces an '11n_disable' option to the ath9k 
driver, similar to the same option for the iwlagn driver.

Tested at the internal wireless network of www.cs.fau.de, where 802.11n 
currently only works reliably with Windows clients.

---
  drivers/net/wireless/ath/ath9k/init.c |   10 +++++++++-
  1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c 
b/drivers/net/wireless/ath/ath9k/init.c
index 616e30b..9521ca3 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -43,6 +43,10 @@ static int ath9k_btcoex_enable;
  module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
  MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");

+int ath9k_modparam_disable_11n;
+module_param_named(11n_disable, ath9k_modparam_disable_11n, int, 0444);
+MODULE_PARM_DESC(11n_disable, "disable 11n functionality");
+
  bool is_ath9k_unloaded;
  /* We use the hw_value as an index into our private channel structure */

@@ -231,7 +235,11 @@ static void setup_ht_cap(struct ath_softc *sc,
         u8 tx_streams, rx_streams;
         int i, max_streams;

-       ht_info->ht_supported = true;
+       if (ath9k_modparam_disable_11n)
+               ht_info->ht_supported = false;
+       else
+               ht_info->ht_supported = true;
+
         ht_info->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
                        IEEE80211_HT_CAP_SM_PS |
                        IEEE80211_HT_CAP_SGI_40 |
-- 
1.7.5.4
