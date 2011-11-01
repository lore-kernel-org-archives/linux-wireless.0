Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44591 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1KAQFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 12:05:45 -0400
Received: by qabj40 with SMTP id j40so5891302qab.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2011 09:05:44 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 1 Nov 2011 18:05:44 +0200
Message-ID: <CAFED-jm6P3Xn-3O6YuEXbtVCf6_JpyH1K18kTJkFybpBbwBnVA@mail.gmail.com> (sfid-20111101_170548_821733_69B9C14A)
Subject: [PATCH] compat-wireless: add driver-select for mac80211_hwsim
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>

---
 scripts/driver-select |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/scripts/driver-select b/scripts/driver-select
index 3619541..6f7f103 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -33,7 +33,7 @@ PURPLE="\033[35m"
 CYAN="\033[36m"
 UNDERLINE="\033[02m"

-SUPPORTED_80211_DRIVERS="ath5k ath9k ath9k_htc carl9170 ath6kl b43
zd1211rw rt2x00 wl1251 wl12xx brcmsmac brcmfmac"
+SUPPORTED_80211_DRIVERS="ath5k ath9k ath9k_htc carl9170 ath6kl b43
zd1211rw rt2x00 wl1251 wl12xx brcmsmac brcmfmac mac80211_hwsim"

 # b43 needs some more work for driver-select, the SSB stuff, plus
 # what if you update b44 but not b43? It will bust.
@@ -424,6 +424,11 @@ case $1 in
                disable_staging
                disable_var_01
                ;;
+       mac80211_hwsim)
+               disable_staging
+               disable_bt_usb_ethernet
+               select_driver           CONFIG_MAC80211_HWSIM
+               ;;
 # Ethernet and Bluetooth drivers
        atl1)
                enable_only_ethernet
-- 
1.7.4.1
