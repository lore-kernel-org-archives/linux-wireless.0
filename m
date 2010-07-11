Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38439 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab0GKKcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:09 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so640225ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:09 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/17] rt2x00: Remove set_tim callback from PCI drivers
Date: Sun, 11 Jul 2010 12:29:26 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111228.24393.IvDoorn@gmail.com> <201007111228.56050.IvDoorn@gmail.com>
In-Reply-To: <201007111228.56050.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111229.27800.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Using the set_tim callback without managing the DTIM count and the
broad- and multicast buffering in hw, fw or the driver results in wrong
DTIM count values being sent out in beacons. Since all PCI drivers
fetch new beacons periodically and hence get an updated TIM we can just
remove the set_tim callback from these.

The rt2x00 USB drivers don't update the beacon periodically and thus
rely on the set_tim callback to get a correct TIM for beacon
transmission. USB devices still suffer from the DTIM count being wrong
under some circumstances but removing the set_tim callback from these
would cause more harm then good.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    1 -
 drivers/net/wireless/rt2x00/rt2500pci.c |    1 -
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 -
 drivers/net/wireless/rt2x00/rt61pci.c   |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 116244b..5063e01 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1589,7 +1589,6 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
-	.set_tim		= rt2x00mac_set_tim,
 	.sw_scan_start		= rt2x00mac_sw_scan_start,
 	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
 	.get_stats		= rt2x00mac_get_stats,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5e80948..c2a555d 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1883,7 +1883,6 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
-	.set_tim		= rt2x00mac_set_tim,
 	.sw_scan_start		= rt2x00mac_sw_scan_start,
 	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
 	.get_stats		= rt2x00mac_get_stats,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 4c138eb..520236d 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1096,7 +1096,6 @@ static const struct ieee80211_ops rt2800pci_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
-	.set_tim		= rt2x00mac_set_tim,
 	.set_key		= rt2x00mac_set_key,
 	.sw_scan_start		= rt2x00mac_sw_scan_start,
 	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 049433f..e539c6c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2805,7 +2805,6 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
-	.set_tim		= rt2x00mac_set_tim,
 	.set_key		= rt2x00mac_set_key,
 	.sw_scan_start		= rt2x00mac_sw_scan_start,
 	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
-- 
1.7.1.1

