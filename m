Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:30440 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYBQQgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 11:36:09 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1391418fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 08:36:08 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 09/11] Fix hw mode registration with mac80211.
Date: Sun, 17 Feb 2008 17:35:55 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802171730.44353.IvDoorn@gmail.com>
In-Reply-To: <200802171730.44353.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802171735.56101.IvDoorn@gmail.com> (sfid-20080217_163621_580011_1D8291ED)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

The supported_bands field of struct hw_mode_spec now represents a bitfield,
so bitfield operators need to be tested with when setting the band data.

The current code generates the following warning:

[176624.986244] WARNING: at /usr/local/src/incoming/compat-wireless-2.6/net/wireless/core.c:269 wiphy_register()
[176624.986249] Pid: 12548, comm: modprobe Tainted: P        2.6.24.2#4
[176624.986251]
[176624.986251] Call Trace:
[176624.986277]  [<ffffffff881c56bf>] :cfg80211:wiphy_register+0x17f/0x1a0
[176624.986282]  [<ffffffff881ddf80>] :rt61pci:rt61pci_eepromregister_write+0x0/0x80
[176624.986302]  [<ffffffff88b7e4bc>] :mac80211:ieee80211_register_hw+0x2c/0x2b0
[176624.986310]  [<ffffffff881cdc80>] :rt2x00lib:rt2x00lib_probe_dev+0x350/0x3f0
[176624.986318]  [<ffffffff881d74b9>] :rt2x00pci:rt2x00pci_probe+0x149/0x200
[176624.986325]  [<ffffffff8030c858>] pci_device_probe+0xf8/0x170
[176624.986331]  [<ffffffff803594fc>] driver_probe_device+0x9c/0x1c0
[176624.986335]  [<ffffffff80359700>] __driver_attach+0x0/0xb0
[176624.986337]  [<ffffffff803597a5>] __driver_attach+0xa5/0xb0
[176624.986341]  [<ffffffff8035877d>] bus_for_each_dev+0x4d/0x80
[176624.986347]  [<ffffffff80358b8c>] bus_add_driver+0xac/0x210
[176624.986351]  [<ffffffff8030cad3>] __pci_register_driver+0x73/0xc0
[176624.986357]  [<ffffffff8025689e>] sys_init_module+0x18e/0x1a20
[176624.986374]  [<ffffffff8020c42e>] system_call+0x7e/0x83

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 6103175..015738a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -916,7 +916,7 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	 * Rates: CCK, OFDM.
 	 * Channels: 2.4 GHz
 	 */
-	if (spec->supported_bands > SUPPORT_BAND_2GHZ) {
+	if (spec->supported_bands & SUPPORT_BAND_2GHZ) {
 		rt2x00dev->bands[IEEE80211_BAND_2GHZ].n_channels = 14;
 		rt2x00dev->bands[IEEE80211_BAND_2GHZ].n_bitrates = num_rates;
 		rt2x00dev->bands[IEEE80211_BAND_2GHZ].channels = channels;
@@ -930,7 +930,7 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	 * Rates: OFDM.
 	 * Channels: OFDM, UNII, HiperLAN2.
 	 */
-	if (spec->supported_bands > SUPPORT_BAND_5GHZ) {
+	if (spec->supported_bands & SUPPORT_BAND_5GHZ) {
 		rt2x00dev->bands[IEEE80211_BAND_5GHZ].n_channels =
 		    spec->num_channels - 14;
 		rt2x00dev->bands[IEEE80211_BAND_5GHZ].n_bitrates =
-- 
1.5.4

