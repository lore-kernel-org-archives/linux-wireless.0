Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56817 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933893AbcDLN6Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 09:58:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: remove enum ieee80211_band
Date: Tue, 12 Apr 2016 15:58:07 +0200
Message-Id: <1460469487-21008-1-git-send-email-johannes@sipsolutions.net> (sfid-20160412_155833_622456_D48D4C64)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This enum is already perfectly aliased to enum nl80211_band, and
the only reason for it is that we get IEEE80211_NUM_BANDS out of
it. There's no really good reason to not declare the number of
bands in nl80211 though, so do that and remove the cfg80211 one.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl                   |   1 -
 drivers/net/wireless/admtek/adm8211.c              |   4 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   4 +-
 drivers/net/wireless/ath/ath.h                     |   2 +-
 drivers/net/wireless/ath/ath10k/core.h             |   2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   8 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  68 ++++----
 drivers/net/wireless/ath/ath10k/wmi.c              |   8 +-
 drivers/net/wireless/ath/ath5k/ani.c               |   2 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |  10 +-
 drivers/net/wireless/ath/ath5k/attach.c            |   8 +-
 drivers/net/wireless/ath/ath5k/base.c              |  32 ++--
 drivers/net/wireless/ath/ath5k/debug.c             |   6 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |   6 +-
 drivers/net/wireless/ath/ath5k/phy.c               |  30 ++--
 drivers/net/wireless/ath/ath5k/qcu.c               |   8 +-
 drivers/net/wireless/ath/ath5k/reset.c             |   6 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  22 +--
 drivers/net/wireless/ath/ath6kl/core.h             |   2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |  22 +--
 drivers/net/wireless/ath/ath6kl/wmi.h              |   2 +-
 drivers/net/wireless/ath/ath9k/calib.c             |   6 +-
 drivers/net/wireless/ath/ath9k/channel.c           |   8 +-
 drivers/net/wireless/ath/ath9k/common-init.c       |  28 ++--
 drivers/net/wireless/ath/ath9k/common.c            |   4 +-
 drivers/net/wireless/ath/ath9k/debug_sta.c         |   6 +-
 drivers/net/wireless/ath/ath9k/dynack.c            |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  12 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   2 +-
 drivers/net/wireless/ath/ath9k/init.c              |  12 +-
 drivers/net/wireless/ath/ath9k/main.c              |   4 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   4 +-
 drivers/net/wireless/ath/carl9170/mac.c            |  12 +-
 drivers/net/wireless/ath/carl9170/main.c           |   6 +-
 drivers/net/wireless/ath/carl9170/phy.c            |  18 +--
 drivers/net/wireless/ath/carl9170/rx.c             |   2 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   8 +-
 drivers/net/wireless/ath/regd.c                    |  16 +-
 drivers/net/wireless/ath/regd.h                    |   2 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |  12 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   4 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |   2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   4 +-
 drivers/net/wireless/ath/wil6210/netdev.c          |   2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   2 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |   6 +-
 drivers/net/wireless/atmel/atmel.c                 |   2 +-
 drivers/net/wireless/broadcom/b43/b43.h            |   4 +-
 drivers/net/wireless/broadcom/b43/main.c           |  34 ++--
 drivers/net/wireless/broadcom/b43/phy_ac.c         |   2 +-
 drivers/net/wireless/broadcom/b43/phy_common.c     |   2 +-
 drivers/net/wireless/broadcom/b43/phy_ht.c         |  16 +-
 drivers/net/wireless/broadcom/b43/phy_lcn.c        |  10 +-
 drivers/net/wireless/broadcom/b43/phy_lp.c         |  30 ++--
 drivers/net/wireless/broadcom/b43/phy_n.c          | 176 ++++++++++-----------
 drivers/net/wireless/broadcom/b43/tables_lpphy.c   |  14 +-
 drivers/net/wireless/broadcom/b43/tables_nphy.c    |  16 +-
 drivers/net/wireless/broadcom/b43/tables_phy_lcn.c |   2 +-
 drivers/net/wireless/broadcom/b43/xmit.c           |   8 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |  12 +-
 drivers/net/wireless/broadcom/b43legacy/xmit.c     |   2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  74 ++++-----
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   8 +-
 .../wireless/broadcom/brcm80211/brcmsmac/channel.c |  10 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |  16 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |   4 +-
 drivers/net/wireless/cisco/airo.c                  |   6 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   6 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |  12 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |  30 ++--
 drivers/net/wireless/intel/iwlegacy/3945-rs.c      |  22 +--
 drivers/net/wireless/intel/iwlegacy/3945.c         |  20 +--
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  38 ++---
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |  22 +--
 drivers/net/wireless/intel/iwlegacy/4965.c         |   6 +-
 drivers/net/wireless/intel/iwlegacy/4965.h         |   2 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |  70 ++++----
 drivers/net/wireless/intel/iwlegacy/common.h       |  30 ++--
 drivers/net/wireless/intel/iwlegacy/debug.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h       |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h       |   6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |  12 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |  22 +--
 drivers/net/wireless/intel/iwlwifi/dvm/rs.h        |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c      |  10 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |  38 ++---
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-1000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-2000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-5000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-6000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |  38 ++---
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  26 +--
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |  10 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  28 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  36 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   4 +-
 drivers/net/wireless/intersil/orinoco/cfg.c        |   6 +-
 drivers/net/wireless/intersil/orinoco/hw.c         |   2 +-
 drivers/net/wireless/intersil/orinoco/scan.c       |   4 +-
 drivers/net/wireless/intersil/p54/eeprom.c         |  32 ++--
 drivers/net/wireless/intersil/p54/main.c           |   4 +-
 drivers/net/wireless/intersil/p54/p54.h            |   2 +-
 drivers/net/wireless/intersil/p54/txrx.c           |   4 +-
 drivers/net/wireless/mac80211_hwsim.c              |  14 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |  10 +-
 drivers/net/wireless/marvell/libertas/cmd.c        |   4 +-
 drivers/net/wireless/marvell/libertas_tf/main.c    |   4 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  34 ++--
 drivers/net/wireless/marvell/mwifiex/cfp.c         |  12 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |   8 +-
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c     |   2 +-
 drivers/net/wireless/marvell/mwl8k.c               |  88 +++++------
 drivers/net/wireless/mediatek/mt7601u/init.c       |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  30 ++--
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |  40 ++---
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |  22 +--
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |  22 +--
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   8 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   4 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   |  30 ++--
 drivers/net/wireless/realtek/rtlwifi/base.c        |  44 +++---
 drivers/net/wireless/realtek/rtlwifi/regd.c        |  16 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   2 +-
 drivers/net/wireless/rndis_wlan.c                  |   4 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        | 100 ++++++------
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   8 +-
 drivers/net/wireless/rsi/rsi_91x_pkt.c             |   2 +-
 drivers/net/wireless/rsi/rsi_main.h                |   2 +-
 drivers/net/wireless/st/cw1200/main.c              |  10 +-
 drivers/net/wireless/st/cw1200/scan.c              |   2 +-
 drivers/net/wireless/st/cw1200/sta.c               |   6 +-
 drivers/net/wireless/st/cw1200/txrx.c              |   2 +-
 drivers/net/wireless/st/cw1200/wsm.c               |   4 +-
 drivers/net/wireless/ti/wl1251/main.c              |   2 +-
 drivers/net/wireless/ti/wl1251/rx.c                |   2 +-
 drivers/net/wireless/ti/wl12xx/main.c              |   8 +-
 drivers/net/wireless/ti/wl12xx/scan.c              |  20 +--
 drivers/net/wireless/ti/wl18xx/cmd.c               |   6 +-
 drivers/net/wireless/ti/wl18xx/event.c             |   6 +-
 drivers/net/wireless/ti/wl18xx/main.c              |  22 +--
 drivers/net/wireless/ti/wl18xx/scan.c              |   8 +-
 drivers/net/wireless/ti/wl18xx/tx.c                |   2 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |  36 ++---
 drivers/net/wireless/ti/wlcore/cmd.h               |   6 +-
 drivers/net/wireless/ti/wlcore/main.c              |  32 ++--
 drivers/net/wireless/ti/wlcore/ps.c                |   4 +-
 drivers/net/wireless/ti/wlcore/rx.c                |   4 +-
 drivers/net/wireless/ti/wlcore/rx.h                |   2 +-
 drivers/net/wireless/ti/wlcore/scan.c              |  14 +-
 drivers/net/wireless/ti/wlcore/tx.c                |   2 +-
 drivers/net/wireless/ti/wlcore/tx.h                |   4 +-
 drivers/net/wireless/ti/wlcore/wlcore.h            |   4 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h          |   2 +-
 drivers/net/wireless/wl3501_cs.c                   |   2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   4 +-
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c      |   4 +-
 drivers/staging/rtl8723au/include/ieee80211.h      |   2 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |  54 +++----
 drivers/staging/vt6655/channel.c                   |   4 +-
 drivers/staging/vt6655/device_main.c               |   4 +-
 drivers/staging/vt6655/rxtx.c                      |   2 +-
 drivers/staging/vt6656/channel.c                   |   4 +-
 drivers/staging/vt6656/int.c                       |   2 +-
 drivers/staging/vt6656/main_usb.c                  |   2 +-
 drivers/staging/vt6656/rxtx.c                      |   2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c  |  10 +-
 drivers/staging/wlan-ng/cfg80211.c                 |   6 +-
 include/net/cfg80211.h                             |  44 ++----
 include/net/mac80211.h                             |  12 +-
 include/uapi/linux/nl80211.h                       |   4 +
 net/mac80211/cfg.c                                 |  14 +-
 net/mac80211/debugfs_netdev.c                      |  12 +-
 net/mac80211/ibss.c                                |  10 +-
 net/mac80211/ieee80211_i.h                         |  34 ++--
 net/mac80211/iface.c                               |   2 +-
 net/mac80211/main.c                                |   6 +-
 net/mac80211/mesh.c                                |  10 +-
 net/mac80211/mesh_plink.c                          |  10 +-
 net/mac80211/mlme.c                                |  14 +-
 net/mac80211/rate.c                                |   2 +-
 net/mac80211/rc80211_minstrel.c                    |   6 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   4 +-
 net/mac80211/rx.c                                  |   6 +-
 net/mac80211/scan.c                                |  12 +-
 net/mac80211/spectmgmt.c                           |   4 +-
 net/mac80211/tdls.c                                |  18 +--
 net/mac80211/trace.h                               |   6 +-
 net/mac80211/tx.c                                  |  14 +-
 net/mac80211/util.c                                |  24 +--
 net/mac80211/vht.c                                 |   4 +-
 net/wireless/chan.c                                |   2 +-
 net/wireless/core.c                                |   8 +-
 net/wireless/debugfs.c                             |   4 +-
 net/wireless/ibss.c                                |   6 +-
 net/wireless/mesh.c                                |   4 +-
 net/wireless/mlme.c                                |   2 +-
 net/wireless/nl80211.c                             |  44 +++---
 net/wireless/rdev-ops.h                            |   2 +-
 net/wireless/reg.c                                 |  30 ++--
 net/wireless/reg.h                                 |   2 +-
 net/wireless/scan.c                                |  14 +-
 net/wireless/sme.c                                 |   6 +-
 net/wireless/trace.h                               |  20 +--
 net/wireless/util.c                                |  40 ++---
 net/wireless/wext-compat.c                         |  14 +-
 230 files changed, 1420 insertions(+), 1437 deletions(-)

diff --git a/Documentation/DocBook/80211.tmpl b/Documentation/DocBook/80211.tmpl
index f9b9ad7894f5..f2a312b35875 100644
--- a/Documentation/DocBook/80211.tmpl
+++ b/Documentation/DocBook/80211.tmpl
@@ -75,7 +75,6 @@
       <chapter>
       <title>Device registration</title>
 !Pinclude/net/cfg80211.h Device registration
-!Finclude/net/cfg80211.h ieee80211_band
 !Finclude/net/cfg80211.h ieee80211_channel_flags
 !Finclude/net/cfg80211.h ieee80211_channel
 !Finclude/net/cfg80211.h ieee80211_rate_flags
diff --git a/drivers/net/wireless/admtek/adm8211.c b/drivers/net/wireless/admtek/adm8211.c
index 15f057ed41ad..70ecd82d674d 100644
--- a/drivers/net/wireless/admtek/adm8211.c
+++ b/drivers/net/wireless/admtek/adm8211.c
@@ -440,7 +440,7 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 			rx_status.rate_idx = rate;
 
 			rx_status.freq = adm8211_channels[priv->channel - 1].center_freq;
-			rx_status.band = IEEE80211_BAND_2GHZ;
+			rx_status.band = NL80211_BAND_2GHZ;
 
 			memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 			ieee80211_rx_irqsafe(dev, skb);
@@ -1894,7 +1894,7 @@ static int adm8211_probe(struct pci_dev *pdev,
 
 	priv->channel = 1;
 
-	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+	dev->wiphy->bands[NL80211_BAND_2GHZ] = &priv->band;
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 3b343c63aa52..8aded24bcdf4 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1471,12 +1471,12 @@ static int ar5523_init_modes(struct ar5523 *ar)
 	memcpy(ar->channels, ar5523_channels, sizeof(ar5523_channels));
 	memcpy(ar->rates, ar5523_rates, sizeof(ar5523_rates));
 
-	ar->band.band = IEEE80211_BAND_2GHZ;
+	ar->band.band = NL80211_BAND_2GHZ;
 	ar->band.channels = ar->channels;
 	ar->band.n_channels = ARRAY_SIZE(ar5523_channels);
 	ar->band.bitrates = ar->rates;
 	ar->band.n_bitrates = ARRAY_SIZE(ar5523_rates);
-	ar->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &ar->band;
+	ar->hw->wiphy->bands[NL80211_BAND_2GHZ] = &ar->band;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 65ef483ebf50..da7a7c8dafb2 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -185,7 +185,7 @@ struct ath_common {
 	bool bt_ant_diversity;
 
 	int last_rssi;
-	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
+	struct ieee80211_supported_band sbands[NUM_NL80211_BANDS];
 };
 
 static inline const struct ath_ps_ops *ath_ps_ops(struct ath_common *common)
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d85b99164212..362bbed8f0e9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -765,7 +765,7 @@ struct ath10k {
 	} scan;
 
 	struct {
-		struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
+		struct ieee80211_supported_band sbands[NUM_NL80211_BANDS];
 	} mac;
 
 	/* should never be NULL; needed for regular htt rx */
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9390897a00c6..079fef5b7ef2 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2182,9 +2182,9 @@ static void ath10k_htt_rx_tx_mode_switch_ind(struct ath10k *ar,
 	ath10k_mac_tx_push_pending(ar);
 }
 
-static inline enum ieee80211_band phy_mode_to_band(u32 phy_mode)
+static inline enum nl80211_band phy_mode_to_band(u32 phy_mode)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	switch (phy_mode) {
 	case MODE_11A:
@@ -2193,7 +2193,7 @@ static inline enum ieee80211_band phy_mode_to_band(u32 phy_mode)
 	case MODE_11AC_VHT20:
 	case MODE_11AC_VHT40:
 	case MODE_11AC_VHT80:
-		band = IEEE80211_BAND_5GHZ;
+		band = NL80211_BAND_5GHZ;
 		break;
 	case MODE_11G:
 	case MODE_11B:
@@ -2204,7 +2204,7 @@ static inline enum ieee80211_band phy_mode_to_band(u32 phy_mode)
 	case MODE_11AC_VHT40_2G:
 	case MODE_11AC_VHT80_2G:
 	default:
-		band = IEEE80211_BAND_2GHZ;
+		band = NL80211_BAND_2GHZ;
 	}
 
 	return band;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b0e613bc10a5..6ace10bc96f5 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -482,7 +482,7 @@ chan_to_phymode(const struct cfg80211_chan_def *chandef)
 	enum wmi_phy_mode phymode = MODE_UNKNOWN;
 
 	switch (chandef->chan->band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		switch (chandef->width) {
 		case NL80211_CHAN_WIDTH_20_NOHT:
 			if (chandef->chan->flags & IEEE80211_CHAN_NO_OFDM)
@@ -505,7 +505,7 @@ chan_to_phymode(const struct cfg80211_chan_def *chandef)
 			break;
 		}
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		switch (chandef->width) {
 		case NL80211_CHAN_WIDTH_20_NOHT:
 			phymode = MODE_11A;
@@ -2055,7 +2055,7 @@ static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
 	struct cfg80211_chan_def def;
 	const struct ieee80211_supported_band *sband;
 	const struct ieee80211_rate *rates;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	u32 ratemask;
 	u8 rate;
 	int i;
@@ -2115,7 +2115,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 	const struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct cfg80211_chan_def def;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	const u8 *ht_mcs_mask;
 	const u16 *vht_mcs_mask;
 	int i, n;
@@ -2339,7 +2339,7 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	const struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct cfg80211_chan_def def;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	const u16 *vht_mcs_mask;
 	u8 ampdu_factor;
 
@@ -2357,7 +2357,7 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 
 	arg->peer_flags |= ar->wmi.peer_flags->vht;
 
-	if (def.chan->band == IEEE80211_BAND_2GHZ)
+	if (def.chan->band == NL80211_BAND_2GHZ)
 		arg->peer_flags |= ar->wmi.peer_flags->vht_2g;
 
 	arg->peer_vht_caps = vht_cap->cap;
@@ -2426,7 +2426,7 @@ static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
 
 static bool ath10k_mac_sta_has_ofdm_only(struct ieee80211_sta *sta)
 {
-	return sta->supp_rates[IEEE80211_BAND_2GHZ] >>
+	return sta->supp_rates[NL80211_BAND_2GHZ] >>
 	       ATH10K_MAC_FIRST_OFDM_RATE_IDX;
 }
 
@@ -2437,7 +2437,7 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 {
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct cfg80211_chan_def def;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	const u8 *ht_mcs_mask;
 	const u16 *vht_mcs_mask;
 	enum wmi_phy_mode phymode = MODE_UNKNOWN;
@@ -2450,7 +2450,7 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 	vht_mcs_mask = arvif->bitrate_mask.control[band].vht_mcs;
 
 	switch (band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		if (sta->vht_cap.vht_supported &&
 		    !ath10k_peer_assoc_h_vht_masked(vht_mcs_mask)) {
 			if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
@@ -2470,7 +2470,7 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 		}
 
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		/*
 		 * Check VHT first.
 		 */
@@ -2848,7 +2848,7 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 {
 	struct ieee80211_hw *hw = ar->hw;
 	struct ieee80211_supported_band **bands;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_channel *channel;
 	struct wmi_scan_chan_list_arg arg = {0};
 	struct wmi_channel_arg *ch;
@@ -2860,7 +2860,7 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	bands = hw->wiphy->bands;
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		if (!bands[band])
 			continue;
 
@@ -2879,7 +2879,7 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 		return -ENOMEM;
 
 	ch = arg.channels;
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		if (!bands[band])
 			continue;
 
@@ -2917,7 +2917,7 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 			/* FIXME: why use only legacy modes, why not any
 			 * HT/VHT modes? Would that even make any
 			 * difference? */
-			if (channel->band == IEEE80211_BAND_2GHZ)
+			if (channel->band == NL80211_BAND_2GHZ)
 				ch->mode = MODE_11G;
 			else
 				ch->mode = MODE_11A;
@@ -4254,14 +4254,14 @@ static void ath10k_mac_setup_ht_vht_cap(struct ath10k *ar)
 	vht_cap = ath10k_create_vht_cap(ar);
 
 	if (ar->phy_capability & WHAL_WLAN_11G_CAPABILITY) {
-		band = &ar->mac.sbands[IEEE80211_BAND_2GHZ];
+		band = &ar->mac.sbands[NL80211_BAND_2GHZ];
 		band->ht_cap = ht_cap;
 
 		/* Enable the VHT support at 2.4 GHz */
 		band->vht_cap = vht_cap;
 	}
 	if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY) {
-		band = &ar->mac.sbands[IEEE80211_BAND_5GHZ];
+		band = &ar->mac.sbands[NL80211_BAND_5GHZ];
 		band->ht_cap = ht_cap;
 		band->vht_cap = vht_cap;
 	}
@@ -5595,7 +5595,7 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 	struct ath10k_sta *arsta;
 	struct ieee80211_sta *sta;
 	struct cfg80211_chan_def def;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	const u8 *ht_mcs_mask;
 	const u16 *vht_mcs_mask;
 	u32 changed, bw, nss, smps;
@@ -6394,14 +6394,14 @@ static int ath10k_get_survey(struct ieee80211_hw *hw, int idx,
 
 	mutex_lock(&ar->conf_mutex);
 
-	sband = hw->wiphy->bands[IEEE80211_BAND_2GHZ];
+	sband = hw->wiphy->bands[NL80211_BAND_2GHZ];
 	if (sband && idx >= sband->n_channels) {
 		idx -= sband->n_channels;
 		sband = NULL;
 	}
 
 	if (!sband)
-		sband = hw->wiphy->bands[IEEE80211_BAND_5GHZ];
+		sband = hw->wiphy->bands[NL80211_BAND_5GHZ];
 
 	if (!sband || idx >= sband->n_channels) {
 		ret = -ENOENT;
@@ -6424,7 +6424,7 @@ exit:
 
 static bool
 ath10k_mac_bitrate_mask_has_single_rate(struct ath10k *ar,
-					enum ieee80211_band band,
+					enum nl80211_band band,
 					const struct cfg80211_bitrate_mask *mask)
 {
 	int num_rates = 0;
@@ -6443,7 +6443,7 @@ ath10k_mac_bitrate_mask_has_single_rate(struct ath10k *ar,
 
 static bool
 ath10k_mac_bitrate_mask_get_single_nss(struct ath10k *ar,
-				       enum ieee80211_band band,
+				       enum nl80211_band band,
 				       const struct cfg80211_bitrate_mask *mask,
 				       int *nss)
 {
@@ -6492,7 +6492,7 @@ ath10k_mac_bitrate_mask_get_single_nss(struct ath10k *ar,
 
 static int
 ath10k_mac_bitrate_mask_get_single_rate(struct ath10k *ar,
-					enum ieee80211_band band,
+					enum nl80211_band band,
 					const struct cfg80211_bitrate_mask *mask,
 					u8 *rate, u8 *nss)
 {
@@ -6593,7 +6593,7 @@ static int ath10k_mac_set_fixed_rate_params(struct ath10k_vif *arvif,
 
 static bool
 ath10k_mac_can_set_bitrate_mask(struct ath10k *ar,
-				enum ieee80211_band band,
+				enum nl80211_band band,
 				const struct cfg80211_bitrate_mask *mask)
 {
 	int i;
@@ -6645,7 +6645,7 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct cfg80211_chan_def def;
 	struct ath10k *ar = arvif->ar;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	const u8 *ht_mcs_mask;
 	const u16 *vht_mcs_mask;
 	u8 rate;
@@ -7275,7 +7275,7 @@ static const struct ieee80211_ops ath10k_ops = {
 };
 
 #define CHAN2G(_channel, _freq, _flags) { \
-	.band			= IEEE80211_BAND_2GHZ, \
+	.band			= NL80211_BAND_2GHZ, \
 	.hw_value		= (_channel), \
 	.center_freq		= (_freq), \
 	.flags			= (_flags), \
@@ -7284,7 +7284,7 @@ static const struct ieee80211_ops ath10k_ops = {
 }
 
 #define CHAN5G(_channel, _freq, _flags) { \
-	.band			= IEEE80211_BAND_5GHZ, \
+	.band			= NL80211_BAND_5GHZ, \
 	.hw_value		= (_channel), \
 	.center_freq		= (_freq), \
 	.flags			= (_flags), \
@@ -7604,13 +7604,13 @@ int ath10k_mac_register(struct ath10k *ar)
 			goto err_free;
 		}
 
-		band = &ar->mac.sbands[IEEE80211_BAND_2GHZ];
+		band = &ar->mac.sbands[NL80211_BAND_2GHZ];
 		band->n_channels = ARRAY_SIZE(ath10k_2ghz_channels);
 		band->channels = channels;
 		band->n_bitrates = ath10k_g_rates_size;
 		band->bitrates = ath10k_g_rates;
 
-		ar->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = band;
+		ar->hw->wiphy->bands[NL80211_BAND_2GHZ] = band;
 	}
 
 	if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY) {
@@ -7622,12 +7622,12 @@ int ath10k_mac_register(struct ath10k *ar)
 			goto err_free;
 		}
 
-		band = &ar->mac.sbands[IEEE80211_BAND_5GHZ];
+		band = &ar->mac.sbands[NL80211_BAND_5GHZ];
 		band->n_channels = ARRAY_SIZE(ath10k_5ghz_channels);
 		band->channels = channels;
 		band->n_bitrates = ath10k_a_rates_size;
 		band->bitrates = ath10k_a_rates;
-		ar->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = band;
+		ar->hw->wiphy->bands[NL80211_BAND_5GHZ] = band;
 	}
 
 	ath10k_mac_setup_ht_vht_cap(ar);
@@ -7815,8 +7815,8 @@ err_dfs_detector_exit:
 		ar->dfs_detector->exit(ar->dfs_detector);
 
 err_free:
-	kfree(ar->mac.sbands[IEEE80211_BAND_2GHZ].channels);
-	kfree(ar->mac.sbands[IEEE80211_BAND_5GHZ].channels);
+	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
+	kfree(ar->mac.sbands[NL80211_BAND_5GHZ].channels);
 
 	SET_IEEE80211_DEV(ar->hw, NULL);
 	return ret;
@@ -7829,8 +7829,8 @@ void ath10k_mac_unregister(struct ath10k *ar)
 	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED) && ar->dfs_detector)
 		ar->dfs_detector->exit(ar->dfs_detector);
 
-	kfree(ar->mac.sbands[IEEE80211_BAND_2GHZ].channels);
-	kfree(ar->mac.sbands[IEEE80211_BAND_5GHZ].channels);
+	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
+	kfree(ar->mac.sbands[NL80211_BAND_5GHZ].channels);
 
 	SET_IEEE80211_DEV(ar->hw, NULL);
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f7ec65f263a0..4c75c74be5e7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2281,9 +2281,9 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	 * of mgmt rx.
 	 */
 	if (channel >= 1 && channel <= 14) {
-		status->band = IEEE80211_BAND_2GHZ;
+		status->band = NL80211_BAND_2GHZ;
 	} else if (channel >= 36 && channel <= 165) {
-		status->band = IEEE80211_BAND_5GHZ;
+		status->band = NL80211_BAND_5GHZ;
 	} else {
 		/* Shouldn't happen unless list of advertised channels to
 		 * mac80211 has been changed.
@@ -2293,7 +2293,7 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		return 0;
 	}
 
-	if (phy_mode == MODE_11B && status->band == IEEE80211_BAND_5GHZ)
+	if (phy_mode == MODE_11B && status->band == NL80211_BAND_5GHZ)
 		ath10k_dbg(ar, ATH10K_DBG_MGMT, "wmi mgmt rx 11b (CCK) on 5GHz\n");
 
 	sband = &ar->mac.sbands[status->band];
@@ -2352,7 +2352,7 @@ static int freq_to_idx(struct ath10k *ar, int freq)
 	struct ieee80211_supported_band *sband;
 	int band, ch, idx = 0;
 
-	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = NL80211_BAND_2GHZ; band < NUM_NL80211_BANDS; band++) {
 		sband = ar->hw->wiphy->bands[band];
 		if (!sband)
 			continue;
diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index 38be2702c0e2..0624333f5430 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -279,7 +279,7 @@ ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as,
 		if (as->firstep_level < ATH5K_ANI_MAX_FIRSTEP_LVL)
 			ath5k_ani_set_firstep_level(ah, as->firstep_level + 1);
 		return;
-	} else if (ah->ah_current_channel->band == IEEE80211_BAND_2GHZ) {
+	} else if (ah->ah_current_channel->band == NL80211_BAND_2GHZ) {
 		/* beacon RSSI is low. in B/G mode turn of OFDM weak signal
 		 * detect and zero firstep level to maximize CCK sensitivity */
 		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI,
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index ba12f7f4061d..67fedb61fcc0 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1265,10 +1265,10 @@ struct ath5k_hw {
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
-	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
+	struct ieee80211_supported_band sbands[NUM_NL80211_BANDS];
 	struct ieee80211_channel channels[ATH_CHAN_MAX];
-	struct ieee80211_rate	rates[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
-	s8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
+	struct ieee80211_rate	rates[NUM_NL80211_BANDS][AR5K_MAX_RATES];
+	s8			rate_idx[NUM_NL80211_BANDS][AR5K_MAX_RATES];
 	enum nl80211_iftype	opmode;
 
 #ifdef CONFIG_ATH5K_DEBUG
@@ -1532,7 +1532,7 @@ int ath5k_eeprom_mode_from_channel(struct ath5k_hw *ah,
 
 /* Protocol Control Unit Functions */
 /* Helpers */
-int ath5k_hw_get_frame_duration(struct ath5k_hw *ah, enum ieee80211_band band,
+int ath5k_hw_get_frame_duration(struct ath5k_hw *ah, enum nl80211_band band,
 		int len, struct ieee80211_rate *rate, bool shortpre);
 unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah);
 unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah);
@@ -1611,7 +1611,7 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel);
 
 /* PHY functions */
 /* Misc PHY functions */
-u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, enum ieee80211_band band);
+u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, enum nl80211_band band);
 int ath5k_hw_phy_disable(struct ath5k_hw *ah);
 /* Gain_F optimization */
 enum ath5k_rfgain ath5k_hw_gainf_calibrate(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 66b6366158b9..233054bd6b52 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -152,7 +152,7 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 	ah->ah_phy_revision = ath5k_hw_reg_read(ah, AR5K_PHY_CHIP_ID) &
 			0xffffffff;
 	ah->ah_radio_5ghz_revision = ath5k_hw_radio_revision(ah,
-			IEEE80211_BAND_5GHZ);
+			NL80211_BAND_5GHZ);
 
 	/* Try to identify radio chip based on its srev */
 	switch (ah->ah_radio_5ghz_revision & 0xf0) {
@@ -160,14 +160,14 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 		ah->ah_radio = AR5K_RF5111;
 		ah->ah_single_chip = false;
 		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
-							IEEE80211_BAND_2GHZ);
+							NL80211_BAND_2GHZ);
 		break;
 	case AR5K_SREV_RAD_5112:
 	case AR5K_SREV_RAD_2112:
 		ah->ah_radio = AR5K_RF5112;
 		ah->ah_single_chip = false;
 		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
-							IEEE80211_BAND_2GHZ);
+							NL80211_BAND_2GHZ);
 		break;
 	case AR5K_SREV_RAD_2413:
 		ah->ah_radio = AR5K_RF2413;
@@ -204,7 +204,7 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 			ah->ah_radio = AR5K_RF5111;
 			ah->ah_single_chip = false;
 			ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
-							IEEE80211_BAND_2GHZ);
+							NL80211_BAND_2GHZ);
 		} else if (ah->ah_mac_version == (AR5K_SREV_AR2425 >> 4) ||
 			   ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4) ||
 			   ah->ah_phy_revision == AR5K_SREV_PHY_2425) {
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3d946d8b2db2..d98fd421c7ec 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -268,15 +268,15 @@ static void ath5k_reg_notifier(struct wiphy *wiphy,
  * Returns true for the channel numbers used.
  */
 #ifdef CONFIG_ATH5K_TEST_CHANNELS
-static bool ath5k_is_standard_channel(short chan, enum ieee80211_band band)
+static bool ath5k_is_standard_channel(short chan, enum nl80211_band band)
 {
 	return true;
 }
 
 #else
-static bool ath5k_is_standard_channel(short chan, enum ieee80211_band band)
+static bool ath5k_is_standard_channel(short chan, enum nl80211_band band)
 {
-	if (band == IEEE80211_BAND_2GHZ && chan <= 14)
+	if (band == NL80211_BAND_2GHZ && chan <= 14)
 		return true;
 
 	return	/* UNII 1,2 */
@@ -297,18 +297,18 @@ ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
 		unsigned int mode, unsigned int max)
 {
 	unsigned int count, size, freq, ch;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	switch (mode) {
 	case AR5K_MODE_11A:
 		/* 1..220, but 2GHz frequencies are filtered by check_channel */
 		size = 220;
-		band = IEEE80211_BAND_5GHZ;
+		band = NL80211_BAND_5GHZ;
 		break;
 	case AR5K_MODE_11B:
 	case AR5K_MODE_11G:
 		size = 26;
-		band = IEEE80211_BAND_2GHZ;
+		band = NL80211_BAND_2GHZ;
 		break;
 	default:
 		ATH5K_WARN(ah, "bad mode, not copying channels\n");
@@ -363,13 +363,13 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 	int max_c, count_c = 0;
 	int i;
 
-	BUILD_BUG_ON(ARRAY_SIZE(ah->sbands) < IEEE80211_NUM_BANDS);
+	BUILD_BUG_ON(ARRAY_SIZE(ah->sbands) < NUM_NL80211_BANDS);
 	max_c = ARRAY_SIZE(ah->channels);
 
 	/* 2GHz band */
-	sband = &ah->sbands[IEEE80211_BAND_2GHZ];
-	sband->band = IEEE80211_BAND_2GHZ;
-	sband->bitrates = &ah->rates[IEEE80211_BAND_2GHZ][0];
+	sband = &ah->sbands[NL80211_BAND_2GHZ];
+	sband->band = NL80211_BAND_2GHZ;
+	sband->bitrates = &ah->rates[NL80211_BAND_2GHZ][0];
 
 	if (test_bit(AR5K_MODE_11G, ah->ah_capabilities.cap_mode)) {
 		/* G mode */
@@ -381,7 +381,7 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 		sband->n_channels = ath5k_setup_channels(ah, sband->channels,
 					AR5K_MODE_11G, max_c);
 
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+		hw->wiphy->bands[NL80211_BAND_2GHZ] = sband;
 		count_c = sband->n_channels;
 		max_c -= count_c;
 	} else if (test_bit(AR5K_MODE_11B, ah->ah_capabilities.cap_mode)) {
@@ -407,7 +407,7 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 		sband->n_channels = ath5k_setup_channels(ah, sband->channels,
 					AR5K_MODE_11B, max_c);
 
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+		hw->wiphy->bands[NL80211_BAND_2GHZ] = sband;
 		count_c = sband->n_channels;
 		max_c -= count_c;
 	}
@@ -415,9 +415,9 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 
 	/* 5GHz band, A mode */
 	if (test_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode)) {
-		sband = &ah->sbands[IEEE80211_BAND_5GHZ];
-		sband->band = IEEE80211_BAND_5GHZ;
-		sband->bitrates = &ah->rates[IEEE80211_BAND_5GHZ][0];
+		sband = &ah->sbands[NL80211_BAND_5GHZ];
+		sband->band = NL80211_BAND_5GHZ;
+		sband->bitrates = &ah->rates[NL80211_BAND_5GHZ][0];
 
 		memcpy(sband->bitrates, &ath5k_rates[4],
 		       sizeof(struct ieee80211_rate) * 8);
@@ -427,7 +427,7 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 		sband->n_channels = ath5k_setup_channels(ah, sband->channels,
 					AR5K_MODE_11A, max_c);
 
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
+		hw->wiphy->bands[NL80211_BAND_5GHZ] = sband;
 	}
 	ath5k_setup_rate_idx(ah, sband);
 
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 654a1e33f827..929d7ccc031c 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -1043,14 +1043,14 @@ ath5k_debug_dump_bands(struct ath5k_hw *ah)
 
 	BUG_ON(!ah->sbands);
 
-	for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
+	for (b = 0; b < NUM_NL80211_BANDS; b++) {
 		struct ieee80211_supported_band *band = &ah->sbands[b];
 		char bname[6];
 		switch (band->band) {
-		case IEEE80211_BAND_2GHZ:
+		case NL80211_BAND_2GHZ:
 			strcpy(bname, "2 GHz");
 			break;
-		case IEEE80211_BAND_5GHZ:
+		case NL80211_BAND_5GHZ:
 			strcpy(bname, "5 GHz");
 			break;
 		default:
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index bf29da5e90da..fc47b70988b1 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -110,7 +110,7 @@ static const unsigned int ack_rates_high[] =
  * bwmodes.
  */
 int
-ath5k_hw_get_frame_duration(struct ath5k_hw *ah, enum ieee80211_band band,
+ath5k_hw_get_frame_duration(struct ath5k_hw *ah, enum nl80211_band band,
 		int len, struct ieee80211_rate *rate, bool shortpre)
 {
 	int sifs, preamble, plcp_bits, sym_time;
@@ -221,7 +221,7 @@ ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
 	case AR5K_BWMODE_DEFAULT:
 		sifs = AR5K_INIT_SIFS_DEFAULT_BG;
 	default:
-		if (channel->band == IEEE80211_BAND_5GHZ)
+		if (channel->band == NL80211_BAND_5GHZ)
 			sifs = AR5K_INIT_SIFS_DEFAULT_A;
 		break;
 	}
@@ -279,7 +279,7 @@ ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
 	struct ieee80211_rate *rate;
 	unsigned int i;
 	/* 802.11g covers both OFDM and CCK */
-	u8 band = IEEE80211_BAND_2GHZ;
+	u8 band = NL80211_BAND_2GHZ;
 
 	/* Write rate duration table */
 	for (i = 0; i < ah->sbands[band].n_bitrates; i++) {
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 98ee85456321..641b13a279e1 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -75,13 +75,13 @@
 /**
  * ath5k_hw_radio_revision() - Get the PHY Chip revision
  * @ah: The &struct ath5k_hw
- * @band: One of enum ieee80211_band
+ * @band: One of enum nl80211_band
  *
  * Returns the revision number of a 2GHz, 5GHz or single chip
  * radio.
  */
 u16
-ath5k_hw_radio_revision(struct ath5k_hw *ah, enum ieee80211_band band)
+ath5k_hw_radio_revision(struct ath5k_hw *ah, enum nl80211_band band)
 {
 	unsigned int i;
 	u32 srev;
@@ -91,10 +91,10 @@ ath5k_hw_radio_revision(struct ath5k_hw *ah, enum ieee80211_band band)
 	 * Set the radio chip access register
 	 */
 	switch (band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_2GHZ, AR5K_PHY(0));
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
 		break;
 	default:
@@ -138,11 +138,11 @@ ath5k_channel_ok(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 	u16 freq = channel->center_freq;
 
 	/* Check if the channel is in our supported range */
-	if (channel->band == IEEE80211_BAND_2GHZ) {
+	if (channel->band == NL80211_BAND_2GHZ) {
 		if ((freq >= ah->ah_capabilities.cap_range.range_2ghz_min) &&
 		    (freq <= ah->ah_capabilities.cap_range.range_2ghz_max))
 			return true;
-	} else if (channel->band == IEEE80211_BAND_5GHZ)
+	} else if (channel->band == NL80211_BAND_5GHZ)
 		if ((freq >= ah->ah_capabilities.cap_range.range_5ghz_min) &&
 		    (freq <= ah->ah_capabilities.cap_range.range_5ghz_max))
 			return true;
@@ -743,7 +743,7 @@ done:
 /**
  * ath5k_hw_rfgain_init() - Write initial RF gain settings to hw
  * @ah: The &struct ath5k_hw
- * @band: One of enum ieee80211_band
+ * @band: One of enum nl80211_band
  *
  * Write initial RF gain table to set the RF sensitivity.
  *
@@ -751,7 +751,7 @@ done:
  * with Gain_F calibration
  */
 static int
-ath5k_hw_rfgain_init(struct ath5k_hw *ah, enum ieee80211_band band)
+ath5k_hw_rfgain_init(struct ath5k_hw *ah, enum nl80211_band band)
 {
 	const struct ath5k_ini_rfgain *ath5k_rfg;
 	unsigned int i, size, index;
@@ -786,7 +786,7 @@ ath5k_hw_rfgain_init(struct ath5k_hw *ah, enum ieee80211_band band)
 		return -EINVAL;
 	}
 
-	index = (band == IEEE80211_BAND_2GHZ) ? 1 : 0;
+	index = (band == NL80211_BAND_2GHZ) ? 1 : 0;
 
 	for (i = 0; i < size; i++) {
 		AR5K_REG_WAIT(i);
@@ -917,7 +917,7 @@ ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 	}
 
 	/* Set Output and Driver bias current (OB/DB) */
-	if (channel->band == IEEE80211_BAND_2GHZ) {
+	if (channel->band == NL80211_BAND_2GHZ) {
 
 		if (channel->hw_value == AR5K_MODE_11B)
 			ee_mode = AR5K_EEPROM_MODE_11B;
@@ -944,7 +944,7 @@ ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 						AR5K_RF_DB_2GHZ, true);
 
 	/* RF5111 always needs OB/DB for 5GHz, even if we use 2GHz */
-	} else if ((channel->band == IEEE80211_BAND_5GHZ) ||
+	} else if ((channel->band == NL80211_BAND_5GHZ) ||
 			(ah->ah_radio == AR5K_RF5111)) {
 
 		/* For 11a, Turbo and XR we need to choose
@@ -1145,7 +1145,7 @@ ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 	}
 
 	if (ah->ah_radio == AR5K_RF5413 &&
-	channel->band == IEEE80211_BAND_2GHZ) {
+	channel->band == NL80211_BAND_2GHZ) {
 
 		ath5k_hw_rfb_op(ah, rf_regs, 1, AR5K_RF_DERBY_CHAN_SEL_MODE,
 									true);
@@ -1270,7 +1270,7 @@ ath5k_hw_rf5111_channel(struct ath5k_hw *ah,
 	 */
 	data0 = data1 = 0;
 
-	if (channel->band == IEEE80211_BAND_2GHZ) {
+	if (channel->band == NL80211_BAND_2GHZ) {
 		/* Map 2GHz channel to 5GHz Atheros channel ID */
 		ret = ath5k_hw_rf5111_chan2athchan(
 			ieee80211_frequency_to_channel(channel->center_freq),
@@ -1919,7 +1919,7 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 	/* Convert current frequency to fbin value (the same way channels
 	 * are stored on EEPROM, check out ath5k_eeprom_bin2freq) and scale
 	 * up by 2 so we can compare it later */
-	if (channel->band == IEEE80211_BAND_2GHZ) {
+	if (channel->band == NL80211_BAND_2GHZ) {
 		chan_fbin = (channel->center_freq - 2300) * 10;
 		freq_band = AR5K_EEPROM_BAND_2GHZ;
 	} else {
@@ -1983,7 +1983,7 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz / 4;
 			break;
 		default:
-			if (channel->band == IEEE80211_BAND_5GHZ) {
+			if (channel->band == NL80211_BAND_5GHZ) {
 				/* Both sample_freq and chip_freq are 40MHz */
 				spur_delta_phase = (spur_offset << 17) / 25;
 				spur_freq_sigma_delta =
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index ddaad712c59a..beda11ce34a7 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -559,7 +559,7 @@ ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *rate;
 	u32 ack_tx_time, eifs, eifs_clock, sifs, sifs_clock;
@@ -596,10 +596,10 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 	 *
 	 * Also we have different lowest rate for 802.11a
 	 */
-	if (channel->band == IEEE80211_BAND_5GHZ)
-		band = IEEE80211_BAND_5GHZ;
+	if (channel->band == NL80211_BAND_5GHZ)
+		band = NL80211_BAND_5GHZ;
 	else
-		band = IEEE80211_BAND_2GHZ;
+		band = NL80211_BAND_2GHZ;
 
 	switch (ah->ah_bwmode) {
 	case AR5K_BWMODE_5MHZ:
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 4b1c87fa15ac..56d7925a0c2c 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -752,7 +752,7 @@ ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 			clock = AR5K_PHY_PLL_RF5111;		/*Zero*/
 		}
 
-		if (channel->band == IEEE80211_BAND_2GHZ) {
+		if (channel->band == NL80211_BAND_2GHZ) {
 			mode |= AR5K_PHY_MODE_FREQ_2GHZ;
 			clock |= AR5K_PHY_PLL_44MHZ;
 
@@ -771,7 +771,7 @@ ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 				else
 					mode |= AR5K_PHY_MODE_MOD_DYN;
 			}
-		} else if (channel->band == IEEE80211_BAND_5GHZ) {
+		} else if (channel->band == NL80211_BAND_5GHZ) {
 			mode |= (AR5K_PHY_MODE_FREQ_5GHZ |
 				 AR5K_PHY_MODE_MOD_OFDM);
 
@@ -906,7 +906,7 @@ ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
 		u32 data;
 		ath5k_hw_reg_write(ah, AR5K_PHY_CCKTXCTL_WORLD,
 				AR5K_PHY_CCKTXCTL);
-		if (channel->band == IEEE80211_BAND_5GHZ)
+		if (channel->band == NL80211_BAND_5GHZ)
 			data = 0xffb81020;
 		else
 			data = 0xffb80d20;
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 7f3f94fbf157..4e11ba06f089 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -34,7 +34,7 @@
 }
 
 #define CHAN2G(_channel, _freq, _flags) {   \
-	.band           = IEEE80211_BAND_2GHZ,  \
+	.band           = NL80211_BAND_2GHZ,  \
 	.hw_value       = (_channel),           \
 	.center_freq    = (_freq),              \
 	.flags          = (_flags),             \
@@ -43,7 +43,7 @@
 }
 
 #define CHAN5G(_channel, _flags) {		    \
-	.band           = IEEE80211_BAND_5GHZ,      \
+	.band           = NL80211_BAND_5GHZ,      \
 	.hw_value       = (_channel),               \
 	.center_freq    = 5000 + (5 * (_channel)),  \
 	.flags          = (_flags),                 \
@@ -2583,7 +2583,7 @@ void ath6kl_check_wow_status(struct ath6kl *ar)
 }
 #endif
 
-static int ath6kl_set_htcap(struct ath6kl_vif *vif, enum ieee80211_band band,
+static int ath6kl_set_htcap(struct ath6kl_vif *vif, enum nl80211_band band,
 			    bool ht_enable)
 {
 	struct ath6kl_htcap *htcap = &vif->htcap[band];
@@ -2594,7 +2594,7 @@ static int ath6kl_set_htcap(struct ath6kl_vif *vif, enum ieee80211_band band,
 	if (ht_enable) {
 		/* Set default ht capabilities */
 		htcap->ht_enable = true;
-		htcap->cap_info = (band == IEEE80211_BAND_2GHZ) ?
+		htcap->cap_info = (band == NL80211_BAND_2GHZ) ?
 				   ath6kl_g_htcap : ath6kl_a_htcap;
 		htcap->ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K;
 	} else /* Disable ht */
@@ -2609,7 +2609,7 @@ static int ath6kl_restore_htcap(struct ath6kl_vif *vif)
 	struct wiphy *wiphy = vif->ar->wiphy;
 	int band, ret = 0;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		if (!wiphy->bands[band])
 			continue;
 
@@ -3530,7 +3530,7 @@ static void ath6kl_cfg80211_reg_notify(struct wiphy *wiphy,
 				       struct regulatory_request *request)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
-	u32 rates[IEEE80211_NUM_BANDS];
+	u32 rates[NUM_NL80211_BANDS];
 	int ret, i;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
@@ -3555,7 +3555,7 @@ static void ath6kl_cfg80211_reg_notify(struct wiphy *wiphy,
 	 * changed.
 	 */
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+	for (i = 0; i < NUM_NL80211_BANDS; i++)
 		if (wiphy->bands[i])
 			rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
 
@@ -3791,8 +3791,8 @@ struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, const char *name,
 	vif->listen_intvl_t = ATH6KL_DEFAULT_LISTEN_INTVAL;
 	vif->bmiss_time_t = ATH6KL_DEFAULT_BMISS_TIME;
 	vif->bg_scan_period = 0;
-	vif->htcap[IEEE80211_BAND_2GHZ].ht_enable = true;
-	vif->htcap[IEEE80211_BAND_5GHZ].ht_enable = true;
+	vif->htcap[NL80211_BAND_2GHZ].ht_enable = true;
+	vif->htcap[NL80211_BAND_5GHZ].ht_enable = true;
 
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
 	if (fw_vif_idx != 0) {
@@ -3943,9 +3943,9 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	wiphy->available_antennas_rx = ar->hw.rx_ant;
 
 	if (band_2gig)
-		wiphy->bands[IEEE80211_BAND_2GHZ] = &ath6kl_band_2ghz;
+		wiphy->bands[NL80211_BAND_2GHZ] = &ath6kl_band_2ghz;
 	if (band_5gig)
-		wiphy->bands[IEEE80211_BAND_5GHZ] = &ath6kl_band_5ghz;
+		wiphy->bands[NL80211_BAND_5GHZ] = &ath6kl_band_5ghz;
 
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 5f3acfe6015e..713a571a27ce 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -623,7 +623,7 @@ struct ath6kl_vif {
 	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
 	struct ath6kl_key keys[WMI_MAX_KEY_INDEX + 1];
 	struct aggr_info *aggr_cntxt;
-	struct ath6kl_htcap htcap[IEEE80211_NUM_BANDS];
+	struct ath6kl_htcap htcap[NUM_NL80211_BANDS];
 
 	struct timer_list disconnect_timer;
 	struct timer_list sched_scan_timer;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 0b3e9c0293e0..631c3a0c572b 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2048,7 +2048,7 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 	sc->no_cck = cpu_to_le32(no_cck);
 	sc->num_ch = num_chan;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		sband = ar->wiphy->bands[band];
 
 		if (!sband)
@@ -2770,10 +2770,10 @@ static int ath6kl_set_bitrate_mask64(struct wmi *wmi, u8 if_idx,
 	memset(&ratemask, 0, sizeof(ratemask));
 
 	/* only check 2.4 and 5 GHz bands, skip the rest */
-	for (band = 0; band <= IEEE80211_BAND_5GHZ; band++) {
+	for (band = 0; band <= NL80211_BAND_5GHZ; band++) {
 		/* copy legacy rate mask */
 		ratemask[band] = mask->control[band].legacy;
-		if (band == IEEE80211_BAND_5GHZ)
+		if (band == NL80211_BAND_5GHZ)
 			ratemask[band] =
 				mask->control[band].legacy << 4;
 
@@ -2799,9 +2799,9 @@ static int ath6kl_set_bitrate_mask64(struct wmi *wmi, u8 if_idx,
 		if (mode == WMI_RATES_MODE_11A ||
 		    mode == WMI_RATES_MODE_11A_HT20 ||
 		    mode == WMI_RATES_MODE_11A_HT40)
-			band = IEEE80211_BAND_5GHZ;
+			band = NL80211_BAND_5GHZ;
 		else
-			band = IEEE80211_BAND_2GHZ;
+			band = NL80211_BAND_2GHZ;
 		cmd->ratemask[mode] = cpu_to_le64(ratemask[band]);
 	}
 
@@ -2822,10 +2822,10 @@ static int ath6kl_set_bitrate_mask32(struct wmi *wmi, u8 if_idx,
 	memset(&ratemask, 0, sizeof(ratemask));
 
 	/* only check 2.4 and 5 GHz bands, skip the rest */
-	for (band = 0; band <= IEEE80211_BAND_5GHZ; band++) {
+	for (band = 0; band <= NL80211_BAND_5GHZ; band++) {
 		/* copy legacy rate mask */
 		ratemask[band] = mask->control[band].legacy;
-		if (band == IEEE80211_BAND_5GHZ)
+		if (band == NL80211_BAND_5GHZ)
 			ratemask[band] =
 				mask->control[band].legacy << 4;
 
@@ -2849,9 +2849,9 @@ static int ath6kl_set_bitrate_mask32(struct wmi *wmi, u8 if_idx,
 		if (mode == WMI_RATES_MODE_11A ||
 		    mode == WMI_RATES_MODE_11A_HT20 ||
 		    mode == WMI_RATES_MODE_11A_HT40)
-			band = IEEE80211_BAND_5GHZ;
+			band = NL80211_BAND_5GHZ;
 		else
-			band = IEEE80211_BAND_2GHZ;
+			band = NL80211_BAND_2GHZ;
 		cmd->ratemask[mode] = cpu_to_le32(ratemask[band]);
 	}
 
@@ -3174,7 +3174,7 @@ int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 if_idx,
 }
 
 int ath6kl_wmi_set_htcap_cmd(struct wmi *wmi, u8 if_idx,
-			     enum ieee80211_band band,
+			     enum nl80211_band band,
 			     struct ath6kl_htcap *htcap)
 {
 	struct sk_buff *skb;
@@ -3187,7 +3187,7 @@ int ath6kl_wmi_set_htcap_cmd(struct wmi *wmi, u8 if_idx,
 	cmd = (struct wmi_set_htcap_cmd *) skb->data;
 
 	/*
-	 * NOTE: Band in firmware matches enum ieee80211_band, it is unlikely
+	 * NOTE: Band in firmware matches enum nl80211_band, it is unlikely
 	 * this will be changed in firmware. If at all there is any change in
 	 * band value, the host needs to be fixed.
 	 */
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 05d25a94c781..3af464a73b58 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2628,7 +2628,7 @@ int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, u8 if_idx, enum wmi_txop_cfg cfg);
 int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 if_idx,
 				 u8 keep_alive_intvl);
 int ath6kl_wmi_set_htcap_cmd(struct wmi *wmi, u8 if_idx,
-			     enum ieee80211_band band,
+			     enum nl80211_band band,
 			     struct ath6kl_htcap *htcap);
 int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len);
 
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 37f6d66d1671..0f71146b781d 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -145,14 +145,14 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
 }
 
 static bool ath9k_hw_get_nf_thresh(struct ath_hw *ah,
-				   enum ieee80211_band band,
+				   enum nl80211_band band,
 				   int16_t *nft)
 {
 	switch (band) {
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		*nft = (int8_t)ah->eep_ops->get_eeprom(ah, EEP_NFTHRESH_5);
 		break;
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		*nft = (int8_t)ah->eep_ops->get_eeprom(ah, EEP_NFTHRESH_2);
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 319cb5f25f58..e56bafcf5864 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -107,9 +107,9 @@ void ath_chanctx_init(struct ath_softc *sc)
 	struct ieee80211_channel *chan;
 	int i, j;
 
-	sband = &common->sbands[IEEE80211_BAND_2GHZ];
+	sband = &common->sbands[NL80211_BAND_2GHZ];
 	if (!sband->n_channels)
-		sband = &common->sbands[IEEE80211_BAND_5GHZ];
+		sband = &common->sbands[NL80211_BAND_5GHZ];
 
 	chan = &sband->channels[0];
 	for (i = 0; i < ATH9K_NUM_CHANCTX; i++) {
@@ -1333,9 +1333,9 @@ void ath9k_offchannel_init(struct ath_softc *sc)
 	struct ieee80211_channel *chan;
 	int i;
 
-	sband = &common->sbands[IEEE80211_BAND_2GHZ];
+	sband = &common->sbands[NL80211_BAND_2GHZ];
 	if (!sband->n_channels)
-		sband = &common->sbands[IEEE80211_BAND_5GHZ];
+		sband = &common->sbands[NL80211_BAND_5GHZ];
 
 	chan = &sband->channels[0];
 
diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
index a006c1499728..8b4f7fdabf58 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.c
+++ b/drivers/net/wireless/ath/ath9k/common-init.c
@@ -19,14 +19,14 @@
 #include "common.h"
 
 #define CHAN2G(_freq, _idx)  { \
-	.band = IEEE80211_BAND_2GHZ, \
+	.band = NL80211_BAND_2GHZ, \
 	.center_freq = (_freq), \
 	.hw_value = (_idx), \
 	.max_power = 20, \
 }
 
 #define CHAN5G(_freq, _idx) { \
-	.band = IEEE80211_BAND_5GHZ, \
+	.band = NL80211_BAND_5GHZ, \
 	.center_freq = (_freq), \
 	.hw_value = (_idx), \
 	.max_power = 20, \
@@ -139,12 +139,12 @@ int ath9k_cmn_init_channels_rates(struct ath_common *common)
 
 		memcpy(channels, ath9k_2ghz_chantable,
 		       sizeof(ath9k_2ghz_chantable));
-		common->sbands[IEEE80211_BAND_2GHZ].channels = channels;
-		common->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
-		common->sbands[IEEE80211_BAND_2GHZ].n_channels =
+		common->sbands[NL80211_BAND_2GHZ].channels = channels;
+		common->sbands[NL80211_BAND_2GHZ].band = NL80211_BAND_2GHZ;
+		common->sbands[NL80211_BAND_2GHZ].n_channels =
 			ARRAY_SIZE(ath9k_2ghz_chantable);
-		common->sbands[IEEE80211_BAND_2GHZ].bitrates = ath9k_legacy_rates;
-		common->sbands[IEEE80211_BAND_2GHZ].n_bitrates =
+		common->sbands[NL80211_BAND_2GHZ].bitrates = ath9k_legacy_rates;
+		common->sbands[NL80211_BAND_2GHZ].n_bitrates =
 			ARRAY_SIZE(ath9k_legacy_rates);
 	}
 
@@ -156,13 +156,13 @@ int ath9k_cmn_init_channels_rates(struct ath_common *common)
 
 		memcpy(channels, ath9k_5ghz_chantable,
 		       sizeof(ath9k_5ghz_chantable));
-		common->sbands[IEEE80211_BAND_5GHZ].channels = channels;
-		common->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
-		common->sbands[IEEE80211_BAND_5GHZ].n_channels =
+		common->sbands[NL80211_BAND_5GHZ].channels = channels;
+		common->sbands[NL80211_BAND_5GHZ].band = NL80211_BAND_5GHZ;
+		common->sbands[NL80211_BAND_5GHZ].n_channels =
 			ARRAY_SIZE(ath9k_5ghz_chantable);
-		common->sbands[IEEE80211_BAND_5GHZ].bitrates =
+		common->sbands[NL80211_BAND_5GHZ].bitrates =
 			ath9k_legacy_rates + 4;
-		common->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
+		common->sbands[NL80211_BAND_5GHZ].n_bitrates =
 			ARRAY_SIZE(ath9k_legacy_rates) - 4;
 	}
 	return 0;
@@ -236,9 +236,9 @@ void ath9k_cmn_reload_chainmask(struct ath_hw *ah)
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 		ath9k_cmn_setup_ht_cap(ah,
-			&common->sbands[IEEE80211_BAND_2GHZ].ht_cap);
+			&common->sbands[NL80211_BAND_2GHZ].ht_cap);
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
 		ath9k_cmn_setup_ht_cap(ah,
-			&common->sbands[IEEE80211_BAND_5GHZ].ht_cap);
+			&common->sbands[NL80211_BAND_5GHZ].ht_cap);
 }
 EXPORT_SYMBOL(ath9k_cmn_reload_chainmask);
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index e8c699446470..b80e08b13b74 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -173,7 +173,7 @@ int ath9k_cmn_process_rate(struct ath_common *common,
 			   struct ieee80211_rx_status *rxs)
 {
 	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	unsigned int i = 0;
 	struct ath_hw *ah = common->ah;
 
@@ -305,7 +305,7 @@ static void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
 	ichan->channel = chan->center_freq;
 	ichan->chan = chan;
 
-	if (chan->band == IEEE80211_BAND_5GHZ)
+	if (chan->band == NL80211_BAND_5GHZ)
 		flags |= CHANNEL_5GHZ;
 
 	switch (chandef->width) {
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index c2ca57a2ed09..b66cfa91364f 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -139,7 +139,7 @@ void ath_debug_rate_stats(struct ath_softc *sc,
 	}
 
 	if (IS_OFDM_RATE(rs->rs_rate)) {
-		if (ah->curchan->chan->band == IEEE80211_BAND_2GHZ)
+		if (ah->curchan->chan->band == NL80211_BAND_2GHZ)
 			rstats->ofdm_stats[rxs->rate_idx - 4].ofdm_cnt++;
 		else
 			rstats->ofdm_stats[rxs->rate_idx].ofdm_cnt++;
@@ -173,7 +173,7 @@ static ssize_t read_file_node_recv(struct file *file, char __user *user_buf,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_rx_rate_stats *rstats;
 	struct ieee80211_sta *sta = an->sta;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	u32 len = 0, size = 4096;
 	char *buf;
 	size_t retval;
@@ -206,7 +206,7 @@ static ssize_t read_file_node_recv(struct file *file, char __user *user_buf,
 	len += scnprintf(buf + len, size - len, "\n");
 
 legacy:
-	if (band == IEEE80211_BAND_2GHZ) {
+	if (band == NL80211_BAND_2GHZ) {
 		PRINT_CCK_RATE("CCK-1M/LP", 0, false);
 		PRINT_CCK_RATE("CCK-2M/LP", 1, false);
 		PRINT_CCK_RATE("CCK-5.5M/LP", 2, false);
diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index 22b3cc4c27cd..d2ff0fc0484c 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -212,7 +212,7 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
 		struct ieee80211_tx_rate *rates = info->status.rates;
 
 		rate = &common->sbands[info->band].bitrates[rates[ridx].idx];
-		if (info->band == IEEE80211_BAND_2GHZ &&
+		if (info->band == NL80211_BAND_2GHZ &&
 		    !(rate->flags & IEEE80211_RATE_ERP_G))
 			phy = WLAN_RC_PHY_CCK;
 		else
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index c2249ad54085..c148c6c504f7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -765,11 +765,11 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		sizeof(struct htc_frame_hdr) + 4;
 
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&common->sbands[IEEE80211_BAND_2GHZ];
+		hw->wiphy->bands[NL80211_BAND_2GHZ] =
+			&common->sbands[NL80211_BAND_2GHZ];
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&common->sbands[IEEE80211_BAND_5GHZ];
+		hw->wiphy->bands[NL80211_BAND_5GHZ] =
+			&common->sbands[NL80211_BAND_5GHZ];
 
 	ath9k_cmn_reload_chainmask(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 639294a9e34d..8a8d7853da15 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1770,8 +1770,8 @@ static int ath9k_htc_set_bitrate_mask(struct ieee80211_hw *hw,
 	memset(&tmask, 0, sizeof(struct ath9k_htc_target_rate_mask));
 
 	tmask.vif_index = avp->index;
-	tmask.band = IEEE80211_BAND_2GHZ;
-	tmask.mask = cpu_to_be32(mask->control[IEEE80211_BAND_2GHZ].legacy);
+	tmask.band = NL80211_BAND_2GHZ;
+	tmask.mask = cpu_to_be32(mask->control[NL80211_BAND_2GHZ].legacy);
 
 	WMI_CMD_BUF(WMI_BITRATE_MASK_CMDID, &tmask);
 	if (ret) {
@@ -1781,8 +1781,8 @@ static int ath9k_htc_set_bitrate_mask(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	tmask.band = IEEE80211_BAND_5GHZ;
-	tmask.mask = cpu_to_be32(mask->control[IEEE80211_BAND_5GHZ].legacy);
+	tmask.band = NL80211_BAND_5GHZ;
+	tmask.mask = cpu_to_be32(mask->control[NL80211_BAND_5GHZ].legacy);
 
 	WMI_CMD_BUF(WMI_BITRATE_MASK_CMDID, &tmask);
 	if (ret) {
@@ -1793,8 +1793,8 @@ static int ath9k_htc_set_bitrate_mask(struct ieee80211_hw *hw,
 	}
 
 	ath_dbg(common, CONFIG, "Set bitrate masks: 0x%x, 0x%x\n",
-		mask->control[IEEE80211_BAND_2GHZ].legacy,
-		mask->control[IEEE80211_BAND_5GHZ].legacy);
+		mask->control[NL80211_BAND_2GHZ].legacy,
+		mask->control[NL80211_BAND_5GHZ].legacy);
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index cc9648f844ae..f333ef1e3e7b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -494,7 +494,7 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 		if (txs->ts_flags & ATH9K_HTC_TXSTAT_SGI)
 			rate->flags |= IEEE80211_TX_RC_SHORT_GI;
 	} else {
-		if (cur_conf->chandef.chan->band == IEEE80211_BAND_5GHZ)
+		if (cur_conf->chandef.chan->band == NL80211_BAND_5GHZ)
 			rate->idx += 4; /* No CCK rates */
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 77ace8d72d54..4bf1e244b49b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -705,9 +705,9 @@ static void ath9k_init_txpower_limits(struct ath_softc *sc)
 	struct ath9k_channel *curchan = ah->curchan;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
-		ath9k_init_band_txpower(sc, IEEE80211_BAND_2GHZ);
+		ath9k_init_band_txpower(sc, NL80211_BAND_2GHZ);
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
-		ath9k_init_band_txpower(sc, IEEE80211_BAND_5GHZ);
+		ath9k_init_band_txpower(sc, NL80211_BAND_5GHZ);
 
 	ah->curchan = curchan;
 }
@@ -879,11 +879,11 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	sc->ant_tx = hw->wiphy->available_antennas_tx;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&common->sbands[IEEE80211_BAND_2GHZ];
+		hw->wiphy->bands[NL80211_BAND_2GHZ] =
+			&common->sbands[NL80211_BAND_2GHZ];
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&common->sbands[IEEE80211_BAND_5GHZ];
+		hw->wiphy->bands[NL80211_BAND_5GHZ] =
+			&common->sbands[NL80211_BAND_5GHZ];
 
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 	ath9k_set_mcc_capab(sc, hw);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 50ec4c9a9da7..8b6398850657 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1933,14 +1933,14 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx == 0)
 		ath_update_survey_stats(sc);
 
-	sband = hw->wiphy->bands[IEEE80211_BAND_2GHZ];
+	sband = hw->wiphy->bands[NL80211_BAND_2GHZ];
 	if (sband && idx >= sband->n_channels) {
 		idx -= sband->n_channels;
 		sband = NULL;
 	}
 
 	if (!sband)
-		sband = hw->wiphy->bands[IEEE80211_BAND_5GHZ];
+		sband = hw->wiphy->bands[NL80211_BAND_5GHZ];
 
 	if (!sband || idx >= sband->n_channels) {
 		spin_unlock_bh(&common->cc_lock);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index fe795fc5288c..8ddd604bd00c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1112,7 +1112,7 @@ static u8 ath_get_rate_txpower(struct ath_softc *sc, struct ath_buf *bf,
 				bool is_2ghz;
 				struct modal_eep_header *pmodal;
 
-				is_2ghz = info->band == IEEE80211_BAND_2GHZ;
+				is_2ghz = info->band == NL80211_BAND_2GHZ;
 				pmodal = &eep->modalHeader[is_2ghz];
 				power_ht40delta = pmodal->ht40PowerIncForPdadc;
 			} else {
@@ -1236,7 +1236,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 
 		/* legacy rates */
 		rate = &common->sbands[tx_info->band].bitrates[rates[i].idx];
-		if ((tx_info->band == IEEE80211_BAND_2GHZ) &&
+		if ((tx_info->band == NL80211_BAND_2GHZ) &&
 		    !(rate->flags & IEEE80211_RATE_ERP_G))
 			phy = WLAN_RC_PHY_CCK;
 		else
diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index a2f005703c04..7d4a72dc98db 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -48,7 +48,7 @@ int carl9170_set_dyn_sifs_ack(struct ar9170 *ar)
 	if (conf_is_ht40(&ar->hw->conf))
 		val = 0x010a;
 	else {
-		if (ar->hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
+		if (ar->hw->conf.chandef.chan->band == NL80211_BAND_2GHZ)
 			val = 0x105;
 		else
 			val = 0x104;
@@ -66,7 +66,7 @@ int carl9170_set_rts_cts_rate(struct ar9170 *ar)
 		rts_rate = 0x1da;
 		cts_rate = 0x10a;
 	} else {
-		if (ar->hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ) {
+		if (ar->hw->conf.chandef.chan->band == NL80211_BAND_2GHZ) {
 			/* 11 mbit CCK */
 			rts_rate = 033;
 			cts_rate = 003;
@@ -93,7 +93,7 @@ int carl9170_set_slot_time(struct ar9170 *ar)
 		return 0;
 	}
 
-	if ((ar->hw->conf.chandef.chan->band == IEEE80211_BAND_5GHZ) ||
+	if ((ar->hw->conf.chandef.chan->band == NL80211_BAND_5GHZ) ||
 	    vif->bss_conf.use_short_slot)
 		slottime = 9;
 
@@ -120,7 +120,7 @@ int carl9170_set_mac_rates(struct ar9170 *ar)
 	basic |= (vif->bss_conf.basic_rates & 0xff0) << 4;
 	rcu_read_unlock();
 
-	if (ar->hw->conf.chandef.chan->band == IEEE80211_BAND_5GHZ)
+	if (ar->hw->conf.chandef.chan->band == NL80211_BAND_5GHZ)
 		mandatory = 0xff00; /* OFDM 6/9/12/18/24/36/48/54 */
 	else
 		mandatory = 0xff0f; /* OFDM (6/9../54) + CCK (1/2/5.5/11) */
@@ -512,10 +512,10 @@ int carl9170_set_mac_tpc(struct ar9170 *ar, struct ieee80211_channel *channel)
 		chains = AR9170_TX_PHY_TXCHAIN_1;
 
 	switch (channel->band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		power = ar->power_2G_ofdm[0] & 0x3f;
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		power = ar->power_5G_leg[0] & 0x3f;
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 4d1527a2e292..ffb22a04beeb 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1666,7 +1666,7 @@ static int carl9170_op_get_survey(struct ieee80211_hw *hw, int idx,
 			return err;
 	}
 
-	for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
+	for (b = 0; b < NUM_NL80211_BANDS; b++) {
 		band = ar->hw->wiphy->bands[b];
 
 		if (!band)
@@ -1941,13 +1941,13 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 	}
 
 	if (ar->eeprom.operating_flags & AR9170_OPFLAG_2GHZ) {
-		ar->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+		ar->hw->wiphy->bands[NL80211_BAND_2GHZ] =
 			&carl9170_band_2GHz;
 		chans += carl9170_band_2GHz.n_channels;
 		bands++;
 	}
 	if (ar->eeprom.operating_flags & AR9170_OPFLAG_5GHZ) {
-		ar->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+		ar->hw->wiphy->bands[NL80211_BAND_5GHZ] =
 			&carl9170_band_5GHz;
 		chans += carl9170_band_5GHz.n_channels;
 		bands++;
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index dca6df13fd5b..34d9fd77046e 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -540,11 +540,11 @@ static int carl9170_init_phy_from_eeprom(struct ar9170 *ar,
 	return carl9170_regwrite_result();
 }
 
-static int carl9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
+static int carl9170_init_phy(struct ar9170 *ar, enum nl80211_band band)
 {
 	int i, err;
 	u32 val;
-	bool is_2ghz = band == IEEE80211_BAND_2GHZ;
+	bool is_2ghz = band == NL80211_BAND_2GHZ;
 	bool is_40mhz = conf_is_ht40(&ar->hw->conf);
 
 	carl9170_regwrite_begin(ar);
@@ -1125,13 +1125,13 @@ static int carl9170_set_freq_cal_data(struct ar9170 *ar,
 	u8 f, tmp;
 
 	switch (channel->band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		f = channel->center_freq - 2300;
 		cal_freq_pier = ar->eeprom.cal_freq_pier_2G;
 		i = AR5416_NUM_2G_CAL_PIERS - 1;
 		break;
 
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		f = (channel->center_freq - 4800) / 5;
 		cal_freq_pier = ar->eeprom.cal_freq_pier_5G;
 		i = AR5416_NUM_5G_CAL_PIERS - 1;
@@ -1158,12 +1158,12 @@ static int carl9170_set_freq_cal_data(struct ar9170 *ar,
 			int j;
 
 			switch (channel->band) {
-			case IEEE80211_BAND_2GHZ:
+			case NL80211_BAND_2GHZ:
 				cal_pier_data = &ar->eeprom.
 					cal_pier_data_2G[chain][idx];
 				break;
 
-			case IEEE80211_BAND_5GHZ:
+			case NL80211_BAND_5GHZ:
 				cal_pier_data = &ar->eeprom.
 					cal_pier_data_5G[chain][idx];
 				break;
@@ -1340,7 +1340,7 @@ static void carl9170_calc_ctl(struct ar9170 *ar, u32 freq, enum carl9170_bw bw)
 		/* skip CTL and heavy clip for CTL_MKK and CTL_ETSI */
 		return;
 
-	if (ar->hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ) {
+	if (ar->hw->conf.chandef.chan->band == NL80211_BAND_2GHZ) {
 		modes = mode_list_2ghz;
 		nr_modes = ARRAY_SIZE(mode_list_2ghz);
 	} else {
@@ -1607,7 +1607,7 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 		return err;
 
 	err = carl9170_init_rf_banks_0_7(ar,
-					 channel->band == IEEE80211_BAND_5GHZ);
+					 channel->band == NL80211_BAND_5GHZ);
 	if (err)
 		return err;
 
@@ -1621,7 +1621,7 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 		return err;
 
 	err = carl9170_init_rf_bank4_pwr(ar,
-					 channel->band == IEEE80211_BAND_5GHZ,
+					 channel->band == NL80211_BAND_5GHZ,
 					 channel->center_freq, bw);
 	if (err)
 		return err;
diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index d66533cbc38a..0c34c8729dc6 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -417,7 +417,7 @@ static int carl9170_rx_mac_status(struct ar9170 *ar,
 
 			return -EINVAL;
 		}
-		if (status->band == IEEE80211_BAND_2GHZ)
+		if (status->band == NL80211_BAND_2GHZ)
 			status->rate_idx += 4;
 		break;
 
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index ae86a600d920..2bf04c9edc98 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -720,12 +720,12 @@ static void carl9170_tx_rate_tpc_chains(struct ar9170 *ar,
 			/* +1 dBm for HT40 */
 			*tpc += 2;
 
-			if (info->band == IEEE80211_BAND_2GHZ)
+			if (info->band == NL80211_BAND_2GHZ)
 				txpower = ar->power_2G_ht40;
 			else
 				txpower = ar->power_5G_ht40;
 		} else {
-			if (info->band == IEEE80211_BAND_2GHZ)
+			if (info->band == NL80211_BAND_2GHZ)
 				txpower = ar->power_2G_ht20;
 			else
 				txpower = ar->power_5G_ht20;
@@ -734,7 +734,7 @@ static void carl9170_tx_rate_tpc_chains(struct ar9170 *ar,
 		*phyrate = txrate->idx;
 		*tpc += txpower[idx & 7];
 	} else {
-		if (info->band == IEEE80211_BAND_2GHZ) {
+		if (info->band == NL80211_BAND_2GHZ) {
 			if (idx < 4)
 				txpower = ar->power_2G_cck;
 			else
@@ -797,7 +797,7 @@ static __le32 carl9170_tx_physet(struct ar9170 *ar,
 		 * tmp |= cpu_to_le32(AR9170_TX_PHY_GREENFIELD);
 		 */
 	} else {
-		if (info->band == IEEE80211_BAND_2GHZ) {
+		if (info->band == NL80211_BAND_2GHZ) {
 			if (txrate->idx <= AR9170_TX_PHY_RATE_CCK_11M)
 				tmp |= cpu_to_le32(AR9170_TX_PHY_MOD_CCK);
 			else
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 06ea6cc9e30a..7e15ed9ed31f 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -336,12 +336,12 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 			      struct ath_regulatory *reg,
 			      enum nl80211_reg_initiator initiator)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	unsigned int i;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		if (!wiphy->bands[band])
 			continue;
 		sband = wiphy->bands[band];
@@ -374,7 +374,7 @@ ath_reg_apply_ir_flags(struct wiphy *wiphy,
 {
 	struct ieee80211_supported_band *sband;
 
-	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
+	sband = wiphy->bands[NL80211_BAND_2GHZ];
 	if (!sband)
 		return;
 
@@ -402,10 +402,10 @@ static void ath_reg_apply_radar_flags(struct wiphy *wiphy)
 	struct ieee80211_channel *ch;
 	unsigned int i;
 
-	if (!wiphy->bands[IEEE80211_BAND_5GHZ])
+	if (!wiphy->bands[NL80211_BAND_5GHZ])
 		return;
 
-	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+	sband = wiphy->bands[NL80211_BAND_5GHZ];
 
 	for (i = 0; i < sband->n_channels; i++) {
 		ch = &sband->channels[i];
@@ -772,7 +772,7 @@ ath_regd_init(struct ath_regulatory *reg,
 EXPORT_SYMBOL(ath_regd_init);
 
 u32 ath_regd_get_band_ctl(struct ath_regulatory *reg,
-			  enum ieee80211_band band)
+			  enum nl80211_band band)
 {
 	if (!reg->regpair ||
 	    (reg->country_code == CTRY_DEFAULT &&
@@ -794,9 +794,9 @@ u32 ath_regd_get_band_ctl(struct ath_regulatory *reg,
 	}
 
 	switch (band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		return reg->regpair->reg_2ghz_ctl;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		return reg->regpair->reg_5ghz_ctl;
 	default:
 		return NO_CTL;
diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 37f53bd8fcb1..565d3075f06e 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -255,7 +255,7 @@ int ath_regd_init(struct ath_regulatory *reg, struct wiphy *wiphy,
 		  void (*reg_notifier)(struct wiphy *wiphy,
 				       struct regulatory_request *request));
 u32 ath_regd_get_band_ctl(struct ath_regulatory *reg,
-			  enum ieee80211_band band);
+			  enum nl80211_band band);
 void ath_reg_notifier_apply(struct wiphy *wiphy,
 			    struct regulatory_request *request,
 			    struct ath_regulatory *reg);
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index a27279c2c695..9a1db3bbec4e 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -26,14 +26,14 @@ module_param_named(debug_mask, wcn36xx_dbg_mask, uint, 0644);
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 
 #define CHAN2G(_freq, _idx) { \
-	.band = IEEE80211_BAND_2GHZ, \
+	.band = NL80211_BAND_2GHZ, \
 	.center_freq = (_freq), \
 	.hw_value = (_idx), \
 	.max_power = 25, \
 }
 
 #define CHAN5G(_freq, _idx) { \
-	.band = IEEE80211_BAND_5GHZ, \
+	.band = NL80211_BAND_5GHZ, \
 	.center_freq = (_freq), \
 	.hw_value = (_idx), \
 	.max_power = 25, \
@@ -516,7 +516,7 @@ static void wcn36xx_sw_scan_complete(struct ieee80211_hw *hw,
 }
 
 static void wcn36xx_update_allowed_rates(struct ieee80211_sta *sta,
-					 enum ieee80211_band band)
+					 enum nl80211_band band)
 {
 	int i, size;
 	u16 *rates_table;
@@ -529,7 +529,7 @@ static void wcn36xx_update_allowed_rates(struct ieee80211_sta *sta,
 
 	size = ARRAY_SIZE(sta_priv->supported_rates.dsss_rates);
 	rates_table = sta_priv->supported_rates.dsss_rates;
-	if (band == IEEE80211_BAND_2GHZ) {
+	if (band == NL80211_BAND_2GHZ) {
 		for (i = 0; i < size; i++) {
 			if (rates & 0x01) {
 				rates_table[i] = wcn_2ghz_rates[i].hw_value;
@@ -958,8 +958,8 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
-	wcn->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wcn_band_2ghz;
-	wcn->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &wcn_band_5ghz;
+	wcn->hw->wiphy->bands[NL80211_BAND_2GHZ] = &wcn_band_2ghz;
+	wcn->hw->wiphy->bands[NL80211_BAND_5GHZ] = &wcn_band_5ghz;
 
 	wcn->hw->wiphy->cipher_suites = cipher_suites;
 	wcn->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 74f56a81ad9a..96992a2c4b42 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -104,11 +104,11 @@ static void wcn36xx_smd_set_bss_nw_type(struct wcn36xx *wcn,
 		struct ieee80211_sta *sta,
 		struct wcn36xx_hal_config_bss_params *bss_params)
 {
-	if (IEEE80211_BAND_5GHZ == WCN36XX_BAND(wcn))
+	if (NL80211_BAND_5GHZ == WCN36XX_BAND(wcn))
 		bss_params->nw_type = WCN36XX_HAL_11A_NW_TYPE;
 	else if (sta && sta->ht_cap.ht_supported)
 		bss_params->nw_type = WCN36XX_HAL_11N_NW_TYPE;
-	else if (sta && (sta->supp_rates[IEEE80211_BAND_2GHZ] & 0x7f))
+	else if (sta && (sta->supp_rates[NL80211_BAND_2GHZ] & 0x7f))
 		bss_params->nw_type = WCN36XX_HAL_11G_NW_TYPE;
 	else
 		bss_params->nw_type = WCN36XX_HAL_11B_NW_TYPE;
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 99c21aac68bd..6c47a7336c38 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -225,7 +225,7 @@ static void wcn36xx_set_tx_mgmt(struct wcn36xx_tx_bd *bd,
 
 	/* default rate for unicast */
 	if (ieee80211_is_mgmt(hdr->frame_control))
-		bd->bd_rate = (WCN36XX_BAND(wcn) == IEEE80211_BAND_5GHZ) ?
+		bd->bd_rate = (WCN36XX_BAND(wcn) == NL80211_BAND_5GHZ) ?
 			WCN36XX_BD_RATE_CTRL :
 			WCN36XX_BD_RATE_MGMT;
 	else if (ieee80211_is_ctl(hdr->frame_control))
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 12cae3c005fb..0fb3a7941d84 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -21,7 +21,7 @@
 #define WIL_MAX_ROC_DURATION_MS 5000
 
 #define CHAN60G(_channel, _flags) {				\
-	.band			= IEEE80211_BAND_60GHZ,		\
+	.band			= NL80211_BAND_60GHZ,		\
 	.center_freq		= 56160 + (2160 * (_channel)),	\
 	.hw_value		= (_channel),			\
 	.flags			= (_flags),			\
@@ -1411,7 +1411,7 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
 
-	wiphy->bands[IEEE80211_BAND_60GHZ] = &wil_band_60ghz;
+	wiphy->bands[NL80211_BAND_60GHZ] = &wil_band_60ghz;
 
 	/* TODO: figure this out */
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 3bc0e2634db0..098409753d5b 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -157,7 +157,7 @@ void *wil_if_alloc(struct device *dev)
 
 	wdev->iftype = NL80211_IFTYPE_STATION; /* TODO */
 	/* default monitor channel */
-	ch = wdev->wiphy->bands[IEEE80211_BAND_60GHZ]->channels;
+	ch = wdev->wiphy->bands[NL80211_BAND_60GHZ]->channels;
 	cfg80211_chandef_create(&wdev->preset_chandef, ch, NL80211_CHAN_NO_HT);
 
 	ndev = alloc_netdev(0, "wlan%d", NET_NAME_UNKNOWN, wil_dev_setup);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 3cc4462aec1a..6ca28c3eff0a 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -333,7 +333,7 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 	}
 
 	ch_no = data->info.channel + 1;
-	freq = ieee80211_channel_to_frequency(ch_no, IEEE80211_BAND_60GHZ);
+	freq = ieee80211_channel_to_frequency(ch_no, NL80211_BAND_60GHZ);
 	channel = ieee80211_get_channel(wiphy, freq);
 	signal = data->info.sqi;
 	d_status = le16_to_cpu(data->info.status);
diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 1efb1d66e0b7..7c108047fb46 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -1547,7 +1547,7 @@ static inline int at76_guess_freq(struct at76_priv *priv)
 		channel = el[2];
 
 exit:
-	return ieee80211_channel_to_frequency(channel, IEEE80211_BAND_2GHZ);
+	return ieee80211_channel_to_frequency(channel, NL80211_BAND_2GHZ);
 }
 
 static void at76_rx_tasklet(unsigned long param)
@@ -1590,7 +1590,7 @@ static void at76_rx_tasklet(unsigned long param)
 	rx_status.signal = buf->rssi;
 	rx_status.flag |= RX_FLAG_DECRYPTED;
 	rx_status.flag |= RX_FLAG_IV_STRIPPED;
-	rx_status.band = IEEE80211_BAND_2GHZ;
+	rx_status.band = NL80211_BAND_2GHZ;
 	rx_status.freq = at76_guess_freq(priv);
 
 	at76_dbg(DBG_MAC80211, "calling ieee80211_rx_irqsafe(): %d/%d",
@@ -2359,7 +2359,7 @@ static int at76_init_new_device(struct at76_priv *priv,
 	priv->hw->wiphy->max_scan_ssids = 1;
 	priv->hw->wiphy->max_scan_ie_len = 0;
 	priv->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
-	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &at76_supported_band;
+	priv->hw->wiphy->bands[NL80211_BAND_2GHZ] = &at76_supported_band;
 	ieee80211_hw_set(priv->hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(priv->hw, SIGNAL_UNSPEC);
 	priv->hw->max_signal = 100;
diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index 6a1f03c271c1..8f8f37f3a00c 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -2434,7 +2434,7 @@ static int atmel_get_range(struct net_device *dev,
 
 			/* Values in MHz -> * 10^5 * 10 */
 			range->freq[k].m = 100000 *
-			 ieee80211_channel_to_frequency(i, IEEE80211_BAND_2GHZ);
+			 ieee80211_channel_to_frequency(i, NL80211_BAND_2GHZ);
 			range->freq[k++].e = 1;
 		}
 		range->num_frequency = k;
diff --git a/drivers/net/wireless/broadcom/b43/b43.h b/drivers/net/wireless/broadcom/b43/b43.h
index 036552439816..d7d42f0b80c3 100644
--- a/drivers/net/wireless/broadcom/b43/b43.h
+++ b/drivers/net/wireless/broadcom/b43/b43.h
@@ -992,9 +992,9 @@ static inline int b43_is_mode(struct b43_wl *wl, int type)
 
 /**
  * b43_current_band - Returns the currently used band.
- * Returns one of IEEE80211_BAND_2GHZ and IEEE80211_BAND_5GHZ.
+ * Returns one of NL80211_BAND_2GHZ and NL80211_BAND_5GHZ.
  */
-static inline enum ieee80211_band b43_current_band(struct b43_wl *wl)
+static inline enum nl80211_band b43_current_band(struct b43_wl *wl)
 {
 	return wl->hw->conf.chandef.chan->band;
 }
diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index b0603e796ad8..4ee5c5853f9f 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -187,7 +187,7 @@ static struct ieee80211_rate __b43_ratetable[] = {
 #define b43_g_ratetable_size	12
 
 #define CHAN2G(_channel, _freq, _flags) {			\
-	.band			= IEEE80211_BAND_2GHZ,		\
+	.band			= NL80211_BAND_2GHZ,		\
 	.center_freq		= (_freq),			\
 	.hw_value		= (_channel),			\
 	.flags			= (_flags),			\
@@ -216,7 +216,7 @@ static struct ieee80211_channel b43_2ghz_chantable[] = {
 #undef CHAN2G
 
 #define CHAN4G(_channel, _flags) {				\
-	.band			= IEEE80211_BAND_5GHZ,		\
+	.band			= NL80211_BAND_5GHZ,		\
 	.center_freq		= 4000 + (5 * (_channel)),	\
 	.hw_value		= (_channel),			\
 	.flags			= (_flags),			\
@@ -224,7 +224,7 @@ static struct ieee80211_channel b43_2ghz_chantable[] = {
 	.max_power		= 30,				\
 }
 #define CHAN5G(_channel, _flags) {				\
-	.band			= IEEE80211_BAND_5GHZ,		\
+	.band			= NL80211_BAND_5GHZ,		\
 	.center_freq		= 5000 + (5 * (_channel)),	\
 	.hw_value		= (_channel),			\
 	.flags			= (_flags),			\
@@ -323,7 +323,7 @@ static struct ieee80211_channel b43_5ghz_aphy_chantable[] = {
 #undef CHAN5G
 
 static struct ieee80211_supported_band b43_band_5GHz_nphy = {
-	.band		= IEEE80211_BAND_5GHZ,
+	.band		= NL80211_BAND_5GHZ,
 	.channels	= b43_5ghz_nphy_chantable,
 	.n_channels	= ARRAY_SIZE(b43_5ghz_nphy_chantable),
 	.bitrates	= b43_a_ratetable,
@@ -331,7 +331,7 @@ static struct ieee80211_supported_band b43_band_5GHz_nphy = {
 };
 
 static struct ieee80211_supported_band b43_band_5GHz_nphy_limited = {
-	.band		= IEEE80211_BAND_5GHZ,
+	.band		= NL80211_BAND_5GHZ,
 	.channels	= b43_5ghz_nphy_chantable_limited,
 	.n_channels	= ARRAY_SIZE(b43_5ghz_nphy_chantable_limited),
 	.bitrates	= b43_a_ratetable,
@@ -339,7 +339,7 @@ static struct ieee80211_supported_band b43_band_5GHz_nphy_limited = {
 };
 
 static struct ieee80211_supported_band b43_band_5GHz_aphy = {
-	.band		= IEEE80211_BAND_5GHZ,
+	.band		= NL80211_BAND_5GHZ,
 	.channels	= b43_5ghz_aphy_chantable,
 	.n_channels	= ARRAY_SIZE(b43_5ghz_aphy_chantable),
 	.bitrates	= b43_a_ratetable,
@@ -347,7 +347,7 @@ static struct ieee80211_supported_band b43_band_5GHz_aphy = {
 };
 
 static struct ieee80211_supported_band b43_band_2GHz = {
-	.band		= IEEE80211_BAND_2GHZ,
+	.band		= NL80211_BAND_2GHZ,
 	.channels	= b43_2ghz_chantable,
 	.n_channels	= ARRAY_SIZE(b43_2ghz_chantable),
 	.bitrates	= b43_g_ratetable,
@@ -355,7 +355,7 @@ static struct ieee80211_supported_band b43_band_2GHz = {
 };
 
 static struct ieee80211_supported_band b43_band_2ghz_limited = {
-	.band		= IEEE80211_BAND_2GHZ,
+	.band		= NL80211_BAND_2GHZ,
 	.channels	= b43_2ghz_chantable,
 	.n_channels	= b43_2ghz_chantable_limited_size,
 	.bitrates	= b43_g_ratetable,
@@ -717,7 +717,7 @@ static void b43_set_slot_time(struct b43_wldev *dev, u16 slot_time)
 {
 	/* slot_time is in usec. */
 	/* This test used to exit for all but a G PHY. */
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 		return;
 	b43_write16(dev, B43_MMIO_IFSSLOT, 510 + slot_time);
 	/* Shared memory location 0x0010 is the slot time and should be
@@ -3880,12 +3880,12 @@ static void b43_op_set_tsf(struct ieee80211_hw *hw,
 	mutex_unlock(&wl->mutex);
 }
 
-static const char *band_to_string(enum ieee80211_band band)
+static const char *band_to_string(enum nl80211_band band)
 {
 	switch (band) {
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		return "5";
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		return "2.4";
 	default:
 		break;
@@ -3903,10 +3903,10 @@ static int b43_switch_band(struct b43_wldev *dev,
 	u32 tmp;
 
 	switch (chan->band) {
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		gmode = false;
 		break;
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		gmode = true;
 		break;
 	default:
@@ -5294,16 +5294,16 @@ static int b43_setup_bands(struct b43_wldev *dev,
 		     phy->radio_rev == 9;
 
 	if (have_2ghz_phy)
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = limited_2g ?
+		hw->wiphy->bands[NL80211_BAND_2GHZ] = limited_2g ?
 			&b43_band_2ghz_limited : &b43_band_2GHz;
 	if (dev->phy.type == B43_PHYTYPE_N) {
 		if (have_5ghz_phy)
-			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = limited_5g ?
+			hw->wiphy->bands[NL80211_BAND_5GHZ] = limited_5g ?
 				&b43_band_5GHz_nphy_limited :
 				&b43_band_5GHz_nphy;
 	} else {
 		if (have_5ghz_phy)
-			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &b43_band_5GHz_aphy;
+			hw->wiphy->bands[NL80211_BAND_5GHZ] = &b43_band_5GHz_aphy;
 	}
 
 	dev->phy.supports_2ghz = have_2ghz_phy;
diff --git a/drivers/net/wireless/broadcom/b43/phy_ac.c b/drivers/net/wireless/broadcom/b43/phy_ac.c
index e75633d67938..52f8abad8831 100644
--- a/drivers/net/wireless/broadcom/b43/phy_ac.c
+++ b/drivers/net/wireless/broadcom/b43/phy_ac.c
@@ -61,7 +61,7 @@ static void b43_phy_ac_op_radio_write(struct b43_wldev *dev, u16 reg,
 
 static unsigned int b43_phy_ac_op_get_default_chan(struct b43_wldev *dev)
 {
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		return 11;
 	return 36;
 }
diff --git a/drivers/net/wireless/broadcom/b43/phy_common.c b/drivers/net/wireless/broadcom/b43/phy_common.c
index ec2b9c577b90..85f2ca989565 100644
--- a/drivers/net/wireless/broadcom/b43/phy_common.c
+++ b/drivers/net/wireless/broadcom/b43/phy_common.c
@@ -436,7 +436,7 @@ int b43_switch_channel(struct b43_wldev *dev, unsigned int new_channel)
 	 * firmware from sending ghost packets.
 	 */
 	channelcookie = new_channel;
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 		channelcookie |= B43_SHM_SH_CHAN_5GHZ;
 	/* FIXME: set 40Mhz flag if required */
 	if (0)
diff --git a/drivers/net/wireless/broadcom/b43/phy_ht.c b/drivers/net/wireless/broadcom/b43/phy_ht.c
index bd68945965d6..718c90e81696 100644
--- a/drivers/net/wireless/broadcom/b43/phy_ht.c
+++ b/drivers/net/wireless/broadcom/b43/phy_ht.c
@@ -568,7 +568,7 @@ static void b43_phy_ht_tx_power_ctl(struct b43_wldev *dev, bool enable)
 	} else {
 		b43_phy_set(dev, B43_PHY_HT_TXPCTL_CMD_C1, en_bits);
 
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 			for (i = 0; i < 3; i++)
 				b43_phy_write(dev, cmd_regs[i], 0x32);
 		}
@@ -643,7 +643,7 @@ static void b43_phy_ht_tx_power_ctl_setup(struct b43_wldev *dev)
 	u16 freq = dev->phy.chandef->chan->center_freq;
 	int i, c;
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		for (c = 0; c < 3; c++) {
 			target[c] = sprom->core_pwr_info[c].maxpwr_2g;
 			a1[c] = sprom->core_pwr_info[c].pa_2g[0];
@@ -777,7 +777,7 @@ static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 				const struct b43_phy_ht_channeltab_e_phy *e,
 				struct ieee80211_channel *new_channel)
 {
-	if (new_channel->band == IEEE80211_BAND_5GHZ) {
+	if (new_channel->band == NL80211_BAND_5GHZ) {
 		/* Switch to 2 GHz for a moment to access B-PHY regs */
 		b43_phy_mask(dev, B43_PHY_HT_BANDCTL, ~B43_PHY_HT_BANDCTL_5GHZ);
 
@@ -805,7 +805,7 @@ static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 	} else {
 		b43_phy_ht_classifier(dev, B43_PHY_HT_CLASS_CTL_OFDM_EN,
 				      B43_PHY_HT_CLASS_CTL_OFDM_EN);
-		if (new_channel->band == IEEE80211_BAND_2GHZ)
+		if (new_channel->band == NL80211_BAND_2GHZ)
 			b43_phy_mask(dev, B43_PHY_HT_TEST, ~0x840);
 	}
 
@@ -916,7 +916,7 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 	if (0) /* TODO: condition */
 		; /* TODO: PHY op on reg 0x217 */
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 		b43_phy_ht_classifier(dev, B43_PHY_HT_CLASS_CTL_CCK_EN, 0);
 	else
 		b43_phy_ht_classifier(dev, B43_PHY_HT_CLASS_CTL_CCK_EN,
@@ -1005,7 +1005,7 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 	b43_phy_ht_classifier(dev, 0, 0);
 	b43_phy_ht_read_clip_detection(dev, clip_state);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		b43_phy_ht_bphy_init(dev);
 
 	b43_httab_write_bulk(dev, B43_HTTAB32(0x1a, 0xc0),
@@ -1077,7 +1077,7 @@ static int b43_phy_ht_op_switch_channel(struct b43_wldev *dev,
 	enum nl80211_channel_type channel_type =
 		cfg80211_get_chandef_type(&dev->wl->hw->conf.chandef);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
 			return -EINVAL;
 	} else {
@@ -1089,7 +1089,7 @@ static int b43_phy_ht_op_switch_channel(struct b43_wldev *dev,
 
 static unsigned int b43_phy_ht_op_get_default_chan(struct b43_wldev *dev)
 {
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		return 11;
 	return 36;
 }
diff --git a/drivers/net/wireless/broadcom/b43/phy_lcn.c b/drivers/net/wireless/broadcom/b43/phy_lcn.c
index 97461ccf3e1e..63bd29f070f7 100644
--- a/drivers/net/wireless/broadcom/b43/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/b43/phy_lcn.c
@@ -108,7 +108,7 @@ static void b43_radio_2064_channel_setup(struct b43_wldev *dev)
 /* wlc_radio_2064_init */
 static void b43_radio_2064_init(struct b43_wldev *dev)
 {
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		b43_radio_write(dev, 0x09c, 0x0020);
 		b43_radio_write(dev, 0x105, 0x0008);
 	} else {
@@ -535,7 +535,7 @@ static void b43_phy_lcn_tx_pwr_ctl_init(struct b43_wldev *dev)
 	b43_mac_suspend(dev);
 
 	if (!dev->phy.lcn->hw_pwr_ctl_capable) {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 			tx_gains.gm_gain = 4;
 			tx_gains.pga_gain = 12;
 			tx_gains.pad_gain = 12;
@@ -720,7 +720,7 @@ static int b43_phy_lcn_op_init(struct b43_wldev *dev)
 	else
 		B43_WARN_ON(1);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		b43_phy_lcn_tx_pwr_ctl_init(dev);
 
 	b43_switch_channel(dev, dev->phy.channel);
@@ -779,7 +779,7 @@ static int b43_phy_lcn_op_switch_channel(struct b43_wldev *dev,
 	enum nl80211_channel_type channel_type =
 		cfg80211_get_chandef_type(&dev->wl->hw->conf.chandef);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
 			return -EINVAL;
 	} else {
@@ -791,7 +791,7 @@ static int b43_phy_lcn_op_switch_channel(struct b43_wldev *dev,
 
 static unsigned int b43_phy_lcn_op_get_default_chan(struct b43_wldev *dev)
 {
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		return 1;
 	return 36;
 }
diff --git a/drivers/net/wireless/broadcom/b43/phy_lp.c b/drivers/net/wireless/broadcom/b43/phy_lp.c
index 058a9f232050..6922cbb99a04 100644
--- a/drivers/net/wireless/broadcom/b43/phy_lp.c
+++ b/drivers/net/wireless/broadcom/b43/phy_lp.c
@@ -46,7 +46,7 @@ static inline u16 channel2freq_lp(u8 channel)
 
 static unsigned int b43_lpphy_op_get_default_chan(struct b43_wldev *dev)
 {
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		return 1;
 	return 36;
 }
@@ -91,7 +91,7 @@ static void lpphy_read_band_sprom(struct b43_wldev *dev)
 	u32 ofdmpo;
 	int i;
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		lpphy->tx_isolation_med_band = sprom->tri2g;
 		lpphy->bx_arch = sprom->bxa2g;
 		lpphy->rx_pwr_offset = sprom->rxpo2g;
@@ -174,7 +174,7 @@ static void lpphy_adjust_gain_table(struct b43_wldev *dev, u32 freq)
 
 	B43_WARN_ON(dev->phy.rev >= 2);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		isolation = lpphy->tx_isolation_med_band;
 	else if (freq <= 5320)
 		isolation = lpphy->tx_isolation_low_band;
@@ -238,7 +238,7 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_LPPHY_INPUT_PWRDB,
 			0xFF00, lpphy->rx_pwr_offset);
 	if ((sprom->boardflags_lo & B43_BFL_FEM) &&
-	   ((b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ||
+	   ((b43_current_band(dev->wl) == NL80211_BAND_5GHZ) ||
 	   (sprom->boardflags_hi & B43_BFH_PAREF))) {
 		ssb_pmu_set_ldo_voltage(&bus->chipco, LDO_PAREF, 0x28);
 		ssb_pmu_set_ldo_paref(&bus->chipco, true);
@@ -280,7 +280,7 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_7, 0xC0FF, 0x0900);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_8, 0xFFC0, 0x000A);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_8, 0xC0FF, 0x0B00);
-	} else if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ ||
+	} else if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ ||
 		   (dev->dev->board_type == SSB_BOARD_BU4312) ||
 		   (dev->phy.rev == 0 && (sprom->boardflags_lo & B43_BFL_FEM))) {
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xFFC0, 0x0001);
@@ -326,7 +326,7 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 		//FIXME the Broadcom driver caches & delays this HF write!
 		b43_hf_write(dev, b43_hf_read(dev) | B43_HF_PR45960W);
 	}
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		b43_phy_set(dev, B43_LPPHY_LP_PHY_CTL, 0x8000);
 		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x0040);
 		b43_phy_maskset(dev, B43_LPPHY_MINPWR_LEVEL, 0x00FF, 0xA400);
@@ -466,7 +466,7 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 		b43_lptab_write(dev, B43_LPTAB16(0x08, 0x12), 0x40);
 	}
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x40);
 		b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xF0FF, 0xB00);
 		b43_phy_maskset(dev, B43_LPPHY_SYNCPEAKCNT, 0xFFF8, 0x6);
@@ -547,7 +547,7 @@ static void lpphy_2062_init(struct b43_wldev *dev)
 		b43_radio_write(dev, B2062_S_BG_CTL1,
 			(b43_radio_read(dev, B2062_N_COMM2) >> 1) | 0x80);
 	}
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		b43_radio_set(dev, B2062_N_TSSI_CTL0, 0x1);
 	else
 		b43_radio_mask(dev, B2062_N_TSSI_CTL0, ~0x1);
@@ -746,7 +746,7 @@ static void lpphy_clear_deaf(struct b43_wldev *dev, bool user)
 		lpphy->crs_sys_disable = false;
 
 	if (!lpphy->crs_usr_disable && !lpphy->crs_sys_disable) {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 			b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL,
 					0xFF1F, 0x60);
 		else
@@ -807,7 +807,7 @@ static void lpphy_disable_rx_gain_override(struct b43_wldev *dev)
 	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFFBF);
 	if (dev->phy.rev >= 2) {
 		b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFEFF);
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 			b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFBFF);
 			b43_phy_mask(dev, B43_PHY_OFDM(0xE5), 0xFFF7);
 		}
@@ -823,7 +823,7 @@ static void lpphy_enable_rx_gain_override(struct b43_wldev *dev)
 	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x40);
 	if (dev->phy.rev >= 2) {
 		b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2, 0x100);
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 			b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2, 0x400);
 			b43_phy_set(dev, B43_PHY_OFDM(0xE5), 0x8);
 		}
@@ -951,7 +951,7 @@ static void lpphy_rev2plus_set_rx_gain(struct b43_wldev *dev, u32 gain)
 			0xFBFF, ext_lna << 10);
 	b43_phy_write(dev, B43_LPPHY_RX_GAIN_CTL_OVERRIDE_VAL, low_gain);
 	b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS, 0xFFF0, high_gain);
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		tmp = (gain >> 2) & 0x3;
 		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2_VAL,
 				0xE7FF, tmp<<11);
@@ -1344,7 +1344,7 @@ static void lpphy_calibrate_rc(struct b43_wldev *dev)
 	if (dev->phy.rev >= 2) {
 		lpphy_rev2plus_rc_calib(dev);
 	} else if (!lpphy->rc_cap) {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 			lpphy_rev0_1_rc_calib(dev);
 	} else {
 		lpphy_set_rc_cap(dev);
@@ -1548,7 +1548,7 @@ static void lpphy_tx_pctl_init_sw(struct b43_wldev *dev)
 {
 	struct lpphy_tx_gains gains;
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		gains.gm = 4;
 		gains.pad = 12;
 		gains.pga = 12;
@@ -1902,7 +1902,7 @@ static int lpphy_rx_iq_cal(struct b43_wldev *dev, bool noise, bool tx,
 
 	lpphy_set_trsw_over(dev, tx, rx);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x8);
 		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_VAL_0,
 				0xFFF7, pa << 3);
diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 9f0bcf3b8414..a5557d70689f 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -105,9 +105,9 @@ enum n_rail_type {
 
 static inline bool b43_nphy_ipa(struct b43_wldev *dev)
 {
-	enum ieee80211_band band = b43_current_band(dev->wl);
-	return ((dev->phy.n->ipa2g_on && band == IEEE80211_BAND_2GHZ) ||
-		(dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ));
+	enum nl80211_band band = b43_current_band(dev->wl);
+	return ((dev->phy.n->ipa2g_on && band == NL80211_BAND_2GHZ) ||
+		(dev->phy.n->ipa5g_on && band == NL80211_BAND_5GHZ));
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCoreGetState */
@@ -357,7 +357,7 @@ static void b43_nphy_rf_ctl_intc_override_rev7(struct b43_wldev *dev,
 			break;
 		case N_INTC_OVERRIDE_PA:
 			tmp = 0x0030;
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+			if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 				val = value << 5;
 			else
 				val = value << 4;
@@ -365,7 +365,7 @@ static void b43_nphy_rf_ctl_intc_override_rev7(struct b43_wldev *dev,
 			b43_phy_set(dev, reg, 0x1000);
 			break;
 		case N_INTC_OVERRIDE_EXT_LNA_PU:
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+			if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 				tmp = 0x0001;
 				tmp2 = 0x0004;
 				val = value;
@@ -378,7 +378,7 @@ static void b43_nphy_rf_ctl_intc_override_rev7(struct b43_wldev *dev,
 			b43_phy_mask(dev, reg, ~tmp2);
 			break;
 		case N_INTC_OVERRIDE_EXT_LNA_GAIN:
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+			if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 				tmp = 0x0002;
 				tmp2 = 0x0008;
 				val = value << 1;
@@ -465,7 +465,7 @@ static void b43_nphy_rf_ctl_intc_override(struct b43_wldev *dev,
 			}
 			break;
 		case N_INTC_OVERRIDE_PA:
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+			if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 				tmp = 0x0020;
 				val = value << 5;
 			} else {
@@ -475,7 +475,7 @@ static void b43_nphy_rf_ctl_intc_override(struct b43_wldev *dev,
 			b43_phy_maskset(dev, reg, ~tmp, val);
 			break;
 		case N_INTC_OVERRIDE_EXT_LNA_PU:
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+			if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 				tmp = 0x0001;
 				val = value;
 			} else {
@@ -485,7 +485,7 @@ static void b43_nphy_rf_ctl_intc_override(struct b43_wldev *dev,
 			b43_phy_maskset(dev, reg, ~tmp, val);
 			break;
 		case N_INTC_OVERRIDE_EXT_LNA_GAIN:
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+			if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 				tmp = 0x0002;
 				val = value << 1;
 			} else {
@@ -600,7 +600,7 @@ static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 1);
 
 	if (nphy->gain_boost) {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 			gain[0] = 6;
 			gain[1] = 6;
 		} else {
@@ -736,7 +736,7 @@ static void b43_radio_2057_setup(struct b43_wldev *dev,
 	switch (phy->radio_rev) {
 	case 0 ... 4:
 	case 6:
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 			b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_R1, 0x3f);
 			b43_radio_write(dev, R2057_CP_KPD_IDAC, 0x3f);
 			b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_C1, 0x8);
@@ -751,7 +751,7 @@ static void b43_radio_2057_setup(struct b43_wldev *dev,
 	case 9: /* e.g. PHY rev 16 */
 		b43_radio_write(dev, R2057_LOGEN_PTAT_RESETS, 0x20);
 		b43_radio_write(dev, R2057_VCOBUF_IDACS, 0x18);
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 			b43_radio_write(dev, R2057_LOGEN_PTAT_RESETS, 0x38);
 			b43_radio_write(dev, R2057_VCOBUF_IDACS, 0x0f);
 
@@ -775,7 +775,7 @@ static void b43_radio_2057_setup(struct b43_wldev *dev,
 		break;
 	}
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		u16 txmix2g_tune_boost_pu = 0;
 		u16 pad2g_tune_pus = 0;
 
@@ -1135,7 +1135,7 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 {
 	struct b43_phy *phy = &dev->phy;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
-	enum ieee80211_band band = b43_current_band(dev->wl);
+	enum nl80211_band band = b43_current_band(dev->wl);
 	u16 offset;
 	u8 i;
 	u16 bias, cbias;
@@ -1152,10 +1152,10 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 		 dev->dev->chip_pkg == BCMA_PKG_ID_BCM43224_FAB_SMIC);
 
 	b43_chantab_radio_2056_upload(dev, e);
-	b2056_upload_syn_pll_cp2(dev, band == IEEE80211_BAND_5GHZ);
+	b2056_upload_syn_pll_cp2(dev, band == NL80211_BAND_5GHZ);
 
 	if (sprom->boardflags2_lo & B43_BFL2_GPLL_WAR &&
-	    b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	    b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER1, 0x1F);
 		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER2, 0x1F);
 		if (dev->dev->chip_id == BCMA_CHIP_ID_BCM4716 ||
@@ -1168,21 +1168,21 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 		}
 	}
 	if (sprom->boardflags2_hi & B43_BFH2_GPLL_WAR2 &&
-	    b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	    b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER1, 0x1f);
 		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER2, 0x1f);
 		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER4, 0x0b);
 		b43_radio_write(dev, B2056_SYN_PLL_CP2, 0x20);
 	}
 	if (sprom->boardflags2_lo & B43_BFL2_APLL_WAR &&
-	    b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+	    b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER1, 0x1F);
 		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER2, 0x1F);
 		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER4, 0x05);
 		b43_radio_write(dev, B2056_SYN_PLL_CP2, 0x0C);
 	}
 
-	if (dev->phy.n->ipa2g_on && band == IEEE80211_BAND_2GHZ) {
+	if (dev->phy.n->ipa2g_on && band == NL80211_BAND_2GHZ) {
 		for (i = 0; i < 2; i++) {
 			offset = i ? B2056_TX1 : B2056_TX0;
 			if (dev->phy.rev >= 5) {
@@ -1244,7 +1244,7 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 			}
 			b43_radio_write(dev, offset | B2056_TX_PA_SPARE1, 0xee);
 		}
-	} else if (dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ) {
+	} else if (dev->phy.n->ipa5g_on && band == NL80211_BAND_5GHZ) {
 		u16 freq = phy->chandef->chan->center_freq;
 		if (freq < 5100) {
 			paa_boost = 0xA;
@@ -1501,7 +1501,7 @@ static void b43_radio_init2055(struct b43_wldev *dev)
 		/* Follow wl, not specs. Do not force uploading all regs */
 		b2055_upload_inittab(dev, 0, 0);
 	} else {
-		bool ghz5 = b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ;
+		bool ghz5 = b43_current_band(dev->wl) == NL80211_BAND_5GHZ;
 		b2055_upload_inittab(dev, ghz5, 0);
 	}
 	b43_radio_init2055_post(dev);
@@ -1785,7 +1785,7 @@ static void b43_nphy_rev3_rssi_select(struct b43_wldev *dev, u8 code,
 				b43_phy_maskset(dev, reg, 0xFFC3, 0);
 
 				if (rssi_type == N_RSSI_W1)
-					val = (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ? 4 : 8;
+					val = (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) ? 4 : 8;
 				else if (rssi_type == N_RSSI_W2)
 					val = 16;
 				else
@@ -1813,12 +1813,12 @@ static void b43_nphy_rev3_rssi_select(struct b43_wldev *dev, u8 code,
 
 				if (rssi_type != N_RSSI_IQ &&
 				    rssi_type != N_RSSI_TBD) {
-					enum ieee80211_band band =
+					enum nl80211_band band =
 						b43_current_band(dev->wl);
 
 					if (dev->phy.rev < 7) {
 						if (b43_nphy_ipa(dev))
-							val = (band == IEEE80211_BAND_5GHZ) ? 0xC : 0xE;
+							val = (band == NL80211_BAND_5GHZ) ? 0xC : 0xE;
 						else
 							val = 0x11;
 						reg = (i == 0) ? B2056_TX0 : B2056_TX1;
@@ -2120,7 +2120,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 						     1, 0, false);
 		b43_nphy_rf_ctl_override_rev7(dev, 0x80, 1, 0, false, 0);
 		b43_nphy_rf_ctl_override_rev7(dev, 0x40, 1, 0, false, 0);
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 			b43_nphy_rf_ctl_override_rev7(dev, 0x20, 0, 0, false,
 						      0);
 			b43_nphy_rf_ctl_override_rev7(dev, 0x10, 1, 0, false,
@@ -2136,7 +2136,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 		b43_nphy_rf_ctl_override(dev, 0x2, 1, 0, false);
 		b43_nphy_rf_ctl_override(dev, 0x80, 1, 0, false);
 		b43_nphy_rf_ctl_override(dev, 0x40, 1, 0, false);
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 			b43_nphy_rf_ctl_override(dev, 0x20, 0, 0, false);
 			b43_nphy_rf_ctl_override(dev, 0x10, 1, 0, false);
 		} else {
@@ -2257,7 +2257,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 		b43_phy_write(dev, regs_to_store[i], saved_regs_phy[i]);
 
 	/* Store for future configuration */
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		rssical_radio_regs = nphy->rssical_cache.rssical_radio_regs_2G;
 		rssical_phy_regs = nphy->rssical_cache.rssical_phy_regs_2G;
 	} else {
@@ -2289,7 +2289,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 	rssical_phy_regs[11] = b43_phy_read(dev, B43_NPHY_RSSIMC_1Q_RSSI_Y);
 
 	/* Remember for which channel we store configuration */
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		nphy->rssical_chanspec_2G.center_freq = phy->chandef->chan->center_freq;
 	else
 		nphy->rssical_chanspec_5G.center_freq = phy->chandef->chan->center_freq;
@@ -2336,7 +2336,7 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, enum n_rssi_type type)
 	b43_nphy_read_clip_detection(dev, clip_state);
 	b43_nphy_write_clip_detection(dev, clip_off);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 		override = 0x140;
 	else
 		override = 0x110;
@@ -2629,7 +2629,7 @@ static void b43_nphy_gain_ctl_workarounds_rev1_2(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_CCK_SHIFTB_REF, 0x809C);
 
 	if (nphy->gain_boost) {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ &&
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ &&
 		    b43_is_40mhz(dev))
 			code = 4;
 		else
@@ -2688,7 +2688,7 @@ static void b43_nphy_gain_ctl_workarounds_rev1_2(struct b43_wldev *dev)
 		~B43_NPHY_OVER_DGAIN_CCKDGECV & 0xFFFF,
 		0x5A << B43_NPHY_OVER_DGAIN_CCKDGECV_SHIFT);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		b43_phy_maskset(dev, B43_PHY_N(0xC5D), 0xFF80, 4);
 }
 
@@ -2803,7 +2803,7 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	scap_val = b43_radio_read(dev, R2057_RCCAL_SCAP_VAL);
 
 	if (b43_nphy_ipa(dev)) {
-		bool ghz2 = b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ;
+		bool ghz2 = b43_current_band(dev->wl) == NL80211_BAND_2GHZ;
 
 		switch (phy->radio_rev) {
 		case 5:
@@ -2831,7 +2831,7 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 				bcap_val_11b[core] = bcap_val;
 				lpf_ofdm_20mhz[core] = 4;
 				lpf_11b[core] = 1;
-				if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+				if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 					scap_val_11n_20[core] = 0xc;
 					bcap_val_11n_20[core] = 0xc;
 					scap_val_11n_40[core] = 0xa;
@@ -2982,7 +2982,7 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 			conv = 0x7f;
 			filt = 0xee;
 		}
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 			for (core = 0; core < 2; core++) {
 				if (core == 0) {
 					b43_radio_write(dev, 0x5F, bias);
@@ -2998,7 +2998,7 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	}
 
 	if (b43_nphy_ipa(dev)) {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 			if (phy->radio_rev == 3 || phy->radio_rev == 4 ||
 			    phy->radio_rev == 6) {
 				for (core = 0; core < 2; core++) {
@@ -3221,7 +3221,7 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 					 ARRAY_SIZE(rx2tx_events));
 	}
 
-	tmp16 = (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) ?
+	tmp16 = (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) ?
 		0x2 : 0x9C40;
 	b43_phy_write(dev, B43_NPHY_ENDROP_TLEN, tmp16);
 
@@ -3240,7 +3240,7 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	b43_ntab_write(dev, B43_NTAB16(8, 0), 2);
 	b43_ntab_write(dev, B43_NTAB16(8, 16), 2);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		pdet_range = sprom->fem.ghz2.pdet_range;
 	else
 		pdet_range = sprom->fem.ghz5.pdet_range;
@@ -3249,7 +3249,7 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	switch (pdet_range) {
 	case 3:
 		if (!(dev->phy.rev >= 4 &&
-		      b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ))
+		      b43_current_band(dev->wl) == NL80211_BAND_2GHZ))
 			break;
 		/* FALL THROUGH */
 	case 0:
@@ -3261,7 +3261,7 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 		break;
 	case 2:
 		if (dev->phy.rev >= 6) {
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+			if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 				vmid[3] = 0x94;
 			else
 				vmid[3] = 0x8e;
@@ -3277,7 +3277,7 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 		break;
 	case 4:
 	case 5:
-		if (b43_current_band(dev->wl) != IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) != NL80211_BAND_2GHZ) {
 			if (pdet_range == 4) {
 				vmid[3] = 0x8e;
 				tmp16 = 0x96;
@@ -3322,9 +3322,9 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	/* N PHY WAR TX Chain Update with hw_phytxchain as argument */
 
 	if ((sprom->boardflags2_lo & B43_BFL2_APLL_WAR &&
-	     b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ||
+	     b43_current_band(dev->wl) == NL80211_BAND_5GHZ) ||
 	    (sprom->boardflags2_lo & B43_BFL2_GPLL_WAR &&
-	     b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ))
+	     b43_current_band(dev->wl) == NL80211_BAND_2GHZ))
 		tmp32 = 0x00088888;
 	else
 		tmp32 = 0x88888888;
@@ -3333,7 +3333,7 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	b43_ntab_write(dev, B43_NTAB32(30, 3), tmp32);
 
 	if (dev->phy.rev == 4 &&
-	    b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+	    b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 		b43_radio_write(dev, B2056_TX0 | B2056_TX_GMBB_IDAC,
 				0x70);
 		b43_radio_write(dev, B2056_TX1 | B2056_TX_GMBB_IDAC,
@@ -3376,7 +3376,7 @@ static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
 		delays1[5] = 0x14;
 	}
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ &&
+	if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ &&
 	    nphy->band5g_pwrgain) {
 		b43_radio_mask(dev, B2055_C1_TX_RF_SPARE, ~0x8);
 		b43_radio_mask(dev, B2055_C2_TX_RF_SPARE, ~0x8);
@@ -3451,7 +3451,7 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = phy->n;
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 		b43_nphy_classifier(dev, 1, 0);
 	else
 		b43_nphy_classifier(dev, 1, 1);
@@ -3586,7 +3586,7 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
 		gain = (target.pad[core]) | (target.pga[core] << 4) |
 			(target.txgm[core] << 8);
 
-		indx = (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ?
+		indx = (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) ?
 			1 : 0;
 		for (i = 0; i < 9; i++)
 			if (tbl_iqcal_gainparams[indx][i][0] == gain)
@@ -3614,7 +3614,7 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 	struct b43_phy_n *nphy = dev->phy.n;
 	u8 i;
 	u16 bmask, val, tmp;
-	enum ieee80211_band band = b43_current_band(dev->wl);
+	enum nl80211_band band = b43_current_band(dev->wl);
 
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 1);
@@ -3679,7 +3679,7 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 		}
 		b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD, ~(bmask), val);
 
-		if (band == IEEE80211_BAND_5GHZ) {
+		if (band == NL80211_BAND_5GHZ) {
 			if (phy->rev >= 19) {
 				/* TODO */
 			} else if (phy->rev >= 7) {
@@ -3770,7 +3770,7 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 		txpi[0] = 72;
 		txpi[1] = 72;
 	} else {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 			txpi[0] = sprom->txpid2g[0];
 			txpi[1] = sprom->txpid2g[1];
 		} else if (freq >= 4900 && freq < 5100) {
@@ -3868,7 +3868,7 @@ static void b43_nphy_ipa_internal_tssi_setup(struct b43_wldev *dev)
 	} else if (phy->rev >= 7) {
 		for (core = 0; core < 2; core++) {
 			r = core ? 0x190 : 0x170;
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 				b43_radio_write(dev, r + 0x5, 0x5);
 				b43_radio_write(dev, r + 0x9, 0xE);
 				if (phy->rev != 5)
@@ -3892,7 +3892,7 @@ static void b43_nphy_ipa_internal_tssi_setup(struct b43_wldev *dev)
 			b43_radio_write(dev, r + 0xC, 0);
 		}
 	} else {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 			b43_radio_write(dev, B2056_SYN_RESERVED_ADDR31, 0x128);
 		else
 			b43_radio_write(dev, B2056_SYN_RESERVED_ADDR31, 0x80);
@@ -3909,7 +3909,7 @@ static void b43_nphy_ipa_internal_tssi_setup(struct b43_wldev *dev)
 			b43_radio_write(dev, r | B2056_TX_TSSI_MISC1, 8);
 			b43_radio_write(dev, r | B2056_TX_TSSI_MISC2, 0);
 			b43_radio_write(dev, r | B2056_TX_TSSI_MISC3, 0);
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 				b43_radio_write(dev, r | B2056_TX_TX_SSI_MASTER,
 						0x5);
 				if (phy->rev != 5)
@@ -4098,7 +4098,7 @@ static void b43_nphy_tx_power_ctl_setup(struct b43_wldev *dev)
 		b0[0] = b0[1] = 5612;
 		b1[0] = b1[1] = -1393;
 	} else {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 			for (c = 0; c < 2; c++) {
 				idle[c] = nphy->pwr_ctl_info[c].idle_tssi_2g;
 				target[c] = sprom->core_pwr_info[c].maxpwr_2g;
@@ -4153,11 +4153,11 @@ static void b43_nphy_tx_power_ctl_setup(struct b43_wldev *dev)
 			for (c = 0; c < 2; c++) {
 				r = c ? 0x190 : 0x170;
 				if (b43_nphy_ipa(dev))
-					b43_radio_write(dev, r + 0x9, (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) ? 0xE : 0xC);
+					b43_radio_write(dev, r + 0x9, (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) ? 0xE : 0xC);
 			}
 		} else {
 			if (b43_nphy_ipa(dev)) {
-				tmp = (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ? 0xC : 0xE;
+				tmp = (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) ? 0xC : 0xE;
 				b43_radio_write(dev,
 					B2056_TX0 | B2056_TX_TX_SSI_MUX, tmp);
 				b43_radio_write(dev,
@@ -4267,13 +4267,13 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 		} else if (phy->rev >= 7) {
 			pga_gain = (table[i] >> 24) & 0xf;
 			pad_gain = (table[i] >> 19) & 0x1f;
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+			if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 				rfpwr_offset = rf_pwr_offset_table[pad_gain];
 			else
 				rfpwr_offset = rf_pwr_offset_table[pga_gain];
 		} else {
 			pga_gain = (table[i] >> 24) & 0xF;
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+			if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 				rfpwr_offset = b43_ntab_papd_pga_gain_delta_ipa_2g[pga_gain];
 			else
 				rfpwr_offset = 0; /* FIXME */
@@ -4288,7 +4288,7 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 static void b43_nphy_pa_override(struct b43_wldev *dev, bool enable)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	u16 tmp;
 
 	if (!enable) {
@@ -4300,12 +4300,12 @@ static void b43_nphy_pa_override(struct b43_wldev *dev, bool enable)
 		if (dev->phy.rev >= 7) {
 			tmp = 0x1480;
 		} else if (dev->phy.rev >= 3) {
-			if (band == IEEE80211_BAND_5GHZ)
+			if (band == NL80211_BAND_5GHZ)
 				tmp = 0x600;
 			else
 				tmp = 0x480;
 		} else {
-			if (band == IEEE80211_BAND_5GHZ)
+			if (band == NL80211_BAND_5GHZ)
 				tmp = 0x180;
 			else
 				tmp = 0x120;
@@ -4734,7 +4734,7 @@ static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
 	u16 *rssical_radio_regs = NULL;
 	u16 *rssical_phy_regs = NULL;
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		if (!nphy->rssical_chanspec_2G.center_freq)
 			return;
 		rssical_radio_regs = nphy->rssical_cache.rssical_radio_regs_2G;
@@ -4804,7 +4804,7 @@ static void b43_nphy_tx_cal_radio_setup_rev7(struct b43_wldev *dev)
 		save[off + 7] = b43_radio_read(dev, r + R2057_TX0_TSSIG);
 		save[off + 8] = b43_radio_read(dev, r + R2057_TX0_TSSI_MISC1);
 
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 			b43_radio_write(dev, r + R2057_TX0_TX_SSI_MASTER, 0xA);
 			b43_radio_write(dev, r + R2057_TX0_IQCAL_VCM_HG, 0x43);
 			b43_radio_write(dev, r + R2057_TX0_IQCAL_IDAC, 0x55);
@@ -4864,7 +4864,7 @@ static void b43_nphy_tx_cal_radio_setup(struct b43_wldev *dev)
 		save[offset + 9] = b43_radio_read(dev, B2055_XOMISC);
 		save[offset + 10] = b43_radio_read(dev, B2055_PLL_LFC1);
 
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 			b43_radio_write(dev, tmp | B2055_CAL_RVARCTL, 0x0A);
 			b43_radio_write(dev, tmp | B2055_CAL_LPOCTL, 0x40);
 			b43_radio_write(dev, tmp | B2055_CAL_TS, 0x55);
@@ -5005,7 +5005,7 @@ static void b43_nphy_int_pa_set_tx_dig_filters(struct b43_wldev *dev)
 		b43_nphy_pa_set_tx_dig_filter(dev, 0x186,
 					      tbl_tx_filter_coef_rev4[3]);
 	} else {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+		if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 			b43_nphy_pa_set_tx_dig_filter(dev, 0x186,
 						      tbl_tx_filter_coef_rev4[5]);
 		if (dev->phy.channel == 14)
@@ -5185,7 +5185,7 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 							      false, 0);
 			} else if (phy->rev == 7) {
 				b43_radio_maskset(dev, R2057_OVR_REG0, 1 << 4, 1 << 4);
-				if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+				if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 					b43_radio_maskset(dev, R2057_PAD2G_TUNE_PUS_CORE0, ~1, 0);
 					b43_radio_maskset(dev, R2057_PAD2G_TUNE_PUS_CORE1, ~1, 0);
 				} else {
@@ -5210,7 +5210,7 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 		b43_ntab_write(dev, B43_NTAB16(8, 18), tmp);
 		regs[5] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
 		regs[6] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+		if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 			tmp = 0x0180;
 		else
 			tmp = 0x0120;
@@ -5233,7 +5233,7 @@ static void b43_nphy_save_cal(struct b43_wldev *dev)
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 1);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		rxcal_coeffs = &nphy->cal_cache.rxcal_coeffs_2G;
 		txcal_radio_regs = nphy->cal_cache.txcal_radio_regs_2G;
 		iqcal_chanspec = &nphy->iqcal_chanspec_2G;
@@ -5304,7 +5304,7 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
 	u16 *txcal_radio_regs = NULL;
 	struct b43_phy_n_iq_comp *rxcal_coeffs = NULL;
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		if (!nphy->iqcal_chanspec_2G.center_freq)
 			return;
 		table = nphy->cal_cache.txcal_coeffs_2G;
@@ -5332,7 +5332,7 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
 	if (dev->phy.rev < 2)
 		b43_nphy_tx_iq_workaround(dev);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		txcal_radio_regs = nphy->cal_cache.txcal_radio_regs_2G;
 		rxcal_coeffs = &nphy->cal_cache.rxcal_coeffs_2G;
 	} else {
@@ -5422,7 +5422,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 
 	phy6or5x = dev->phy.rev >= 6 ||
 		(dev->phy.rev == 5 && nphy->ipa2g_on &&
-		b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ);
+		b43_current_band(dev->wl) == NL80211_BAND_2GHZ);
 	if (phy6or5x) {
 		if (b43_is_40mhz(dev)) {
 			b43_ntab_write_bulk(dev, B43_NTAB16(15, 0), 18,
@@ -5657,7 +5657,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 	u16 tmp[6];
 	u16 uninitialized_var(cur_hpf1), uninitialized_var(cur_hpf2), cur_lna;
 	u32 real, imag;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	u8 use;
 	u16 cur_hpf;
@@ -5712,18 +5712,18 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 		band = b43_current_band(dev->wl);
 
 		if (nphy->rxcalparams & 0xFF000000) {
-			if (band == IEEE80211_BAND_5GHZ)
+			if (band == NL80211_BAND_5GHZ)
 				b43_phy_write(dev, rfctl[0], 0x140);
 			else
 				b43_phy_write(dev, rfctl[0], 0x110);
 		} else {
-			if (band == IEEE80211_BAND_5GHZ)
+			if (band == NL80211_BAND_5GHZ)
 				b43_phy_write(dev, rfctl[0], 0x180);
 			else
 				b43_phy_write(dev, rfctl[0], 0x120);
 		}
 
-		if (band == IEEE80211_BAND_5GHZ)
+		if (band == NL80211_BAND_5GHZ)
 			b43_phy_write(dev, rfctl[1], 0x148);
 		else
 			b43_phy_write(dev, rfctl[1], 0x114);
@@ -5919,7 +5919,7 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 #if 0
 	/* Some extra gains */
 	hw_gain = 6; /* N-PHY specific */
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		hw_gain += sprom->antenna_gain.a0;
 	else
 		hw_gain += sprom->antenna_gain.a1;
@@ -6043,7 +6043,7 @@ static int b43_phy_initn(struct b43_wldev *dev)
 	u8 tx_pwr_state;
 	struct nphy_txgains target;
 	u16 tmp;
-	enum ieee80211_band tmp2;
+	enum nl80211_band tmp2;
 	bool do_rssi_cal;
 
 	u16 clip[2];
@@ -6051,7 +6051,7 @@ static int b43_phy_initn(struct b43_wldev *dev)
 
 	if ((dev->phy.rev >= 3) &&
 	   (sprom->boardflags_lo & B43_BFL_EXTLNA) &&
-	   (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)) {
+	   (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)) {
 		switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 		case B43_BUS_BCMA:
@@ -6170,7 +6170,7 @@ static int b43_phy_initn(struct b43_wldev *dev)
 
 	b43_nphy_classifier(dev, 0, 0);
 	b43_nphy_read_clip_detection(dev, clip);
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		b43_nphy_bphy_init(dev);
 
 	tx_pwr_state = nphy->txpwrctrl;
@@ -6187,7 +6187,7 @@ static int b43_phy_initn(struct b43_wldev *dev)
 
 	do_rssi_cal = false;
 	if (phy->rev >= 3) {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 			do_rssi_cal = !nphy->rssical_chanspec_2G.center_freq;
 		else
 			do_rssi_cal = !nphy->rssical_chanspec_5G.center_freq;
@@ -6201,7 +6201,7 @@ static int b43_phy_initn(struct b43_wldev *dev)
 	}
 
 	if (!((nphy->measure_hold & 0x6) != 0)) {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 			do_cal = !nphy->iqcal_chanspec_2G.center_freq;
 		else
 			do_cal = !nphy->iqcal_chanspec_5G.center_freq;
@@ -6291,7 +6291,7 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 	int ch = new_channel->hw_value;
 	u16 tmp16;
 
-	if (new_channel->band == IEEE80211_BAND_5GHZ) {
+	if (new_channel->band == NL80211_BAND_5GHZ) {
 		/* Switch to 2 GHz for a moment to access B43_PHY_B_BBCFG */
 		b43_phy_mask(dev, B43_NPHY_BANDCTL, ~B43_NPHY_BANDCTL_5GHZ);
 
@@ -6302,7 +6302,7 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 			    B43_PHY_B_BBCFG_RSTCCA | B43_PHY_B_BBCFG_RSTRX);
 		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16);
 		b43_phy_set(dev, B43_NPHY_BANDCTL, B43_NPHY_BANDCTL_5GHZ);
-	} else if (new_channel->band == IEEE80211_BAND_2GHZ) {
+	} else if (new_channel->band == NL80211_BAND_2GHZ) {
 		b43_phy_mask(dev, B43_NPHY_BANDCTL, ~B43_NPHY_BANDCTL_5GHZ);
 		tmp16 = b43_read16(dev, B43_MMIO_PSM_PHY_HDR);
 		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16 | 4);
@@ -6319,7 +6319,7 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 		b43_phy_set(dev, B43_PHY_B_TEST, 0x0800);
 	} else {
 		b43_nphy_classifier(dev, 2, 2);
-		if (new_channel->band == IEEE80211_BAND_2GHZ)
+		if (new_channel->band == NL80211_BAND_2GHZ)
 			b43_phy_mask(dev, B43_PHY_B_TEST, ~0x840);
 	}
 
@@ -6449,7 +6449,7 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 			&(tabent_r7->phy_regs) : &(tabent_r7_2g->phy_regs);
 
 		if (phy->radio_rev <= 4 || phy->radio_rev == 6) {
-			tmp = (channel->band == IEEE80211_BAND_5GHZ) ? 2 : 0;
+			tmp = (channel->band == NL80211_BAND_5GHZ) ? 2 : 0;
 			b43_radio_maskset(dev, R2057_TIA_CONFIG_CORE0, ~2, tmp);
 			b43_radio_maskset(dev, R2057_TIA_CONFIG_CORE1, ~2, tmp);
 		}
@@ -6457,12 +6457,12 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 		b43_radio_2057_setup(dev, tabent_r7, tabent_r7_2g);
 		b43_nphy_channel_setup(dev, phy_regs, channel);
 	} else if (phy->rev >= 3) {
-		tmp = (channel->band == IEEE80211_BAND_5GHZ) ? 4 : 0;
+		tmp = (channel->band == NL80211_BAND_5GHZ) ? 4 : 0;
 		b43_radio_maskset(dev, 0x08, 0xFFFB, tmp);
 		b43_radio_2056_setup(dev, tabent_r3);
 		b43_nphy_channel_setup(dev, &(tabent_r3->phy_regs), channel);
 	} else {
-		tmp = (channel->band == IEEE80211_BAND_5GHZ) ? 0x0020 : 0x0050;
+		tmp = (channel->band == NL80211_BAND_5GHZ) ? 0x0020 : 0x0050;
 		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, tmp);
 		b43_radio_2055_setup(dev, tabent_r2);
 		b43_nphy_channel_setup(dev, &(tabent_r2->phy_regs), channel);
@@ -6692,7 +6692,7 @@ static int b43_nphy_op_switch_channel(struct b43_wldev *dev,
 	enum nl80211_channel_type channel_type =
 		cfg80211_get_chandef_type(&dev->wl->hw->conf.chandef);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
 			return -EINVAL;
 	} else {
@@ -6705,7 +6705,7 @@ static int b43_nphy_op_switch_channel(struct b43_wldev *dev,
 
 static unsigned int b43_nphy_op_get_default_chan(struct b43_wldev *dev)
 {
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 		return 1;
 	return 36;
 }
diff --git a/drivers/net/wireless/broadcom/b43/tables_lpphy.c b/drivers/net/wireless/broadcom/b43/tables_lpphy.c
index cff187c5616d..ce01e1645df7 100644
--- a/drivers/net/wireless/broadcom/b43/tables_lpphy.c
+++ b/drivers/net/wireless/broadcom/b43/tables_lpphy.c
@@ -560,7 +560,7 @@ void b2062_upload_init_table(struct b43_wldev *dev)
 
 	for (i = 0; i < ARRAY_SIZE(b2062_init_tab); i++) {
 		e = &b2062_init_tab[i];
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 			if (!(e->flags & B206X_FLAG_G))
 				continue;
 			b43_radio_write(dev, e->offset, e->value_g);
@@ -579,7 +579,7 @@ void b2063_upload_init_table(struct b43_wldev *dev)
 
 	for (i = 0; i < ARRAY_SIZE(b2063_init_tab); i++) {
 		e = &b2063_init_tab[i];
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 			if (!(e->flags & B206X_FLAG_G))
 				continue;
 			b43_radio_write(dev, e->offset, e->value_g);
@@ -2379,12 +2379,12 @@ static void lpphy_rev2plus_write_gain_table(struct b43_wldev *dev, int offset,
 	tmp |= data.pga << 8;
 	tmp |= data.gm;
 	if (dev->phy.rev >= 3) {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+		if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 			tmp |= 0x10 << 24;
 		else
 			tmp |= 0x70 << 24;
 	} else {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+		if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 			tmp |= 0x14 << 24;
 		else
 			tmp |= 0x7F << 24;
@@ -2423,7 +2423,7 @@ void lpphy_init_tx_gain_table(struct b43_wldev *dev)
 		    (sprom->boardflags_lo & B43_BFL_HGPA))
 			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev0_nopa_tx_gain_table);
-		else if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		else if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev0_2ghz_tx_gain_table);
 		else
@@ -2435,7 +2435,7 @@ void lpphy_init_tx_gain_table(struct b43_wldev *dev)
 		    (sprom->boardflags_lo & B43_BFL_HGPA))
 			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev1_nopa_tx_gain_table);
-		else if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		else if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev1_2ghz_tx_gain_table);
 		else
@@ -2446,7 +2446,7 @@ void lpphy_init_tx_gain_table(struct b43_wldev *dev)
 		if (sprom->boardflags_hi & B43_BFH_NOPA)
 			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev2_nopa_tx_gain_table);
-		else if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		else if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
 			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev2_2ghz_tx_gain_table);
 		else
diff --git a/drivers/net/wireless/broadcom/b43/tables_nphy.c b/drivers/net/wireless/broadcom/b43/tables_nphy.c
index b2f0d245bcf3..44e0957a70cc 100644
--- a/drivers/net/wireless/broadcom/b43/tables_nphy.c
+++ b/drivers/net/wireless/broadcom/b43/tables_nphy.c
@@ -3502,7 +3502,7 @@ static void b43_nphy_tables_init_rev7_volatile(struct b43_wldev *dev)
 		{ 0x2, 0x18, 0x2 }, /* Core 1 */
 	};
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 		antswlut = sprom->fem.ghz5.antswlut;
 	else
 		antswlut = sprom->fem.ghz2.antswlut;
@@ -3566,7 +3566,7 @@ static void b43_nphy_tables_init_rev3(struct b43_wldev *dev)
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	u8 antswlut;
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+	if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 		antswlut = sprom->fem.ghz5.antswlut;
 	else
 		antswlut = sprom->fem.ghz2.antswlut;
@@ -3651,7 +3651,7 @@ static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		switch (phy->rev) {
 		case 17:
 			if (phy->radio_rev == 14)
@@ -3698,17 +3698,17 @@ static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
 const u32 *b43_nphy_get_tx_gain_table(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
-	enum ieee80211_band band = b43_current_band(dev->wl);
+	enum nl80211_band band = b43_current_band(dev->wl);
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
 	if (dev->phy.rev < 3)
 		return b43_ntab_tx_gain_rev0_1_2;
 
 	/* rev 3+ */
-	if ((dev->phy.n->ipa2g_on && band == IEEE80211_BAND_2GHZ) ||
-	    (dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ)) {
+	if ((dev->phy.n->ipa2g_on && band == NL80211_BAND_2GHZ) ||
+	    (dev->phy.n->ipa5g_on && band == NL80211_BAND_5GHZ)) {
 		return b43_nphy_get_ipa_gain_table(dev);
-	} else if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+	} else if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ) {
 		switch (phy->rev) {
 		case 6:
 		case 5:
@@ -3746,7 +3746,7 @@ const s16 *b43_ntab_get_rf_pwr_offset_table(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		switch (phy->rev) {
 		case 17:
 			if (phy->radio_rev == 14)
diff --git a/drivers/net/wireless/broadcom/b43/tables_phy_lcn.c b/drivers/net/wireless/broadcom/b43/tables_phy_lcn.c
index e347b8d80ea4..704ef1bcb5b1 100644
--- a/drivers/net/wireless/broadcom/b43/tables_phy_lcn.c
+++ b/drivers/net/wireless/broadcom/b43/tables_phy_lcn.c
@@ -701,7 +701,7 @@ void b43_phy_lcn_tables_init(struct b43_wldev *dev)
 
 	b43_phy_lcn_upload_static_tables(dev);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ) {
 		if (sprom->boardflags_lo & B43_BFL_FEM)
 			b43_phy_lcn_load_tx_gain_tab(dev,
 				b43_lcntab_tx_gain_tbl_2ghz_ext_pa_rev0);
diff --git a/drivers/net/wireless/broadcom/b43/xmit.c b/drivers/net/wireless/broadcom/b43/xmit.c
index 426dc13c44cd..f6201264de49 100644
--- a/drivers/net/wireless/broadcom/b43/xmit.c
+++ b/drivers/net/wireless/broadcom/b43/xmit.c
@@ -803,7 +803,7 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	chanid = (chanstat & B43_RX_CHAN_ID) >> B43_RX_CHAN_ID_SHIFT;
 	switch (chanstat & B43_RX_CHAN_PHYTYPE) {
 	case B43_PHYTYPE_A:
-		status.band = IEEE80211_BAND_5GHZ;
+		status.band = NL80211_BAND_5GHZ;
 		B43_WARN_ON(1);
 		/* FIXME: We don't really know which value the "chanid" contains.
 		 *        So the following assignment might be wrong. */
@@ -811,7 +811,7 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 			ieee80211_channel_to_frequency(chanid, status.band);
 		break;
 	case B43_PHYTYPE_G:
-		status.band = IEEE80211_BAND_2GHZ;
+		status.band = NL80211_BAND_2GHZ;
 		/* Somewhere between 478.104 and 508.1084 firmware for G-PHY
 		 * has been modified to be compatible with N-PHY and others.
 		 */
@@ -826,9 +826,9 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		/* chanid is the SHM channel cookie. Which is the plain
 		 * channel number in b43. */
 		if (chanstat & B43_RX_CHAN_5GHZ)
-			status.band = IEEE80211_BAND_5GHZ;
+			status.band = NL80211_BAND_5GHZ;
 		else
-			status.band = IEEE80211_BAND_2GHZ;
+			status.band = NL80211_BAND_2GHZ;
 		status.freq =
 			ieee80211_channel_to_frequency(chanid, status.band);
 		break;
diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index afc1fb3e38df..83770d2ea057 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -1056,7 +1056,7 @@ static void b43legacy_write_probe_resp_plcp(struct b43legacy_wldev *dev,
 	b43legacy_generate_plcp_hdr(&plcp, size + FCS_LEN, rate->hw_value);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
 					       dev->wl->vif,
-					       IEEE80211_BAND_2GHZ,
+					       NL80211_BAND_2GHZ,
 					       size,
 					       rate);
 	/* Write PLCP in two parts and timing for packet transfer */
@@ -1122,7 +1122,7 @@ static const u8 *b43legacy_generate_probe_resp(struct b43legacy_wldev *dev,
 					 IEEE80211_STYPE_PROBE_RESP);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
 					       dev->wl->vif,
-					       IEEE80211_BAND_2GHZ,
+					       NL80211_BAND_2GHZ,
 					       *dest_size,
 					       rate);
 	hdr->duration_id = dur;
@@ -2719,7 +2719,7 @@ static int b43legacy_op_dev_config(struct ieee80211_hw *hw,
 
 	/* Switch the PHY mode (if necessary). */
 	switch (conf->chandef.chan->band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		if (phy->type == B43legacy_PHYTYPE_B)
 			new_phymode = B43legacy_PHYMODE_B;
 		else
@@ -2792,7 +2792,7 @@ out_unlock_mutex:
 static void b43legacy_update_basic_rates(struct b43legacy_wldev *dev, u32 brates)
 {
 	struct ieee80211_supported_band *sband =
-		dev->wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ];
+		dev->wl->hw->wiphy->bands[NL80211_BAND_2GHZ];
 	struct ieee80211_rate *rate;
 	int i;
 	u16 basic, direct, offset, basic_offset, rateptr;
@@ -3630,13 +3630,13 @@ static int b43legacy_setup_modes(struct b43legacy_wldev *dev,
 
 	phy->possible_phymodes = 0;
 	if (have_bphy) {
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+		hw->wiphy->bands[NL80211_BAND_2GHZ] =
 			&b43legacy_band_2GHz_BPHY;
 		phy->possible_phymodes |= B43legacy_PHYMODE_B;
 	}
 
 	if (have_gphy) {
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+		hw->wiphy->bands[NL80211_BAND_2GHZ] =
 			&b43legacy_band_2GHz_GPHY;
 		phy->possible_phymodes |= B43legacy_PHYMODE_G;
 	}
diff --git a/drivers/net/wireless/broadcom/b43legacy/xmit.c b/drivers/net/wireless/broadcom/b43legacy/xmit.c
index 34bf3f0b729f..35ccf400b02c 100644
--- a/drivers/net/wireless/broadcom/b43legacy/xmit.c
+++ b/drivers/net/wireless/broadcom/b43legacy/xmit.c
@@ -565,7 +565,7 @@ void b43legacy_rx(struct b43legacy_wldev *dev,
 	switch (chanstat & B43legacy_RX_CHAN_PHYTYPE) {
 	case B43legacy_PHYTYPE_B:
 	case B43legacy_PHYTYPE_G:
-		status.band = IEEE80211_BAND_2GHZ;
+		status.band = NL80211_BAND_2GHZ;
 		status.freq = chanid + 2400;
 		break;
 	default:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index d5c2a27573b4..9a567e263bb1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -144,7 +144,7 @@ static struct ieee80211_rate __wl_rates[] = {
 #define wl_a_rates_size		(wl_g_rates_size - 4)
 
 #define CHAN2G(_channel, _freq) {				\
-	.band			= IEEE80211_BAND_2GHZ,		\
+	.band			= NL80211_BAND_2GHZ,		\
 	.center_freq		= (_freq),			\
 	.hw_value		= (_channel),			\
 	.flags			= IEEE80211_CHAN_DISABLED,	\
@@ -153,7 +153,7 @@ static struct ieee80211_rate __wl_rates[] = {
 }
 
 #define CHAN5G(_channel) {					\
-	.band			= IEEE80211_BAND_5GHZ,		\
+	.band			= NL80211_BAND_5GHZ,		\
 	.center_freq		= 5000 + (5 * (_channel)),	\
 	.hw_value		= (_channel),			\
 	.flags			= IEEE80211_CHAN_DISABLED,	\
@@ -181,13 +181,13 @@ static struct ieee80211_channel __wl_5ghz_channels[] = {
  * above is added to the band during setup.
  */
 static const struct ieee80211_supported_band __wl_band_2ghz = {
-	.band = IEEE80211_BAND_2GHZ,
+	.band = NL80211_BAND_2GHZ,
 	.bitrates = wl_g_rates,
 	.n_bitrates = wl_g_rates_size,
 };
 
 static const struct ieee80211_supported_band __wl_band_5ghz = {
-	.band = IEEE80211_BAND_5GHZ,
+	.band = NL80211_BAND_5GHZ,
 	.bitrates = wl_a_rates,
 	.n_bitrates = wl_a_rates_size,
 };
@@ -292,13 +292,13 @@ static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
 		WARN_ON_ONCE(1);
 	}
 	switch (ch->chan->band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		ch_inf.band = BRCMU_CHAN_BAND_2G;
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		ch_inf.band = BRCMU_CHAN_BAND_5G;
 		break;
-	case IEEE80211_BAND_60GHZ:
+	case NL80211_BAND_60GHZ:
 	default:
 		WARN_ON_ONCE(1);
 	}
@@ -2679,9 +2679,9 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	channel = bi->ctl_ch;
 
 	if (channel <= CH_MAX_2G_CHANNEL)
-		band = wiphy->bands[IEEE80211_BAND_2GHZ];
+		band = wiphy->bands[NL80211_BAND_2GHZ];
 	else
-		band = wiphy->bands[IEEE80211_BAND_5GHZ];
+		band = wiphy->bands[NL80211_BAND_5GHZ];
 
 	freq = ieee80211_channel_to_frequency(channel, band->band);
 	notify_channel = ieee80211_get_channel(wiphy, freq);
@@ -2788,9 +2788,9 @@ static s32 brcmf_inform_ibss(struct brcmf_cfg80211_info *cfg,
 	cfg->d11inf.decchspec(&ch);
 
 	if (ch.band == BRCMU_CHAN_BAND_2G)
-		band = wiphy->bands[IEEE80211_BAND_2GHZ];
+		band = wiphy->bands[NL80211_BAND_2GHZ];
 	else
-		band = wiphy->bands[IEEE80211_BAND_5GHZ];
+		band = wiphy->bands[NL80211_BAND_5GHZ];
 
 	freq = ieee80211_channel_to_frequency(ch.chnum, band->band);
 	cfg->channel = freq;
@@ -5215,9 +5215,9 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	cfg->d11inf.decchspec(&ch);
 
 	if (ch.band == BRCMU_CHAN_BAND_2G)
-		band = wiphy->bands[IEEE80211_BAND_2GHZ];
+		band = wiphy->bands[NL80211_BAND_2GHZ];
 	else
-		band = wiphy->bands[IEEE80211_BAND_5GHZ];
+		band = wiphy->bands[NL80211_BAND_5GHZ];
 
 	freq = ieee80211_channel_to_frequency(ch.chnum, band->band);
 	notify_channel = ieee80211_get_channel(wiphy, freq);
@@ -5707,11 +5707,11 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 	}
 
 	wiphy = cfg_to_wiphy(cfg);
-	band = wiphy->bands[IEEE80211_BAND_2GHZ];
+	band = wiphy->bands[NL80211_BAND_2GHZ];
 	if (band)
 		for (i = 0; i < band->n_channels; i++)
 			band->channels[i].flags = IEEE80211_CHAN_DISABLED;
-	band = wiphy->bands[IEEE80211_BAND_5GHZ];
+	band = wiphy->bands[NL80211_BAND_5GHZ];
 	if (band)
 		for (i = 0; i < band->n_channels; i++)
 			band->channels[i].flags = IEEE80211_CHAN_DISABLED;
@@ -5722,9 +5722,9 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 		cfg->d11inf.decchspec(&ch);
 
 		if (ch.band == BRCMU_CHAN_BAND_2G) {
-			band = wiphy->bands[IEEE80211_BAND_2GHZ];
+			band = wiphy->bands[NL80211_BAND_2GHZ];
 		} else if (ch.band == BRCMU_CHAN_BAND_5G) {
-			band = wiphy->bands[IEEE80211_BAND_5GHZ];
+			band = wiphy->bands[NL80211_BAND_5GHZ];
 		} else {
 			brcmf_err("Invalid channel Spec. 0x%x.\n", ch.chspec);
 			continue;
@@ -5839,7 +5839,7 @@ static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 			return err;
 		}
 
-		band = cfg_to_wiphy(cfg)->bands[IEEE80211_BAND_2GHZ];
+		band = cfg_to_wiphy(cfg)->bands[NL80211_BAND_2GHZ];
 		list = (struct brcmf_chanspec_list *)pbuf;
 		num_chan = le32_to_cpu(list->count);
 		for (i = 0; i < num_chan; i++) {
@@ -5871,11 +5871,11 @@ static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
 	band = WLC_BAND_2G;
 	err = brcmf_fil_iovar_int_get(ifp, "bw_cap", &band);
 	if (!err) {
-		bw_cap[IEEE80211_BAND_2GHZ] = band;
+		bw_cap[NL80211_BAND_2GHZ] = band;
 		band = WLC_BAND_5G;
 		err = brcmf_fil_iovar_int_get(ifp, "bw_cap", &band);
 		if (!err) {
-			bw_cap[IEEE80211_BAND_5GHZ] = band;
+			bw_cap[NL80211_BAND_5GHZ] = band;
 			return;
 		}
 		WARN_ON(1);
@@ -5890,14 +5890,14 @@ static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
 
 	switch (mimo_bwcap) {
 	case WLC_N_BW_40ALL:
-		bw_cap[IEEE80211_BAND_2GHZ] |= WLC_BW_40MHZ_BIT;
+		bw_cap[NL80211_BAND_2GHZ] |= WLC_BW_40MHZ_BIT;
 		/* fall-thru */
 	case WLC_N_BW_20IN2G_40IN5G:
-		bw_cap[IEEE80211_BAND_5GHZ] |= WLC_BW_40MHZ_BIT;
+		bw_cap[NL80211_BAND_5GHZ] |= WLC_BW_40MHZ_BIT;
 		/* fall-thru */
 	case WLC_N_BW_20ALL:
-		bw_cap[IEEE80211_BAND_2GHZ] |= WLC_BW_20MHZ_BIT;
-		bw_cap[IEEE80211_BAND_5GHZ] |= WLC_BW_20MHZ_BIT;
+		bw_cap[NL80211_BAND_2GHZ] |= WLC_BW_20MHZ_BIT;
+		bw_cap[NL80211_BAND_5GHZ] |= WLC_BW_20MHZ_BIT;
 		break;
 	default:
 		brcmf_err("invalid mimo_bw_cap value\n");
@@ -5938,7 +5938,7 @@ static void brcmf_update_vht_cap(struct ieee80211_supported_band *band,
 	__le16 mcs_map;
 
 	/* not allowed in 2.4G band */
-	if (band->band == IEEE80211_BAND_2GHZ)
+	if (band->band == NL80211_BAND_2GHZ)
 		return;
 
 	band->vht_cap.vht_supported = true;
@@ -5997,8 +5997,8 @@ static int brcmf_setup_wiphybands(struct wiphy *wiphy)
 		brcmf_get_bwcap(ifp, bw_cap);
 	}
 	brcmf_dbg(INFO, "nmode=%d, vhtmode=%d, bw_cap=(%d, %d)\n",
-		  nmode, vhtmode, bw_cap[IEEE80211_BAND_2GHZ],
-		  bw_cap[IEEE80211_BAND_5GHZ]);
+		  nmode, vhtmode, bw_cap[NL80211_BAND_2GHZ],
+		  bw_cap[NL80211_BAND_5GHZ]);
 
 	err = brcmf_fil_iovar_int_get(ifp, "rxchain", &rxchain);
 	if (err) {
@@ -6321,7 +6321,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 			}
 
 			band->n_channels = ARRAY_SIZE(__wl_2ghz_channels);
-			wiphy->bands[IEEE80211_BAND_2GHZ] = band;
+			wiphy->bands[NL80211_BAND_2GHZ] = band;
 		}
 		if (bandlist[i] == cpu_to_le32(WLC_BAND_5G)) {
 			band = kmemdup(&__wl_band_5ghz, sizeof(__wl_band_5ghz),
@@ -6338,7 +6338,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 			}
 
 			band->n_channels = ARRAY_SIZE(__wl_5ghz_channels);
-			wiphy->bands[IEEE80211_BAND_5GHZ] = band;
+			wiphy->bands[NL80211_BAND_5GHZ] = band;
 		}
 	}
 	err = brcmf_setup_wiphybands(wiphy);
@@ -6604,13 +6604,13 @@ static void brcmf_free_wiphy(struct wiphy *wiphy)
 			kfree(wiphy->iface_combinations[i].limits);
 	}
 	kfree(wiphy->iface_combinations);
-	if (wiphy->bands[IEEE80211_BAND_2GHZ]) {
-		kfree(wiphy->bands[IEEE80211_BAND_2GHZ]->channels);
-		kfree(wiphy->bands[IEEE80211_BAND_2GHZ]);
+	if (wiphy->bands[NL80211_BAND_2GHZ]) {
+		kfree(wiphy->bands[NL80211_BAND_2GHZ]->channels);
+		kfree(wiphy->bands[NL80211_BAND_2GHZ]);
 	}
-	if (wiphy->bands[IEEE80211_BAND_5GHZ]) {
-		kfree(wiphy->bands[IEEE80211_BAND_5GHZ]->channels);
-		kfree(wiphy->bands[IEEE80211_BAND_5GHZ]);
+	if (wiphy->bands[NL80211_BAND_5GHZ]) {
+		kfree(wiphy->bands[NL80211_BAND_5GHZ]->channels);
+		kfree(wiphy->bands[NL80211_BAND_5GHZ]);
 	}
 	wiphy_free(wiphy);
 }
@@ -6698,8 +6698,8 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	 * cfg80211 here that we do and have it decide we can enable
 	 * it. But first check if device does support 2G operation.
 	 */
-	if (wiphy->bands[IEEE80211_BAND_2GHZ]) {
-		cap = &wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap;
+	if (wiphy->bands[NL80211_BAND_2GHZ]) {
+		cap = &wiphy->bands[NL80211_BAND_2GHZ]->ht_cap.cap;
 		*cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 	}
 	err = wiphy_register(wiphy);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index b5a49e564f25..c2ac91df35ed 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1430,8 +1430,8 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 
 	freq = ieee80211_channel_to_frequency(ch.chnum,
 					      ch.band == BRCMU_CHAN_BAND_2G ?
-					      IEEE80211_BAND_2GHZ :
-					      IEEE80211_BAND_5GHZ);
+					      NL80211_BAND_2GHZ :
+					      NL80211_BAND_5GHZ);
 
 	wdev = &ifp->vif->wdev;
 	cfg80211_rx_mgmt(wdev, freq, 0, (u8 *)mgmt_frame, mgmt_frame_len, 0);
@@ -1900,8 +1900,8 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 	mgmt_frame_len = e->datalen - sizeof(*rxframe);
 	freq = ieee80211_channel_to_frequency(ch.chnum,
 					      ch.band == BRCMU_CHAN_BAND_2G ?
-					      IEEE80211_BAND_2GHZ :
-					      IEEE80211_BAND_5GHZ);
+					      NL80211_BAND_2GHZ :
+					      NL80211_BAND_5GHZ);
 
 	cfg80211_rx_mgmt(&vif->wdev, freq, 0, mgmt_frame, mgmt_frame_len, 0);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
index 38bd5890bd53..3a03287fa912 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
@@ -636,7 +636,7 @@ static void brcms_reg_apply_radar_flags(struct wiphy *wiphy)
 	struct ieee80211_channel *ch;
 	int i;
 
-	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+	sband = wiphy->bands[NL80211_BAND_5GHZ];
 	if (!sband)
 		return;
 
@@ -666,7 +666,7 @@ brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *rule;
 	int band, i;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		sband = wiphy->bands[band];
 		if (!sband)
 			continue;
@@ -710,7 +710,7 @@ static void brcms_reg_notifier(struct wiphy *wiphy,
 		brcms_reg_apply_beaconing_flags(wiphy, request->initiator);
 
 	/* Disable radio if all channels disallowed by regulatory */
-	for (band = 0; !ch_found && band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; !ch_found && band < NUM_NL80211_BANDS; band++) {
 		sband = wiphy->bands[band];
 		if (!sband)
 			continue;
@@ -755,9 +755,9 @@ void brcms_c_regd_init(struct brcms_c_info *wlc)
 					      &sup_chan);
 
 		if (band_idx == BAND_2G_INDEX)
-			sband = wiphy->bands[IEEE80211_BAND_2GHZ];
+			sband = wiphy->bands[NL80211_BAND_2GHZ];
 		else
-			sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+			sband = wiphy->bands[NL80211_BAND_5GHZ];
 
 		for (i = 0; i < sband->n_channels; i++) {
 			ch = &sband->channels[i];
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index 61ae2768132a..7c2a9a9bc372 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -49,7 +49,7 @@
 	FIF_PSPOLL)
 
 #define CHAN2GHZ(channel, freqency, chflags)  { \
-	.band = IEEE80211_BAND_2GHZ, \
+	.band = NL80211_BAND_2GHZ, \
 	.center_freq = (freqency), \
 	.hw_value = (channel), \
 	.flags = chflags, \
@@ -58,7 +58,7 @@
 }
 
 #define CHAN5GHZ(channel, chflags)  { \
-	.band = IEEE80211_BAND_5GHZ, \
+	.band = NL80211_BAND_5GHZ, \
 	.center_freq = 5000 + 5*(channel), \
 	.hw_value = (channel), \
 	.flags = chflags, \
@@ -217,7 +217,7 @@ static struct ieee80211_rate legacy_ratetable[] = {
 };
 
 static const struct ieee80211_supported_band brcms_band_2GHz_nphy_template = {
-	.band = IEEE80211_BAND_2GHZ,
+	.band = NL80211_BAND_2GHZ,
 	.channels = brcms_2ghz_chantable,
 	.n_channels = ARRAY_SIZE(brcms_2ghz_chantable),
 	.bitrates = legacy_ratetable,
@@ -238,7 +238,7 @@ static const struct ieee80211_supported_band brcms_band_2GHz_nphy_template = {
 };
 
 static const struct ieee80211_supported_band brcms_band_5GHz_nphy_template = {
-	.band = IEEE80211_BAND_5GHZ,
+	.band = NL80211_BAND_5GHZ,
 	.channels = brcms_5ghz_nphy_chantable,
 	.n_channels = ARRAY_SIZE(brcms_5ghz_nphy_chantable),
 	.bitrates = legacy_ratetable + BRCMS_LEGACY_5G_RATE_OFFSET,
@@ -1026,8 +1026,8 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	int has_5g = 0;
 	u16 phy_type;
 
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = NULL;
-	hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
+	hw->wiphy->bands[NL80211_BAND_2GHZ] = NULL;
+	hw->wiphy->bands[NL80211_BAND_5GHZ] = NULL;
 
 	phy_type = brcms_c_get_phy_type(wl->wlc, 0);
 	if (phy_type == PHY_TYPE_N || phy_type == PHY_TYPE_LCN) {
@@ -1038,7 +1038,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 			band->ht_cap.mcs.rx_mask[1] = 0;
 			band->ht_cap.mcs.rx_highest = cpu_to_le16(72);
 		}
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = band;
+		hw->wiphy->bands[NL80211_BAND_2GHZ] = band;
 	} else {
 		return -EPERM;
 	}
@@ -1049,7 +1049,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 		if (phy_type == PHY_TYPE_N || phy_type == PHY_TYPE_LCN) {
 			band = &wlc->bandstate[BAND_5G_INDEX]->band;
 			*band = brcms_band_5GHz_nphy_template;
-			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = band;
+			hw->wiphy->bands[NL80211_BAND_5GHZ] = band;
 		} else {
 			return -EPERM;
 		}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 218cbc8bf3a7..e16ee60639f5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -7076,7 +7076,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	channel = BRCMS_CHAN_CHANNEL(rxh->RxChan);
 
 	rx_status->band =
-		channel > 14 ? IEEE80211_BAND_5GHZ : IEEE80211_BAND_2GHZ;
+		channel > 14 ? NL80211_BAND_5GHZ : NL80211_BAND_2GHZ;
 	rx_status->freq =
 		ieee80211_channel_to_frequency(channel, rx_status->band);
 
@@ -7143,7 +7143,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 		 * a subset of the 2.4G rates. See bitrates field
 		 * of brcms_band_5GHz_nphy (in mac80211_if.c).
 		 */
-		if (rx_status->band == IEEE80211_BAND_5GHZ)
+		if (rx_status->band == NL80211_BAND_5GHZ)
 			rx_status->rate_idx -= BRCMS_LEGACY_5G_RATE_OFFSET;
 
 		/* Determine short preamble and rate_idx */
diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index d2353f6e5214..4bd9e2b97e86 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -5836,7 +5836,7 @@ static int airo_get_freq(struct net_device *dev,
 	ch = le16_to_cpu(status_rid.channel);
 	if((ch > 0) && (ch < 15)) {
 		fwrq->m = 100000 *
-			ieee80211_channel_to_frequency(ch, IEEE80211_BAND_2GHZ);
+			ieee80211_channel_to_frequency(ch, NL80211_BAND_2GHZ);
 		fwrq->e = 1;
 	} else {
 		fwrq->m = ch;
@@ -6894,7 +6894,7 @@ static int airo_get_range(struct net_device *dev,
 	for(i = 0; i < 14; i++) {
 		range->freq[k].i = i + 1; /* List index */
 		range->freq[k].m = 100000 *
-		     ieee80211_channel_to_frequency(i + 1, IEEE80211_BAND_2GHZ);
+		     ieee80211_channel_to_frequency(i + 1, NL80211_BAND_2GHZ);
 		range->freq[k++].e = 1;	/* Values in MHz -> * 10^5 * 10 */
 	}
 	range->num_frequency = k;
@@ -7302,7 +7302,7 @@ static inline char *airo_translate_scan(struct net_device *dev,
 	iwe.cmd = SIOCGIWFREQ;
 	iwe.u.freq.m = le16_to_cpu(bss->dsChannel);
 	iwe.u.freq.m = 100000 *
-	      ieee80211_channel_to_frequency(iwe.u.freq.m, IEEE80211_BAND_2GHZ);
+	      ieee80211_channel_to_frequency(iwe.u.freq.m, NL80211_BAND_2GHZ);
 	iwe.u.freq.e = 1;
 	current_ev = iwe_stream_add_event(info, current_ev, end_buf,
 					  &iwe, IW_EV_FREQ_LEN);
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 717320b17622..e1e42ed6c412 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -1913,7 +1913,7 @@ static int ipw2100_wdev_init(struct net_device *dev)
 	if (geo->bg_channels) {
 		struct ieee80211_supported_band *bg_band = &priv->ieee->bg_band;
 
-		bg_band->band = IEEE80211_BAND_2GHZ;
+		bg_band->band = NL80211_BAND_2GHZ;
 		bg_band->n_channels = geo->bg_channels;
 		bg_band->channels = kcalloc(geo->bg_channels,
 					    sizeof(struct ieee80211_channel),
@@ -1924,7 +1924,7 @@ static int ipw2100_wdev_init(struct net_device *dev)
 		}
 		/* translate geo->bg to bg_band.channels */
 		for (i = 0; i < geo->bg_channels; i++) {
-			bg_band->channels[i].band = IEEE80211_BAND_2GHZ;
+			bg_band->channels[i].band = NL80211_BAND_2GHZ;
 			bg_band->channels[i].center_freq = geo->bg[i].freq;
 			bg_band->channels[i].hw_value = geo->bg[i].channel;
 			bg_band->channels[i].max_power = geo->bg[i].max_power;
@@ -1945,7 +1945,7 @@ static int ipw2100_wdev_init(struct net_device *dev)
 		bg_band->bitrates = ipw2100_bg_rates;
 		bg_band->n_bitrates = RATE_COUNT;
 
-		wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = bg_band;
+		wdev->wiphy->bands[NL80211_BAND_2GHZ] = bg_band;
 	}
 
 	wdev->wiphy->cipher_suites = ipw_cipher_suites;
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index ed0adaf1eec4..dac13cf42e9f 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -11359,7 +11359,7 @@ static int ipw_wdev_init(struct net_device *dev)
 	if (geo->bg_channels) {
 		struct ieee80211_supported_band *bg_band = &priv->ieee->bg_band;
 
-		bg_band->band = IEEE80211_BAND_2GHZ;
+		bg_band->band = NL80211_BAND_2GHZ;
 		bg_band->n_channels = geo->bg_channels;
 		bg_band->channels = kcalloc(geo->bg_channels,
 					    sizeof(struct ieee80211_channel),
@@ -11370,7 +11370,7 @@ static int ipw_wdev_init(struct net_device *dev)
 		}
 		/* translate geo->bg to bg_band.channels */
 		for (i = 0; i < geo->bg_channels; i++) {
-			bg_band->channels[i].band = IEEE80211_BAND_2GHZ;
+			bg_band->channels[i].band = NL80211_BAND_2GHZ;
 			bg_band->channels[i].center_freq = geo->bg[i].freq;
 			bg_band->channels[i].hw_value = geo->bg[i].channel;
 			bg_band->channels[i].max_power = geo->bg[i].max_power;
@@ -11391,14 +11391,14 @@ static int ipw_wdev_init(struct net_device *dev)
 		bg_band->bitrates = ipw2200_bg_rates;
 		bg_band->n_bitrates = ipw2200_num_bg_rates;
 
-		wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = bg_band;
+		wdev->wiphy->bands[NL80211_BAND_2GHZ] = bg_band;
 	}
 
 	/* fill-out priv->ieee->a_band */
 	if (geo->a_channels) {
 		struct ieee80211_supported_band *a_band = &priv->ieee->a_band;
 
-		a_band->band = IEEE80211_BAND_5GHZ;
+		a_band->band = NL80211_BAND_5GHZ;
 		a_band->n_channels = geo->a_channels;
 		a_band->channels = kcalloc(geo->a_channels,
 					   sizeof(struct ieee80211_channel),
@@ -11409,7 +11409,7 @@ static int ipw_wdev_init(struct net_device *dev)
 		}
 		/* translate geo->a to a_band.channels */
 		for (i = 0; i < geo->a_channels; i++) {
-			a_band->channels[i].band = IEEE80211_BAND_5GHZ;
+			a_band->channels[i].band = NL80211_BAND_5GHZ;
 			a_band->channels[i].center_freq = geo->a[i].freq;
 			a_band->channels[i].hw_value = geo->a[i].channel;
 			a_band->channels[i].max_power = geo->a[i].max_power;
@@ -11430,7 +11430,7 @@ static int ipw_wdev_init(struct net_device *dev)
 		a_band->bitrates = ipw2200_a_rates;
 		a_band->n_bitrates = ipw2200_num_a_rates;
 
-		wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = a_band;
+		wdev->wiphy->bands[NL80211_BAND_5GHZ] = a_band;
 	}
 
 	wdev->wiphy->cipher_suites = ipw_cipher_suites;
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index af1b3e6839fa..466912eb2d87 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -1547,7 +1547,7 @@ il3945_irq_tasklet(struct il_priv *il)
 }
 
 static int
-il3945_get_channels_for_scan(struct il_priv *il, enum ieee80211_band band,
+il3945_get_channels_for_scan(struct il_priv *il, enum nl80211_band band,
 			     u8 is_active, u8 n_probes,
 			     struct il3945_scan_channel *scan_ch,
 			     struct ieee80211_vif *vif)
@@ -1618,7 +1618,7 @@ il3945_get_channels_for_scan(struct il_priv *il, enum ieee80211_band band,
 		/* scan_pwr_info->tpc.dsp_atten; */
 
 		/*scan_pwr_info->tpc.tx_gain; */
-		if (band == IEEE80211_BAND_5GHZ)
+		if (band == NL80211_BAND_5GHZ)
 			scan_ch->tpc.tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else {
 			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
@@ -2534,7 +2534,7 @@ il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	};
 	struct il3945_scan_cmd *scan;
 	u8 n_probes = 0;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	bool is_active = false;
 	int ret;
 	u16 len;
@@ -2615,14 +2615,14 @@ il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	/* flags + rate selection */
 
 	switch (il->scan_band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		scan->tx_cmd.rate = RATE_1M_PLCP;
-		band = IEEE80211_BAND_2GHZ;
+		band = NL80211_BAND_2GHZ;
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		scan->tx_cmd.rate = RATE_6M_PLCP;
-		band = IEEE80211_BAND_5GHZ;
+		band = NL80211_BAND_5GHZ;
 		break;
 	default:
 		IL_WARN("Invalid scan band\n");
@@ -3507,7 +3507,7 @@ il3945_init_drv(struct il_priv *il)
 
 	il->ieee_channels = NULL;
 	il->ieee_rates = NULL;
-	il->band = IEEE80211_BAND_2GHZ;
+	il->band = NL80211_BAND_2GHZ;
 
 	il->iw_mode = NL80211_IFTYPE_STATION;
 	il->missed_beacon_threshold = IL_MISSED_BEACON_THRESHOLD_DEF;
@@ -3582,13 +3582,13 @@ il3945_setup_mac(struct il_priv *il)
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
 
-	if (il->bands[IEEE80211_BAND_2GHZ].n_channels)
-		il->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-		    &il->bands[IEEE80211_BAND_2GHZ];
+	if (il->bands[NL80211_BAND_2GHZ].n_channels)
+		il->hw->wiphy->bands[NL80211_BAND_2GHZ] =
+		    &il->bands[NL80211_BAND_2GHZ];
 
-	if (il->bands[IEEE80211_BAND_5GHZ].n_channels)
-		il->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-		    &il->bands[IEEE80211_BAND_5GHZ];
+	if (il->bands[NL80211_BAND_5GHZ].n_channels)
+		il->hw->wiphy->bands[NL80211_BAND_5GHZ] =
+		    &il->bands[NL80211_BAND_5GHZ];
 
 	il_leds_init(il);
 
@@ -3761,7 +3761,7 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_release_irq;
 	}
 
-	il_set_rxon_channel(il, &il->bands[IEEE80211_BAND_2GHZ].channels[5]);
+	il_set_rxon_channel(il, &il->bands[NL80211_BAND_2GHZ].channels[5]);
 	il3945_setup_deferred_work(il);
 	il3945_setup_handlers(il);
 	il_power_initialize(il);
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-rs.c b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
index 76b0729ade17..03ad9b8b55f4 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
@@ -97,7 +97,7 @@ static struct il3945_tpt_entry il3945_tpt_table_g[] = {
 #define RATE_RETRY_TH		15
 
 static u8
-il3945_get_rate_idx_by_rssi(s32 rssi, enum ieee80211_band band)
+il3945_get_rate_idx_by_rssi(s32 rssi, enum nl80211_band band)
 {
 	u32 idx = 0;
 	u32 table_size = 0;
@@ -107,11 +107,11 @@ il3945_get_rate_idx_by_rssi(s32 rssi, enum ieee80211_band band)
 		rssi = IL_MIN_RSSI_VAL;
 
 	switch (band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		tpt_table = il3945_tpt_table_g;
 		table_size = ARRAY_SIZE(il3945_tpt_table_g);
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		tpt_table = il3945_tpt_table_a;
 		table_size = ARRAY_SIZE(il3945_tpt_table_a);
 		break;
@@ -380,7 +380,7 @@ il3945_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_id)
 
 	il->_3945.sta_supp_rates = sta->supp_rates[sband->band];
 	/* For 5 GHz band it start at IL_FIRST_OFDM_RATE */
-	if (sband->band == IEEE80211_BAND_5GHZ) {
+	if (sband->band == NL80211_BAND_5GHZ) {
 		rs_sta->last_txrate_idx += IL_FIRST_OFDM_RATE;
 		il->_3945.sta_supp_rates <<= IL_FIRST_OFDM_RATE;
 	}
@@ -541,7 +541,7 @@ il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *sband,
 
 static u16
 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta, u8 idx, u16 rate_mask,
-			 enum ieee80211_band band)
+			 enum nl80211_band band)
 {
 	u8 high = RATE_INVALID;
 	u8 low = RATE_INVALID;
@@ -549,7 +549,7 @@ il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta, u8 idx, u16 rate_mask,
 
 	/* 802.11A walks to the next literal adjacent rate in
 	 * the rate table */
-	if (unlikely(band == IEEE80211_BAND_5GHZ)) {
+	if (unlikely(band == NL80211_BAND_5GHZ)) {
 		int i;
 		u32 mask;
 
@@ -657,14 +657,14 @@ il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 
 	/* get user max rate if set */
 	max_rate_idx = txrc->max_rate_idx;
-	if (sband->band == IEEE80211_BAND_5GHZ && max_rate_idx != -1)
+	if (sband->band == NL80211_BAND_5GHZ && max_rate_idx != -1)
 		max_rate_idx += IL_FIRST_OFDM_RATE;
 	if (max_rate_idx < 0 || max_rate_idx >= RATE_COUNT)
 		max_rate_idx = -1;
 
 	idx = min(rs_sta->last_txrate_idx & 0xffff, RATE_COUNT_3945 - 1);
 
-	if (sband->band == IEEE80211_BAND_5GHZ)
+	if (sband->band == NL80211_BAND_5GHZ)
 		rate_mask = rate_mask << IL_FIRST_OFDM_RATE;
 
 	spin_lock_irqsave(&rs_sta->lock, flags);
@@ -806,7 +806,7 @@ il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 
 out:
 
-	if (sband->band == IEEE80211_BAND_5GHZ) {
+	if (sband->band == NL80211_BAND_5GHZ) {
 		if (WARN_ON_ONCE(idx < IL_FIRST_OFDM_RATE))
 			idx = IL_FIRST_OFDM_RATE;
 		rs_sta->last_txrate_idx = idx;
@@ -935,7 +935,7 @@ il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 
 	rs_sta->tgg = 0;
 	switch (il->band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		/* TODO: this always does G, not a regression */
 		if (il->active.flags & RXON_FLG_TGG_PROTECT_MSK) {
 			rs_sta->tgg = 1;
@@ -943,7 +943,7 @@ il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 		} else
 			rs_sta->expected_tpt = il3945_expected_tpt_g;
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		rs_sta->expected_tpt = il3945_expected_tpt_a;
 		break;
 	default:
diff --git a/drivers/net/wireless/intel/iwlegacy/3945.c b/drivers/net/wireless/intel/iwlegacy/3945.c
index 93bdf684babe..7bcedbb53d94 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945.c
@@ -255,13 +255,13 @@ il3945_rs_next_rate(struct il_priv *il, int rate)
 	int next_rate = il3945_get_prev_ieee_rate(rate);
 
 	switch (il->band) {
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		if (rate == RATE_12M_IDX)
 			next_rate = RATE_9M_IDX;
 		else if (rate == RATE_6M_IDX)
 			next_rate = RATE_6M_IDX;
 		break;
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		if (!(il->_3945.sta_supp_rates & IL_OFDM_RATES_MASK) &&
 		    il_is_associated(il)) {
 			if (rate == RATE_11M_IDX)
@@ -349,7 +349,7 @@ il3945_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 
 	/* Fill the MRR chain with some info about on-chip retransmissions */
 	rate_idx = il3945_hwrate_to_plcp_idx(tx_resp->rate);
-	if (info->band == IEEE80211_BAND_5GHZ)
+	if (info->band == NL80211_BAND_5GHZ)
 		rate_idx -= IL_FIRST_OFDM_RATE;
 
 	fail = tx_resp->failure_frame;
@@ -554,14 +554,14 @@ il3945_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 	rx_status.mactime = le64_to_cpu(rx_end->timestamp);
 	rx_status.band =
 	    (rx_hdr->
-	     phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ? IEEE80211_BAND_2GHZ :
-	    IEEE80211_BAND_5GHZ;
+	     phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ? NL80211_BAND_2GHZ :
+	    NL80211_BAND_5GHZ;
 	rx_status.freq =
 	    ieee80211_channel_to_frequency(le16_to_cpu(rx_hdr->channel),
 					   rx_status.band);
 
 	rx_status.rate_idx = il3945_hwrate_to_plcp_idx(rx_hdr->rate);
-	if (rx_status.band == IEEE80211_BAND_5GHZ)
+	if (rx_status.band == NL80211_BAND_5GHZ)
 		rx_status.rate_idx -= IL_FIRST_OFDM_RATE;
 
 	rx_status.antenna =
@@ -1409,7 +1409,7 @@ il3945_send_tx_power(struct il_priv *il)
 
 	chan = le16_to_cpu(il->active.channel);
 
-	txpower.band = (il->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
+	txpower.band = (il->band == NL80211_BAND_5GHZ) ? 0 : 1;
 	ch_info = il_get_channel_info(il, il->band, chan);
 	if (!ch_info) {
 		IL_ERR("Failed to get channel info for channel %d [%d]\n", chan,
@@ -2310,7 +2310,7 @@ il3945_manage_ibss_station(struct il_priv *il, struct ieee80211_vif *vif,
 
 		il3945_sync_sta(il, vif_priv->ibss_bssid_sta_id,
 				(il->band ==
-				 IEEE80211_BAND_5GHZ) ? RATE_6M_PLCP :
+				 NL80211_BAND_5GHZ) ? RATE_6M_PLCP :
 				RATE_1M_PLCP);
 		il3945_rate_scale_init(il->hw, vif_priv->ibss_bssid_sta_id);
 
@@ -2343,7 +2343,7 @@ il3945_init_hw_rate_table(struct il_priv *il)
 	}
 
 	switch (il->band) {
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		D_RATE("Select A mode rate scale\n");
 		/* If one of the following CCK rates is used,
 		 * have it fall back to the 6M OFDM rate */
@@ -2359,7 +2359,7 @@ il3945_init_hw_rate_table(struct il_priv *il)
 		    il3945_rates[IL_FIRST_OFDM_RATE].table_rs_idx;
 		break;
 
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		D_RATE("Select B/G mode rate scale\n");
 		/* If an OFDM rate is used, have it fall back to the
 		 * 1M CCK rates */
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index f9ed48070e17..a91d170a614b 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -457,7 +457,7 @@ il4965_rxq_stop(struct il_priv *il)
 }
 
 int
-il4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
+il4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum nl80211_band band)
 {
 	int idx = 0;
 	int band_offset = 0;
@@ -468,7 +468,7 @@ il4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
 		return idx;
 		/* Legacy rate format, search for match in table */
 	} else {
-		if (band == IEEE80211_BAND_5GHZ)
+		if (band == NL80211_BAND_5GHZ)
 			band_offset = IL_FIRST_OFDM_RATE;
 		for (idx = band_offset; idx < RATE_COUNT_LEGACY; idx++)
 			if (il_rates[idx].plcp == (rate_n_flags & 0xFF))
@@ -688,8 +688,8 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
 	rx_status.band =
 	    (phy_res->
-	     phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ? IEEE80211_BAND_2GHZ :
-	    IEEE80211_BAND_5GHZ;
+	     phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ? NL80211_BAND_2GHZ :
+	    NL80211_BAND_5GHZ;
 	rx_status.freq =
 	    ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel),
 					   rx_status.band);
@@ -766,7 +766,7 @@ il4965_hdl_rx_phy(struct il_priv *il, struct il_rx_buf *rxb)
 
 static int
 il4965_get_channels_for_scan(struct il_priv *il, struct ieee80211_vif *vif,
-			     enum ieee80211_band band, u8 is_active,
+			     enum nl80211_band band, u8 is_active,
 			     u8 n_probes, struct il_scan_channel *scan_ch)
 {
 	struct ieee80211_channel *chan;
@@ -822,7 +822,7 @@ il4965_get_channels_for_scan(struct il_priv *il, struct ieee80211_vif *vif,
 		 * power level:
 		 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
 		 */
-		if (band == IEEE80211_BAND_5GHZ)
+		if (band == NL80211_BAND_5GHZ)
 			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else
 			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
@@ -870,7 +870,7 @@ il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	u32 rate_flags = 0;
 	u16 cmd_len;
 	u16 rx_chain = 0;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	u8 n_probes = 0;
 	u8 rx_ant = il->hw_params.valid_rx_ant;
 	u8 rate;
@@ -944,7 +944,7 @@ il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	switch (il->scan_band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		chan_mod =
 		    le32_to_cpu(il->active.flags & RXON_FLG_CHANNEL_MODE_MSK) >>
@@ -956,7 +956,7 @@ il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 			rate_flags = RATE_MCS_CCK_MSK;
 		}
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		rate = RATE_6M_PLCP;
 		break;
 	default:
@@ -1590,7 +1590,7 @@ il4965_tx_cmd_build_rate(struct il_priv *il,
 	    || rate_idx > RATE_COUNT_LEGACY)
 		rate_idx = rate_lowest_index(&il->bands[info->band], sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
-	if (info->band == IEEE80211_BAND_5GHZ)
+	if (info->band == NL80211_BAND_5GHZ)
 		rate_idx += IL_FIRST_OFDM_RATE;
 	/* Get PLCP rate for tx_cmd->rate_n_flags */
 	rate_plcp = il_rates[rate_idx].plcp;
@@ -3051,7 +3051,7 @@ il4965_sta_alloc_lq(struct il_priv *il, u8 sta_id)
 	}
 	/* Set up the rate scaling to start at selected rate, fall back
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
-	if (il->band == IEEE80211_BAND_5GHZ)
+	if (il->band == NL80211_BAND_5GHZ)
 		r = RATE_6M_IDX;
 	else
 		r = RATE_1M_IDX;
@@ -5790,12 +5790,12 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 
 	hw->max_listen_interval = IL_CONN_MAX_LISTEN_INTERVAL;
 
-	if (il->bands[IEEE80211_BAND_2GHZ].n_channels)
-		il->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-		    &il->bands[IEEE80211_BAND_2GHZ];
-	if (il->bands[IEEE80211_BAND_5GHZ].n_channels)
-		il->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-		    &il->bands[IEEE80211_BAND_5GHZ];
+	if (il->bands[NL80211_BAND_2GHZ].n_channels)
+		il->hw->wiphy->bands[NL80211_BAND_2GHZ] =
+		    &il->bands[NL80211_BAND_2GHZ];
+	if (il->bands[NL80211_BAND_5GHZ].n_channels)
+		il->hw->wiphy->bands[NL80211_BAND_5GHZ] =
+		    &il->bands[NL80211_BAND_5GHZ];
 
 	il_leds_init(il);
 
@@ -6368,7 +6368,7 @@ il4965_init_drv(struct il_priv *il)
 
 	il->ieee_channels = NULL;
 	il->ieee_rates = NULL;
-	il->band = IEEE80211_BAND_2GHZ;
+	il->band = NL80211_BAND_2GHZ;
 
 	il->iw_mode = NL80211_IFTYPE_STATION;
 	il->current_ht_config.smps = IEEE80211_SMPS_STATIC;
@@ -6480,7 +6480,7 @@ il4965_set_hw_params(struct il_priv *il)
 	il->hw_params.max_data_size = IL49_RTC_DATA_SIZE;
 	il->hw_params.max_inst_size = IL49_RTC_INST_SIZE;
 	il->hw_params.max_bsm_size = BSM_SRAM_SIZE;
-	il->hw_params.ht40_channel = BIT(IEEE80211_BAND_5GHZ);
+	il->hw_params.ht40_channel = BIT(NL80211_BAND_5GHZ);
 
 	il->hw_params.rx_wrt_ptr_reg = FH49_RSCSR_CHNL0_WPTR;
 
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index bac60b2bc3f0..a867ae7f4095 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -549,7 +549,7 @@ il4965_rate_n_flags_from_tbl(struct il_priv *il, struct il_scale_tbl_info *tbl,
  */
 static int
 il4965_rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
-				enum ieee80211_band band,
+				enum nl80211_band band,
 				struct il_scale_tbl_info *tbl, int *rate_idx)
 {
 	u32 ant_msk = (rate_n_flags & RATE_MCS_ANT_ABC_MSK);
@@ -574,7 +574,7 @@ il4965_rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 	/* legacy rate format */
 	if (!(rate_n_flags & RATE_MCS_HT_MSK)) {
 		if (il4965_num_of_ant == 1) {
-			if (band == IEEE80211_BAND_5GHZ)
+			if (band == NL80211_BAND_5GHZ)
 				tbl->lq_type = LQ_A;
 			else
 				tbl->lq_type = LQ_G;
@@ -743,7 +743,7 @@ il4965_rs_get_lower_rate(struct il_lq_sta *lq_sta,
 	if (!is_legacy(tbl->lq_type) && (!ht_possible || !scale_idx)) {
 		switch_to_legacy = 1;
 		scale_idx = rs_ht_to_legacy[scale_idx];
-		if (lq_sta->band == IEEE80211_BAND_5GHZ)
+		if (lq_sta->band == NL80211_BAND_5GHZ)
 			tbl->lq_type = LQ_A;
 		else
 			tbl->lq_type = LQ_G;
@@ -762,7 +762,7 @@ il4965_rs_get_lower_rate(struct il_lq_sta *lq_sta,
 	/* Mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
 		/* supp_rates has no CCK bits in A mode */
-		if (lq_sta->band == IEEE80211_BAND_5GHZ)
+		if (lq_sta->band == NL80211_BAND_5GHZ)
 			rate_mask =
 			    (u16) (rate_mask &
 				   (lq_sta->supp_rates << IL_FIRST_OFDM_RATE));
@@ -851,7 +851,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	table = &lq_sta->lq;
 	tx_rate = le32_to_cpu(table->rs_table[0].rate_n_flags);
 	il4965_rs_get_tbl_info_from_mcs(tx_rate, il->band, &tbl_type, &rs_idx);
-	if (il->band == IEEE80211_BAND_5GHZ)
+	if (il->band == NL80211_BAND_5GHZ)
 		rs_idx -= IL_FIRST_OFDM_RATE;
 	mac_flags = info->status.rates[0].flags;
 	mac_idx = info->status.rates[0].idx;
@@ -864,7 +864,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 		 * mac80211 HT idx is always zero-idxed; we need to move
 		 * HT OFDM rates after CCK rates in 2.4 GHz band
 		 */
-		if (il->band == IEEE80211_BAND_2GHZ)
+		if (il->band == NL80211_BAND_2GHZ)
 			mac_idx += IL_FIRST_OFDM_RATE;
 	}
 	/* Here we actually compare this rate to the latest LQ command */
@@ -1816,7 +1816,7 @@ il4965_rs_rate_scale_perform(struct il_priv *il, struct sk_buff *skb,
 
 	/* mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
-		if (lq_sta->band == IEEE80211_BAND_5GHZ)
+		if (lq_sta->band == NL80211_BAND_5GHZ)
 			/* supp_rates has no CCK bits in A mode */
 			rate_scale_idx_msk =
 			    (u16) (rate_mask &
@@ -2212,7 +2212,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 	/* Get max rate if user set max rate */
 	if (lq_sta) {
 		lq_sta->max_rate_idx = txrc->max_rate_idx;
-		if (sband->band == IEEE80211_BAND_5GHZ &&
+		if (sband->band == NL80211_BAND_5GHZ &&
 		    lq_sta->max_rate_idx != -1)
 			lq_sta->max_rate_idx += IL_FIRST_OFDM_RATE;
 		if (lq_sta->max_rate_idx < 0 ||
@@ -2258,11 +2258,11 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 	} else {
 		/* Check for invalid rates */
 		if (rate_idx < 0 || rate_idx >= RATE_COUNT_LEGACY ||
-		    (sband->band == IEEE80211_BAND_5GHZ &&
+		    (sband->band == NL80211_BAND_5GHZ &&
 		     rate_idx < IL_FIRST_OFDM_RATE))
 			rate_idx = rate_lowest_index(sband, sta);
 		/* On valid 5 GHz rate, adjust idx */
-		else if (sband->band == IEEE80211_BAND_5GHZ)
+		else if (sband->band == NL80211_BAND_5GHZ)
 			rate_idx -= IL_FIRST_OFDM_RATE;
 		info->control.rates[0].flags = 0;
 	}
@@ -2362,7 +2362,7 @@ il4965_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_id)
 
 	/* Set last_txrate_idx to lowest rate */
 	lq_sta->last_txrate_idx = rate_lowest_index(sband, sta);
-	if (sband->band == IEEE80211_BAND_5GHZ)
+	if (sband->band == NL80211_BAND_5GHZ)
 		lq_sta->last_txrate_idx += IL_FIRST_OFDM_RATE;
 	lq_sta->is_agg = 0;
 
diff --git a/drivers/net/wireless/intel/iwlegacy/4965.c b/drivers/net/wireless/intel/iwlegacy/4965.c
index fe47db9c20cd..c3c638ed0ed7 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965.c
@@ -1267,7 +1267,7 @@ il4965_send_tx_power(struct il_priv *il)
 	     "TX Power requested while scanning!\n"))
 		return -EAGAIN;
 
-	band = il->band == IEEE80211_BAND_2GHZ;
+	band = il->band == NL80211_BAND_2GHZ;
 
 	is_ht40 = iw4965_is_ht40_channel(il->active.flags);
 
@@ -1480,7 +1480,7 @@ il4965_hw_channel_switch(struct il_priv *il,
 	u8 switch_count;
 	u16 beacon_interval = le16_to_cpu(il->timing.beacon_interval);
 	struct ieee80211_vif *vif = il->vif;
-	band = (il->band == IEEE80211_BAND_2GHZ);
+	band = (il->band == NL80211_BAND_2GHZ);
 
 	if (WARN_ON_ONCE(vif == NULL))
 		return -EIO;
@@ -1918,7 +1918,7 @@ struct il_cfg il4965_cfg = {
 	 * Force use of chains B and C for scan RX on 5 GHz band
 	 * because the device has off-channel reception on chain A.
 	 */
-	.scan_rx_antennas[IEEE80211_BAND_5GHZ] = ANT_BC,
+	.scan_rx_antennas[NL80211_BAND_5GHZ] = ANT_BC,
 
 	.eeprom_size = IL4965_EEPROM_IMG_SIZE,
 	.num_of_queues = IL49_NUM_QUEUES,
diff --git a/drivers/net/wireless/intel/iwlegacy/4965.h b/drivers/net/wireless/intel/iwlegacy/4965.h
index e432715e02d8..527e8b531aed 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965.h
+++ b/drivers/net/wireless/intel/iwlegacy/4965.h
@@ -68,7 +68,7 @@ void il4965_rx_replenish(struct il_priv *il);
 void il4965_rx_replenish_now(struct il_priv *il);
 void il4965_rx_queue_free(struct il_priv *il, struct il_rx_queue *rxq);
 int il4965_rxq_stop(struct il_priv *il);
-int il4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
+int il4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum nl80211_band band);
 void il4965_rx_handle(struct il_priv *il);
 
 /* tx */
diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 2cc3d42bbab7..eb24b9241bb2 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -860,7 +860,7 @@ il_init_band_reference(const struct il_priv *il, int eep_band,
  * Does not set up a command, or touch hardware.
  */
 static int
-il_mod_ht40_chan_info(struct il_priv *il, enum ieee80211_band band, u16 channel,
+il_mod_ht40_chan_info(struct il_priv *il, enum nl80211_band band, u16 channel,
 		      const struct il_eeprom_channel *eeprom_ch,
 		      u8 clear_ht40_extension_channel)
 {
@@ -945,7 +945,7 @@ il_init_channel_map(struct il_priv *il)
 			ch_info->channel = eeprom_ch_idx[ch];
 			ch_info->band =
 			    (band ==
-			     1) ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+			     1) ? NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
 
 			/* permanently store EEPROM's channel regulatory flags
 			 *   and max power in channel info database. */
@@ -1003,14 +1003,14 @@ il_init_channel_map(struct il_priv *il)
 
 	/* Two additional EEPROM bands for 2.4 and 5 GHz HT40 channels */
 	for (band = 6; band <= 7; band++) {
-		enum ieee80211_band ieeeband;
+		enum nl80211_band ieeeband;
 
 		il_init_band_reference(il, band, &eeprom_ch_count,
 				       &eeprom_ch_info, &eeprom_ch_idx);
 
 		/* EEPROM band 6 is 2.4, band 7 is 5 GHz */
 		ieeeband =
-		    (band == 6) ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+		    (band == 6) ? NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
 
 		/* Loop through each band adding each of the channels */
 		for (ch = 0; ch < eeprom_ch_count; ch++) {
@@ -1048,19 +1048,19 @@ EXPORT_SYMBOL(il_free_channel_map);
  * Based on band and channel number.
  */
 const struct il_channel_info *
-il_get_channel_info(const struct il_priv *il, enum ieee80211_band band,
+il_get_channel_info(const struct il_priv *il, enum nl80211_band band,
 		    u16 channel)
 {
 	int i;
 
 	switch (band) {
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		for (i = 14; i < il->channel_count; i++) {
 			if (il->channel_info[i].channel == channel)
 				return &il->channel_info[i];
 		}
 		break;
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		if (channel >= 1 && channel <= 14)
 			return &il->channel_info[channel - 1];
 		break;
@@ -1457,7 +1457,7 @@ il_hdl_scan_complete(struct il_priv *il, struct il_rx_buf *rxb)
 	clear_bit(S_SCAN_HW, &il->status);
 
 	D_SCAN("Scan on %sGHz took %dms\n",
-	       (il->scan_band == IEEE80211_BAND_2GHZ) ? "2.4" : "5.2",
+	       (il->scan_band == NL80211_BAND_2GHZ) ? "2.4" : "5.2",
 	       jiffies_to_msecs(jiffies - il->scan_start));
 
 	queue_work(il->workqueue, &il->scan_completed);
@@ -1475,10 +1475,10 @@ il_setup_rx_scan_handlers(struct il_priv *il)
 EXPORT_SYMBOL(il_setup_rx_scan_handlers);
 
 u16
-il_get_active_dwell_time(struct il_priv *il, enum ieee80211_band band,
+il_get_active_dwell_time(struct il_priv *il, enum nl80211_band band,
 			 u8 n_probes)
 {
-	if (band == IEEE80211_BAND_5GHZ)
+	if (band == NL80211_BAND_5GHZ)
 		return IL_ACTIVE_DWELL_TIME_52 +
 		    IL_ACTIVE_DWELL_FACTOR_52GHZ * (n_probes + 1);
 	else
@@ -1488,14 +1488,14 @@ il_get_active_dwell_time(struct il_priv *il, enum ieee80211_band band,
 EXPORT_SYMBOL(il_get_active_dwell_time);
 
 u16
-il_get_passive_dwell_time(struct il_priv *il, enum ieee80211_band band,
+il_get_passive_dwell_time(struct il_priv *il, enum nl80211_band band,
 			  struct ieee80211_vif *vif)
 {
 	u16 value;
 
 	u16 passive =
 	    (band ==
-	     IEEE80211_BAND_2GHZ) ? IL_PASSIVE_DWELL_BASE +
+	     NL80211_BAND_2GHZ) ? IL_PASSIVE_DWELL_BASE +
 	    IL_PASSIVE_DWELL_TIME_24 : IL_PASSIVE_DWELL_BASE +
 	    IL_PASSIVE_DWELL_TIME_52;
 
@@ -1520,10 +1520,10 @@ void
 il_init_scan_params(struct il_priv *il)
 {
 	u8 ant_idx = fls(il->hw_params.valid_tx_ant) - 1;
-	if (!il->scan_tx_ant[IEEE80211_BAND_5GHZ])
-		il->scan_tx_ant[IEEE80211_BAND_5GHZ] = ant_idx;
-	if (!il->scan_tx_ant[IEEE80211_BAND_2GHZ])
-		il->scan_tx_ant[IEEE80211_BAND_2GHZ] = ant_idx;
+	if (!il->scan_tx_ant[NL80211_BAND_5GHZ])
+		il->scan_tx_ant[NL80211_BAND_5GHZ] = ant_idx;
+	if (!il->scan_tx_ant[NL80211_BAND_2GHZ])
+		il->scan_tx_ant[NL80211_BAND_2GHZ] = ant_idx;
 }
 EXPORT_SYMBOL(il_init_scan_params);
 
@@ -2003,7 +2003,7 @@ il_prep_station(struct il_priv *il, const u8 *addr, bool is_ap,
 	il_set_ht_add_station(il, sta_id, sta);
 
 	/* 3945 only */
-	rate = (il->band == IEEE80211_BAND_5GHZ) ? RATE_6M_PLCP : RATE_1M_PLCP;
+	rate = (il->band == NL80211_BAND_5GHZ) ? RATE_6M_PLCP : RATE_1M_PLCP;
 	/* Turn on both antennas for the station... */
 	station->sta.rate_n_flags = cpu_to_le16(rate | RATE_MCS_ANT_AB_MSK);
 
@@ -3382,7 +3382,7 @@ EXPORT_SYMBOL(il_bcast_addr);
 static void
 il_init_ht_hw_capab(const struct il_priv *il,
 		    struct ieee80211_sta_ht_cap *ht_info,
-		    enum ieee80211_band band)
+		    enum nl80211_band band)
 {
 	u16 max_bit_rate = 0;
 	u8 rx_chains_num = il->hw_params.rx_chains_num;
@@ -3443,8 +3443,8 @@ il_init_geos(struct il_priv *il)
 	int i = 0;
 	s8 max_tx_power = 0;
 
-	if (il->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
-	    il->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
+	if (il->bands[NL80211_BAND_2GHZ].n_bitrates ||
+	    il->bands[NL80211_BAND_5GHZ].n_bitrates) {
 		D_INFO("Geography modes already initialized.\n");
 		set_bit(S_GEO_CONFIGURED, &il->status);
 		return 0;
@@ -3465,23 +3465,23 @@ il_init_geos(struct il_priv *il)
 	}
 
 	/* 5.2GHz channels start after the 2.4GHz channels */
-	sband = &il->bands[IEEE80211_BAND_5GHZ];
+	sband = &il->bands[NL80211_BAND_5GHZ];
 	sband->channels = &channels[ARRAY_SIZE(il_eeprom_band_1)];
 	/* just OFDM */
 	sband->bitrates = &rates[IL_FIRST_OFDM_RATE];
 	sband->n_bitrates = RATE_COUNT_LEGACY - IL_FIRST_OFDM_RATE;
 
 	if (il->cfg->sku & IL_SKU_N)
-		il_init_ht_hw_capab(il, &sband->ht_cap, IEEE80211_BAND_5GHZ);
+		il_init_ht_hw_capab(il, &sband->ht_cap, NL80211_BAND_5GHZ);
 
-	sband = &il->bands[IEEE80211_BAND_2GHZ];
+	sband = &il->bands[NL80211_BAND_2GHZ];
 	sband->channels = channels;
 	/* OFDM & CCK */
 	sband->bitrates = rates;
 	sband->n_bitrates = RATE_COUNT_LEGACY;
 
 	if (il->cfg->sku & IL_SKU_N)
-		il_init_ht_hw_capab(il, &sband->ht_cap, IEEE80211_BAND_2GHZ);
+		il_init_ht_hw_capab(il, &sband->ht_cap, NL80211_BAND_2GHZ);
 
 	il->ieee_channels = channels;
 	il->ieee_rates = rates;
@@ -3532,7 +3532,7 @@ il_init_geos(struct il_priv *il)
 	il->tx_power_user_lmt = max_tx_power;
 	il->tx_power_next = max_tx_power;
 
-	if (il->bands[IEEE80211_BAND_5GHZ].n_channels == 0 &&
+	if (il->bands[NL80211_BAND_5GHZ].n_channels == 0 &&
 	    (il->cfg->sku & IL_SKU_A)) {
 		IL_INFO("Incorrectly detected BG card as ABG. "
 			"Please send your PCI ID 0x%04X:0x%04X to maintainer.\n",
@@ -3541,8 +3541,8 @@ il_init_geos(struct il_priv *il)
 	}
 
 	IL_INFO("Tunable channels: %d 802.11bg, %d 802.11a channels\n",
-		il->bands[IEEE80211_BAND_2GHZ].n_channels,
-		il->bands[IEEE80211_BAND_5GHZ].n_channels);
+		il->bands[NL80211_BAND_2GHZ].n_channels,
+		il->bands[NL80211_BAND_5GHZ].n_channels);
 
 	set_bit(S_GEO_CONFIGURED, &il->status);
 
@@ -3563,7 +3563,7 @@ il_free_geos(struct il_priv *il)
 EXPORT_SYMBOL(il_free_geos);
 
 static bool
-il_is_channel_extension(struct il_priv *il, enum ieee80211_band band,
+il_is_channel_extension(struct il_priv *il, enum nl80211_band band,
 			u16 channel, u8 extension_chan_offset)
 {
 	const struct il_channel_info *ch_info;
@@ -3926,14 +3926,14 @@ EXPORT_SYMBOL(il_set_rxon_ht);
 
 /* Return valid, unused, channel for a passive scan to reset the RF */
 u8
-il_get_single_channel_number(struct il_priv *il, enum ieee80211_band band)
+il_get_single_channel_number(struct il_priv *il, enum nl80211_band band)
 {
 	const struct il_channel_info *ch_info;
 	int i;
 	u8 channel = 0;
 	u8 min, max;
 
-	if (band == IEEE80211_BAND_5GHZ) {
+	if (band == NL80211_BAND_5GHZ) {
 		min = 14;
 		max = il->channel_count;
 	} else {
@@ -3965,14 +3965,14 @@ EXPORT_SYMBOL(il_get_single_channel_number);
 int
 il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch)
 {
-	enum ieee80211_band band = ch->band;
+	enum nl80211_band band = ch->band;
 	u16 channel = ch->hw_value;
 
 	if (le16_to_cpu(il->staging.channel) == channel && il->band == band)
 		return 0;
 
 	il->staging.channel = cpu_to_le16(channel);
-	if (band == IEEE80211_BAND_5GHZ)
+	if (band == NL80211_BAND_5GHZ)
 		il->staging.flags &= ~RXON_FLG_BAND_24G_MSK;
 	else
 		il->staging.flags |= RXON_FLG_BAND_24G_MSK;
@@ -3986,10 +3986,10 @@ il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch)
 EXPORT_SYMBOL(il_set_rxon_channel);
 
 void
-il_set_flags_for_band(struct il_priv *il, enum ieee80211_band band,
+il_set_flags_for_band(struct il_priv *il, enum nl80211_band band,
 		      struct ieee80211_vif *vif)
 {
-	if (band == IEEE80211_BAND_5GHZ) {
+	if (band == NL80211_BAND_5GHZ) {
 		il->staging.flags &=
 		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK |
 		      RXON_FLG_CCK_MSK);
@@ -5415,7 +5415,7 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
 		D_MAC80211("ERP_CTS %d\n", bss_conf->use_cts_prot);
-		if (bss_conf->use_cts_prot && il->band != IEEE80211_BAND_5GHZ)
+		if (bss_conf->use_cts_prot && il->band != NL80211_BAND_5GHZ)
 			il->staging.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
 			il->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/wireless/intel/iwlegacy/common.h
index ce52cf114fde..726ede391cb9 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -432,7 +432,7 @@ u16 il_eeprom_query16(const struct il_priv *il, size_t offset);
 int il_init_channel_map(struct il_priv *il);
 void il_free_channel_map(struct il_priv *il);
 const struct il_channel_info *il_get_channel_info(const struct il_priv *il,
-						  enum ieee80211_band band,
+						  enum nl80211_band band,
 						  u16 channel);
 
 #define IL_NUM_SCAN_RATES         (2)
@@ -497,7 +497,7 @@ struct il_channel_info {
 
 	u8 group_idx;		/* 0-4, maps channel to group1/2/3/4/5 */
 	u8 band_idx;		/* 0-4, maps channel to band1/2/3/4/5 */
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	/* HT40 channel info */
 	s8 ht40_max_power_avg;	/* (dBm) regul. eeprom, normal Tx, any rate */
@@ -811,7 +811,7 @@ struct il_sensitivity_ranges {
  * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
  * @max_stations:
  * @ht40_channel: is 40MHz width possible in band 2.4
- * BIT(IEEE80211_BAND_5GHZ) BIT(IEEE80211_BAND_5GHZ)
+ * BIT(NL80211_BAND_5GHZ) BIT(NL80211_BAND_5GHZ)
  * @sw_crypto: 0 for hw, 1 for sw
  * @max_xxx_size: for ucode uses
  * @ct_kill_threshold: temperature threshold
@@ -1141,13 +1141,13 @@ struct il_priv {
 	struct list_head free_frames;
 	int frames_count;
 
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	int alloc_rxb_page;
 
 	void (*handlers[IL_CN_MAX]) (struct il_priv *il,
 				     struct il_rx_buf *rxb);
 
-	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
+	struct ieee80211_supported_band bands[NUM_NL80211_BANDS];
 
 	/* spectrum measurement report caching */
 	struct il_spectrum_notification measure_report;
@@ -1176,10 +1176,10 @@ struct il_priv {
 	unsigned long scan_start;
 	unsigned long scan_start_tsf;
 	void *scan_cmd;
-	enum ieee80211_band scan_band;
+	enum nl80211_band scan_band;
 	struct cfg80211_scan_request *scan_request;
 	struct ieee80211_vif *scan_vif;
-	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
+	u8 scan_tx_ant[NUM_NL80211_BANDS];
 	u8 mgmt_tx_ant;
 
 	/* spinlock */
@@ -1479,7 +1479,7 @@ il_is_channel_radar(const struct il_channel_info *ch_info)
 static inline u8
 il_is_channel_a_band(const struct il_channel_info *ch_info)
 {
-	return ch_info->band == IEEE80211_BAND_5GHZ;
+	return ch_info->band == NL80211_BAND_5GHZ;
 }
 
 static inline int
@@ -1673,7 +1673,7 @@ struct il_cfg {
 	/* params not likely to change within a device family */
 	struct il_base_params *base_params;
 	/* params likely to change within a device family */
-	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
+	u8 scan_rx_antennas[NUM_NL80211_BANDS];
 	enum il_led_mode led_mode;
 
 	int eeprom_size;
@@ -1707,9 +1707,9 @@ void il_set_rxon_hwcrypto(struct il_priv *il, int hw_decrypt);
 int il_check_rxon_cmd(struct il_priv *il);
 int il_full_rxon_required(struct il_priv *il);
 int il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch);
-void il_set_flags_for_band(struct il_priv *il, enum ieee80211_band band,
+void il_set_flags_for_band(struct il_priv *il, enum nl80211_band band,
 			   struct ieee80211_vif *vif);
-u8 il_get_single_channel_number(struct il_priv *il, enum ieee80211_band band);
+u8 il_get_single_channel_number(struct il_priv *il, enum nl80211_band band);
 void il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf);
 bool il_is_ht40_tx_allowed(struct il_priv *il,
 			   struct ieee80211_sta_ht_cap *ht_cap);
@@ -1793,9 +1793,9 @@ int il_force_reset(struct il_priv *il, bool external);
 u16 il_fill_probe_req(struct il_priv *il, struct ieee80211_mgmt *frame,
 		      const u8 *ta, const u8 *ie, int ie_len, int left);
 void il_setup_rx_scan_handlers(struct il_priv *il);
-u16 il_get_active_dwell_time(struct il_priv *il, enum ieee80211_band band,
+u16 il_get_active_dwell_time(struct il_priv *il, enum nl80211_band band,
 			     u8 n_probes);
-u16 il_get_passive_dwell_time(struct il_priv *il, enum ieee80211_band band,
+u16 il_get_passive_dwell_time(struct il_priv *il, enum nl80211_band band,
 			      struct ieee80211_vif *vif);
 void il_setup_scan_deferred_work(struct il_priv *il);
 void il_cancel_scan_deferred_work(struct il_priv *il);
@@ -1955,7 +1955,7 @@ il_commit_rxon(struct il_priv *il)
 }
 
 static inline const struct ieee80211_supported_band *
-il_get_hw_mode(struct il_priv *il, enum ieee80211_band band)
+il_get_hw_mode(struct il_priv *il, enum nl80211_band band)
 {
 	return il->hw->wiphy->bands[band];
 }
@@ -2813,7 +2813,7 @@ struct il_lq_sta {
 	u8 action_counter;	/* # mode-switch actions tried */
 	u8 is_green;
 	u8 is_dup;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	/* The following are bitmaps of rates; RATE_6M_MASK, etc. */
 	u32 supp_rates;
diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index 908b9f4fef6f..6fc6b7ff9849 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -544,7 +544,7 @@ il_dbgfs_channels_read(struct file *file, char __user *user_buf, size_t count,
 		return -ENOMEM;
 	}
 
-	supp_band = il_get_hw_mode(il, IEEE80211_BAND_2GHZ);
+	supp_band = il_get_hw_mode(il, NL80211_BAND_2GHZ);
 	if (supp_band) {
 		channels = supp_band->channels;
 
@@ -571,7 +571,7 @@ il_dbgfs_channels_read(struct file *file, char __user *user_buf, size_t count,
 				      flags & IEEE80211_CHAN_NO_IR ?
 				      "passive only" : "active/passive");
 	}
-	supp_band = il_get_hw_mode(il, IEEE80211_BAND_5GHZ);
+	supp_band = il_get_hw_mode(il, NL80211_BAND_5GHZ);
 	if (supp_band) {
 		channels = supp_band->channels;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/agn.h b/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
index 9de277c6c420..b79e38734f2f 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
@@ -158,7 +158,7 @@ void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 			 struct iwl_rxon_context *ctx);
 void iwl_set_flags_for_band(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
-			    enum ieee80211_band band,
+			    enum nl80211_band band,
 			    struct ieee80211_vif *vif);
 
 /* uCode */
@@ -186,7 +186,7 @@ int iwl_send_statistics_request(struct iwl_priv *priv,
 				u8 flags, bool clear);
 
 static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
-			struct iwl_priv *priv, enum ieee80211_band band)
+			struct iwl_priv *priv, enum nl80211_band band)
 {
 	return priv->hw->wiphy->bands[band];
 }
@@ -198,7 +198,7 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan);
 #endif
 
 /* rx */
-int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
+int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum nl80211_band band);
 void iwl_setup_rx_handlers(struct iwl_priv *priv);
 void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
 
@@ -258,7 +258,7 @@ void iwl_cancel_scan_deferred_work(struct iwl_priv *priv);
 int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 				   struct ieee80211_vif *vif,
 				   enum iwl_scan_type scan_type,
-				   enum ieee80211_band band);
+				   enum nl80211_band band);
 
 /* For faster active scanning, scan will move to the next channel if fewer than
  * PLCP_QUIET_THRESH packets are heard on this channel within
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index 74c51615244e..f6591c83d636 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -335,7 +335,7 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 	if (!buf)
 		return -ENOMEM;
 
-	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_2GHZ);
+	supp_band = iwl_get_hw_mode(priv, NL80211_BAND_2GHZ);
 	if (supp_band) {
 		channels = supp_band->channels;
 
@@ -358,7 +358,7 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 					IEEE80211_CHAN_NO_IR ?
 					"passive only" : "active/passive");
 	}
-	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_5GHZ);
+	supp_band = iwl_get_hw_mode(priv, NL80211_BAND_5GHZ);
 	if (supp_band) {
 		channels = supp_band->channels;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
index 1a7ead753eee..8148df61a916 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
@@ -677,7 +677,7 @@ struct iwl_priv {
 
 	struct iwl_hw_params hw_params;
 
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	u8 valid_contexts;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
@@ -722,11 +722,11 @@ struct iwl_priv {
 	unsigned long scan_start;
 	unsigned long scan_start_tsf;
 	void *scan_cmd;
-	enum ieee80211_band scan_band;
+	enum nl80211_band scan_band;
 	struct cfg80211_scan_request *scan_request;
 	struct ieee80211_vif *scan_vif;
 	enum iwl_scan_type scan_type;
-	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
+	u8 scan_tx_ant[NUM_NL80211_BANDS];
 	u8 mgmt_tx_ant;
 
 	/* max number of station keys */
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
index cc13c04063a5..f21732ec3b25 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
@@ -420,7 +420,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 		.data = { &cmd, },
 	};
 
-	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
+	cmd.band = priv->band == NL80211_BAND_2GHZ;
 	ch = ch_switch->chandef.chan->hw_value;
 	IWL_DEBUG_11H(priv, "channel switch from %d to %d\n",
 		      ctx->active.channel, ch);
@@ -588,7 +588,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 
 	hcmd.data[0] = cmd;
 
-	cmd->band = priv->band == IEEE80211_BAND_2GHZ;
+	cmd->band = priv->band == NL80211_BAND_2GHZ;
 	ch = ch_switch->chandef.chan->hw_value;
 	IWL_DEBUG_11H(priv, "channel switch from %u to %u\n",
 		      ctx->active.channel, ch);
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index 1799469268ea..8dda52ae3bb5 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -94,7 +94,7 @@ void iwlagn_temperature(struct iwl_priv *priv)
 	iwl_tt_handler(priv);
 }
 
-int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
+int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum nl80211_band band)
 {
 	int idx = 0;
 	int band_offset = 0;
@@ -105,7 +105,7 @@ int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
 		return idx;
 	/* Legacy rate format, search for match in table */
 	} else {
-		if (band == IEEE80211_BAND_5GHZ)
+		if (band == NL80211_BAND_5GHZ)
 			band_offset = IWL_FIRST_OFDM_RATE;
 		for (idx = band_offset; idx < IWL_RATE_COUNT_LEGACY; idx++)
 			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
@@ -878,7 +878,7 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant, u8 valid)
 	int i;
 	u8 ind = ant;
 
-	if (priv->band == IEEE80211_BAND_2GHZ &&
+	if (priv->band == NL80211_BAND_2GHZ &&
 	    priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)
 		return 0;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index c63ea79571ff..8c0719468d00 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -202,12 +202,12 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
 
-	if (priv->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels)
-		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&priv->nvm_data->bands[IEEE80211_BAND_2GHZ];
-	if (priv->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels)
-		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&priv->nvm_data->bands[IEEE80211_BAND_5GHZ];
+	if (priv->nvm_data->bands[NL80211_BAND_2GHZ].n_channels)
+		priv->hw->wiphy->bands[NL80211_BAND_2GHZ] =
+			&priv->nvm_data->bands[NL80211_BAND_2GHZ];
+	if (priv->nvm_data->bands[NL80211_BAND_5GHZ].n_channels)
+		priv->hw->wiphy->bands[NL80211_BAND_5GHZ] =
+			&priv->nvm_data->bands[NL80211_BAND_5GHZ];
 
 	hw->wiphy->hw_version = priv->trans->hw_id;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 614716251c39..37b32a6f60fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -262,7 +262,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	rate_flags = iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 
 	/* In mac80211, rates for 5 GHz start at 0 */
-	if (info->band == IEEE80211_BAND_5GHZ)
+	if (info->band == NL80211_BAND_5GHZ)
 		rate += IWL_FIRST_OFDM_RATE;
 	else if (rate >= IWL_FIRST_CCK_RATE && rate <= IWL_LAST_CCK_RATE)
 		rate_flags |= RATE_MCS_CCK_MSK;
@@ -1117,7 +1117,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 
 	INIT_LIST_HEAD(&priv->calib_results);
 
-	priv->band = IEEE80211_BAND_2GHZ;
+	priv->band = NL80211_BAND_2GHZ;
 
 	priv->plcp_delta_threshold = priv->lib->plcp_delta_threshold;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index ee7505537c96..b95c2d76db33 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -599,7 +599,7 @@ static u32 rate_n_flags_from_tbl(struct iwl_priv *priv,
  * fill "search" or "active" tx mode table.
  */
 static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
-				    enum ieee80211_band band,
+				    enum nl80211_band band,
 				    struct iwl_scale_tbl_info *tbl,
 				    int *rate_idx)
 {
@@ -624,7 +624,7 @@ static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 	/* legacy rate format */
 	if (!(rate_n_flags & RATE_MCS_HT_MSK)) {
 		if (num_of_ant == 1) {
-			if (band == IEEE80211_BAND_5GHZ)
+			if (band == NL80211_BAND_5GHZ)
 				tbl->lq_type = LQ_A;
 			else
 				tbl->lq_type = LQ_G;
@@ -802,7 +802,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 	if (!is_legacy(tbl->lq_type) && (!ht_possible || !scale_index)) {
 		switch_to_legacy = 1;
 		scale_index = rs_ht_to_legacy[scale_index];
-		if (lq_sta->band == IEEE80211_BAND_5GHZ)
+		if (lq_sta->band == NL80211_BAND_5GHZ)
 			tbl->lq_type = LQ_A;
 		else
 			tbl->lq_type = LQ_G;
@@ -821,7 +821,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 	/* Mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
 		/* supp_rates has no CCK bits in A mode */
-		if (lq_sta->band == IEEE80211_BAND_5GHZ)
+		if (lq_sta->band == NL80211_BAND_5GHZ)
 			rate_mask  = (u16)(rate_mask &
 			   (lq_sta->supp_rates << IWL_FIRST_OFDM_RATE));
 		else
@@ -939,7 +939,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	table = &lq_sta->lq;
 	tx_rate = le32_to_cpu(table->rs_table[0].rate_n_flags);
 	rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type, &rs_index);
-	if (priv->band == IEEE80211_BAND_5GHZ)
+	if (priv->band == NL80211_BAND_5GHZ)
 		rs_index -= IWL_FIRST_OFDM_RATE;
 	mac_flags = info->status.rates[0].flags;
 	mac_index = info->status.rates[0].idx;
@@ -952,7 +952,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		 * mac80211 HT index is always zero-indexed; we need to move
 		 * HT OFDM rates after CCK rates in 2.4 GHz band
 		 */
-		if (priv->band == IEEE80211_BAND_2GHZ)
+		if (priv->band == NL80211_BAND_2GHZ)
 			mac_index += IWL_FIRST_OFDM_RATE;
 	}
 	/* Here we actually compare this rate to the latest LQ command */
@@ -2284,7 +2284,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 	/* mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
-		if (lq_sta->band == IEEE80211_BAND_5GHZ)
+		if (lq_sta->band == NL80211_BAND_5GHZ)
 			/* supp_rates has no CCK bits in A mode */
 			rate_scale_index_msk = (u16) (rate_mask &
 				(lq_sta->supp_rates << IWL_FIRST_OFDM_RATE));
@@ -2721,7 +2721,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 	/* Get max rate if user set max rate */
 	if (lq_sta) {
 		lq_sta->max_rate_idx = txrc->max_rate_idx;
-		if ((sband->band == IEEE80211_BAND_5GHZ) &&
+		if ((sband->band == NL80211_BAND_5GHZ) &&
 		    (lq_sta->max_rate_idx != -1))
 			lq_sta->max_rate_idx += IWL_FIRST_OFDM_RATE;
 		if ((lq_sta->max_rate_idx < 0) ||
@@ -2763,11 +2763,11 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 	} else {
 		/* Check for invalid rates */
 		if ((rate_idx < 0) || (rate_idx >= IWL_RATE_COUNT_LEGACY) ||
-				((sband->band == IEEE80211_BAND_5GHZ) &&
+				((sband->band == NL80211_BAND_5GHZ) &&
 				 (rate_idx < IWL_FIRST_OFDM_RATE)))
 			rate_idx = rate_lowest_index(sband, sta);
 		/* On valid 5 GHz rate, adjust index */
-		else if (sband->band == IEEE80211_BAND_5GHZ)
+		else if (sband->band == NL80211_BAND_5GHZ)
 			rate_idx -= IWL_FIRST_OFDM_RATE;
 		info->control.rates[0].flags = 0;
 	}
@@ -2880,7 +2880,7 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 
 	/* Set last_txrate_idx to lowest rate */
 	lq_sta->last_txrate_idx = rate_lowest_index(sband, sta);
-	if (sband->band == IEEE80211_BAND_5GHZ)
+	if (sband->band == NL80211_BAND_5GHZ)
 		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 	lq_sta->is_agg = 0;
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.h b/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
index c5fe44584613..50c1e951dd2d 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
@@ -355,7 +355,7 @@ struct iwl_lq_sta {
 	u8 action_counter;	/* # mode-switch actions tried */
 	u8 is_green;
 	u8 is_dup;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
 	u32 supp_rates;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 27ea61e3a390..dfa2041cfdac 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -834,7 +834,7 @@ static void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	/* rx_status carries information about the packet to mac80211 */
 	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
 	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
-				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+				NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
 	rx_status.freq =
 		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel),
 					       rx_status.band);
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c b/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
index 2d47cb24c48b..b228552184b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
@@ -719,7 +719,7 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
 void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 			 struct iwl_rxon_context *ctx)
 {
-	enum ieee80211_band band = ch->band;
+	enum nl80211_band band = ch->band;
 	u16 channel = ch->hw_value;
 
 	if ((le16_to_cpu(ctx->staging.channel) == channel) &&
@@ -727,7 +727,7 @@ void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 		return;
 
 	ctx->staging.channel = cpu_to_le16(channel);
-	if (band == IEEE80211_BAND_5GHZ)
+	if (band == NL80211_BAND_5GHZ)
 		ctx->staging.flags &= ~RXON_FLG_BAND_24G_MSK;
 	else
 		ctx->staging.flags |= RXON_FLG_BAND_24G_MSK;
@@ -740,10 +740,10 @@ void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 
 void iwl_set_flags_for_band(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
-			    enum ieee80211_band band,
+			    enum nl80211_band band,
 			    struct ieee80211_vif *vif)
 {
-	if (band == IEEE80211_BAND_5GHZ) {
+	if (band == NL80211_BAND_5GHZ) {
 		ctx->staging.flags &=
 		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK
 		      | RXON_FLG_CCK_MSK);
@@ -1476,7 +1476,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 
 	iwlagn_set_rxon_chain(priv, ctx);
 
-	if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
+	if (bss_conf->use_cts_prot && (priv->band != NL80211_BAND_5GHZ))
 		ctx->staging.flags |= RXON_FLG_TGG_PROTECT_MSK;
 	else
 		ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
index 81a2ddbe9569..d01766f16175 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
@@ -312,7 +312,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		       scan_notif->tsf_high, scan_notif->status);
 
 	IWL_DEBUG_SCAN(priv, "Scan on %sGHz took %dms\n",
-		       (priv->scan_band == IEEE80211_BAND_2GHZ) ? "2.4" : "5.2",
+		       (priv->scan_band == NL80211_BAND_2GHZ) ? "2.4" : "5.2",
 		       jiffies_to_msecs(jiffies - priv->scan_start));
 
 	/*
@@ -362,9 +362,9 @@ void iwl_setup_rx_scan_handlers(struct iwl_priv *priv)
 }
 
 static u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
-				     enum ieee80211_band band, u8 n_probes)
+				     enum nl80211_band band, u8 n_probes)
 {
-	if (band == IEEE80211_BAND_5GHZ)
+	if (band == NL80211_BAND_5GHZ)
 		return IWL_ACTIVE_DWELL_TIME_52 +
 			IWL_ACTIVE_DWELL_FACTOR_52GHZ * (n_probes + 1);
 	else
@@ -431,9 +431,9 @@ static u16 iwl_limit_dwell(struct iwl_priv *priv, u16 dwell_time)
 }
 
 static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
-				      enum ieee80211_band band)
+				      enum nl80211_band band)
 {
-	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
+	u16 passive = (band == NL80211_BAND_2GHZ) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
 
@@ -442,7 +442,7 @@ static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 
 /* Return valid, unused, channel for a passive scan to reset the RF */
 static u8 iwl_get_single_channel_number(struct iwl_priv *priv,
-					enum ieee80211_band band)
+					enum nl80211_band band)
 {
 	struct ieee80211_supported_band *sband = priv->hw->wiphy->bands[band];
 	struct iwl_rxon_context *ctx;
@@ -470,7 +470,7 @@ static u8 iwl_get_single_channel_number(struct iwl_priv *priv,
 
 static int iwl_get_channel_for_reset_scan(struct iwl_priv *priv,
 					  struct ieee80211_vif *vif,
-					  enum ieee80211_band band,
+					  enum nl80211_band band,
 					  struct iwl_scan_channel *scan_ch)
 {
 	const struct ieee80211_supported_band *sband;
@@ -492,7 +492,7 @@ static int iwl_get_channel_for_reset_scan(struct iwl_priv *priv,
 			cpu_to_le16(IWL_RADIO_RESET_DWELL_TIME);
 		/* Set txpower levels to defaults */
 		scan_ch->dsp_atten = 110;
-		if (band == IEEE80211_BAND_5GHZ)
+		if (band == NL80211_BAND_5GHZ)
 			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else
 			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
@@ -505,7 +505,7 @@ static int iwl_get_channel_for_reset_scan(struct iwl_priv *priv,
 
 static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 				     struct ieee80211_vif *vif,
-				     enum ieee80211_band band,
+				     enum nl80211_band band,
 				     u8 is_active, u8 n_probes,
 				     struct iwl_scan_channel *scan_ch)
 {
@@ -553,7 +553,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		 * power level:
 		 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
 		 */
-		if (band == IEEE80211_BAND_5GHZ)
+		if (band == NL80211_BAND_5GHZ)
 			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else
 			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
@@ -636,7 +636,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	u32 rate_flags = 0;
 	u16 cmd_len = 0;
 	u16 rx_chain = 0;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	u8 n_probes = 0;
 	u8 rx_ant = priv->nvm_data->valid_rx_ant;
 	u8 rate;
@@ -750,7 +750,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	switch (priv->scan_band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		chan_mod = le32_to_cpu(
 			priv->contexts[IWL_RXON_CTX_BSS].active.flags &
@@ -771,7 +771,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		    priv->lib->bt_params->advanced_bt_coexist)
 			scan->tx_cmd.tx_flags |= TX_CMD_FLG_IGNORE_BT;
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		rate = IWL_RATE_6M_PLCP;
 		break;
 	default:
@@ -809,7 +809,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	band = priv->scan_band;
 
-	if (band == IEEE80211_BAND_2GHZ &&
+	if (band == NL80211_BAND_2GHZ &&
 	    priv->lib->bt_params &&
 	    priv->lib->bt_params->advanced_bt_coexist) {
 		/* transmit 2.4 GHz probes only on first antenna */
@@ -925,16 +925,16 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 void iwl_init_scan_params(struct iwl_priv *priv)
 {
 	u8 ant_idx = fls(priv->nvm_data->valid_tx_ant) - 1;
-	if (!priv->scan_tx_ant[IEEE80211_BAND_5GHZ])
-		priv->scan_tx_ant[IEEE80211_BAND_5GHZ] = ant_idx;
-	if (!priv->scan_tx_ant[IEEE80211_BAND_2GHZ])
-		priv->scan_tx_ant[IEEE80211_BAND_2GHZ] = ant_idx;
+	if (!priv->scan_tx_ant[NL80211_BAND_5GHZ])
+		priv->scan_tx_ant[NL80211_BAND_5GHZ] = ant_idx;
+	if (!priv->scan_tx_ant[NL80211_BAND_2GHZ])
+		priv->scan_tx_ant[NL80211_BAND_2GHZ] = ant_idx;
 }
 
 int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 				   struct ieee80211_vif *vif,
 				   enum iwl_scan_type scan_type,
-				   enum ieee80211_band band)
+				   enum nl80211_band band)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
index 8e9768a553e4..de6ec9b7ace4 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
@@ -579,7 +579,7 @@ static void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 
 	/* Set up the rate scaling to start at selected rate, fall back
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
-	if (priv->band == IEEE80211_BAND_5GHZ)
+	if (priv->band == NL80211_BAND_5GHZ)
 		r = IWL_RATE_6M_INDEX;
 	else if (ctx && ctx->vif && ctx->vif->p2p)
 		r = IWL_RATE_6M_INDEX;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
index 59e2001c39f8..4b97371c3b42 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -81,7 +81,7 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_TSF_MSK;
 	else if (ieee80211_is_back_req(fc))
 		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
-	else if (info->band == IEEE80211_BAND_2GHZ &&
+	else if (info->band == NL80211_BAND_2GHZ &&
 		 priv->lib->bt_params &&
 		 priv->lib->bt_params->advanced_bt_coexist &&
 		 (ieee80211_is_auth(fc) || ieee80211_is_assoc_req(fc) ||
@@ -177,7 +177,7 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 		rate_idx = rate_lowest_index(
 				&priv->nvm_data->bands[info->band], sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
-	if (info->band == IEEE80211_BAND_5GHZ)
+	if (info->band == NL80211_BAND_5GHZ)
 		rate_idx += IWL_FIRST_OFDM_RATE;
 	/* Get PLCP rate for tx_cmd->rate_n_flags */
 	rate_plcp = iwl_rates[rate_idx].plcp;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-1000.c b/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
index ef22c3d168fc..5c2aae64d59f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
@@ -64,7 +64,7 @@ static const struct iwl_base_params iwl1000_base_params = {
 static const struct iwl_ht_params iwl1000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.ht40_bands = BIT(IEEE80211_BAND_2GHZ),
+	.ht40_bands = BIT(NL80211_BAND_2GHZ),
 };
 
 static const struct iwl_eeprom_params iwl1000_eeprom_params = {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-2000.c b/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
index dc246c997084..2e823bdc4757 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
@@ -89,7 +89,7 @@ static const struct iwl_base_params iwl2030_base_params = {
 static const struct iwl_ht_params iwl2000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.ht40_bands = BIT(IEEE80211_BAND_2GHZ),
+	.ht40_bands = BIT(NL80211_BAND_2GHZ),
 };
 
 static const struct iwl_eeprom_params iwl20x0_eeprom_params = {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-5000.c b/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
index 4dcdab6781cc..4c3e3cf4c799 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
@@ -62,7 +62,7 @@ static const struct iwl_base_params iwl5000_base_params = {
 
 static const struct iwl_ht_params iwl5000_ht_params = {
 	.ht_greenfield_support = true,
-	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
+	.ht40_bands = BIT(NL80211_BAND_2GHZ) | BIT(NL80211_BAND_5GHZ),
 };
 
 static const struct iwl_eeprom_params iwl5000_eeprom_params = {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
index 9938f5340ac0..5a7b7e1f0aab 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
@@ -110,7 +110,7 @@ static const struct iwl_base_params iwl6000_g2_base_params = {
 static const struct iwl_ht_params iwl6000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
+	.ht40_bands = BIT(NL80211_BAND_2GHZ) | BIT(NL80211_BAND_5GHZ),
 };
 
 static const struct iwl_eeprom_params iwl6000_eeprom_params = {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index b6283c881d42..abd2904ecc48 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -156,7 +156,7 @@ static const struct iwl_tt_params iwl7000_high_temp_tt_params = {
 
 static const struct iwl_ht_params iwl7000_ht_params = {
 	.stbc = true,
-	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
+	.ht40_bands = BIT(NL80211_BAND_2GHZ) | BIT(NL80211_BAND_5GHZ),
 };
 
 #define IWL_DEVICE_7000_COMMON					\
@@ -287,7 +287,7 @@ static const struct iwl_pwr_tx_backoff iwl7265_pwr_tx_backoffs[] = {
 static const struct iwl_ht_params iwl7265_ht_params = {
 	.stbc = true,
 	.ldpc = true,
-	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
+	.ht40_bands = BIT(NL80211_BAND_2GHZ) | BIT(NL80211_BAND_5GHZ),
 };
 
 const struct iwl_cfg iwl3165_2ac_cfg = {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index 0728a288aa3d..a9212a12f4da 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -124,7 +124,7 @@ static const struct iwl_base_params iwl8000_base_params = {
 static const struct iwl_ht_params iwl8000_ht_params = {
 	.stbc = true,
 	.ldpc = true,
-	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
+	.ht40_bands = BIT(NL80211_BAND_2GHZ) | BIT(NL80211_BAND_5GHZ),
 };
 
 static const struct iwl_tt_params iwl8000_tt_params = {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index a3d35aa291a9..b9aca3795f06 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -93,7 +93,7 @@ static const struct iwl_base_params iwl9000_base_params = {
 static const struct iwl_ht_params iwl9000_ht_params = {
 	.stbc = true,
 	.ldpc = true,
-	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
+	.ht40_bands = BIT(NL80211_BAND_2GHZ) | BIT(NL80211_BAND_5GHZ),
 };
 
 static const struct iwl_tt_params iwl9000_tt_params = {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 08bb4f4e424a..720679889ab3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -185,7 +185,7 @@ struct iwl_base_params {
  * @stbc: support Tx STBC and 1*SS Rx STBC
  * @ldpc: support Tx/Rx with LDPC
  * @use_rts_for_aggregation: use rts/cts protection for HT traffic
- * @ht40_bands: bitmap of bands (using %IEEE80211_BAND_*) that support HT40
+ * @ht40_bands: bitmap of bands (using %NL80211_BAND_*) that support HT40
  */
 struct iwl_ht_params {
 	enum ieee80211_smps_mode smps_mode;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index c15f5be85197..bf1b69aec813 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -390,10 +390,10 @@ iwl_eeprom_enh_txp_read_element(struct iwl_nvm_data *data,
 				int n_channels, s8 max_txpower_avg)
 {
 	int ch_idx;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	band = txp->flags & IWL_EEPROM_ENH_TXP_FL_BAND_52G ?
-		IEEE80211_BAND_5GHZ : IEEE80211_BAND_2GHZ;
+		NL80211_BAND_5GHZ : NL80211_BAND_2GHZ;
 
 	for (ch_idx = 0; ch_idx < n_channels; ch_idx++) {
 		struct ieee80211_channel *chan = &data->channels[ch_idx];
@@ -526,7 +526,7 @@ static void iwl_init_band_reference(const struct iwl_cfg *cfg,
 
 static void iwl_mod_ht40_chan_info(struct device *dev,
 				   struct iwl_nvm_data *data, int n_channels,
-				   enum ieee80211_band band, u16 channel,
+				   enum nl80211_band band, u16 channel,
 				   const struct iwl_eeprom_channel *eeprom_ch,
 				   u8 clear_ht40_extension_channel)
 {
@@ -548,7 +548,7 @@ static void iwl_mod_ht40_chan_info(struct device *dev,
 	IWL_DEBUG_EEPROM(dev,
 			 "HT40 Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm): Ad-Hoc %ssupported\n",
 			 channel,
-			 band == IEEE80211_BAND_5GHZ ? "5.2" : "2.4",
+			 band == NL80211_BAND_5GHZ ? "5.2" : "2.4",
 			 CHECK_AND_PRINT(IBSS),
 			 CHECK_AND_PRINT(ACTIVE),
 			 CHECK_AND_PRINT(RADAR),
@@ -606,8 +606,8 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 			n_channels++;
 
 			channel->hw_value = eeprom_ch_array[ch_idx];
-			channel->band = (band == 1) ? IEEE80211_BAND_2GHZ
-						    : IEEE80211_BAND_5GHZ;
+			channel->band = (band == 1) ? NL80211_BAND_2GHZ
+						    : NL80211_BAND_5GHZ;
 			channel->center_freq =
 				ieee80211_channel_to_frequency(
 					channel->hw_value, channel->band);
@@ -677,15 +677,15 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 
 	/* Two additional EEPROM bands for 2.4 and 5 GHz HT40 channels */
 	for (band = 6; band <= 7; band++) {
-		enum ieee80211_band ieeeband;
+		enum nl80211_band ieeeband;
 
 		iwl_init_band_reference(cfg, eeprom, eeprom_size, band,
 					&eeprom_ch_count, &eeprom_ch_info,
 					&eeprom_ch_array);
 
 		/* EEPROM band 6 is 2.4, band 7 is 5 GHz */
-		ieeeband = (band == 6) ? IEEE80211_BAND_2GHZ
-				       : IEEE80211_BAND_5GHZ;
+		ieeeband = (band == 6) ? NL80211_BAND_2GHZ
+				       : NL80211_BAND_5GHZ;
 
 		/* Loop through each band adding each of the channels */
 		for (ch_idx = 0; ch_idx < eeprom_ch_count; ch_idx++) {
@@ -708,7 +708,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 
 int iwl_init_sband_channels(struct iwl_nvm_data *data,
 			    struct ieee80211_supported_band *sband,
-			    int n_channels, enum ieee80211_band band)
+			    int n_channels, enum nl80211_band band)
 {
 	struct ieee80211_channel *chan = &data->channels[0];
 	int n = 0, idx = 0;
@@ -734,7 +734,7 @@ int iwl_init_sband_channels(struct iwl_nvm_data *data,
 void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 			  struct iwl_nvm_data *data,
 			  struct ieee80211_sta_ht_cap *ht_info,
-			  enum ieee80211_band band,
+			  enum nl80211_band band,
 			  u8 tx_chains, u8 rx_chains)
 {
 	int max_bit_rate = 0;
@@ -813,22 +813,22 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 	int n_used = 0;
 	struct ieee80211_supported_band *sband;
 
-	sband = &data->bands[IEEE80211_BAND_2GHZ];
-	sband->band = IEEE80211_BAND_2GHZ;
+	sband = &data->bands[NL80211_BAND_2GHZ];
+	sband->band = NL80211_BAND_2GHZ;
 	sband->bitrates = &iwl_cfg80211_rates[RATES_24_OFFS];
 	sband->n_bitrates = N_RATES_24;
 	n_used += iwl_init_sband_channels(data, sband, n_channels,
-					  IEEE80211_BAND_2GHZ);
-	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, IEEE80211_BAND_2GHZ,
+					  NL80211_BAND_2GHZ);
+	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, NL80211_BAND_2GHZ,
 			     data->valid_tx_ant, data->valid_rx_ant);
 
-	sband = &data->bands[IEEE80211_BAND_5GHZ];
-	sband->band = IEEE80211_BAND_5GHZ;
+	sband = &data->bands[NL80211_BAND_5GHZ];
+	sband->band = NL80211_BAND_5GHZ;
 	sband->bitrates = &iwl_cfg80211_rates[RATES_52_OFFS];
 	sband->n_bitrates = N_RATES_52;
 	n_used += iwl_init_sband_channels(data, sband, n_channels,
-					  IEEE80211_BAND_5GHZ);
-	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, IEEE80211_BAND_5GHZ,
+					  NL80211_BAND_5GHZ);
+	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, NL80211_BAND_5GHZ,
 			     data->valid_tx_ant, data->valid_rx_ant);
 
 	if (n_channels != n_used)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
index ad2b834668ff..53f39a34eca2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
@@ -98,7 +98,7 @@ struct iwl_nvm_data {
 	s8 max_tx_pwr_half_dbm;
 
 	bool lar_enabled;
-	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
+	struct ieee80211_supported_band bands[NUM_NL80211_BANDS];
 	struct ieee80211_channel channels[];
 };
 
@@ -133,12 +133,12 @@ int iwl_nvm_check_version(struct iwl_nvm_data *data,
 
 int iwl_init_sband_channels(struct iwl_nvm_data *data,
 			    struct ieee80211_supported_band *sband,
-			    int n_channels, enum ieee80211_band band);
+			    int n_channels, enum nl80211_band band);
 
 void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 			  struct iwl_nvm_data *data,
 			  struct ieee80211_sta_ht_cap *ht_info,
-			  enum ieee80211_band band,
+			  enum nl80211_band band,
 			  u8 tx_chains, u8 rx_chains);
 
 #endif /* __iwl_eeprom_parse_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 93a689583dff..14743c37d976 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -308,7 +308,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 
 		channel->hw_value = nvm_chan[ch_idx];
 		channel->band = (ch_idx < num_2ghz_channels) ?
-				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+				NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
 		channel->center_freq =
 			ieee80211_channel_to_frequency(
 				channel->hw_value, channel->band);
@@ -320,7 +320,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		 * is not used in mvm, and is used for backwards compatibility
 		 */
 		channel->max_power = IWL_DEFAULT_MAX_TX_POWER;
-		is_5ghz = channel->band == IEEE80211_BAND_5GHZ;
+		is_5ghz = channel->band == NL80211_BAND_5GHZ;
 
 		/* don't put limitations in case we're using LAR */
 		if (!lar_supported)
@@ -439,22 +439,22 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 				&ch_section[NVM_CHANNELS_FAMILY_8000],
 				lar_supported);
 
-	sband = &data->bands[IEEE80211_BAND_2GHZ];
-	sband->band = IEEE80211_BAND_2GHZ;
+	sband = &data->bands[NL80211_BAND_2GHZ];
+	sband->band = NL80211_BAND_2GHZ;
 	sband->bitrates = &iwl_cfg80211_rates[RATES_24_OFFS];
 	sband->n_bitrates = N_RATES_24;
 	n_used += iwl_init_sband_channels(data, sband, n_channels,
-					  IEEE80211_BAND_2GHZ);
-	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, IEEE80211_BAND_2GHZ,
+					  NL80211_BAND_2GHZ);
+	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, NL80211_BAND_2GHZ,
 			     tx_chains, rx_chains);
 
-	sband = &data->bands[IEEE80211_BAND_5GHZ];
-	sband->band = IEEE80211_BAND_5GHZ;
+	sband = &data->bands[NL80211_BAND_5GHZ];
+	sband->band = NL80211_BAND_5GHZ;
 	sband->bitrates = &iwl_cfg80211_rates[RATES_52_OFFS];
 	sband->n_bitrates = N_RATES_52;
 	n_used += iwl_init_sband_channels(data, sband, n_channels,
-					  IEEE80211_BAND_5GHZ);
-	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, IEEE80211_BAND_5GHZ,
+					  NL80211_BAND_5GHZ);
+	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, NL80211_BAND_5GHZ,
 			     tx_chains, rx_chains);
 	if (data->sku_cap_11ac_enable && !iwlwifi_mod_params.disable_11ac)
 		iwl_init_vht_hw_capab(cfg, data, &sband->vht_cap,
@@ -781,7 +781,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	struct ieee80211_regdomain *regd;
 	int size_of_regd;
 	struct ieee80211_reg_rule *rule;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	int center_freq, prev_center_freq = 0;
 	int valid_rules = 0;
 	bool new_rule;
@@ -809,7 +809,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	for (ch_idx = 0; ch_idx < num_of_ch; ch_idx++) {
 		ch_flags = (u16)__le32_to_cpup(channels + ch_idx);
 		band = (ch_idx < NUM_2GHZ_CHANNELS) ?
-		       IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+		       NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
 		center_freq = ieee80211_channel_to_frequency(nvm_chan[ch_idx],
 							     band);
 		new_rule = false;
@@ -857,7 +857,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		IWL_DEBUG_DEV(dev, IWL_DL_LAR,
 			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s(0x%02x): Ad-Hoc %ssupported\n",
 			      center_freq,
-			      band == IEEE80211_BAND_5GHZ ? "5.2" : "2.4",
+			      band == NL80211_BAND_5GHZ ? "5.2" : "2.4",
 			      CHECK_AND_PRINT_I(VALID),
 			      CHECK_AND_PRINT_I(ACTIVE),
 			      CHECK_AND_PRINT_I(RADAR),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index 35cdeca3d61e..a63f5bbb1ba7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -378,7 +378,7 @@ iwl_get_coex_type(struct iwl_mvm *mvm, const struct ieee80211_vif *vif)
 	chanctx_conf = rcu_dereference(vif->chanctx_conf);
 
 	if (!chanctx_conf ||
-	     chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ) {
+	     chanctx_conf->def.chan->band != NL80211_BAND_2GHZ) {
 		rcu_read_unlock();
 		return BT_COEX_INVALID_LUT;
 	}
@@ -537,7 +537,7 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 
 	/* If channel context is invalid or not on 2.4GHz .. */
 	if ((!chanctx_conf ||
-	     chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ)) {
+	     chanctx_conf->def.chan->band != NL80211_BAND_2GHZ)) {
 		if (vif->type == NL80211_IFTYPE_STATION) {
 			/* ... relax constraints and disable rssi events */
 			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
@@ -857,11 +857,11 @@ bool iwl_mvm_bt_coex_is_shared_ant_avail(struct iwl_mvm *mvm)
 }
 
 bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
-				    enum ieee80211_band band)
+				    enum nl80211_band band)
 {
 	u32 bt_activity = le32_to_cpu(mvm->last_bt_notif.bt_activity_grading);
 
-	if (band != IEEE80211_BAND_2GHZ)
+	if (band != NL80211_BAND_2GHZ)
 		return false;
 
 	return bt_activity >= BT_LOW_TRAFFIC;
@@ -873,7 +873,7 @@ u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 	__le16 fc = hdr->frame_control;
 	bool mplut_enabled = iwl_mvm_is_mplut_supported(mvm);
 
-	if (info->band != IEEE80211_BAND_2GHZ)
+	if (info->band != NL80211_BAND_2GHZ)
 		return 0;
 
 	if (unlikely(mvm->bt_tx_prio))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 3a279d3403ef..fb96bc00f022 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -724,9 +724,9 @@ static ssize_t iwl_dbgfs_tof_responder_params_write(struct ieee80211_vif *vif,
 
 		ret = kstrtou32(data, 10, &value);
 		if (ret == 0 && value) {
-			enum ieee80211_band band = (cmd->channel_num <= 14) ?
-						   IEEE80211_BAND_2GHZ :
-						   IEEE80211_BAND_5GHZ;
+			enum nl80211_band band = (cmd->channel_num <= 14) ?
+						   NL80211_BAND_2GHZ :
+						   NL80211_BAND_5GHZ;
 			struct ieee80211_channel chn = {
 				.band = band,
 				.center_freq = ieee80211_channel_to_frequency(
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 6ad5c602e84c..9e97cf4ff1c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -980,7 +980,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		goto error;
 
 	/* Add all the PHY contexts */
-	chan = &mvm->hw->wiphy->bands[IEEE80211_BAND_2GHZ]->channels[0];
+	chan = &mvm->hw->wiphy->bands[NL80211_BAND_2GHZ]->channels[0];
 	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
 	for (i = 0; i < NUM_PHY_CTX; i++) {
 		/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 923d19112e0c..456067b2f48d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -559,7 +559,7 @@ void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 static void iwl_mvm_ack_rates(struct iwl_mvm *mvm,
 			      struct ieee80211_vif *vif,
-			      enum ieee80211_band band,
+			      enum nl80211_band band,
 			      u8 *cck_rates, u8 *ofdm_rates)
 {
 	struct ieee80211_supported_band *sband;
@@ -730,7 +730,7 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 	rcu_read_lock();
 	chanctx = rcu_dereference(vif->chanctx_conf);
 	iwl_mvm_ack_rates(mvm, vif, chanctx ? chanctx->def.chan->band
-					    : IEEE80211_BAND_2GHZ,
+					    : NL80211_BAND_2GHZ,
 			  &cck_ack_rates, &ofdm_ack_rates);
 	rcu_read_unlock();
 
@@ -1065,7 +1065,7 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 		cpu_to_le32(BIT(mvm->mgmt_last_antenna_idx) <<
 			    RATE_MCS_ANT_POS);
 
-	if (info->band == IEEE80211_BAND_5GHZ || vif->p2p) {
+	if (info->band == NL80211_BAND_5GHZ || vif->p2p) {
 		rate = IWL_FIRST_OFDM_RATE;
 	} else {
 		rate = IWL_FIRST_CCK_RATE;
@@ -1516,7 +1516,7 @@ void iwl_mvm_rx_stored_beacon_notif(struct iwl_mvm *mvm,
 	rx_status.device_timestamp = le32_to_cpu(sb->system_time);
 	rx_status.band =
 		(sb->phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_BAND_24)) ?
-				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+				NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
 	rx_status.freq =
 		ieee80211_channel_to_frequency(le16_to_cpu(sb->channel),
 					       rx_status.band);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 4f5ec495b460..ef91b3770703 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -550,18 +550,18 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	else
 		mvm->max_scans = IWL_MVM_MAX_LMAC_SCANS;
 
-	if (mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels)
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&mvm->nvm_data->bands[IEEE80211_BAND_2GHZ];
-	if (mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels) {
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&mvm->nvm_data->bands[IEEE80211_BAND_5GHZ];
+	if (mvm->nvm_data->bands[NL80211_BAND_2GHZ].n_channels)
+		hw->wiphy->bands[NL80211_BAND_2GHZ] =
+			&mvm->nvm_data->bands[NL80211_BAND_2GHZ];
+	if (mvm->nvm_data->bands[NL80211_BAND_5GHZ].n_channels) {
+		hw->wiphy->bands[NL80211_BAND_5GHZ] =
+			&mvm->nvm_data->bands[NL80211_BAND_5GHZ];
 
 		if (fw_has_capa(&mvm->fw->ucode_capa,
 				IWL_UCODE_TLV_CAPA_BEAMFORMER) &&
 		    fw_has_api(&mvm->fw->ucode_capa,
 			       IWL_UCODE_TLV_API_LQ_SS_PARAMS))
-			hw->wiphy->bands[IEEE80211_BAND_5GHZ]->vht_cap.cap |=
+			hw->wiphy->bands[NL80211_BAND_5GHZ]->vht_cap.cap |=
 				IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE;
 	}
 
@@ -2911,7 +2911,7 @@ static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 			cpu_to_le32(FW_CMD_ID_AND_COLOR(MAC_INDEX_AUX, 0)),
 		.sta_id_and_color = cpu_to_le32(mvm->aux_sta.sta_id),
 		/* Set the channel info data */
-		.channel_info.band = (channel->band == IEEE80211_BAND_2GHZ) ?
+		.channel_info.band = (channel->band == NL80211_BAND_2GHZ) ?
 			PHY_BAND_24 : PHY_BAND_5,
 		.channel_info.channel = channel->hw_value,
 		.channel_info.width = PHY_VHT_CHANNEL_MODE20,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 2d685e02d488..85800ba0c667 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1133,9 +1133,9 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm);
 
 /* Utils */
 int iwl_mvm_legacy_rate_to_mac80211_idx(u32 rate_n_flags,
-					enum ieee80211_band band);
+					enum nl80211_band band);
 void iwl_mvm_hwrate_to_tx_rate(u32 rate_n_flags,
-			       enum ieee80211_band band,
+			       enum nl80211_band band,
 			       struct ieee80211_tx_rate *r);
 u8 iwl_mvm_mac80211_idx_to_hwrate(int rate_idx);
 void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm);
@@ -1468,7 +1468,7 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 bool iwl_mvm_bt_coex_is_ant_avail(struct iwl_mvm *mvm, u8 ant);
 bool iwl_mvm_bt_coex_is_shared_ant_avail(struct iwl_mvm *mvm);
 bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
-				    enum ieee80211_band band);
+				    enum nl80211_band band);
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			   struct ieee80211_tx_info *info, u8 ac);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index 6e6a56f2153d..95138830b9f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -147,7 +147,7 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 	u8 active_cnt, idle_cnt;
 
 	/* Set the channel info data */
-	cmd->ci.band = (chandef->chan->band == IEEE80211_BAND_2GHZ ?
+	cmd->ci.band = (chandef->chan->band == NL80211_BAND_2GHZ ?
 	      PHY_BAND_24 : PHY_BAND_5);
 
 	cmd->ci.channel = chandef->chan->hw_value;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 61d0a8cd13f9..81dd2f6a48a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -829,7 +829,7 @@ static u32 ucode_rate_from_rs_rate(struct iwl_mvm *mvm,
 
 /* Convert a ucode rate into an rs_rate object */
 static int rs_rate_from_ucode_rate(const u32 ucode_rate,
-				   enum ieee80211_band band,
+				   enum nl80211_band band,
 				   struct rs_rate *rate)
 {
 	u32 ant_msk = ucode_rate & RATE_MCS_ANT_ABC_MSK;
@@ -848,7 +848,7 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 	if (!(ucode_rate & RATE_MCS_HT_MSK) &&
 	    !(ucode_rate & RATE_MCS_VHT_MSK)) {
 		if (num_of_ant == 1) {
-			if (band == IEEE80211_BAND_5GHZ)
+			if (band == NL80211_BAND_5GHZ)
 				rate->type = LQ_LEGACY_A;
 			else
 				rate->type = LQ_LEGACY_G;
@@ -1043,7 +1043,7 @@ static void rs_get_lower_rate_down_column(struct iwl_lq_sta *lq_sta,
 		return;
 	} else if (is_siso(rate)) {
 		/* Downgrade to Legacy if we were in SISO */
-		if (lq_sta->band == IEEE80211_BAND_5GHZ)
+		if (lq_sta->band == NL80211_BAND_5GHZ)
 			rate->type = LQ_LEGACY_A;
 		else
 			rate->type = LQ_LEGACY_G;
@@ -1850,7 +1850,7 @@ static int rs_switch_to_column(struct iwl_mvm *mvm,
 	rate->ant = column->ant;
 
 	if (column->mode == RS_LEGACY) {
-		if (lq_sta->band == IEEE80211_BAND_5GHZ)
+		if (lq_sta->band == NL80211_BAND_5GHZ)
 			rate->type = LQ_LEGACY_A;
 		else
 			rate->type = LQ_LEGACY_G;
@@ -2020,7 +2020,7 @@ static void rs_get_adjacent_txp(struct iwl_mvm *mvm, int index,
 }
 
 static bool rs_tpc_allowed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			   struct rs_rate *rate, enum ieee80211_band band)
+			   struct rs_rate *rate, enum nl80211_band band)
 {
 	int index = rate->index;
 	bool cam = (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM);
@@ -2126,7 +2126,7 @@ static bool rs_tpc_perform(struct iwl_mvm *mvm,
 	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	struct ieee80211_vif *vif = mvm_sta->vif;
 	struct ieee80211_chanctx_conf *chanctx_conf;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct iwl_rate_scale_data *window;
 	struct rs_rate *rate = &tbl->rate;
 	enum tpc_action action;
@@ -2148,7 +2148,7 @@ static bool rs_tpc_perform(struct iwl_mvm *mvm,
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(vif->chanctx_conf);
 	if (WARN_ON(!chanctx_conf))
-		band = IEEE80211_NUM_BANDS;
+		band = NUM_NL80211_BANDS;
 	else
 		band = chanctx_conf->def.chan->band;
 	rcu_read_unlock();
@@ -2606,7 +2606,7 @@ static void rs_init_optimal_rate(struct iwl_mvm *mvm,
 		rate->type = lq_sta->is_vht ? LQ_VHT_MIMO2 : LQ_HT_MIMO2;
 	else if (lq_sta->max_siso_rate_idx != IWL_RATE_INVALID)
 		rate->type = lq_sta->is_vht ? LQ_VHT_SISO : LQ_HT_SISO;
-	else if (lq_sta->band == IEEE80211_BAND_5GHZ)
+	else if (lq_sta->band == NL80211_BAND_5GHZ)
 		rate->type = LQ_LEGACY_A;
 	else
 		rate->type = LQ_LEGACY_G;
@@ -2623,7 +2623,7 @@ static void rs_init_optimal_rate(struct iwl_mvm *mvm,
 	} else {
 		lq_sta->optimal_rate_mask = lq_sta->active_legacy_rate;
 
-		if (lq_sta->band == IEEE80211_BAND_5GHZ) {
+		if (lq_sta->band == NL80211_BAND_5GHZ) {
 			lq_sta->optimal_rates = rs_optimal_rates_5ghz_legacy;
 			lq_sta->optimal_nentries =
 				ARRAY_SIZE(rs_optimal_rates_5ghz_legacy);
@@ -2679,7 +2679,7 @@ static struct rs_rate *rs_get_optimal_rate(struct iwl_mvm *mvm,
 static void rs_get_initial_rate(struct iwl_mvm *mvm,
 				struct ieee80211_sta *sta,
 				struct iwl_lq_sta *lq_sta,
-				enum ieee80211_band band,
+				enum nl80211_band band,
 				struct rs_rate *rate)
 {
 	int i, nentries;
@@ -2714,7 +2714,7 @@ static void rs_get_initial_rate(struct iwl_mvm *mvm,
 	rate->index = find_first_bit(&lq_sta->active_legacy_rate,
 				     BITS_PER_LONG);
 
-	if (band == IEEE80211_BAND_5GHZ) {
+	if (band == NL80211_BAND_5GHZ) {
 		rate->type = LQ_LEGACY_A;
 		initial_rates = rs_optimal_rates_5ghz_legacy;
 		nentries = ARRAY_SIZE(rs_optimal_rates_5ghz_legacy);
@@ -2814,7 +2814,7 @@ void rs_update_last_rssi(struct iwl_mvm *mvm,
 static void rs_initialize_lq(struct iwl_mvm *mvm,
 			     struct ieee80211_sta *sta,
 			     struct iwl_lq_sta *lq_sta,
-			     enum ieee80211_band band,
+			     enum nl80211_band band,
 			     bool init)
 {
 	struct iwl_scale_tbl_info *tbl;
@@ -3097,7 +3097,7 @@ void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm, u32 rate, bool agg)
  * Called after adding a new station to initialize rate scaling
  */
 void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  enum ieee80211_band band, bool init)
+			  enum nl80211_band band, bool init)
 {
 	int i, j;
 	struct ieee80211_hw *hw = mvm->hw;
@@ -3203,7 +3203,7 @@ static void rs_rate_update(void *mvm_r,
 #ifdef CONFIG_MAC80211_DEBUGFS
 static void rs_build_rates_table_from_fixed(struct iwl_mvm *mvm,
 					    struct iwl_lq_cmd *lq_cmd,
-					    enum ieee80211_band band,
+					    enum nl80211_band band,
 					    u32 ucode_rate)
 {
 	struct rs_rate rate;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index bdb6f2d8d854..90d046fb24a0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -305,7 +305,7 @@ struct iwl_lq_sta {
 	bool stbc_capable;      /* Tx STBC is supported by chip and Rx by STA */
 	bool bfer_capable;      /* Remote supports beamformee and we BFer */
 
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
 	unsigned long active_legacy_rate;
@@ -358,7 +358,7 @@ struct iwl_lq_sta {
 
 /* Initialize station's rate scaling information after adding station */
 void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  enum ieee80211_band band, bool init);
+			  enum nl80211_band band, bool init);
 
 /* Notify RS about Tx status */
 void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index d8cadf2fe098..263e8a8576b7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -319,7 +319,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rx_status->device_timestamp = le32_to_cpu(phy_info->system_timestamp);
 	rx_status->band =
 		(phy_info->phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_BAND_24)) ?
-				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+				NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
 	rx_status->freq =
 		ieee80211_channel_to_frequency(le16_to_cpu(phy_info->channel),
 					       rx_status->band);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index d4a4c13400cb..651604d18a32 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -456,8 +456,8 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	rx_status->mactime = le64_to_cpu(desc->tsf_on_air_rise);
 	rx_status->device_timestamp = le32_to_cpu(desc->gp2_on_air_rise);
-	rx_status->band = desc->channel > 14 ? IEEE80211_BAND_5GHZ :
-					       IEEE80211_BAND_2GHZ;
+	rx_status->band = desc->channel > 14 ? NL80211_BAND_5GHZ :
+					       NL80211_BAND_2GHZ;
 	rx_status->freq = ieee80211_channel_to_frequency(desc->channel,
 							 rx_status->band);
 	iwl_mvm_get_signal_strength(mvm, desc, rx_status);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index c1d1be9c5d01..6f609dd5c222 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -163,16 +163,16 @@ static inline __le16 iwl_mvm_scan_rx_chain(struct iwl_mvm *mvm)
 	return cpu_to_le16(rx_chain);
 }
 
-static __le32 iwl_mvm_scan_rxon_flags(enum ieee80211_band band)
+static __le32 iwl_mvm_scan_rxon_flags(enum nl80211_band band)
 {
-	if (band == IEEE80211_BAND_2GHZ)
+	if (band == NL80211_BAND_2GHZ)
 		return cpu_to_le32(PHY_BAND_24);
 	else
 		return cpu_to_le32(PHY_BAND_5);
 }
 
 static inline __le32
-iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum ieee80211_band band,
+iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum nl80211_band band,
 			  bool no_cck)
 {
 	u32 tx_ant;
@@ -182,7 +182,7 @@ iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum ieee80211_band band,
 				     mvm->scan_last_antenna_idx);
 	tx_ant = BIT(mvm->scan_last_antenna_idx) << RATE_MCS_ANT_POS;
 
-	if (band == IEEE80211_BAND_2GHZ && !no_cck)
+	if (band == NL80211_BAND_2GHZ && !no_cck)
 		return cpu_to_le32(IWL_RATE_1M_PLCP | RATE_MCS_CCK_MSK |
 				   tx_ant);
 	else
@@ -591,14 +591,14 @@ static void iwl_mvm_scan_fill_tx_cmd(struct iwl_mvm *mvm,
 	tx_cmd[0].tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
 					 TX_CMD_FLG_BT_DIS);
 	tx_cmd[0].rate_n_flags = iwl_mvm_scan_rate_n_flags(mvm,
-							   IEEE80211_BAND_2GHZ,
+							   NL80211_BAND_2GHZ,
 							   no_cck);
 	tx_cmd[0].sta_id = mvm->aux_sta.sta_id;
 
 	tx_cmd[1].tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
 					 TX_CMD_FLG_BT_DIS);
 	tx_cmd[1].rate_n_flags = iwl_mvm_scan_rate_n_flags(mvm,
-							   IEEE80211_BAND_5GHZ,
+							   NL80211_BAND_5GHZ,
 							   no_cck);
 	tx_cmd[1].sta_id = mvm->aux_sta.sta_id;
 }
@@ -695,19 +695,19 @@ iwl_mvm_build_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	/* Insert ds parameter set element on 2.4 GHz band */
 	newpos = iwl_mvm_copy_and_insert_ds_elem(mvm,
-						 ies->ies[IEEE80211_BAND_2GHZ],
-						 ies->len[IEEE80211_BAND_2GHZ],
+						 ies->ies[NL80211_BAND_2GHZ],
+						 ies->len[NL80211_BAND_2GHZ],
 						 pos);
 	params->preq.band_data[0].offset = cpu_to_le16(pos - params->preq.buf);
 	params->preq.band_data[0].len = cpu_to_le16(newpos - pos);
 	pos = newpos;
 
-	memcpy(pos, ies->ies[IEEE80211_BAND_5GHZ],
-	       ies->len[IEEE80211_BAND_5GHZ]);
+	memcpy(pos, ies->ies[NL80211_BAND_5GHZ],
+	       ies->len[NL80211_BAND_5GHZ]);
 	params->preq.band_data[1].offset = cpu_to_le16(pos - params->preq.buf);
 	params->preq.band_data[1].len =
-		cpu_to_le16(ies->len[IEEE80211_BAND_5GHZ]);
-	pos += ies->len[IEEE80211_BAND_5GHZ];
+		cpu_to_le16(ies->len[NL80211_BAND_5GHZ]);
+	pos += ies->len[NL80211_BAND_5GHZ];
 
 	memcpy(pos, ies->common_ies, ies->common_ie_len);
 	params->preq.common_data.offset = cpu_to_le16(pos - params->preq.buf);
@@ -921,10 +921,10 @@ static __le32 iwl_mvm_scan_config_rates(struct iwl_mvm *mvm)
 	unsigned int rates = 0;
 	int i;
 
-	band = &mvm->nvm_data->bands[IEEE80211_BAND_2GHZ];
+	band = &mvm->nvm_data->bands[NL80211_BAND_2GHZ];
 	for (i = 0; i < band->n_bitrates; i++)
 		rates |= rate_to_scan_rate_flag(band->bitrates[i].hw_value);
-	band = &mvm->nvm_data->bands[IEEE80211_BAND_5GHZ];
+	band = &mvm->nvm_data->bands[NL80211_BAND_5GHZ];
 	for (i = 0; i < band->n_bitrates; i++)
 		rates |= rate_to_scan_rate_flag(band->bitrates[i].hw_value);
 
@@ -939,8 +939,8 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	struct iwl_scan_config *scan_config;
 	struct ieee80211_supported_band *band;
 	int num_channels =
-		mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels +
-		mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels;
+		mvm->nvm_data->bands[NL80211_BAND_2GHZ].n_channels +
+		mvm->nvm_data->bands[NL80211_BAND_5GHZ].n_channels;
 	int ret, i, j = 0, cmd_size;
 	struct iwl_host_cmd cmd = {
 		.id = iwl_cmd_id(SCAN_CFG_CMD, IWL_ALWAYS_LONG_GROUP, 0),
@@ -994,10 +994,10 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 				     IWL_CHANNEL_FLAG_EBS_ADD |
 				     IWL_CHANNEL_FLAG_PRE_SCAN_PASSIVE2ACTIVE;
 
-	band = &mvm->nvm_data->bands[IEEE80211_BAND_2GHZ];
+	band = &mvm->nvm_data->bands[NL80211_BAND_2GHZ];
 	for (i = 0; i < band->n_channels; i++, j++)
 		scan_config->channel_array[j] = band->channels[i].hw_value;
-	band = &mvm->nvm_data->bands[IEEE80211_BAND_5GHZ];
+	band = &mvm->nvm_data->bands[NL80211_BAND_5GHZ];
 	for (i = 0; i < band->n_channels; i++, j++)
 		scan_config->channel_array[j] = band->channels[i].hw_value;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
index 18711c5de35a..9f160fc58cd0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
@@ -444,7 +444,7 @@ iwl_mvm_tdls_config_channel_switch(struct iwl_mvm *mvm,
 	}
 
 	if (chandef) {
-		cmd.ci.band = (chandef->chan->band == IEEE80211_BAND_2GHZ ?
+		cmd.ci.band = (chandef->chan->band == NL80211_BAND_2GHZ ?
 			       PHY_BAND_24 : PHY_BAND_5);
 		cmd.ci.channel = chandef->chan->hw_value;
 		cmd.ci.width = iwl_mvm_get_channel_width(chandef);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index efb9b98c4c98..bd286fca3776 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -359,7 +359,7 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 				&mvm->nvm_data->bands[info->band], sta);
 
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
-	if (info->band == IEEE80211_BAND_5GHZ)
+	if (info->band == NL80211_BAND_5GHZ)
 		rate_idx += IWL_FIRST_OFDM_RATE;
 
 	/* For 2.4 GHZ band, check that there is no need to remap */
@@ -372,7 +372,7 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 		iwl_mvm_next_antenna(mvm, iwl_mvm_get_valid_tx_ant(mvm),
 				     mvm->mgmt_last_antenna_idx);
 
-	if (info->band == IEEE80211_BAND_2GHZ &&
+	if (info->band == NL80211_BAND_2GHZ &&
 	    !iwl_mvm_bt_coex_is_shared_ant_avail(mvm))
 		rate_flags = mvm->cfg->non_shared_ant << RATE_MCS_ANT_POS;
 	else
@@ -1052,7 +1052,7 @@ const char *iwl_mvm_get_tx_fail_reason(u32 status)
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
 void iwl_mvm_hwrate_to_tx_rate(u32 rate_n_flags,
-			       enum ieee80211_band band,
+			       enum nl80211_band band,
 			       struct ieee80211_tx_rate *r)
 {
 	if (rate_n_flags & RATE_HT_MCS_GF_MSK)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 486c98541afc..f0ffd62f02d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -217,14 +217,14 @@ static const u8 fw_rate_idx_to_plcp[IWL_RATE_COUNT] = {
 };
 
 int iwl_mvm_legacy_rate_to_mac80211_idx(u32 rate_n_flags,
-					enum ieee80211_band band)
+					enum nl80211_band band)
 {
 	int rate = rate_n_flags & RATE_LEGACY_RATE_MSK;
 	int idx;
 	int band_offset = 0;
 
 	/* Legacy rate format, search for match in table */
-	if (band == IEEE80211_BAND_5GHZ)
+	if (band == NL80211_BAND_5GHZ)
 		band_offset = IWL_FIRST_OFDM_RATE;
 	for (idx = band_offset; idx < IWL_RATE_COUNT_LEGACY; idx++)
 		if (fw_rate_idx_to_plcp[idx] == rate)
diff --git a/drivers/net/wireless/intersil/orinoco/cfg.c b/drivers/net/wireless/intersil/orinoco/cfg.c
index 0f6ea316e38e..7aa47069af0a 100644
--- a/drivers/net/wireless/intersil/orinoco/cfg.c
+++ b/drivers/net/wireless/intersil/orinoco/cfg.c
@@ -60,14 +60,14 @@ int orinoco_wiphy_register(struct wiphy *wiphy)
 		if (priv->channel_mask & (1 << i)) {
 			priv->channels[i].center_freq =
 				ieee80211_channel_to_frequency(i + 1,
-							   IEEE80211_BAND_2GHZ);
+							   NL80211_BAND_2GHZ);
 			channels++;
 		}
 	}
 	priv->band.channels = priv->channels;
 	priv->band.n_channels = channels;
 
-	wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+	wiphy->bands[NL80211_BAND_2GHZ] = &priv->band;
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
 	i = 0;
@@ -175,7 +175,7 @@ static int orinoco_set_monitor_channel(struct wiphy *wiphy,
 	if (cfg80211_get_chandef_type(chandef) != NL80211_CHAN_NO_HT)
 		return -EINVAL;
 
-	if (chandef->chan->band != IEEE80211_BAND_2GHZ)
+	if (chandef->chan->band != NL80211_BAND_2GHZ)
 		return -EINVAL;
 
 	channel = ieee80211_frequency_to_channel(chandef->chan->center_freq);
diff --git a/drivers/net/wireless/intersil/orinoco/hw.c b/drivers/net/wireless/intersil/orinoco/hw.c
index e27e32851f1e..61af5a28f269 100644
--- a/drivers/net/wireless/intersil/orinoco/hw.c
+++ b/drivers/net/wireless/intersil/orinoco/hw.c
@@ -1193,7 +1193,7 @@ int orinoco_hw_get_freq(struct orinoco_private *priv)
 		goto out;
 
 	}
-	freq = ieee80211_channel_to_frequency(channel, IEEE80211_BAND_2GHZ);
+	freq = ieee80211_channel_to_frequency(channel, NL80211_BAND_2GHZ);
 
  out:
 	orinoco_unlock(priv, &flags);
diff --git a/drivers/net/wireless/intersil/orinoco/scan.c b/drivers/net/wireless/intersil/orinoco/scan.c
index 2c66166add70..d0ceb06c72d0 100644
--- a/drivers/net/wireless/intersil/orinoco/scan.c
+++ b/drivers/net/wireless/intersil/orinoco/scan.c
@@ -111,7 +111,7 @@ static void orinoco_add_hostscan_result(struct orinoco_private *priv,
 	}
 
 	freq = ieee80211_channel_to_frequency(
-		le16_to_cpu(bss->a.channel), IEEE80211_BAND_2GHZ);
+		le16_to_cpu(bss->a.channel), NL80211_BAND_2GHZ);
 	channel = ieee80211_get_channel(wiphy, freq);
 	if (!channel) {
 		printk(KERN_DEBUG "Invalid channel designation %04X(%04X)",
@@ -148,7 +148,7 @@ void orinoco_add_extscan_result(struct orinoco_private *priv,
 	ie_len = len - sizeof(*bss);
 	ie = cfg80211_find_ie(WLAN_EID_DS_PARAMS, bss->data, ie_len);
 	chan = ie ? ie[2] : 0;
-	freq = ieee80211_channel_to_frequency(chan, IEEE80211_BAND_2GHZ);
+	freq = ieee80211_channel_to_frequency(chan, NL80211_BAND_2GHZ);
 	channel = ieee80211_get_channel(wiphy, freq);
 
 	timestamp = le64_to_cpu(bss->timestamp);
diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
index 2fe713eda7ad..d4c73d39336f 100644
--- a/drivers/net/wireless/intersil/p54/eeprom.c
+++ b/drivers/net/wireless/intersil/p54/eeprom.c
@@ -76,14 +76,14 @@ struct p54_channel_entry {
 	u16 data;
 	int index;
 	int max_power;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 };
 
 struct p54_channel_list {
 	struct p54_channel_entry *channels;
 	size_t entries;
 	size_t max_entries;
-	size_t band_channel_num[IEEE80211_NUM_BANDS];
+	size_t band_channel_num[NUM_NL80211_BANDS];
 };
 
 static int p54_get_band_from_freq(u16 freq)
@@ -91,10 +91,10 @@ static int p54_get_band_from_freq(u16 freq)
 	/* FIXME: sync these values with the 802.11 spec */
 
 	if ((freq >= 2412) && (freq <= 2484))
-		return IEEE80211_BAND_2GHZ;
+		return NL80211_BAND_2GHZ;
 
 	if ((freq >= 4920) && (freq <= 5825))
-		return IEEE80211_BAND_5GHZ;
+		return NL80211_BAND_5GHZ;
 
 	return -1;
 }
@@ -124,16 +124,16 @@ static int p54_compare_rssichan(const void *_a,
 
 static int p54_fill_band_bitrates(struct ieee80211_hw *dev,
 				  struct ieee80211_supported_band *band_entry,
-				  enum ieee80211_band band)
+				  enum nl80211_band band)
 {
 	/* TODO: generate rate array dynamically */
 
 	switch (band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		band_entry->bitrates = p54_bgrates;
 		band_entry->n_bitrates = ARRAY_SIZE(p54_bgrates);
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		band_entry->bitrates = p54_arates;
 		band_entry->n_bitrates = ARRAY_SIZE(p54_arates);
 		break;
@@ -147,7 +147,7 @@ static int p54_fill_band_bitrates(struct ieee80211_hw *dev,
 static int p54_generate_band(struct ieee80211_hw *dev,
 			     struct p54_channel_list *list,
 			     unsigned int *chan_num,
-			     enum ieee80211_band band)
+			     enum nl80211_band band)
 {
 	struct p54_common *priv = dev->priv;
 	struct ieee80211_supported_band *tmp, *old;
@@ -206,7 +206,7 @@ static int p54_generate_band(struct ieee80211_hw *dev,
 
 	if (j == 0) {
 		wiphy_err(dev->wiphy, "Disabling totally damaged %d GHz band\n",
-			  (band == IEEE80211_BAND_2GHZ) ? 2 : 5);
+			  (band == NL80211_BAND_2GHZ) ? 2 : 5);
 
 		ret = -ENODATA;
 		goto err_out;
@@ -396,7 +396,7 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 	     p54_compare_channels, NULL);
 
 	k = 0;
-	for (i = 0, j = 0; i < IEEE80211_NUM_BANDS; i++) {
+	for (i = 0, j = 0; i < NUM_NL80211_BANDS; i++) {
 		if (p54_generate_band(dev, list, &k, i) == 0)
 			j++;
 	}
@@ -573,10 +573,10 @@ static int p54_parse_rssical(struct ieee80211_hw *dev,
 		for (i = 0; i < entries; i++) {
 			u16 freq = 0;
 			switch (i) {
-			case IEEE80211_BAND_2GHZ:
+			case NL80211_BAND_2GHZ:
 				freq = 2437;
 				break;
-			case IEEE80211_BAND_5GHZ:
+			case NL80211_BAND_5GHZ:
 				freq = 5240;
 				break;
 			}
@@ -902,11 +902,11 @@ good_eeprom:
 	if (priv->rxhw == PDR_SYNTH_FRONTEND_XBOW)
 		p54_init_xbow_synth(priv);
 	if (!(synth & PDR_SYNTH_24_GHZ_DISABLED))
-		dev->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			priv->band_table[IEEE80211_BAND_2GHZ];
+		dev->wiphy->bands[NL80211_BAND_2GHZ] =
+			priv->band_table[NL80211_BAND_2GHZ];
 	if (!(synth & PDR_SYNTH_5_GHZ_DISABLED))
-		dev->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			priv->band_table[IEEE80211_BAND_5GHZ];
+		dev->wiphy->bands[NL80211_BAND_5GHZ] =
+			priv->band_table[NL80211_BAND_5GHZ];
 	if ((synth & PDR_SYNTH_RX_DIV_MASK) == PDR_SYNTH_RX_DIV_SUPPORTED)
 		priv->rx_diversity_mask = 3;
 	if ((synth & PDR_SYNTH_TX_DIV_MASK) == PDR_SYNTH_TX_DIV_SUPPORTED)
diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index 7805864e76f9..d5a3bf91a03e 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -477,7 +477,7 @@ static void p54_bss_info_changed(struct ieee80211_hw *dev,
 		p54_set_edcf(priv);
 	}
 	if (changed & BSS_CHANGED_BASIC_RATES) {
-		if (dev->conf.chandef.chan->band == IEEE80211_BAND_5GHZ)
+		if (dev->conf.chandef.chan->band == NL80211_BAND_5GHZ)
 			priv->basic_rate_mask = (info->basic_rates << 4);
 		else
 			priv->basic_rate_mask = info->basic_rates;
@@ -829,7 +829,7 @@ void p54_free_common(struct ieee80211_hw *dev)
 	struct p54_common *priv = dev->priv;
 	unsigned int i;
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+	for (i = 0; i < NUM_NL80211_BANDS; i++)
 		kfree(priv->band_table[i]);
 
 	kfree(priv->iq_autocal);
diff --git a/drivers/net/wireless/intersil/p54/p54.h b/drivers/net/wireless/intersil/p54/p54.h
index 40b401ed6845..529939e611cd 100644
--- a/drivers/net/wireless/intersil/p54/p54.h
+++ b/drivers/net/wireless/intersil/p54/p54.h
@@ -223,7 +223,7 @@ struct p54_common {
 	struct p54_cal_database *curve_data;
 	struct p54_cal_database *output_limit;
 	struct p54_cal_database *rssi_db;
-	struct ieee80211_supported_band *band_table[IEEE80211_NUM_BANDS];
+	struct ieee80211_supported_band *band_table[NUM_NL80211_BANDS];
 
 	/* BBP/MAC state */
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/wireless/intersil/p54/txrx.c b/drivers/net/wireless/intersil/p54/txrx.c
index 24e5ff9a9272..1af7da0b386e 100644
--- a/drivers/net/wireless/intersil/p54/txrx.c
+++ b/drivers/net/wireless/intersil/p54/txrx.c
@@ -353,7 +353,7 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 	rx_status->signal = p54_rssi_to_dbm(priv, hdr->rssi);
 	if (hdr->rate & 0x10)
 		rx_status->flag |= RX_FLAG_SHORTPRE;
-	if (priv->hw->conf.chandef.chan->band == IEEE80211_BAND_5GHZ)
+	if (priv->hw->conf.chandef.chan->band == NL80211_BAND_5GHZ)
 		rx_status->rate_idx = (rate < 4) ? 0 : rate - 4;
 	else
 		rx_status->rate_idx = rate;
@@ -867,7 +867,7 @@ void p54_tx_80211(struct ieee80211_hw *dev,
 	for (i = 0; i < nrates && ridx < 8; i++) {
 		/* we register the rates in perfect order */
 		rate = info->control.rates[i].idx;
-		if (info->band == IEEE80211_BAND_5GHZ)
+		if (info->band == NL80211_BAND_5GHZ)
 			rate += 4;
 
 		/* store the count we actually calculated for TX status */
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2b185feb1aa0..c757f14c4c00 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -255,14 +255,14 @@ static struct class *hwsim_class;
 static struct net_device *hwsim_mon; /* global monitor netdev */
 
 #define CHAN2G(_freq)  { \
-	.band = IEEE80211_BAND_2GHZ, \
+	.band = NL80211_BAND_2GHZ, \
 	.center_freq = (_freq), \
 	.hw_value = (_freq), \
 	.max_power = 20, \
 }
 
 #define CHAN5G(_freq) { \
-	.band = IEEE80211_BAND_5GHZ, \
+	.band = NL80211_BAND_5GHZ, \
 	.center_freq = (_freq), \
 	.hw_value = (_freq), \
 	.max_power = 20, \
@@ -479,7 +479,7 @@ struct mac80211_hwsim_data {
 	struct list_head list;
 	struct ieee80211_hw *hw;
 	struct device *dev;
-	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
+	struct ieee80211_supported_band bands[NUM_NL80211_BANDS];
 	struct ieee80211_channel channels_2ghz[ARRAY_SIZE(hwsim_channels_2ghz)];
 	struct ieee80211_channel channels_5ghz[ARRAY_SIZE(hwsim_channels_5ghz)];
 	struct ieee80211_rate rates[ARRAY_SIZE(hwsim_rates)];
@@ -2347,7 +2347,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	u8 addr[ETH_ALEN];
 	struct mac80211_hwsim_data *data;
 	struct ieee80211_hw *hw;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
 	int idx;
 
@@ -2476,16 +2476,16 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		sizeof(hwsim_channels_5ghz));
 	memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
 
-	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = NL80211_BAND_2GHZ; band < NUM_NL80211_BANDS; band++) {
 		struct ieee80211_supported_band *sband = &data->bands[band];
 		switch (band) {
-		case IEEE80211_BAND_2GHZ:
+		case NL80211_BAND_2GHZ:
 			sband->channels = data->channels_2ghz;
 			sband->n_channels = ARRAY_SIZE(hwsim_channels_2ghz);
 			sband->bitrates = data->rates;
 			sband->n_bitrates = ARRAY_SIZE(hwsim_rates);
 			break;
-		case IEEE80211_BAND_5GHZ:
+		case NL80211_BAND_5GHZ:
 			sband->channels = data->channels_5ghz;
 			sband->n_channels = ARRAY_SIZE(hwsim_channels_5ghz);
 			sband->bitrates = data->rates + 4;
diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 2eea76a340b7..776b44bfd93a 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -23,7 +23,7 @@
 
 
 #define CHAN2G(_channel, _freq, _flags) {        \
-	.band             = IEEE80211_BAND_2GHZ, \
+	.band             = NL80211_BAND_2GHZ, \
 	.center_freq      = (_freq),             \
 	.hw_value         = (_channel),          \
 	.flags            = (_flags),            \
@@ -639,7 +639,7 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 		if (chan_no != -1) {
 			struct wiphy *wiphy = priv->wdev->wiphy;
 			int freq = ieee80211_channel_to_frequency(chan_no,
-							IEEE80211_BAND_2GHZ);
+							NL80211_BAND_2GHZ);
 			struct ieee80211_channel *channel =
 				ieee80211_get_channel(wiphy, freq);
 
@@ -1266,7 +1266,7 @@ _new_connect_scan_req(struct wiphy *wiphy, struct cfg80211_connect_params *sme)
 {
 	struct cfg80211_scan_request *creq = NULL;
 	int i, n_channels = ieee80211_get_num_supported_channels(wiphy);
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	creq = kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
 		       n_channels * sizeof(void *),
@@ -1281,7 +1281,7 @@ _new_connect_scan_req(struct wiphy *wiphy, struct cfg80211_connect_params *sme)
 
 	/* Scan all available channels */
 	i = 0;
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		int j;
 
 		if (!wiphy->bands[band])
@@ -2200,7 +2200,7 @@ int lbs_cfg_register(struct lbs_private *priv)
 	if (lbs_mesh_activated(priv))
 		wdev->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MESH_POINT);
 
-	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &lbs_band_2ghz;
+	wdev->wiphy->bands[NL80211_BAND_2GHZ] = &lbs_band_2ghz;
 
 	/*
 	 * We could check priv->fwcapinfo && FW_CAPINFO_WPA, but I have
diff --git a/drivers/net/wireless/marvell/libertas/cmd.c b/drivers/net/wireless/marvell/libertas/cmd.c
index 4ddd0e5a6b85..301170cccfff 100644
--- a/drivers/net/wireless/marvell/libertas/cmd.c
+++ b/drivers/net/wireless/marvell/libertas/cmd.c
@@ -743,7 +743,7 @@ int lbs_set_11d_domain_info(struct lbs_private *priv)
 	struct cmd_ds_802_11d_domain_info cmd;
 	struct mrvl_ie_domain_param_set *domain = &cmd.domain;
 	struct ieee80211_country_ie_triplet *t;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_channel *ch;
 	u8 num_triplet = 0;
 	u8 num_parsed_chan = 0;
@@ -777,7 +777,7 @@ int lbs_set_11d_domain_info(struct lbs_private *priv)
 	 * etc.
 	 */
 	for (band = 0;
-	     (band < IEEE80211_NUM_BANDS) && (num_triplet < MAX_11D_TRIPLETS);
+	     (band < NUM_NL80211_BANDS) && (num_triplet < MAX_11D_TRIPLETS);
 	     band++) {
 
 		if (!bands[band])
diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/net/wireless/marvell/libertas_tf/main.c
index a47f0acc099a..0bf8916a02cf 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -570,7 +570,7 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
 	if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK)))
 		stats.flag |= RX_FLAG_FAILED_FCS_CRC;
 	stats.freq = priv->cur_freq;
-	stats.band = IEEE80211_BAND_2GHZ;
+	stats.band = NL80211_BAND_2GHZ;
 	stats.signal = prxpd->snr;
 	priv->noise = prxpd->nf;
 	/* Marvell rate index has a hole at value 4 */
@@ -642,7 +642,7 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
 	priv->band.bitrates = priv->rates;
 	priv->band.n_channels = ARRAY_SIZE(lbtf_channels);
 	priv->band.channels = priv->channels;
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+	hw->wiphy->bands[NL80211_BAND_2GHZ] = &priv->band;
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 49661e087811..6db202fa7157 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -474,7 +474,7 @@ int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 	u8 no_of_parsed_chan = 0;
 	u8 first_chan = 0, next_chan = 0, max_pwr = 0;
 	u8 i, flag = 0;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
@@ -1410,7 +1410,7 @@ mwifiex_cfg80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct mwifiex_chan_stats *pchan_stats = priv->adapter->chan_stats;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	mwifiex_dbg(priv->adapter, DUMP, "dump_survey idx=%d\n", idx);
 
@@ -1586,7 +1586,7 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	if (!priv->media_connected) {
@@ -1600,11 +1600,11 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 	memset(bitmap_rates, 0, sizeof(bitmap_rates));
 
 	/* Fill HR/DSSS rates. */
-	if (band == IEEE80211_BAND_2GHZ)
+	if (band == NL80211_BAND_2GHZ)
 		bitmap_rates[0] = mask->control[band].legacy & 0x000f;
 
 	/* Fill OFDM rates */
-	if (band == IEEE80211_BAND_2GHZ)
+	if (band == NL80211_BAND_2GHZ)
 		bitmap_rates[1] = (mask->control[band].legacy & 0x0ff0) >> 4;
 	else
 		bitmap_rates[1] = mask->control[band].legacy;
@@ -1771,7 +1771,7 @@ mwifiex_cfg80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
 	} else {
 		struct ieee80211_sta_ht_cap *ht_info;
 		int rx_mcs_supp;
-		enum ieee80211_band band;
+		enum nl80211_band band;
 
 		if ((tx_ant == 0x1 && rx_ant == 0x1)) {
 			adapter->user_dev_mcs_support = HT_STREAM_1X1;
@@ -1785,7 +1785,7 @@ mwifiex_cfg80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
 						MWIFIEX_11AC_MCS_MAP_2X2;
 		}
 
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		for (band = 0; band < NUM_NL80211_BANDS; band++) {
 			if (!adapter->wiphy->bands[band])
 				continue;
 
@@ -1997,7 +1997,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 	struct cfg80211_bss *bss;
 	int ie_len;
 	u8 ie_buf[IEEE80211_MAX_SSID_LEN + sizeof(struct ieee_types_header)];
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	if (mwifiex_get_bss_info(priv, &bss_info))
 		return -1;
@@ -2271,7 +2271,7 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 	int index = 0, i;
 	u8 config_bands = 0;
 
-	if (params->chandef.chan->band == IEEE80211_BAND_2GHZ) {
+	if (params->chandef.chan->band == NL80211_BAND_2GHZ) {
 		if (!params->basic_rates) {
 			config_bands = BAND_B | BAND_G;
 		} else {
@@ -2859,18 +2859,18 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	mwifiex_init_priv_params(priv, dev);
 	priv->netdev = dev;
 
-	mwifiex_setup_ht_caps(&wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap, priv);
+	mwifiex_setup_ht_caps(&wiphy->bands[NL80211_BAND_2GHZ]->ht_cap, priv);
 	if (adapter->is_hw_11ac_capable)
 		mwifiex_setup_vht_caps(
-			&wiphy->bands[IEEE80211_BAND_2GHZ]->vht_cap, priv);
+			&wiphy->bands[NL80211_BAND_2GHZ]->vht_cap, priv);
 
 	if (adapter->config_bands & BAND_A)
 		mwifiex_setup_ht_caps(
-			&wiphy->bands[IEEE80211_BAND_5GHZ]->ht_cap, priv);
+			&wiphy->bands[NL80211_BAND_5GHZ]->ht_cap, priv);
 
 	if ((adapter->config_bands & BAND_A) && adapter->is_hw_11ac_capable)
 		mwifiex_setup_vht_caps(
-			&wiphy->bands[IEEE80211_BAND_5GHZ]->vht_cap, priv);
+			&wiphy->bands[NL80211_BAND_5GHZ]->vht_cap, priv);
 
 	dev_net_set(dev, wiphy_net(wiphy));
 	dev->ieee80211_ptr = &priv->wdev;
@@ -3821,7 +3821,7 @@ static int mwifiex_cfg80211_get_channel(struct wiphy *wiphy,
 	struct ieee80211_channel *chan;
 	u8 second_chan_offset;
 	enum nl80211_channel_type chan_type;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	int freq;
 	int ret = -ENODATA;
 
@@ -4053,11 +4053,11 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 				 BIT(NL80211_IFTYPE_P2P_GO) |
 				 BIT(NL80211_IFTYPE_AP);
 
-	wiphy->bands[IEEE80211_BAND_2GHZ] = &mwifiex_band_2ghz;
+	wiphy->bands[NL80211_BAND_2GHZ] = &mwifiex_band_2ghz;
 	if (adapter->config_bands & BAND_A)
-		wiphy->bands[IEEE80211_BAND_5GHZ] = &mwifiex_band_5ghz;
+		wiphy->bands[NL80211_BAND_5GHZ] = &mwifiex_band_5ghz;
 	else
-		wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
+		wiphy->bands[NL80211_BAND_5GHZ] = NULL;
 
 	if (adapter->drcs_enabled && ISSUPP_DRCS_ENABLED(adapter->fw_cap_info))
 		wiphy->iface_combinations = &mwifiex_iface_comb_ap_sta_drcs;
diff --git a/drivers/net/wireless/marvell/mwifiex/cfp.c b/drivers/net/wireless/marvell/mwifiex/cfp.c
index 09fae27140f7..1ff22055e54f 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfp.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfp.c
@@ -322,9 +322,9 @@ mwifiex_get_cfp(struct mwifiex_private *priv, u8 band, u16 channel, u32 freq)
 		return cfp;
 
 	if (mwifiex_band_to_radio_type(band) == HostCmd_SCAN_RADIO_TYPE_BG)
-		sband = priv->wdev.wiphy->bands[IEEE80211_BAND_2GHZ];
+		sband = priv->wdev.wiphy->bands[NL80211_BAND_2GHZ];
 	else
-		sband = priv->wdev.wiphy->bands[IEEE80211_BAND_5GHZ];
+		sband = priv->wdev.wiphy->bands[NL80211_BAND_5GHZ];
 
 	if (!sband) {
 		mwifiex_dbg(priv->adapter, ERROR,
@@ -399,15 +399,15 @@ u32 mwifiex_get_rates_from_cfg80211(struct mwifiex_private *priv,
 	int i;
 
 	if (radio_type) {
-		sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+		sband = wiphy->bands[NL80211_BAND_5GHZ];
 		if (WARN_ON_ONCE(!sband))
 			return 0;
-		rate_mask = request->rates[IEEE80211_BAND_5GHZ];
+		rate_mask = request->rates[NL80211_BAND_5GHZ];
 	} else {
-		sband = wiphy->bands[IEEE80211_BAND_2GHZ];
+		sband = wiphy->bands[NL80211_BAND_2GHZ];
 		if (WARN_ON_ONCE(!sband))
 			return 0;
-		rate_mask = request->rates[IEEE80211_BAND_2GHZ];
+		rate_mask = request->rates[NL80211_BAND_2GHZ];
 	}
 
 	num_rates = 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 489f7a911a83..624b0a95c64e 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -494,13 +494,13 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 							*scan_chan_list,
 				 u8 filtered_scan)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int chan_idx = 0, i;
 
-	for (band = 0; (band < IEEE80211_NUM_BANDS) ; band++) {
+	for (band = 0; (band < NUM_NL80211_BANDS) ; band++) {
 
 		if (!priv->wdev.wiphy->bands[band])
 			continue;
@@ -557,13 +557,13 @@ mwifiex_bgscan_create_channel_list(struct mwifiex_private *priv,
 				   struct mwifiex_chan_scan_param_set
 						*scan_chan_list)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int chan_idx = 0, i;
 
-	for (band = 0; (band < IEEE80211_NUM_BANDS); band++) {
+	for (band = 0; (band < NUM_NL80211_BANDS); band++) {
 		if (!priv->wdev.wiphy->bands[band])
 			continue;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index 92ce32f5bb13..f79d00d1e294 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -816,7 +816,7 @@ void mwifiex_uap_set_channel(struct mwifiex_private *priv,
 						     chandef.chan->center_freq);
 
 	/* Set appropriate bands */
-	if (chandef.chan->band == IEEE80211_BAND_2GHZ) {
+	if (chandef.chan->band == NL80211_BAND_2GHZ) {
 		bss_cfg->band_cfg = BAND_CONFIG_BG;
 		config_bands = BAND_B | BAND_G;
 
diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 088429d0a634..b1b400b59d86 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -346,20 +346,20 @@ struct mwl8k_sta {
 #define MWL8K_STA(_sta) ((struct mwl8k_sta *)&((_sta)->drv_priv))
 
 static const struct ieee80211_channel mwl8k_channels_24[] = {
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2412, .hw_value = 1, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2417, .hw_value = 2, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2422, .hw_value = 3, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2427, .hw_value = 4, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2432, .hw_value = 5, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2437, .hw_value = 6, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2442, .hw_value = 7, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2447, .hw_value = 8, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2452, .hw_value = 9, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2457, .hw_value = 10, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2462, .hw_value = 11, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2467, .hw_value = 12, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2472, .hw_value = 13, },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2484, .hw_value = 14, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2412, .hw_value = 1, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2417, .hw_value = 2, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2422, .hw_value = 3, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2427, .hw_value = 4, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2432, .hw_value = 5, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2437, .hw_value = 6, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2442, .hw_value = 7, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2447, .hw_value = 8, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2452, .hw_value = 9, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2457, .hw_value = 10, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2462, .hw_value = 11, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2467, .hw_value = 12, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2472, .hw_value = 13, },
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2484, .hw_value = 14, },
 };
 
 static const struct ieee80211_rate mwl8k_rates_24[] = {
@@ -379,10 +379,10 @@ static const struct ieee80211_rate mwl8k_rates_24[] = {
 };
 
 static const struct ieee80211_channel mwl8k_channels_50[] = {
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5180, .hw_value = 36, },
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5200, .hw_value = 40, },
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5220, .hw_value = 44, },
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5240, .hw_value = 48, },
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5180, .hw_value = 36, },
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5200, .hw_value = 40, },
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5220, .hw_value = 44, },
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5240, .hw_value = 48, },
 };
 
 static const struct ieee80211_rate mwl8k_rates_50[] = {
@@ -1010,11 +1010,11 @@ mwl8k_rxd_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 	}
 
 	if (rxd->channel > 14) {
-		status->band = IEEE80211_BAND_5GHZ;
+		status->band = NL80211_BAND_5GHZ;
 		if (!(status->flag & RX_FLAG_HT))
 			status->rate_idx -= 5;
 	} else {
-		status->band = IEEE80211_BAND_2GHZ;
+		status->band = NL80211_BAND_2GHZ;
 	}
 	status->freq = ieee80211_channel_to_frequency(rxd->channel,
 						      status->band);
@@ -1118,11 +1118,11 @@ mwl8k_rxd_sta_process(void *_rxd, struct ieee80211_rx_status *status,
 		status->flag |= RX_FLAG_HT;
 
 	if (rxd->channel > 14) {
-		status->band = IEEE80211_BAND_5GHZ;
+		status->band = NL80211_BAND_5GHZ;
 		if (!(status->flag & RX_FLAG_HT))
 			status->rate_idx -= 5;
 	} else {
-		status->band = IEEE80211_BAND_2GHZ;
+		status->band = NL80211_BAND_2GHZ;
 	}
 	status->freq = ieee80211_channel_to_frequency(rxd->channel,
 						      status->band);
@@ -2300,13 +2300,13 @@ static void mwl8k_setup_2ghz_band(struct ieee80211_hw *hw)
 	BUILD_BUG_ON(sizeof(priv->rates_24) != sizeof(mwl8k_rates_24));
 	memcpy(priv->rates_24, mwl8k_rates_24, sizeof(mwl8k_rates_24));
 
-	priv->band_24.band = IEEE80211_BAND_2GHZ;
+	priv->band_24.band = NL80211_BAND_2GHZ;
 	priv->band_24.channels = priv->channels_24;
 	priv->band_24.n_channels = ARRAY_SIZE(mwl8k_channels_24);
 	priv->band_24.bitrates = priv->rates_24;
 	priv->band_24.n_bitrates = ARRAY_SIZE(mwl8k_rates_24);
 
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band_24;
+	hw->wiphy->bands[NL80211_BAND_2GHZ] = &priv->band_24;
 }
 
 static void mwl8k_setup_5ghz_band(struct ieee80211_hw *hw)
@@ -2319,13 +2319,13 @@ static void mwl8k_setup_5ghz_band(struct ieee80211_hw *hw)
 	BUILD_BUG_ON(sizeof(priv->rates_50) != sizeof(mwl8k_rates_50));
 	memcpy(priv->rates_50, mwl8k_rates_50, sizeof(mwl8k_rates_50));
 
-	priv->band_50.band = IEEE80211_BAND_5GHZ;
+	priv->band_50.band = NL80211_BAND_5GHZ;
 	priv->band_50.channels = priv->channels_50;
 	priv->band_50.n_channels = ARRAY_SIZE(mwl8k_channels_50);
 	priv->band_50.bitrates = priv->rates_50;
 	priv->band_50.n_bitrates = ARRAY_SIZE(mwl8k_rates_50);
 
-	hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &priv->band_50;
+	hw->wiphy->bands[NL80211_BAND_5GHZ] = &priv->band_50;
 }
 
 /*
@@ -2876,9 +2876,9 @@ static int mwl8k_cmd_tx_power(struct ieee80211_hw *hw,
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->action = cpu_to_le16(MWL8K_CMD_SET_LIST);
 
-	if (channel->band == IEEE80211_BAND_2GHZ)
+	if (channel->band == NL80211_BAND_2GHZ)
 		cmd->band = cpu_to_le16(0x1);
-	else if (channel->band == IEEE80211_BAND_5GHZ)
+	else if (channel->band == NL80211_BAND_5GHZ)
 		cmd->band = cpu_to_le16(0x4);
 
 	cmd->channel = cpu_to_le16(channel->hw_value);
@@ -3067,7 +3067,7 @@ static int freq_to_idx(struct mwl8k_priv *priv, int freq)
 	struct ieee80211_supported_band *sband;
 	int band, ch, idx = 0;
 
-	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = NL80211_BAND_2GHZ; band < NUM_NL80211_BANDS; band++) {
 		sband = priv->hw->wiphy->bands[band];
 		if (!sband)
 			continue;
@@ -3149,9 +3149,9 @@ static int mwl8k_cmd_set_rf_channel(struct ieee80211_hw *hw,
 	cmd->action = cpu_to_le16(MWL8K_CMD_SET);
 	cmd->current_channel = channel->hw_value;
 
-	if (channel->band == IEEE80211_BAND_2GHZ)
+	if (channel->band == NL80211_BAND_2GHZ)
 		cmd->channel_flags |= cpu_to_le32(0x00000001);
-	else if (channel->band == IEEE80211_BAND_5GHZ)
+	else if (channel->band == NL80211_BAND_5GHZ)
 		cmd->channel_flags |= cpu_to_le32(0x00000004);
 
 	if (!priv->sw_scan_start) {
@@ -4094,10 +4094,10 @@ static int mwl8k_cmd_set_new_stn_add(struct ieee80211_hw *hw,
 	memcpy(cmd->mac_addr, sta->addr, ETH_ALEN);
 	cmd->stn_id = cpu_to_le16(sta->aid);
 	cmd->action = cpu_to_le16(MWL8K_STA_ACTION_ADD);
-	if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
-		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
+	if (hw->conf.chandef.chan->band == NL80211_BAND_2GHZ)
+		rates = sta->supp_rates[NL80211_BAND_2GHZ];
 	else
-		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+		rates = sta->supp_rates[NL80211_BAND_5GHZ] << 5;
 	cmd->legacy_rates = cpu_to_le32(rates);
 	if (sta->ht_cap.ht_supported) {
 		cmd->ht_rates[0] = sta->ht_cap.mcs.rx_mask[0];
@@ -4529,10 +4529,10 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	p->ht_caps = cpu_to_le16(sta->ht_cap.cap);
 	p->extended_ht_caps = (sta->ht_cap.ampdu_factor & 3) |
 		((sta->ht_cap.ampdu_density & 7) << 2);
-	if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
-		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
+	if (hw->conf.chandef.chan->band == NL80211_BAND_2GHZ)
+		rates = sta->supp_rates[NL80211_BAND_2GHZ];
 	else
-		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+		rates = sta->supp_rates[NL80211_BAND_5GHZ] << 5;
 	legacy_rate_mask_to_array(p->legacy_rates, rates);
 	memcpy(p->ht_rates, sta->ht_cap.mcs.rx_mask, 16);
 	p->interop = 1;
@@ -5010,11 +5010,11 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			goto out;
 		}
 
-		if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ) {
-			ap_legacy_rates = ap->supp_rates[IEEE80211_BAND_2GHZ];
+		if (hw->conf.chandef.chan->band == NL80211_BAND_2GHZ) {
+			ap_legacy_rates = ap->supp_rates[NL80211_BAND_2GHZ];
 		} else {
 			ap_legacy_rates =
-				ap->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+				ap->supp_rates[NL80211_BAND_5GHZ] << 5;
 		}
 		memcpy(ap_mcs_rates, ap->ht_cap.mcs.rx_mask, 16);
 
@@ -5042,7 +5042,7 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 					idx--;
 
 				if (hw->conf.chandef.chan->band ==
-				    IEEE80211_BAND_2GHZ)
+				    NL80211_BAND_2GHZ)
 					rate = mwl8k_rates_24[idx].hw_value;
 				else
 					rate = mwl8k_rates_50[idx].hw_value;
@@ -5116,7 +5116,7 @@ mwl8k_bss_info_changed_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		if (idx)
 			idx--;
 
-		if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
+		if (hw->conf.chandef.chan->band == NL80211_BAND_2GHZ)
 			rate = mwl8k_rates_24[idx].hw_value;
 		else
 			rate = mwl8k_rates_50[idx].hw_value;
@@ -5388,7 +5388,7 @@ static int mwl8k_get_survey(struct ieee80211_hw *hw, int idx,
 	struct ieee80211_supported_band *sband;
 
 	if (priv->ap_fw) {
-		sband = hw->wiphy->bands[IEEE80211_BAND_2GHZ];
+		sband = hw->wiphy->bands[NL80211_BAND_2GHZ];
 
 		if (sband && idx >= sband->n_channels) {
 			idx -= sband->n_channels;
@@ -5396,7 +5396,7 @@ static int mwl8k_get_survey(struct ieee80211_hw *hw, int idx,
 		}
 
 		if (!sband)
-			sband = hw->wiphy->bands[IEEE80211_BAND_5GHZ];
+			sband = hw->wiphy->bands[NL80211_BAND_5GHZ];
 
 		if (!sband || idx >= sband->n_channels)
 			return -ENOENT;
diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index 26190fd33407..8fa78d7156be 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -469,7 +469,7 @@ struct mt7601u_dev *mt7601u_alloc_device(struct device *pdev)
 }
 
 #define CHAN2G(_idx, _freq) {			\
-	.band = IEEE80211_BAND_2GHZ,		\
+	.band = NL80211_BAND_2GHZ,		\
 	.center_freq = (_freq),			\
 	.hw_value = (_idx),			\
 	.max_power = 30,			\
@@ -563,7 +563,7 @@ mt76_init_sband_2g(struct mt7601u_dev *dev)
 {
 	dev->sband_2g = devm_kzalloc(dev->dev, sizeof(*dev->sband_2g),
 				     GFP_KERNEL);
-	dev->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = dev->sband_2g;
+	dev->hw->wiphy->bands[NL80211_BAND_2GHZ] = dev->sband_2g;
 
 	WARN_ON(dev->ee->reg.start - 1 + dev->ee->reg.num >
 		ARRAY_SIZE(mt76_channels_2ghz));
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 7fa0128de7e3..c36fa4e03fb6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -777,7 +777,7 @@ static int rt2800_agc_to_rssi(struct rt2x00_dev *rt2x00dev, u32 rxwi_w2)
 	u8 offset1;
 	u8 offset2;
 
-	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG, &eeprom);
 		offset0 = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG_OFFSET0);
 		offset1 = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG_OFFSET1);
@@ -1174,7 +1174,7 @@ static void rt2800_brightness_set(struct led_classdev *led_cdev,
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
 	unsigned int enabled = brightness != LED_OFF;
 	unsigned int bg_mode =
-	    (enabled && led->rt2x00dev->curr_band == IEEE80211_BAND_2GHZ);
+	    (enabled && led->rt2x00dev->curr_band == NL80211_BAND_2GHZ);
 	unsigned int polarity =
 		rt2x00_get_field16(led->rt2x00dev->led_mcu_reg,
 				   EEPROM_FREQ_LED_POLARITY);
@@ -1741,7 +1741,7 @@ static void rt2800_config_3572bt_ant(struct rt2x00_dev *rt2x00dev)
 	u8 led_ctrl, led_g_mode, led_r_mode;
 
 	rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
-	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
 		rt2x00_set_field32(&reg, GPIO_SWITCH_0, 1);
 		rt2x00_set_field32(&reg, GPIO_SWITCH_1, 1);
 	} else {
@@ -1844,7 +1844,7 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 		    rt2x00_has_cap_bt_coexist(rt2x00dev)) {
 			rt2x00_set_field8(&r3, BBP3_RX_ADC, 1);
 			rt2x00_set_field8(&r3, BBP3_RX_ANTENNA,
-				rt2x00dev->curr_band == IEEE80211_BAND_5GHZ);
+				rt2x00dev->curr_band == NL80211_BAND_5GHZ);
 			rt2800_set_ant_diversity(rt2x00dev, ANTENNA_B);
 		} else {
 			rt2x00_set_field8(&r3, BBP3_RX_ANTENNA, 1);
@@ -3451,7 +3451,7 @@ static int rt2800_get_gain_calibration_delta(struct rt2x00_dev *rt2x00dev)
 	 * Matching Delta value   -4   -3   -2   -1    0   +1   +2   +3   +4
 	 * Example TSSI bounds  0xF0 0xD0 0xB5 0xA0 0x88 0x45 0x25 0x15 0x00
 	 */
-	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rt2800_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_BG1, &eeprom);
 		tssi_bounds[0] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_BG1_MINUS4);
@@ -3546,7 +3546,7 @@ static int rt2800_get_gain_calibration_delta(struct rt2x00_dev *rt2x00dev)
 }
 
 static int rt2800_get_txpower_bw_comp(struct rt2x00_dev *rt2x00dev,
-				      enum ieee80211_band band)
+				      enum nl80211_band band)
 {
 	u16 eeprom;
 	u8 comp_en;
@@ -3562,7 +3562,7 @@ static int rt2800_get_txpower_bw_comp(struct rt2x00_dev *rt2x00dev,
 	    !test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
 		return 0;
 
-	if (band == IEEE80211_BAND_2GHZ) {
+	if (band == NL80211_BAND_2GHZ) {
 		comp_en = rt2x00_get_field16(eeprom,
 				 EEPROM_TXPOWER_DELTA_ENABLE_2G);
 		if (comp_en) {
@@ -3611,7 +3611,7 @@ static int rt2800_get_txpower_reg_delta(struct rt2x00_dev *rt2x00dev,
 }
 
 static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
-				   enum ieee80211_band band, int power_level,
+				   enum nl80211_band band, int power_level,
 				   u8 txpower, int delta)
 {
 	u16 eeprom;
@@ -3639,7 +3639,7 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 		rt2800_eeprom_read(rt2x00dev, EEPROM_EIRP_MAX_TX_POWER,
 				   &eeprom);
 
-		if (band == IEEE80211_BAND_2GHZ)
+		if (band == NL80211_BAND_2GHZ)
 			eirp_txpower_criterion = rt2x00_get_field16(eeprom,
 						 EEPROM_EIRP_MAX_TX_POWER_2GHZ);
 		else
@@ -3686,7 +3686,7 @@ static void rt2800_config_txpower_rt3593(struct rt2x00_dev *rt2x00dev,
 	u16 eeprom;
 	u32 regs[TX_PWR_CFG_IDX_COUNT];
 	unsigned int offset;
-	enum ieee80211_band band = chan->band;
+	enum nl80211_band band = chan->band;
 	int delta;
 	int i;
 
@@ -3697,7 +3697,7 @@ static void rt2800_config_txpower_rt3593(struct rt2x00_dev *rt2x00dev,
 	/* calculate temperature compensation delta */
 	delta = rt2800_get_gain_calibration_delta(rt2x00dev);
 
-	if (band == IEEE80211_BAND_5GHZ)
+	if (band == NL80211_BAND_5GHZ)
 		offset = 16;
 	else
 		offset = 0;
@@ -4055,7 +4055,7 @@ static void rt2800_config_txpower_rt3593(struct rt2x00_dev *rt2x00dev,
 	for (i = 0; i < TX_PWR_CFG_IDX_COUNT; i++)
 		rt2x00_dbg(rt2x00dev,
 			   "band:%cGHz, BW:%c0MHz, TX_PWR_CFG_%d%s = %08lx\n",
-			   (band == IEEE80211_BAND_5GHZ) ? '5' : '2',
+			   (band == NL80211_BAND_5GHZ) ? '5' : '2',
 			   (test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags)) ?
 								'4' : '2',
 			   (i > TX_PWR_CFG_9_IDX) ?
@@ -4081,7 +4081,7 @@ static void rt2800_config_txpower_rt28xx(struct rt2x00_dev *rt2x00dev,
 	u16 eeprom;
 	u32 reg, offset;
 	int i, is_rate_b, delta, power_ctrl;
-	enum ieee80211_band band = chan->band;
+	enum nl80211_band band = chan->band;
 
 	/*
 	 * Calculate HT40 compensation. For 40MHz we need to add or subtract
@@ -4436,7 +4436,7 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 {
 	u8 vgc;
 
-	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
 		    rt2x00_rt(rt2x00dev, RT3071) ||
 		    rt2x00_rt(rt2x00dev, RT3090) ||
@@ -4511,7 +4511,7 @@ void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 	case RT3572:
 	case RT3593:
 		if (qual->rssi > -65) {
-			if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ)
+			if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 				vgc += 0x20;
 			else
 				vgc += 0x10;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 3dacede7da5e..f68d492129c6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -753,8 +753,8 @@ struct rt2x00_dev {
 	 * IEEE80211 control structure.
 	 */
 	struct ieee80211_hw *hw;
-	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
-	enum ieee80211_band curr_band;
+	struct ieee80211_supported_band bands[NUM_NL80211_BANDS];
+	enum nl80211_band curr_band;
 	int curr_freq;
 
 	/*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index b2f7c586045d..4e0c5653054b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -911,7 +911,7 @@ static void rt2x00lib_channel(struct ieee80211_channel *entry,
 			      const int value)
 {
 	/* XXX: this assumption about the band is wrong for 802.11j */
-	entry->band = channel <= 14 ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+	entry->band = channel <= 14 ? NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
 	entry->center_freq = ieee80211_channel_to_frequency(channel,
 							    entry->band);
 	entry->hw_value = value;
@@ -975,13 +975,13 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	 * Channels: 2.4 GHz
 	 */
 	if (spec->supported_bands & SUPPORT_BAND_2GHZ) {
-		rt2x00dev->bands[IEEE80211_BAND_2GHZ].n_channels = 14;
-		rt2x00dev->bands[IEEE80211_BAND_2GHZ].n_bitrates = num_rates;
-		rt2x00dev->bands[IEEE80211_BAND_2GHZ].channels = channels;
-		rt2x00dev->bands[IEEE80211_BAND_2GHZ].bitrates = rates;
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-		    &rt2x00dev->bands[IEEE80211_BAND_2GHZ];
-		memcpy(&rt2x00dev->bands[IEEE80211_BAND_2GHZ].ht_cap,
+		rt2x00dev->bands[NL80211_BAND_2GHZ].n_channels = 14;
+		rt2x00dev->bands[NL80211_BAND_2GHZ].n_bitrates = num_rates;
+		rt2x00dev->bands[NL80211_BAND_2GHZ].channels = channels;
+		rt2x00dev->bands[NL80211_BAND_2GHZ].bitrates = rates;
+		hw->wiphy->bands[NL80211_BAND_2GHZ] =
+		    &rt2x00dev->bands[NL80211_BAND_2GHZ];
+		memcpy(&rt2x00dev->bands[NL80211_BAND_2GHZ].ht_cap,
 		       &spec->ht, sizeof(spec->ht));
 	}
 
@@ -991,15 +991,15 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	 * Channels: OFDM, UNII, HiperLAN2.
 	 */
 	if (spec->supported_bands & SUPPORT_BAND_5GHZ) {
-		rt2x00dev->bands[IEEE80211_BAND_5GHZ].n_channels =
+		rt2x00dev->bands[NL80211_BAND_5GHZ].n_channels =
 		    spec->num_channels - 14;
-		rt2x00dev->bands[IEEE80211_BAND_5GHZ].n_bitrates =
+		rt2x00dev->bands[NL80211_BAND_5GHZ].n_bitrates =
 		    num_rates - 4;
-		rt2x00dev->bands[IEEE80211_BAND_5GHZ].channels = &channels[14];
-		rt2x00dev->bands[IEEE80211_BAND_5GHZ].bitrates = &rates[4];
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-		    &rt2x00dev->bands[IEEE80211_BAND_5GHZ];
-		memcpy(&rt2x00dev->bands[IEEE80211_BAND_5GHZ].ht_cap,
+		rt2x00dev->bands[NL80211_BAND_5GHZ].channels = &channels[14];
+		rt2x00dev->bands[NL80211_BAND_5GHZ].bitrates = &rates[4];
+		hw->wiphy->bands[NL80211_BAND_5GHZ] =
+		    &rt2x00dev->bands[NL80211_BAND_5GHZ];
+		memcpy(&rt2x00dev->bands[NL80211_BAND_5GHZ].ht_cap,
 		       &spec->ht, sizeof(spec->ht));
 	}
 
@@ -1016,11 +1016,11 @@ static void rt2x00lib_remove_hw(struct rt2x00_dev *rt2x00dev)
 	if (test_bit(DEVICE_STATE_REGISTERED_HW, &rt2x00dev->flags))
 		ieee80211_unregister_hw(rt2x00dev->hw);
 
-	if (likely(rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_2GHZ])) {
-		kfree(rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_2GHZ]->channels);
-		kfree(rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_2GHZ]->bitrates);
-		rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = NULL;
-		rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
+	if (likely(rt2x00dev->hw->wiphy->bands[NL80211_BAND_2GHZ])) {
+		kfree(rt2x00dev->hw->wiphy->bands[NL80211_BAND_2GHZ]->channels);
+		kfree(rt2x00dev->hw->wiphy->bands[NL80211_BAND_2GHZ]->bitrates);
+		rt2x00dev->hw->wiphy->bands[NL80211_BAND_2GHZ] = NULL;
+		rt2x00dev->hw->wiphy->bands[NL80211_BAND_5GHZ] = NULL;
 	}
 
 	kfree(rt2x00dev->spec.channels_info);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index 24a3436ef952..03013eb2f642 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -252,9 +252,9 @@ static void rt61pci_brightness_set(struct led_classdev *led_cdev,
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
 	unsigned int enabled = brightness != LED_OFF;
 	unsigned int a_mode =
-	    (enabled && led->rt2x00dev->curr_band == IEEE80211_BAND_5GHZ);
+	    (enabled && led->rt2x00dev->curr_band == NL80211_BAND_5GHZ);
 	unsigned int bg_mode =
-	    (enabled && led->rt2x00dev->curr_band == IEEE80211_BAND_2GHZ);
+	    (enabled && led->rt2x00dev->curr_band == NL80211_BAND_2GHZ);
 
 	if (led->type == LED_TYPE_RADIO) {
 		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
@@ -643,12 +643,12 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 2);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-				  (rt2x00dev->curr_band != IEEE80211_BAND_5GHZ));
+				  (rt2x00dev->curr_band != NL80211_BAND_5GHZ));
 		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-		if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ)
+		if (rt2x00dev->curr_band == NL80211_BAND_5GHZ)
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
 		else
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
@@ -657,7 +657,7 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	default:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-		if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ)
+		if (rt2x00dev->curr_band == NL80211_BAND_5GHZ)
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		else
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
@@ -808,7 +808,7 @@ static void rt61pci_config_ant(struct rt2x00_dev *rt2x00dev,
 	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
 	       ant->tx == ANTENNA_SW_DIVERSITY);
 
-	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
 		sel = antenna_sel_a;
 		lna = rt2x00_has_cap_external_lna_a(rt2x00dev);
 	} else {
@@ -822,9 +822,9 @@ static void rt61pci_config_ant(struct rt2x00_dev *rt2x00dev,
 	rt2x00mmio_register_read(rt2x00dev, PHY_CSR0, &reg);
 
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG,
-			   rt2x00dev->curr_band == IEEE80211_BAND_2GHZ);
+			   rt2x00dev->curr_band == NL80211_BAND_2GHZ);
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A,
-			   rt2x00dev->curr_band == IEEE80211_BAND_5GHZ);
+			   rt2x00dev->curr_band == NL80211_BAND_5GHZ);
 
 	rt2x00mmio_register_write(rt2x00dev, PHY_CSR0, reg);
 
@@ -846,7 +846,7 @@ static void rt61pci_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	u16 eeprom;
 	short lna_gain = 0;
 
-	if (libconf->conf->chandef.chan->band == IEEE80211_BAND_2GHZ) {
+	if (libconf->conf->chandef.chan->band == NL80211_BAND_2GHZ) {
 		if (rt2x00_has_cap_external_lna_bg(rt2x00dev))
 			lna_gain += 14;
 
@@ -1048,7 +1048,7 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Determine r17 bounds.
 	 */
-	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
 		low_bound = 0x28;
 		up_bound = 0x48;
 		if (rt2x00_has_cap_external_lna_a(rt2x00dev)) {
@@ -2077,7 +2077,7 @@ static int rt61pci_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 		return 0;
 	}
 
-	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
 		if (lna == 3 || lna == 2)
 			offset += 10;
 	}
diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
index 7bbc86931168..c1397a6d3cee 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
@@ -197,9 +197,9 @@ static void rt73usb_brightness_set(struct led_classdev *led_cdev,
 	   container_of(led_cdev, struct rt2x00_led, led_dev);
 	unsigned int enabled = brightness != LED_OFF;
 	unsigned int a_mode =
-	    (enabled && led->rt2x00dev->curr_band == IEEE80211_BAND_5GHZ);
+	    (enabled && led->rt2x00dev->curr_band == NL80211_BAND_5GHZ);
 	unsigned int bg_mode =
-	    (enabled && led->rt2x00dev->curr_band == IEEE80211_BAND_2GHZ);
+	    (enabled && led->rt2x00dev->curr_band == NL80211_BAND_2GHZ);
 
 	if (led->type == LED_TYPE_RADIO) {
 		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
@@ -593,13 +593,13 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 2);
 		temp = !rt2x00_has_cap_frame_type(rt2x00dev) &&
-		       (rt2x00dev->curr_band != IEEE80211_BAND_5GHZ);
+		       (rt2x00dev->curr_band != NL80211_BAND_5GHZ);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, temp);
 		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-		if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ)
+		if (rt2x00dev->curr_band == NL80211_BAND_5GHZ)
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
 		else
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
@@ -608,7 +608,7 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	default:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-		if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ)
+		if (rt2x00dev->curr_band == NL80211_BAND_5GHZ)
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		else
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
@@ -704,7 +704,7 @@ static void rt73usb_config_ant(struct rt2x00_dev *rt2x00dev,
 	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
 	       ant->tx == ANTENNA_SW_DIVERSITY);
 
-	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
 		sel = antenna_sel_a;
 		lna = rt2x00_has_cap_external_lna_a(rt2x00dev);
 	} else {
@@ -718,9 +718,9 @@ static void rt73usb_config_ant(struct rt2x00_dev *rt2x00dev,
 	rt2x00usb_register_read(rt2x00dev, PHY_CSR0, &reg);
 
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG,
-			   (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ));
+			   (rt2x00dev->curr_band == NL80211_BAND_2GHZ));
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A,
-			   (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ));
+			   (rt2x00dev->curr_band == NL80211_BAND_5GHZ));
 
 	rt2x00usb_register_write(rt2x00dev, PHY_CSR0, reg);
 
@@ -736,7 +736,7 @@ static void rt73usb_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	u16 eeprom;
 	short lna_gain = 0;
 
-	if (libconf->conf->chandef.chan->band == IEEE80211_BAND_2GHZ) {
+	if (libconf->conf->chandef.chan->band == NL80211_BAND_2GHZ) {
 		if (rt2x00_has_cap_external_lna_bg(rt2x00dev))
 			lna_gain += 14;
 
@@ -923,7 +923,7 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Determine r17 bounds.
 	 */
-	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
 		low_bound = 0x28;
 		up_bound = 0x48;
 
@@ -1657,7 +1657,7 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 		return 0;
 	}
 
-	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
 		if (rt2x00_has_cap_external_lna_a(rt2x00dev)) {
 			if (lna == 3 || lna == 2)
 				offset += 10;
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index c76af5d8b8e0..ba242d0160ec 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -526,7 +526,7 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 		 * ieee80211_generic_frame_duration
 		 */
 		duration = ieee80211_generic_frame_duration(dev, priv->vif,
-					IEEE80211_BAND_2GHZ, skb->len,
+					NL80211_BAND_2GHZ, skb->len,
 					ieee80211_get_tx_rate(dev, info));
 
 		frame_duration =  priv->ack_time + le16_to_cpu(duration);
@@ -1529,7 +1529,7 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
 		priv->ack_time =
 			le16_to_cpu(ieee80211_generic_frame_duration(dev,
 					priv->vif,
-					IEEE80211_BAND_2GHZ, 10,
+					NL80211_BAND_2GHZ, 10,
 					&priv->rates[0])) - 10;
 
 		rtl8180_conf_erp(dev, info);
@@ -1795,12 +1795,12 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	memcpy(priv->channels, rtl818x_channels, sizeof(rtl818x_channels));
 	memcpy(priv->rates, rtl818x_rates, sizeof(rtl818x_rates));
 
-	priv->band.band = IEEE80211_BAND_2GHZ;
+	priv->band.band = NL80211_BAND_2GHZ;
 	priv->band.channels = priv->channels;
 	priv->band.n_channels = ARRAY_SIZE(rtl818x_channels);
 	priv->band.bitrates = priv->rates;
 	priv->band.n_bitrates = 4;
-	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+	dev->wiphy->bands[NL80211_BAND_2GHZ] = &priv->band;
 
 	ieee80211_hw_set(dev, HOST_BROADCAST_PS_BUFFERING);
 	ieee80211_hw_set(dev, RX_INCLUDES_FCS);
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index b7f72f9c7988..231f84db9ab0 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -1470,12 +1470,12 @@ static int rtl8187_probe(struct usb_interface *intf,
 	memcpy(priv->rates, rtl818x_rates, sizeof(rtl818x_rates));
 	priv->map = (struct rtl818x_csr *)0xFF00;
 
-	priv->band.band = IEEE80211_BAND_2GHZ;
+	priv->band.band = NL80211_BAND_2GHZ;
 	priv->band.channels = priv->channels;
 	priv->band.n_channels = ARRAY_SIZE(rtl818x_channels);
 	priv->band.bitrates = priv->rates;
 	priv->band.n_bitrates = ARRAY_SIZE(rtl818x_rates);
-	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+	dev->wiphy->bands[NL80211_BAND_2GHZ] = &priv->band;
 
 
 	ieee80211_hw_set(dev, RX_INCLUDES_FCS);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 333addd3d46a..db8433a9efe2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -91,33 +91,33 @@ static struct ieee80211_rate rtl8xxxu_rates[] = {
 };
 
 static struct ieee80211_channel rtl8xxxu_channels_2g[] = {
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2412,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2412,
 	  .hw_value = 1, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2417,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2417,
 	  .hw_value = 2, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2422,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2422,
 	  .hw_value = 3, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2427,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2427,
 	  .hw_value = 4, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2432,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2432,
 	  .hw_value = 5, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2437,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2437,
 	  .hw_value = 6, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2442,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2442,
 	  .hw_value = 7, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2447,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2447,
 	  .hw_value = 8, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2452,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2452,
 	  .hw_value = 9, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2457,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2457,
 	  .hw_value = 10, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2462,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2462,
 	  .hw_value = 11, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2467,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2467,
 	  .hw_value = 12, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2472,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2472,
 	  .hw_value = 13, .max_power = 30 },
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2484,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2484,
 	  .hw_value = 14, .max_power = 30 }
 };
 
@@ -8378,7 +8378,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 		dev_info(&udev->dev, "Enabling HT_20_40 on the 2.4GHz band\n");
 		sband->ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 	}
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+	hw->wiphy->bands[NL80211_BAND_2GHZ] = sband;
 
 	hw->wiphy->rts_threshold = 2347;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 0517a4f2d3f2..c74eb139bfa1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -131,7 +131,7 @@ static struct ieee80211_rate rtl_ratetable_5g[] = {
 };
 
 static const struct ieee80211_supported_band rtl_band_2ghz = {
-	.band = IEEE80211_BAND_2GHZ,
+	.band = NL80211_BAND_2GHZ,
 
 	.channels = rtl_channeltable_2g,
 	.n_channels = ARRAY_SIZE(rtl_channeltable_2g),
@@ -143,7 +143,7 @@ static const struct ieee80211_supported_band rtl_band_2ghz = {
 };
 
 static struct ieee80211_supported_band rtl_band_5ghz = {
-	.band = IEEE80211_BAND_5GHZ,
+	.band = NL80211_BAND_5GHZ,
 
 	.channels = rtl_channeltable_5g,
 	.n_channels = ARRAY_SIZE(rtl_channeltable_5g),
@@ -197,7 +197,7 @@ static void _rtl_init_hw_ht_capab(struct ieee80211_hw *hw,
 
 	ht_cap->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 
-	/*hw->wiphy->bands[IEEE80211_BAND_2GHZ]
+	/*hw->wiphy->bands[NL80211_BAND_2GHZ]
 	 *base on ant_num
 	 *rx_mask: RX mask
 	 *if rx_ant = 1 rx_mask[0]= 0xff;==>MCS0-MCS7
@@ -328,26 +328,26 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	    rtlhal->bandset == BAND_ON_BOTH) {
 		/* 1: 2.4 G bands */
 		/* <1> use  mac->bands as mem for hw->wiphy->bands */
-		sband = &(rtlmac->bands[IEEE80211_BAND_2GHZ]);
+		sband = &(rtlmac->bands[NL80211_BAND_2GHZ]);
 
-		/* <2> set hw->wiphy->bands[IEEE80211_BAND_2GHZ]
+		/* <2> set hw->wiphy->bands[NL80211_BAND_2GHZ]
 		 * to default value(1T1R) */
-		memcpy(&(rtlmac->bands[IEEE80211_BAND_2GHZ]), &rtl_band_2ghz,
+		memcpy(&(rtlmac->bands[NL80211_BAND_2GHZ]), &rtl_band_2ghz,
 				sizeof(struct ieee80211_supported_band));
 
 		/* <3> init ht cap base on ant_num */
 		_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
 
 		/* <4> set mac->sband to wiphy->sband */
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+		hw->wiphy->bands[NL80211_BAND_2GHZ] = sband;
 
 		/* 2: 5 G bands */
 		/* <1> use  mac->bands as mem for hw->wiphy->bands */
-		sband = &(rtlmac->bands[IEEE80211_BAND_5GHZ]);
+		sband = &(rtlmac->bands[NL80211_BAND_5GHZ]);
 
-		/* <2> set hw->wiphy->bands[IEEE80211_BAND_5GHZ]
+		/* <2> set hw->wiphy->bands[NL80211_BAND_5GHZ]
 		 * to default value(1T1R) */
-		memcpy(&(rtlmac->bands[IEEE80211_BAND_5GHZ]), &rtl_band_5ghz,
+		memcpy(&(rtlmac->bands[NL80211_BAND_5GHZ]), &rtl_band_5ghz,
 				sizeof(struct ieee80211_supported_band));
 
 		/* <3> init ht cap base on ant_num */
@@ -355,15 +355,15 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 
 		_rtl_init_hw_vht_capab(hw, &sband->vht_cap);
 		/* <4> set mac->sband to wiphy->sband */
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
+		hw->wiphy->bands[NL80211_BAND_5GHZ] = sband;
 	} else {
 		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
 			/* <1> use  mac->bands as mem for hw->wiphy->bands */
-			sband = &(rtlmac->bands[IEEE80211_BAND_2GHZ]);
+			sband = &(rtlmac->bands[NL80211_BAND_2GHZ]);
 
-			/* <2> set hw->wiphy->bands[IEEE80211_BAND_2GHZ]
+			/* <2> set hw->wiphy->bands[NL80211_BAND_2GHZ]
 			 * to default value(1T1R) */
-			memcpy(&(rtlmac->bands[IEEE80211_BAND_2GHZ]),
+			memcpy(&(rtlmac->bands[NL80211_BAND_2GHZ]),
 			       &rtl_band_2ghz,
 			       sizeof(struct ieee80211_supported_band));
 
@@ -371,14 +371,14 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 			_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
 
 			/* <4> set mac->sband to wiphy->sband */
-			hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+			hw->wiphy->bands[NL80211_BAND_2GHZ] = sband;
 		} else if (rtlhal->current_bandtype == BAND_ON_5G) {
 			/* <1> use  mac->bands as mem for hw->wiphy->bands */
-			sband = &(rtlmac->bands[IEEE80211_BAND_5GHZ]);
+			sband = &(rtlmac->bands[NL80211_BAND_5GHZ]);
 
-			/* <2> set hw->wiphy->bands[IEEE80211_BAND_5GHZ]
+			/* <2> set hw->wiphy->bands[NL80211_BAND_5GHZ]
 			 * to default value(1T1R) */
-			memcpy(&(rtlmac->bands[IEEE80211_BAND_5GHZ]),
+			memcpy(&(rtlmac->bands[NL80211_BAND_5GHZ]),
 			       &rtl_band_5ghz,
 			       sizeof(struct ieee80211_supported_band));
 
@@ -387,7 +387,7 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 
 			_rtl_init_hw_vht_capab(hw, &sband->vht_cap);
 			/* <4> set mac->sband to wiphy->sband */
-			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
+			hw->wiphy->bands[NL80211_BAND_5GHZ] = sband;
 		} else {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Err BAND %d\n",
 				 rtlhal->current_bandtype);
@@ -861,7 +861,7 @@ static u8 _rtl_get_highest_n_rate(struct ieee80211_hw *hw,
 
 /* mac80211's rate_idx is like this:
  *
- * 2.4G band:rx_status->band == IEEE80211_BAND_2GHZ
+ * 2.4G band:rx_status->band == NL80211_BAND_2GHZ
  *
  * B/G rate:
  * (rx_status->flag & RX_FLAG_HT) = 0,
@@ -871,7 +871,7 @@ static u8 _rtl_get_highest_n_rate(struct ieee80211_hw *hw,
  * (rx_status->flag & RX_FLAG_HT) = 1,
  * DESC_RATEMCS0-->DESC_RATEMCS15 ==> idx is 0-->15
  *
- * 5G band:rx_status->band == IEEE80211_BAND_5GHZ
+ * 5G band:rx_status->band == NL80211_BAND_5GHZ
  * A rate:
  * (rx_status->flag & RX_FLAG_HT) = 0,
  * DESC_RATE6M-->DESC_RATE54M ==> idx is 0-->7,
@@ -958,7 +958,7 @@ int rtlwifi_rate_mapping(struct ieee80211_hw *hw, bool isht, bool isvht,
 		return rate_idx;
 	}
 	if (false == isht) {
-		if (IEEE80211_BAND_2GHZ == hw->conf.chandef.chan->band) {
+		if (NL80211_BAND_2GHZ == hw->conf.chandef.chan->band) {
 			switch (desc_rate) {
 			case DESC_RATE1M:
 				rate_idx = 0;
diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index 5be34118e0af..3524441fd516 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -154,13 +154,13 @@ static bool _rtl_is_radar_freq(u16 center_freq)
 static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 					   enum nl80211_reg_initiator initiator)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
 	const struct ieee80211_reg_rule *reg_rule;
 	struct ieee80211_channel *ch;
 	unsigned int i;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 
 		if (!wiphy->bands[band])
 			continue;
@@ -210,9 +210,9 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	struct ieee80211_channel *ch;
 	const struct ieee80211_reg_rule *reg_rule;
 
-	if (!wiphy->bands[IEEE80211_BAND_2GHZ])
+	if (!wiphy->bands[NL80211_BAND_2GHZ])
 		return;
-	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
+	sband = wiphy->bands[NL80211_BAND_2GHZ];
 
 	/*
 	 *If no country IE has been received always enable active scan
@@ -262,10 +262,10 @@ static void _rtl_reg_apply_radar_flags(struct wiphy *wiphy)
 	struct ieee80211_channel *ch;
 	unsigned int i;
 
-	if (!wiphy->bands[IEEE80211_BAND_5GHZ])
+	if (!wiphy->bands[NL80211_BAND_5GHZ])
 		return;
 
-	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+	sband = wiphy->bands[NL80211_BAND_5GHZ];
 
 	for (i = 0; i < sband->n_channels; i++) {
 		ch = &sband->channels[i];
@@ -301,12 +301,12 @@ static void _rtl_reg_apply_world_flags(struct wiphy *wiphy,
 
 static void _rtl_dump_channel_map(struct wiphy *wiphy)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	unsigned int i;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		if (!wiphy->bands[band])
 			continue;
 		sband = wiphy->bands[band];
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 389dc47776c0..11d9c2307e2f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1359,7 +1359,7 @@ struct rtl_mac {
 	u32 tx_ss_num;
 	u32 rx_ss_num;
 
-	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
+	struct ieee80211_supported_band bands[NUM_NL80211_BANDS];
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vif;
 	enum nl80211_iftype opmode;
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index a13d1f2b5912..569918c485b4 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1291,7 +1291,7 @@ static int set_channel(struct usbnet *usbdev, int channel)
 		return 0;
 
 	dsconfig = 1000 *
-		ieee80211_channel_to_frequency(channel, IEEE80211_BAND_2GHZ);
+		ieee80211_channel_to_frequency(channel, NL80211_BAND_2GHZ);
 
 	len = sizeof(config);
 	ret = rndis_query_oid(usbdev,
@@ -3476,7 +3476,7 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	priv->band.n_channels = ARRAY_SIZE(rndis_channels);
 	priv->band.bitrates = priv->rates;
 	priv->band.n_bitrates = ARRAY_SIZE(rndis_rates);
-	wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+	wiphy->bands[NL80211_BAND_2GHZ] = &priv->band;
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
 
 	memcpy(priv->cipher_suites, rndis_cipher_suites,
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 4df992de7d07..dbb23899ddcb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -20,84 +20,84 @@
 #include "rsi_common.h"
 
 static const struct ieee80211_channel rsi_2ghz_channels[] = {
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2412,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2412,
 	  .hw_value = 1 }, /* Channel 1 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2417,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2417,
 	  .hw_value = 2 }, /* Channel 2 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2422,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2422,
 	  .hw_value = 3 }, /* Channel 3 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2427,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2427,
 	  .hw_value = 4 }, /* Channel 4 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2432,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2432,
 	  .hw_value = 5 }, /* Channel 5 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2437,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2437,
 	  .hw_value = 6 }, /* Channel 6 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2442,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2442,
 	  .hw_value = 7 }, /* Channel 7 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2447,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2447,
 	  .hw_value = 8 }, /* Channel 8 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2452,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2452,
 	  .hw_value = 9 }, /* Channel 9 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2457,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2457,
 	  .hw_value = 10 }, /* Channel 10 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2462,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2462,
 	  .hw_value = 11 }, /* Channel 11 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2467,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2467,
 	  .hw_value = 12 }, /* Channel 12 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2472,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2472,
 	  .hw_value = 13 }, /* Channel 13 */
-	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2484,
+	{ .band = NL80211_BAND_2GHZ, .center_freq = 2484,
 	  .hw_value = 14 }, /* Channel 14 */
 };
 
 static const struct ieee80211_channel rsi_5ghz_channels[] = {
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5180,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5180,
 	  .hw_value = 36,  }, /* Channel 36 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5200,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5200,
 	  .hw_value = 40, }, /* Channel 40 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5220,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5220,
 	  .hw_value = 44, }, /* Channel 44 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5240,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5240,
 	  .hw_value = 48, }, /* Channel 48 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5260,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5260,
 	  .hw_value = 52, }, /* Channel 52 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5280,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5280,
 	  .hw_value = 56, }, /* Channel 56 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5300,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5300,
 	  .hw_value = 60, }, /* Channel 60 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5320,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5320,
 	  .hw_value = 64, }, /* Channel 64 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5500,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5500,
 	  .hw_value = 100, }, /* Channel 100 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5520,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5520,
 	  .hw_value = 104, }, /* Channel 104 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5540,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5540,
 	  .hw_value = 108, }, /* Channel 108 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5560,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5560,
 	  .hw_value = 112, }, /* Channel 112 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5580,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5580,
 	  .hw_value = 116, }, /* Channel 116 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5600,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5600,
 	  .hw_value = 120, }, /* Channel 120 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5620,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5620,
 	  .hw_value = 124, }, /* Channel 124 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5640,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5640,
 	  .hw_value = 128, }, /* Channel 128 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5660,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5660,
 	  .hw_value = 132, }, /* Channel 132 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5680,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5680,
 	  .hw_value = 136, }, /* Channel 136 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5700,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5700,
 	  .hw_value = 140, }, /* Channel 140 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5745,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5745,
 	  .hw_value = 149, }, /* Channel 149 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5765,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5765,
 	  .hw_value = 153, }, /* Channel 153 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5785,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5785,
 	  .hw_value = 157, }, /* Channel 157 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5805,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5805,
 	  .hw_value = 161, }, /* Channel 161 */
-	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5825,
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5825,
 	  .hw_value = 165, }, /* Channel 165 */
 };
 
@@ -150,12 +150,12 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 	struct ieee80211_supported_band *sbands = &adapter->sbands[band];
 	void *channels = NULL;
 
-	if (band == IEEE80211_BAND_2GHZ) {
+	if (band == NL80211_BAND_2GHZ) {
 		channels = kmalloc(sizeof(rsi_2ghz_channels), GFP_KERNEL);
 		memcpy(channels,
 		       rsi_2ghz_channels,
 		       sizeof(rsi_2ghz_channels));
-		sbands->band = IEEE80211_BAND_2GHZ;
+		sbands->band = NL80211_BAND_2GHZ;
 		sbands->n_channels = ARRAY_SIZE(rsi_2ghz_channels);
 		sbands->bitrates = rsi_rates;
 		sbands->n_bitrates = ARRAY_SIZE(rsi_rates);
@@ -164,7 +164,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 		memcpy(channels,
 		       rsi_5ghz_channels,
 		       sizeof(rsi_5ghz_channels));
-		sbands->band = IEEE80211_BAND_5GHZ;
+		sbands->band = NL80211_BAND_5GHZ;
 		sbands->n_channels = ARRAY_SIZE(rsi_5ghz_channels);
 		sbands->bitrates = &rsi_rates[4];
 		sbands->n_bitrates = ARRAY_SIZE(rsi_rates) - 4;
@@ -775,7 +775,7 @@ static int rsi_mac80211_set_rate_mask(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
-	enum ieee80211_band band = hw->conf.chandef.chan->band;
+	enum nl80211_band band = hw->conf.chandef.chan->band;
 
 	mutex_lock(&common->mutex);
 	common->fixedrate_mask[band] = 0;
@@ -999,8 +999,8 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 
 	mutex_lock(&common->mutex);
 	/* Resetting all the fields to default values */
-	common->bitrate_mask[IEEE80211_BAND_2GHZ] = 0;
-	common->bitrate_mask[IEEE80211_BAND_5GHZ] = 0;
+	common->bitrate_mask[NL80211_BAND_2GHZ] = 0;
+	common->bitrate_mask[NL80211_BAND_5GHZ] = 0;
 	common->min_rate = 0xffff;
 	common->vif_info[0].is_ht = false;
 	common->vif_info[0].sgi = false;
@@ -1070,8 +1070,8 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	hw->max_rate_tries = MAX_RETRIES;
 
 	hw->max_tx_aggregation_subframes = 6;
-	rsi_register_rates_channels(adapter, IEEE80211_BAND_2GHZ);
-	rsi_register_rates_channels(adapter, IEEE80211_BAND_5GHZ);
+	rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);
+	rsi_register_rates_channels(adapter, NL80211_BAND_5GHZ);
 	hw->rate_control_algorithm = "AARF";
 
 	SET_IEEE80211_PERM_ADDR(hw, common->mac_addr);
@@ -1087,10 +1087,10 @@ int rsi_mac80211_attach(struct rsi_common *common)
 
 	wiphy->available_antennas_rx = 1;
 	wiphy->available_antennas_tx = 1;
-	wiphy->bands[IEEE80211_BAND_2GHZ] =
-		&adapter->sbands[IEEE80211_BAND_2GHZ];
-	wiphy->bands[IEEE80211_BAND_5GHZ] =
-		&adapter->sbands[IEEE80211_BAND_5GHZ];
+	wiphy->bands[NL80211_BAND_2GHZ] =
+		&adapter->sbands[NL80211_BAND_2GHZ];
+	wiphy->bands[NL80211_BAND_5GHZ] =
+		&adapter->sbands[NL80211_BAND_5GHZ];
 
 	status = ieee80211_register_hw(hw);
 	if (status)
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index e43b59d5b53b..40658b62d077 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -210,7 +210,7 @@ static u16 mcs[] = {13, 26, 39, 52, 78, 104, 117, 130};
  */
 static void rsi_set_default_parameters(struct rsi_common *common)
 {
-	common->band = IEEE80211_BAND_2GHZ;
+	common->band = NL80211_BAND_2GHZ;
 	common->channel_width = BW_20MHZ;
 	common->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 	common->channel = 1;
@@ -655,7 +655,7 @@ int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode)
 	vap_caps->rts_threshold = cpu_to_le16(common->rts_threshold);
 	vap_caps->default_mgmt_rate = cpu_to_le32(RSI_RATE_6);
 
-	if (common->band == IEEE80211_BAND_5GHZ) {
+	if (common->band == NL80211_BAND_5GHZ) {
 		vap_caps->default_ctrl_rate = cpu_to_le32(RSI_RATE_6);
 		if (conf_is_ht40(&common->priv->hw->conf)) {
 			vap_caps->default_ctrl_rate |=
@@ -872,7 +872,7 @@ int rsi_band_check(struct rsi_common *common)
 	else
 		common->channel_width = BW_40MHZ;
 
-	if (common->band == IEEE80211_BAND_2GHZ) {
+	if (common->band == NL80211_BAND_2GHZ) {
 		if (common->channel_width)
 			common->endpoint = EP_2GHZ_40MHZ;
 		else
@@ -1046,7 +1046,7 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	if (common->channel_width == BW_40MHZ)
 		auto_rate->desc_word[7] |= cpu_to_le16(1);
 
-	if (band == IEEE80211_BAND_2GHZ) {
+	if (band == NL80211_BAND_2GHZ) {
 		min_rate = RSI_RATE_1;
 		rate_table_offset = 0;
 	} else {
diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
index a0b31c0cf25b..02920c93e82d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
@@ -184,7 +184,7 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	if (wh->addr1[0] & BIT(0))
 		msg[3] |= cpu_to_le16(RSI_BROADCAST_PKT);
 
-	if (common->band == IEEE80211_BAND_2GHZ)
+	if (common->band == NL80211_BAND_2GHZ)
 		msg[4] = cpu_to_le16(RSI_11B_MODE);
 	else
 		msg[4] = cpu_to_le16((RSI_RATE_6 & 0x0f) | RSI_11G_MODE);
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 5baed945f60e..dcd095787166 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -211,7 +211,7 @@ struct rsi_hw {
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vifs[RSI_MAX_VIFS];
 	struct ieee80211_tx_queue_params edca_params[NUM_EDCA_QUEUES];
-	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
+	struct ieee80211_supported_band sbands[NUM_NL80211_BANDS];
 
 	struct device *device;
 	u8 sc_nvifs;
diff --git a/drivers/net/wireless/st/cw1200/main.c b/drivers/net/wireless/st/cw1200/main.c
index 0e51e27d2e3f..dc478cedbde0 100644
--- a/drivers/net/wireless/st/cw1200/main.c
+++ b/drivers/net/wireless/st/cw1200/main.c
@@ -102,7 +102,7 @@ static struct ieee80211_rate cw1200_mcs_rates[] = {
 
 
 #define CHAN2G(_channel, _freq, _flags) {			\
-	.band			= IEEE80211_BAND_2GHZ,		\
+	.band			= NL80211_BAND_2GHZ,		\
 	.center_freq		= (_freq),			\
 	.hw_value		= (_channel),			\
 	.flags			= (_flags),			\
@@ -111,7 +111,7 @@ static struct ieee80211_rate cw1200_mcs_rates[] = {
 }
 
 #define CHAN5G(_channel, _flags) {				\
-	.band			= IEEE80211_BAND_5GHZ,		\
+	.band			= NL80211_BAND_5GHZ,		\
 	.center_freq	= 5000 + (5 * (_channel)),		\
 	.hw_value		= (_channel),			\
 	.flags			= (_flags),			\
@@ -311,12 +311,12 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 
 	hw->sta_data_size = sizeof(struct cw1200_sta_priv);
 
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &cw1200_band_2ghz;
+	hw->wiphy->bands[NL80211_BAND_2GHZ] = &cw1200_band_2ghz;
 	if (have_5ghz)
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &cw1200_band_5ghz;
+		hw->wiphy->bands[NL80211_BAND_5GHZ] = &cw1200_band_5ghz;
 
 	/* Channel params have to be cleared before registering wiphy again */
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		struct ieee80211_supported_band *sband = hw->wiphy->bands[band];
 		if (!sband)
 			continue;
diff --git a/drivers/net/wireless/st/cw1200/scan.c b/drivers/net/wireless/st/cw1200/scan.c
index bff81b8d4164..983788156bb0 100644
--- a/drivers/net/wireless/st/cw1200/scan.c
+++ b/drivers/net/wireless/st/cw1200/scan.c
@@ -402,7 +402,7 @@ void cw1200_probe_work(struct work_struct *work)
 	}
 	wsm = (struct wsm_tx *)frame.skb->data;
 	scan.max_tx_rate = wsm->max_tx_rate;
-	scan.band = (priv->channel->band == IEEE80211_BAND_5GHZ) ?
+	scan.band = (priv->channel->band == NL80211_BAND_5GHZ) ?
 		WSM_PHY_BAND_5G : WSM_PHY_BAND_2_4G;
 	if (priv->join_status == CW1200_JOIN_STATUS_STA ||
 	    priv->join_status == CW1200_JOIN_STATUS_IBSS) {
diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index d0ddcde6c695..daf06a4f842e 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -1278,7 +1278,7 @@ static void cw1200_do_join(struct cw1200_common *priv)
 	join.dtim_period = priv->join_dtim_period;
 
 	join.channel_number = priv->channel->hw_value;
-	join.band = (priv->channel->band == IEEE80211_BAND_5GHZ) ?
+	join.band = (priv->channel->band == NL80211_BAND_5GHZ) ?
 		WSM_PHY_BAND_5G : WSM_PHY_BAND_2_4G;
 
 	memcpy(join.bssid, bssid, sizeof(join.bssid));
@@ -1462,7 +1462,7 @@ int cw1200_enable_listening(struct cw1200_common *priv)
 	};
 
 	if (priv->channel) {
-		start.band = priv->channel->band == IEEE80211_BAND_5GHZ ?
+		start.band = priv->channel->band == NL80211_BAND_5GHZ ?
 			     WSM_PHY_BAND_5G : WSM_PHY_BAND_2_4G;
 		start.channel_number = priv->channel->hw_value;
 	} else {
@@ -2315,7 +2315,7 @@ static int cw1200_start_ap(struct cw1200_common *priv)
 	struct wsm_start start = {
 		.mode = priv->vif->p2p ?
 				WSM_START_MODE_P2P_GO : WSM_START_MODE_AP,
-		.band = (priv->channel->band == IEEE80211_BAND_5GHZ) ?
+		.band = (priv->channel->band == NL80211_BAND_5GHZ) ?
 				WSM_PHY_BAND_5G : WSM_PHY_BAND_2_4G,
 		.channel_number = priv->channel->hw_value,
 		.beacon_interval = conf->beacon_int,
diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless/st/cw1200/txrx.c
index d28bd49cb5fd..3d170287cd0b 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -1079,7 +1079,7 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 
 	hdr->band = ((arg->channel_number & 0xff00) ||
 		     (arg->channel_number > 14)) ?
-			IEEE80211_BAND_5GHZ : IEEE80211_BAND_2GHZ;
+			NL80211_BAND_5GHZ : NL80211_BAND_2GHZ;
 	hdr->freq = ieee80211_channel_to_frequency(
 			arg->channel_number,
 			hdr->band);
diff --git a/drivers/net/wireless/st/cw1200/wsm.c b/drivers/net/wireless/st/cw1200/wsm.c
index 9e0ca3048657..680d60eabc75 100644
--- a/drivers/net/wireless/st/cw1200/wsm.c
+++ b/drivers/net/wireless/st/cw1200/wsm.c
@@ -849,9 +849,9 @@ static int wsm_startup_indication(struct cw1200_common *priv,
 
 	/* Disable unsupported frequency bands */
 	if (!(priv->wsm_caps.fw_cap & 0x1))
-		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = NULL;
+		priv->hw->wiphy->bands[NL80211_BAND_2GHZ] = NULL;
 	if (!(priv->wsm_caps.fw_cap & 0x2))
-		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
+		priv->hw->wiphy->bands[NL80211_BAND_5GHZ] = NULL;
 
 	priv->firmware_ready = 1;
 	wake_up(&priv->wsm_startup_done);
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index cd4777954f87..56384a4e2a35 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1482,7 +1482,7 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 					 BIT(NL80211_IFTYPE_ADHOC);
 	wl->hw->wiphy->max_scan_ssids = 1;
-	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1251_band_2ghz;
+	wl->hw->wiphy->bands[NL80211_BAND_2GHZ] = &wl1251_band_2ghz;
 
 	wl->hw->queues = 4;
 
diff --git a/drivers/net/wireless/ti/wl1251/rx.c b/drivers/net/wireless/ti/wl1251/rx.c
index cde0eaf99714..a27d4c22b6e8 100644
--- a/drivers/net/wireless/ti/wl1251/rx.c
+++ b/drivers/net/wireless/ti/wl1251/rx.c
@@ -53,7 +53,7 @@ static void wl1251_rx_status(struct wl1251 *wl,
 
 	memset(status, 0, sizeof(struct ieee80211_rx_status));
 
-	status->band = IEEE80211_BAND_2GHZ;
+	status->band = NL80211_BAND_2GHZ;
 	status->mactime = desc->timestamp;
 
 	/*
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index a0d6cccc56f3..58b9d3c3a833 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -469,8 +469,8 @@ static const u8 wl12xx_rate_to_idx_5ghz[] = {
 };
 
 static const u8 *wl12xx_band_rate_to_idx[] = {
-	[IEEE80211_BAND_2GHZ] = wl12xx_rate_to_idx_2ghz,
-	[IEEE80211_BAND_5GHZ] = wl12xx_rate_to_idx_5ghz
+	[NL80211_BAND_2GHZ] = wl12xx_rate_to_idx_2ghz,
+	[NL80211_BAND_5GHZ] = wl12xx_rate_to_idx_5ghz
 };
 
 enum wl12xx_hw_rates {
@@ -1827,8 +1827,8 @@ static int wl12xx_setup(struct wl1271 *wl)
 	wl->fw_status_priv_len = 0;
 	wl->stats.fw_stats_len = sizeof(struct wl12xx_acx_statistics);
 	wl->ofdm_only_ap = true;
-	wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ, &wl12xx_ht_cap);
-	wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ, &wl12xx_ht_cap);
+	wlcore_set_ht_cap(wl, NL80211_BAND_2GHZ, &wl12xx_ht_cap);
+	wlcore_set_ht_cap(wl, NL80211_BAND_5GHZ, &wl12xx_ht_cap);
 	wl12xx_conf_init(wl);
 
 	if (!fref_param) {
diff --git a/drivers/net/wireless/ti/wl12xx/scan.c b/drivers/net/wireless/ti/wl12xx/scan.c
index a0dfc59e9644..8d475393f9e3 100644
--- a/drivers/net/wireless/ti/wl12xx/scan.c
+++ b/drivers/net/wireless/ti/wl12xx/scan.c
@@ -27,7 +27,7 @@
 static int wl1271_get_scan_channels(struct wl1271 *wl,
 				    struct cfg80211_scan_request *req,
 				    struct basic_scan_channel_params *channels,
-				    enum ieee80211_band band, bool passive)
+				    enum nl80211_band band, bool passive)
 {
 	struct conf_scan_settings *c = &wl->conf.scan;
 	int i, j;
@@ -92,7 +92,7 @@ static int wl1271_get_scan_channels(struct wl1271 *wl,
 #define WL1271_NOTHING_TO_SCAN 1
 
 static int wl1271_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			    enum ieee80211_band band,
+			    enum nl80211_band band,
 			    bool passive, u32 basic_rate)
 {
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
@@ -144,7 +144,7 @@ static int wl1271_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	cmd->params.tid_trigger = CONF_TX_AC_ANY_TID;
 	cmd->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
 
-	if (band == IEEE80211_BAND_2GHZ)
+	if (band == NL80211_BAND_2GHZ)
 		cmd->params.band = WL1271_SCAN_BAND_2_4_GHZ;
 	else
 		cmd->params.band = WL1271_SCAN_BAND_5_GHZ;
@@ -218,7 +218,7 @@ out:
 void wl1271_scan_stm(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret = 0;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	u32 rate, mask;
 
 	switch (wl->scan.state) {
@@ -226,7 +226,7 @@ void wl1271_scan_stm(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		break;
 
 	case WL1271_SCAN_STATE_2GHZ_ACTIVE:
-		band = IEEE80211_BAND_2GHZ;
+		band = NL80211_BAND_2GHZ;
 		mask = wlvif->bitrate_masks[band];
 		if (wl->scan.req->no_cck) {
 			mask &= ~CONF_TX_CCK_RATES;
@@ -243,7 +243,7 @@ void wl1271_scan_stm(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		break;
 
 	case WL1271_SCAN_STATE_2GHZ_PASSIVE:
-		band = IEEE80211_BAND_2GHZ;
+		band = NL80211_BAND_2GHZ;
 		mask = wlvif->bitrate_masks[band];
 		if (wl->scan.req->no_cck) {
 			mask &= ~CONF_TX_CCK_RATES;
@@ -263,7 +263,7 @@ void wl1271_scan_stm(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		break;
 
 	case WL1271_SCAN_STATE_5GHZ_ACTIVE:
-		band = IEEE80211_BAND_5GHZ;
+		band = NL80211_BAND_5GHZ;
 		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
 		ret = wl1271_scan_send(wl, wlvif, band, false, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
@@ -274,7 +274,7 @@ void wl1271_scan_stm(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		break;
 
 	case WL1271_SCAN_STATE_5GHZ_PASSIVE:
-		band = IEEE80211_BAND_5GHZ;
+		band = NL80211_BAND_5GHZ;
 		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
 		ret = wl1271_scan_send(wl, wlvif, band, true, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
@@ -378,7 +378,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	wl12xx_adjust_channels(cfg, cfg_channels);
 
 	if (!force_passive && cfg->active[0]) {
-		u8 band = IEEE80211_BAND_2GHZ;
+		u8 band = NL80211_BAND_2GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
 						 wlvif->role_id, band,
 						 req->ssids[0].ssid,
@@ -395,7 +395,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	}
 
 	if (!force_passive && cfg->active[1]) {
-		u8 band = IEEE80211_BAND_5GHZ;
+		u8 band = NL80211_BAND_5GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
 						 wlvif->role_id, band,
 						 req->ssids[0].ssid,
diff --git a/drivers/net/wireless/ti/wl18xx/cmd.c b/drivers/net/wireless/ti/wl18xx/cmd.c
index a8d176ddc73c..63e95ba744fd 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.c
+++ b/drivers/net/wireless/ti/wl18xx/cmd.c
@@ -48,10 +48,10 @@ int wl18xx_cmd_channel_switch(struct wl1271 *wl,
 	cmd->stop_tx = ch_switch->block_tx;
 
 	switch (ch_switch->chandef.chan->band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		cmd->band = WLCORE_BAND_2_4GHZ;
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		cmd->band = WLCORE_BAND_5GHZ;
 		break;
 	default:
@@ -187,7 +187,7 @@ int wl18xx_cmd_set_cac(struct wl1271 *wl, struct wl12xx_vif *wlvif, bool start)
 
 	cmd->role_id = wlvif->role_id;
 	cmd->channel = wlvif->channel;
-	if (wlvif->band == IEEE80211_BAND_5GHZ)
+	if (wlvif->band == NL80211_BAND_5GHZ)
 		cmd->band = WLCORE_BAND_5GHZ;
 	cmd->bandwidth = wlcore_get_native_channel_type(wlvif->channel_type);
 
diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index ff6e46dd61f8..ef811848d141 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -64,13 +64,13 @@ static int wlcore_smart_config_sync_event(struct wl1271 *wl, u8 sync_channel,
 					  u8 sync_band)
 {
 	struct sk_buff *skb;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	int freq;
 
 	if (sync_band == WLCORE_BAND_5GHZ)
-		band = IEEE80211_BAND_5GHZ;
+		band = NL80211_BAND_5GHZ;
 	else
-		band = IEEE80211_BAND_2GHZ;
+		band = NL80211_BAND_2GHZ;
 
 	freq = ieee80211_channel_to_frequency(sync_channel, band);
 
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 1bf26cc7374e..ae47c79cb9b6 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -137,8 +137,8 @@ static const u8 wl18xx_rate_to_idx_5ghz[] = {
 };
 
 static const u8 *wl18xx_band_rate_to_idx[] = {
-	[IEEE80211_BAND_2GHZ] = wl18xx_rate_to_idx_2ghz,
-	[IEEE80211_BAND_5GHZ] = wl18xx_rate_to_idx_5ghz
+	[NL80211_BAND_2GHZ] = wl18xx_rate_to_idx_2ghz,
+	[NL80211_BAND_5GHZ] = wl18xx_rate_to_idx_5ghz
 };
 
 enum wl18xx_hw_rates {
@@ -1302,12 +1302,12 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 		wl1271_debug(DEBUG_ACX, "using wide channel rate mask");
 
 		/* sanity check - we don't support this */
-		if (WARN_ON(wlvif->band != IEEE80211_BAND_5GHZ))
+		if (WARN_ON(wlvif->band != NL80211_BAND_5GHZ))
 			return 0;
 
 		return CONF_TX_RATE_USE_WIDE_CHAN;
 	} else if (wl18xx_is_mimo_supported(wl) &&
-		   wlvif->band == IEEE80211_BAND_2GHZ) {
+		   wlvif->band == NL80211_BAND_2GHZ) {
 		wl1271_debug(DEBUG_ACX, "using MIMO rate mask");
 		/*
 		 * we don't care about HT channel here - if a peer doesn't
@@ -1996,24 +1996,24 @@ static int wl18xx_setup(struct wl1271 *wl)
 		 * siso40.
 		 */
 		if (wl18xx_is_mimo_supported(wl))
-			wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
+			wlcore_set_ht_cap(wl, NL80211_BAND_2GHZ,
 					  &wl18xx_mimo_ht_cap_2ghz);
 		else
-			wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
+			wlcore_set_ht_cap(wl, NL80211_BAND_2GHZ,
 					  &wl18xx_siso40_ht_cap_2ghz);
 
 		/* 5Ghz is always wide */
-		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
+		wlcore_set_ht_cap(wl, NL80211_BAND_5GHZ,
 				  &wl18xx_siso40_ht_cap_5ghz);
 	} else if (priv->conf.ht.mode == HT_MODE_WIDE) {
-		wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
+		wlcore_set_ht_cap(wl, NL80211_BAND_2GHZ,
 				  &wl18xx_siso40_ht_cap_2ghz);
-		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
+		wlcore_set_ht_cap(wl, NL80211_BAND_5GHZ,
 				  &wl18xx_siso40_ht_cap_5ghz);
 	} else if (priv->conf.ht.mode == HT_MODE_SISO20) {
-		wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
+		wlcore_set_ht_cap(wl, NL80211_BAND_2GHZ,
 				  &wl18xx_siso20_ht_cap);
-		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
+		wlcore_set_ht_cap(wl, NL80211_BAND_5GHZ,
 				  &wl18xx_siso20_ht_cap);
 	}
 
diff --git a/drivers/net/wireless/ti/wl18xx/scan.c b/drivers/net/wireless/ti/wl18xx/scan.c
index bc15aa2c3efa..4e5221544354 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.c
+++ b/drivers/net/wireless/ti/wl18xx/scan.c
@@ -110,7 +110,7 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	/* TODO: per-band ies? */
 	if (cmd->active[0]) {
-		u8 band = IEEE80211_BAND_2GHZ;
+		u8 band = NL80211_BAND_2GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
 				 cmd->role_id, band,
 				 req->ssids ? req->ssids[0].ssid : NULL,
@@ -127,7 +127,7 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	}
 
 	if (cmd->active[1] || cmd->dfs) {
-		u8 band = IEEE80211_BAND_5GHZ;
+		u8 band = NL80211_BAND_5GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
 				 cmd->role_id, band,
 				 req->ssids ? req->ssids[0].ssid : NULL,
@@ -253,7 +253,7 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 	cmd->terminate_on_report = 0;
 
 	if (cmd->active[0]) {
-		u8 band = IEEE80211_BAND_2GHZ;
+		u8 band = NL80211_BAND_2GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
 				 cmd->role_id, band,
 				 req->ssids ? req->ssids[0].ssid : NULL,
@@ -270,7 +270,7 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 	}
 
 	if (cmd->active[1] || cmd->dfs) {
-		u8 band = IEEE80211_BAND_5GHZ;
+		u8 band = NL80211_BAND_5GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
 				 cmd->role_id, band,
 				 req->ssids ? req->ssids[0].ssid : NULL,
diff --git a/drivers/net/wireless/ti/wl18xx/tx.c b/drivers/net/wireless/ti/wl18xx/tx.c
index 3406ffb53325..ebaf66ef3f84 100644
--- a/drivers/net/wireless/ti/wl18xx/tx.c
+++ b/drivers/net/wireless/ti/wl18xx/tx.c
@@ -43,7 +43,7 @@ void wl18xx_get_last_tx_rate(struct wl1271 *wl, struct ieee80211_vif *vif,
 
 	if (fw_rate <= CONF_HW_RATE_INDEX_54MBPS) {
 		rate->idx = fw_rate;
-		if (band == IEEE80211_BAND_5GHZ)
+		if (band == NL80211_BAND_5GHZ)
 			rate->idx -= CONF_HW_RATE_INDEX_6MBPS;
 		rate->flags = 0;
 	} else {
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index f01d24baff7c..33153565ad62 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -423,7 +423,7 @@ EXPORT_SYMBOL_GPL(wlcore_get_native_channel_type);
 
 static int wl12xx_cmd_role_start_dev(struct wl1271 *wl,
 				     struct wl12xx_vif *wlvif,
-				     enum ieee80211_band band,
+				     enum nl80211_band band,
 				     int channel)
 {
 	struct wl12xx_cmd_role_start *cmd;
@@ -438,7 +438,7 @@ static int wl12xx_cmd_role_start_dev(struct wl1271 *wl,
 	wl1271_debug(DEBUG_CMD, "cmd role start dev %d", wlvif->dev_role_id);
 
 	cmd->role_id = wlvif->dev_role_id;
-	if (band == IEEE80211_BAND_5GHZ)
+	if (band == NL80211_BAND_5GHZ)
 		cmd->band = WLCORE_BAND_5GHZ;
 	cmd->channel = channel;
 
@@ -524,7 +524,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	wl1271_debug(DEBUG_CMD, "cmd role start sta %d", wlvif->role_id);
 
 	cmd->role_id = wlvif->role_id;
-	if (wlvif->band == IEEE80211_BAND_5GHZ)
+	if (wlvif->band == NL80211_BAND_5GHZ)
 		cmd->band = WLCORE_BAND_5GHZ;
 	cmd->channel = wlvif->channel;
 	cmd->sta.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
@@ -693,10 +693,10 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->ap.local_rates = cpu_to_le32(supported_rates);
 
 	switch (wlvif->band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		cmd->band = WLCORE_BAND_2_4GHZ;
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		cmd->band = WLCORE_BAND_5GHZ;
 		break;
 	default:
@@ -773,7 +773,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	wl1271_debug(DEBUG_CMD, "cmd role start ibss %d", wlvif->role_id);
 
 	cmd->role_id = wlvif->role_id;
-	if (wlvif->band == IEEE80211_BAND_5GHZ)
+	if (wlvif->band == NL80211_BAND_5GHZ)
 		cmd->band = WLCORE_BAND_5GHZ;
 	cmd->channel = wlvif->channel;
 	cmd->ibss.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
@@ -1164,7 +1164,7 @@ int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	}
 
 	rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
-	if (band == IEEE80211_BAND_2GHZ)
+	if (band == NL80211_BAND_2GHZ)
 		ret = wl1271_cmd_template_set(wl, role_id,
 					      template_id_2_4,
 					      skb->data, skb->len, 0, rate);
@@ -1195,7 +1195,7 @@ struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 	wl1271_debug(DEBUG_SCAN, "set ap probe request template");
 
 	rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[wlvif->band]);
-	if (wlvif->band == IEEE80211_BAND_2GHZ)
+	if (wlvif->band == NL80211_BAND_2GHZ)
 		ret = wl1271_cmd_template_set(wl, wlvif->role_id,
 					      CMD_TEMPL_CFG_PROBE_REQ_2_4,
 					      skb->data, skb->len, 0, rate);
@@ -1628,19 +1628,19 @@ out:
 	return ret;
 }
 
-static int wlcore_get_reg_conf_ch_idx(enum ieee80211_band band, u16 ch)
+static int wlcore_get_reg_conf_ch_idx(enum nl80211_band band, u16 ch)
 {
 	/*
 	 * map the given band/channel to the respective predefined
 	 * bit expected by the fw
 	 */
 	switch (band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		/* channels 1..14 are mapped to 0..13 */
 		if (ch >= 1 && ch <= 14)
 			return ch - 1;
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		switch (ch) {
 		case 8 ... 16:
 			/* channels 8,12,16 are mapped to 18,19,20 */
@@ -1670,7 +1670,7 @@ static int wlcore_get_reg_conf_ch_idx(enum ieee80211_band band, u16 ch)
 }
 
 void wlcore_set_pending_regdomain_ch(struct wl1271 *wl, u16 channel,
-				     enum ieee80211_band band)
+				     enum nl80211_band band)
 {
 	int ch_bit_idx = 0;
 
@@ -1699,7 +1699,7 @@ int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
 
 	memset(tmp_ch_bitmap, 0, sizeof(tmp_ch_bitmap));
 
-	for (b = IEEE80211_BAND_2GHZ; b <= IEEE80211_BAND_5GHZ; b++) {
+	for (b = NL80211_BAND_2GHZ; b <= NL80211_BAND_5GHZ; b++) {
 		band = wiphy->bands[b];
 		for (i = 0; i < band->n_channels; i++) {
 			struct ieee80211_channel *channel = &band->channels[i];
@@ -1851,7 +1851,7 @@ out:
 }
 
 static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			  u8 role_id, enum ieee80211_band band, u8 channel)
+			  u8 role_id, enum nl80211_band band, u8 channel)
 {
 	struct wl12xx_cmd_roc *cmd;
 	int ret = 0;
@@ -1870,10 +1870,10 @@ static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	cmd->role_id = role_id;
 	cmd->channel = channel;
 	switch (band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		cmd->band = WLCORE_BAND_2_4GHZ;
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		cmd->band = WLCORE_BAND_5GHZ;
 		break;
 	default:
@@ -1925,7 +1925,7 @@ out:
 }
 
 int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id,
-	       enum ieee80211_band band, u8 channel)
+	       enum nl80211_band band, u8 channel)
 {
 	int ret = 0;
 
@@ -1995,7 +1995,7 @@ out:
 
 /* start dev role and roc on its channel */
 int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-		     enum ieee80211_band band, int channel)
+		     enum nl80211_band band, int channel)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index e28e2f2303ce..52c3b4860461 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -40,7 +40,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_stop_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-		     enum ieee80211_band band, int channel);
+		     enum nl80211_band band, int channel);
 int wl12xx_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf,
@@ -83,14 +83,14 @@ int wl1271_cmd_set_ap_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 int wl12xx_cmd_set_peer_state(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			      u8 hlid);
 int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id,
-	       enum ieee80211_band band, u8 channel);
+	       enum nl80211_band band, u8 channel);
 int wl12xx_croc(struct wl1271 *wl, u8 role_id);
 int wl12xx_cmd_add_peer(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			struct ieee80211_sta *sta, u8 hlid);
 int wl12xx_cmd_remove_peer(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			   u8 hlid);
 void wlcore_set_pending_regdomain_ch(struct wl1271 *wl, u16 channel,
-				     enum ieee80211_band band);
+				     enum nl80211_band band);
 int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl);
 int wlcore_cmd_generic_cfg(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			   u8 feature, u8 enable, u8 value);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index a872a07a484c..10fd24c28ece 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1930,7 +1930,7 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	if (test_and_clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags))
 		wlcore_enable_interrupts(wl);
 
-	wl->band = IEEE80211_BAND_2GHZ;
+	wl->band = NL80211_BAND_2GHZ;
 
 	wl->rx_counter = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
@@ -2240,8 +2240,8 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 		wlvif->rate_set = CONF_TX_ENABLED_RATES;
 	}
 
-	wlvif->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
-	wlvif->bitrate_masks[IEEE80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
+	wlvif->bitrate_masks[NL80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
+	wlvif->bitrate_masks[NL80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
 	wlvif->beacon_int = WL1271_DEFAULT_BEACON_INT;
 
 	/*
@@ -2330,7 +2330,7 @@ power_off:
 	 * 11a channels if not supported
 	 */
 	if (!wl->enable_11a)
-		wiphy->bands[IEEE80211_BAND_5GHZ]->n_channels = 0;
+		wiphy->bands[NL80211_BAND_5GHZ]->n_channels = 0;
 
 	wl1271_debug(DEBUG_MAC80211, "11a is %ssupported",
 		     wl->enable_11a ? "" : "not ");
@@ -5871,7 +5871,7 @@ static const struct ieee80211_ops wl1271_ops = {
 };
 
 
-u8 wlcore_rate_to_idx(struct wl1271 *wl, u8 rate, enum ieee80211_band band)
+u8 wlcore_rate_to_idx(struct wl1271 *wl, u8 rate, enum nl80211_band band)
 {
 	u8 idx;
 
@@ -6096,21 +6096,21 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	 * We keep local copies of the band structs because we need to
 	 * modify them on a per-device basis.
 	 */
-	memcpy(&wl->bands[IEEE80211_BAND_2GHZ], &wl1271_band_2ghz,
+	memcpy(&wl->bands[NL80211_BAND_2GHZ], &wl1271_band_2ghz,
 	       sizeof(wl1271_band_2ghz));
-	memcpy(&wl->bands[IEEE80211_BAND_2GHZ].ht_cap,
-	       &wl->ht_cap[IEEE80211_BAND_2GHZ],
+	memcpy(&wl->bands[NL80211_BAND_2GHZ].ht_cap,
+	       &wl->ht_cap[NL80211_BAND_2GHZ],
 	       sizeof(*wl->ht_cap));
-	memcpy(&wl->bands[IEEE80211_BAND_5GHZ], &wl1271_band_5ghz,
+	memcpy(&wl->bands[NL80211_BAND_5GHZ], &wl1271_band_5ghz,
 	       sizeof(wl1271_band_5ghz));
-	memcpy(&wl->bands[IEEE80211_BAND_5GHZ].ht_cap,
-	       &wl->ht_cap[IEEE80211_BAND_5GHZ],
+	memcpy(&wl->bands[NL80211_BAND_5GHZ].ht_cap,
+	       &wl->ht_cap[NL80211_BAND_5GHZ],
 	       sizeof(*wl->ht_cap));
 
-	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-		&wl->bands[IEEE80211_BAND_2GHZ];
-	wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-		&wl->bands[IEEE80211_BAND_5GHZ];
+	wl->hw->wiphy->bands[NL80211_BAND_2GHZ] =
+		&wl->bands[NL80211_BAND_2GHZ];
+	wl->hw->wiphy->bands[NL80211_BAND_5GHZ] =
+		&wl->bands[NL80211_BAND_5GHZ];
 
 	/*
 	 * allow 4 queues per mac address we support +
@@ -6205,7 +6205,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	wl->channel = 0;
 	wl->rx_counter = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
-	wl->band = IEEE80211_BAND_2GHZ;
+	wl->band = NL80211_BAND_2GHZ;
 	wl->channel_type = NL80211_CHAN_NO_HT;
 	wl->flags = 0;
 	wl->sg_enabled = true;
diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index d4420da637d8..b36133b739cb 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -202,7 +202,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		 * enable beacon early termination.
 		 * Not relevant for 5GHz and for high rates.
 		 */
-		if ((wlvif->band == IEEE80211_BAND_2GHZ) &&
+		if ((wlvif->band == NL80211_BAND_2GHZ) &&
 		    (wlvif->basic_rate < CONF_HW_BIT_RATE_9MBPS)) {
 			ret = wl1271_acx_bet_enable(wl, wlvif, true);
 			if (ret < 0)
@@ -213,7 +213,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		wl1271_debug(DEBUG_PSM, "leaving psm");
 
 		/* disable beacon early termination */
-		if ((wlvif->band == IEEE80211_BAND_2GHZ) &&
+		if ((wlvif->band == NL80211_BAND_2GHZ) &&
 		    (wlvif->basic_rate < CONF_HW_BIT_RATE_9MBPS)) {
 			ret = wl1271_acx_bet_enable(wl, wlvif, false);
 			if (ret < 0)
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 34e7e938ede4..c9bd294a0aa6 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -64,9 +64,9 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	memset(status, 0, sizeof(struct ieee80211_rx_status));
 
 	if ((desc->flags & WL1271_RX_DESC_BAND_MASK) == WL1271_RX_DESC_BAND_BG)
-		status->band = IEEE80211_BAND_2GHZ;
+		status->band = NL80211_BAND_2GHZ;
 	else
-		status->band = IEEE80211_BAND_5GHZ;
+		status->band = NL80211_BAND_5GHZ;
 
 	status->rate_idx = wlcore_rate_to_idx(wl, desc->rate, status->band);
 
diff --git a/drivers/net/wireless/ti/wlcore/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
index f5a7087cfb97..57c0565637d6 100644
--- a/drivers/net/wireless/ti/wlcore/rx.h
+++ b/drivers/net/wireless/ti/wlcore/rx.h
@@ -146,7 +146,7 @@ struct wl1271_rx_descriptor {
 } __packed;
 
 int wlcore_rx(struct wl1271 *wl, struct wl_fw_status *status);
-u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
+u8 wl1271_rate_to_idx(int rate, enum nl80211_band band);
 int wl1271_rx_filter_enable(struct wl1271 *wl,
 			    int index, bool enable,
 			    struct wl12xx_rx_filter *filter);
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index a384f3f83099..23343643207a 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -164,7 +164,7 @@ wlcore_scan_get_channels(struct wl1271 *wl,
 		struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
 		u32 delta_per_probe;
 
-		if (band == IEEE80211_BAND_5GHZ)
+		if (band == NL80211_BAND_5GHZ)
 			delta_per_probe = c->dwell_time_delta_per_probe_5;
 		else
 			delta_per_probe = c->dwell_time_delta_per_probe;
@@ -215,7 +215,7 @@ wlcore_scan_get_channels(struct wl1271 *wl,
 			channels[j].channel = req_channels[i]->hw_value;
 
 			if (n_pactive_ch &&
-			    (band == IEEE80211_BAND_2GHZ) &&
+			    (band == NL80211_BAND_2GHZ) &&
 			    (channels[j].channel >= 12) &&
 			    (channels[j].channel <= 14) &&
 			    (flags & IEEE80211_CHAN_NO_IR) &&
@@ -266,7 +266,7 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 n_channels,
 					 n_ssids,
 					 cfg->channels_2,
-					 IEEE80211_BAND_2GHZ,
+					 NL80211_BAND_2GHZ,
 					 false, true, 0,
 					 MAX_CHANNELS_2GHZ,
 					 &n_pactive_ch,
@@ -277,7 +277,7 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 n_channels,
 					 n_ssids,
 					 cfg->channels_2,
-					 IEEE80211_BAND_2GHZ,
+					 NL80211_BAND_2GHZ,
 					 false, false,
 					 cfg->passive[0],
 					 MAX_CHANNELS_2GHZ,
@@ -289,7 +289,7 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 n_channels,
 					 n_ssids,
 					 cfg->channels_5,
-					 IEEE80211_BAND_5GHZ,
+					 NL80211_BAND_5GHZ,
 					 false, true, 0,
 					 wl->max_channels_5,
 					 &n_pactive_ch,
@@ -300,7 +300,7 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 n_channels,
 					 n_ssids,
 					 cfg->channels_5,
-					 IEEE80211_BAND_5GHZ,
+					 NL80211_BAND_5GHZ,
 					 true, true,
 					 cfg->passive[1],
 					 wl->max_channels_5,
@@ -312,7 +312,7 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 n_channels,
 					 n_ssids,
 					 cfg->channels_5,
-					 IEEE80211_BAND_5GHZ,
+					 NL80211_BAND_5GHZ,
 					 false, false,
 					 cfg->passive[1] + cfg->dfs,
 					 wl->max_channels_5,
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index f0ac36139bcc..c1b8e4e9d70b 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -453,7 +453,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 }
 
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
-				enum ieee80211_band rate_band)
+				enum nl80211_band rate_band)
 {
 	struct ieee80211_supported_band *band;
 	u32 enabled_rates = 0;
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 79cb3ff8b71f..e2ba62d92d7a 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -246,9 +246,9 @@ int wlcore_tx_complete(struct wl1271 *wl);
 void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl12xx_tx_reset(struct wl1271 *wl);
 void wl1271_tx_flush(struct wl1271 *wl);
-u8 wlcore_rate_to_idx(struct wl1271 *wl, u8 rate, enum ieee80211_band band);
+u8 wlcore_rate_to_idx(struct wl1271 *wl, u8 rate, enum nl80211_band band);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
-				enum ieee80211_band rate_band);
+				enum nl80211_band rate_band);
 u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set);
 u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		      struct sk_buff *skb, struct ieee80211_sta *sta);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 72c31a8edcfb..8f28aa02230c 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -342,7 +342,7 @@ struct wl1271 {
 	struct wl12xx_vif *sched_vif;
 
 	/* The current band */
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	struct completion *elp_compl;
 	struct delayed_work elp_work;
@@ -517,7 +517,7 @@ void wlcore_update_inconn_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			      struct wl1271_station *wl_sta, bool in_conn);
 
 static inline void
-wlcore_set_ht_cap(struct wl1271 *wl, enum ieee80211_band band,
+wlcore_set_ht_cap(struct wl1271 *wl, enum nl80211_band band,
 		  struct ieee80211_sta_ht_cap *ht_cap)
 {
 	memcpy(&wl->ht_cap[band], ht_cap, sizeof(*ht_cap));
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 27c56876b2c1..5c4199f3a19a 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -392,7 +392,7 @@ struct wl12xx_vif {
 	u8 ssid_len;
 
 	/* The current band */
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	int channel;
 	enum nl80211_channel_type channel_type;
 
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index d5c371d77ddf..99de07d14939 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1454,7 +1454,7 @@ static int wl3501_get_freq(struct net_device *dev, struct iw_request_info *info,
 	struct wl3501_card *this = netdev_priv(dev);
 
 	wrqu->freq.m = 100000 *
-		ieee80211_channel_to_frequency(this->chan, IEEE80211_BAND_2GHZ);
+		ieee80211_channel_to_frequency(this->chan, NL80211_BAND_2GHZ);
 	wrqu->freq.e = 1;
 	return 0;
 }
diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
index e539d9b1b562..3e37a045f702 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
@@ -1068,7 +1068,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 	}
 
 	stats.freq = zd_channels[_zd_chip_get_channel(&mac->chip) - 1].center_freq;
-	stats.band = IEEE80211_BAND_2GHZ;
+	stats.band = NL80211_BAND_2GHZ;
 	stats.signal = zd_check_signal(hw, status->signal_strength);
 
 	rate = zd_rx_rate(buffer, status);
@@ -1395,7 +1395,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	mac->band.n_channels = ARRAY_SIZE(zd_channels);
 	mac->band.channels = mac->channels;
 
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &mac->band;
+	hw->wiphy->bands[NL80211_BAND_2GHZ] = &mac->band;
 
 	ieee80211_hw_set(hw, MFP_CAPABLE);
 	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index f4fff385aeb2..7dd1540ebedd 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -2113,10 +2113,10 @@ static int on_action_public23a(struct rtw_adapter *padapter,
 
 	if (channel <= RTW_CH_MAX_2G_CHANNEL)
 		freq = ieee80211_channel_to_frequency(channel,
-						      IEEE80211_BAND_2GHZ);
+						      NL80211_BAND_2GHZ);
 	else
 		freq = ieee80211_channel_to_frequency(channel,
-						      IEEE80211_BAND_5GHZ);
+						      NL80211_BAND_5GHZ);
 
 	if (cfg80211_rx_mgmt(padapter->rtw_wdev, freq, 0, pframe,
 			     skb->len, 0))
diff --git a/drivers/staging/rtl8723au/include/ieee80211.h b/drivers/staging/rtl8723au/include/ieee80211.h
index 3aa40a32555e..634102e1bda6 100644
--- a/drivers/staging/rtl8723au/include/ieee80211.h
+++ b/drivers/staging/rtl8723au/include/ieee80211.h
@@ -266,7 +266,7 @@ join_res:
 
 /* Represent channel details, subset of ieee80211_channel */
 struct rtw_ieee80211_channel {
-	/* enum ieee80211_band band; */
+	/* enum nl80211_band band; */
 	/* u16 center_freq; */
 	u16 hw_value;
 	u32 flags;
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index 12d18440e824..0da559d929bc 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -39,7 +39,7 @@ static const u32 rtw_cipher_suites[] = {
 }
 
 #define CHAN2G(_channel, _freq, _flags) {			\
-	.band			= IEEE80211_BAND_2GHZ,		\
+	.band			= NL80211_BAND_2GHZ,		\
 	.center_freq		= (_freq),			\
 	.hw_value		= (_channel),			\
 	.flags			= (_flags),			\
@@ -48,7 +48,7 @@ static const u32 rtw_cipher_suites[] = {
 }
 
 #define CHAN5G(_channel, _flags) {				\
-	.band			= IEEE80211_BAND_5GHZ,		\
+	.band			= NL80211_BAND_5GHZ,		\
 	.center_freq		= 5000 + (5 * (_channel)),	\
 	.hw_value		= (_channel),			\
 	.flags			= (_flags),			\
@@ -143,15 +143,15 @@ static void rtw_5g_rates_init(struct ieee80211_rate *rates)
 }
 
 static struct ieee80211_supported_band *
-rtw_spt_band_alloc(enum ieee80211_band band)
+rtw_spt_band_alloc(enum nl80211_band band)
 {
 	struct ieee80211_supported_band *spt_band = NULL;
 	int n_channels, n_bitrates;
 
-	if (band == IEEE80211_BAND_2GHZ) {
+	if (band == NL80211_BAND_2GHZ) {
 		n_channels = RTW_2G_CHANNELS_NUM;
 		n_bitrates = RTW_G_RATES_NUM;
-	} else if (band == IEEE80211_BAND_5GHZ) {
+	} else if (band == NL80211_BAND_5GHZ) {
 		n_channels = RTW_5G_CHANNELS_NUM;
 		n_bitrates = RTW_A_RATES_NUM;
 	} else {
@@ -176,10 +176,10 @@ rtw_spt_band_alloc(enum ieee80211_band band)
 	spt_band->n_channels = n_channels;
 	spt_band->n_bitrates = n_bitrates;
 
-	if (band == IEEE80211_BAND_2GHZ) {
+	if (band == NL80211_BAND_2GHZ) {
 		rtw_2g_channels_init(spt_band->channels);
 		rtw_2g_rates_init(spt_band->bitrates);
-	} else if (band == IEEE80211_BAND_5GHZ) {
+	} else if (band == NL80211_BAND_5GHZ) {
 		rtw_5g_channels_init(spt_band->channels);
 		rtw_5g_rates_init(spt_band->bitrates);
 	}
@@ -257,10 +257,10 @@ static int rtw_cfg80211_inform_bss(struct rtw_adapter *padapter,
 	channel = pnetwork->network.DSConfig;
 	if (channel <= RTW_CH_MAX_2G_CHANNEL)
 		freq = ieee80211_channel_to_frequency(channel,
-						      IEEE80211_BAND_2GHZ);
+						      NL80211_BAND_2GHZ);
 	else
 		freq = ieee80211_channel_to_frequency(channel,
-						      IEEE80211_BAND_5GHZ);
+						      NL80211_BAND_5GHZ);
 
 	notify_channel = ieee80211_get_channel(wiphy, freq);
 
@@ -322,11 +322,11 @@ void rtw_cfg80211_indicate_connect(struct rtw_adapter *padapter)
 		if (channel <= RTW_CH_MAX_2G_CHANNEL)
 			freq =
 			    ieee80211_channel_to_frequency(channel,
-							   IEEE80211_BAND_2GHZ);
+							   NL80211_BAND_2GHZ);
 		else
 			freq =
 			    ieee80211_channel_to_frequency(channel,
-							   IEEE80211_BAND_5GHZ);
+							   NL80211_BAND_5GHZ);
 
 		notify_channel = ieee80211_get_channel(wiphy, freq);
 
@@ -2360,10 +2360,10 @@ void rtw_cfg80211_indicate_sta_assoc(struct rtw_adapter *padapter,
 	channel = pmlmeext->cur_channel;
 	if (channel <= RTW_CH_MAX_2G_CHANNEL)
 		freq = ieee80211_channel_to_frequency(channel,
-						      IEEE80211_BAND_2GHZ);
+						      NL80211_BAND_2GHZ);
 	else
 		freq = ieee80211_channel_to_frequency(channel,
-						      IEEE80211_BAND_5GHZ);
+						      NL80211_BAND_5GHZ);
 
 	cfg80211_rx_mgmt(padapter->rtw_wdev, freq, 0, pmgmt_frame, frame_len,
 			 0);
@@ -2392,10 +2392,10 @@ void rtw_cfg80211_indicate_sta_disassoc(struct rtw_adapter *padapter,
 	channel = pmlmeext->cur_channel;
 	if (channel <= RTW_CH_MAX_2G_CHANNEL)
 		freq = ieee80211_channel_to_frequency(channel,
-						      IEEE80211_BAND_2GHZ);
+						      NL80211_BAND_2GHZ);
 	else
 		freq = ieee80211_channel_to_frequency(channel,
-						      IEEE80211_BAND_5GHZ);
+						      NL80211_BAND_5GHZ);
 
 	mgmt.frame_control =
 		cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_DEAUTH);
@@ -3109,7 +3109,7 @@ static struct cfg80211_ops rtw_cfg80211_ops = {
 };
 
 static void rtw_cfg80211_init_ht_capab(struct ieee80211_sta_ht_cap *ht_cap,
-				       enum ieee80211_band band, u8 rf_type)
+				       enum nl80211_band band, u8 rf_type)
 {
 
 #define MAX_BIT_RATE_40MHZ_MCS15	300	/* Mbps */
@@ -3133,7 +3133,7 @@ static void rtw_cfg80211_init_ht_capab(struct ieee80211_sta_ht_cap *ht_cap,
 	ht_cap->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 
 	/*
-	 *hw->wiphy->bands[IEEE80211_BAND_2GHZ]
+	 *hw->wiphy->bands[NL80211_BAND_2GHZ]
 	 *base on ant_num
 	 *rx_mask: RX mask
 	 *if rx_ant = 1 rx_mask[0]= 0xff;==>MCS0-MCS7
@@ -3173,19 +3173,19 @@ void rtw_cfg80211_init_wiphy(struct rtw_adapter *padapter)
 
 	/* if (padapter->registrypriv.wireless_mode & WIRELESS_11G) */
 	{
-		bands = wiphy->bands[IEEE80211_BAND_2GHZ];
+		bands = wiphy->bands[NL80211_BAND_2GHZ];
 		if (bands)
 			rtw_cfg80211_init_ht_capab(&bands->ht_cap,
-						   IEEE80211_BAND_2GHZ,
+						   NL80211_BAND_2GHZ,
 						   rf_type);
 	}
 
 	/* if (padapter->registrypriv.wireless_mode & WIRELESS_11A) */
 	{
-		bands = wiphy->bands[IEEE80211_BAND_5GHZ];
+		bands = wiphy->bands[NL80211_BAND_5GHZ];
 		if (bands)
 			rtw_cfg80211_init_ht_capab(&bands->ht_cap,
-						   IEEE80211_BAND_5GHZ,
+						   NL80211_BAND_5GHZ,
 						   rf_type);
 	}
 }
@@ -3224,11 +3224,11 @@ static void rtw_cfg80211_preinit_wiphy(struct rtw_adapter *padapter,
 	wiphy->n_cipher_suites = ARRAY_SIZE(rtw_cipher_suites);
 
 	/* if (padapter->registrypriv.wireless_mode & WIRELESS_11G) */
-	wiphy->bands[IEEE80211_BAND_2GHZ] =
-	    rtw_spt_band_alloc(IEEE80211_BAND_2GHZ);
+	wiphy->bands[NL80211_BAND_2GHZ] =
+	    rtw_spt_band_alloc(NL80211_BAND_2GHZ);
 	/* if (padapter->registrypriv.wireless_mode & WIRELESS_11A) */
-	wiphy->bands[IEEE80211_BAND_5GHZ] =
-	    rtw_spt_band_alloc(IEEE80211_BAND_5GHZ);
+	wiphy->bands[NL80211_BAND_5GHZ] =
+	    rtw_spt_band_alloc(NL80211_BAND_5GHZ);
 
 	wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	wiphy->flags |= WIPHY_FLAG_OFFCHAN_TX | WIPHY_FLAG_HAVE_AP_SME;
@@ -3313,8 +3313,8 @@ void rtw_wdev_free(struct wireless_dev *wdev)
 	if (!wdev)
 		return;
 
-	kfree(wdev->wiphy->bands[IEEE80211_BAND_2GHZ]);
-	kfree(wdev->wiphy->bands[IEEE80211_BAND_5GHZ]);
+	kfree(wdev->wiphy->bands[NL80211_BAND_2GHZ]);
+	kfree(wdev->wiphy->bands[NL80211_BAND_5GHZ]);
 
 	wiphy_free(wdev->wiphy);
 
diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index 9ac1ef9d0d51..b7d43a5622ba 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -144,7 +144,7 @@ void vnt_init_bands(struct vnt_private *priv)
 			ch[i].flags = IEEE80211_CHAN_NO_HT40;
 		}
 
-		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+		priv->hw->wiphy->bands[NL80211_BAND_5GHZ] =
 						&vnt_supported_5ghz_band;
 	/* fallthrough */
 	case RF_RFMD2959:
@@ -159,7 +159,7 @@ void vnt_init_bands(struct vnt_private *priv)
 			ch[i].flags = IEEE80211_CHAN_NO_HT40;
 		}
 
-		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+		priv->hw->wiphy->bands[NL80211_BAND_2GHZ] =
 						&vnt_supported_2ghz_band;
 		break;
 	}
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c3eea07ca97e..494164045a0f 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -812,7 +812,7 @@ static int vnt_int_report_rate(struct vnt_private *priv,
 		else if (fb_option & FIFOCTL_AUTO_FB_1)
 			tx_rate = fallback_rate1[tx_rate][retry];
 
-		if (info->band == IEEE80211_BAND_5GHZ)
+		if (info->band == NL80211_BAND_5GHZ)
 			idx = tx_rate - RATE_6M;
 		else
 			idx = tx_rate;
@@ -1290,7 +1290,7 @@ static int vnt_config(struct ieee80211_hw *hw, u32 changed)
 	    (conf->flags & IEEE80211_CONF_OFFCHANNEL)) {
 		set_channel(priv, conf->chandef.chan);
 
-		if (conf->chandef.chan->band == IEEE80211_BAND_5GHZ)
+		if (conf->chandef.chan->band == NL80211_BAND_5GHZ)
 			bb_type = BB_TYPE_11A;
 		else
 			bb_type = BB_TYPE_11G;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 1a2dda09b69d..e4c3165ae027 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1307,7 +1307,7 @@ int vnt_generate_fifo_header(struct vnt_private *priv, u32 dma_idx,
 	}
 
 	if (current_rate > RATE_11M) {
-		if (info->band == IEEE80211_BAND_5GHZ) {
+		if (info->band == NL80211_BAND_5GHZ) {
 			pkt_type = PK_TYPE_11A;
 		} else {
 			if (tx_rate->flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index a0fe288c1322..a4299f405d7f 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -153,7 +153,7 @@ void vnt_init_bands(struct vnt_private *priv)
 			ch[i].flags = IEEE80211_CHAN_NO_HT40;
 		}
 
-		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+		priv->hw->wiphy->bands[NL80211_BAND_5GHZ] =
 						&vnt_supported_5ghz_band;
 	/* fallthrough */
 	case RF_AL2230:
@@ -167,7 +167,7 @@ void vnt_init_bands(struct vnt_private *priv)
 			ch[i].flags = IEEE80211_CHAN_NO_HT40;
 		}
 
-		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+		priv->hw->wiphy->bands[NL80211_BAND_2GHZ] =
 						&vnt_supported_2ghz_band;
 		break;
 	}
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 8d05acbc0e23..73538fb4e4e2 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -97,7 +97,7 @@ static int vnt_int_report_rate(struct vnt_private *priv, u8 pkt_no, u8 tsr)
 		else if (context->fb_option == AUTO_FB_1)
 			tx_rate = fallback_rate1[tx_rate][retry];
 
-		if (info->band == IEEE80211_BAND_5GHZ)
+		if (info->band == NL80211_BAND_5GHZ)
 			idx = tx_rate - RATE_6M;
 		else
 			idx = tx_rate;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index f9afab77b79f..fc5fe4ec6d05 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -662,7 +662,7 @@ static int vnt_config(struct ieee80211_hw *hw, u32 changed)
 			(conf->flags & IEEE80211_CONF_OFFCHANNEL)) {
 		vnt_set_channel(priv, conf->chandef.chan->hw_value);
 
-		if (conf->chandef.chan->band == IEEE80211_BAND_5GHZ)
+		if (conf->chandef.chan->band == NL80211_BAND_5GHZ)
 			bb_type = BB_TYPE_11A;
 		else
 			bb_type = BB_TYPE_11G;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index b74e32001318..aa59e7f14ab3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -813,7 +813,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	}
 
 	if (current_rate > RATE_11M) {
-		if (info->band == IEEE80211_BAND_5GHZ) {
+		if (info->band == NL80211_BAND_5GHZ) {
 			pkt_type = PK_TYPE_11A;
 		} else {
 			if (tx_rate->flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 448a5c8c4514..544917d8b2df 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -102,7 +102,7 @@ static u8 op_ifcs;
 u8 wilc_initialized = 1;
 
 #define CHAN2G(_channel, _freq, _flags) {	 \
-		.band             = IEEE80211_BAND_2GHZ, \
+		.band             = NL80211_BAND_2GHZ, \
 		.center_freq      = (_freq),		 \
 		.hw_value         = (_channel),		 \
 		.flags            = (_flags),		 \
@@ -241,7 +241,7 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 			struct ieee80211_channel *channel;
 
 			if (network_info) {
-				freq = ieee80211_channel_to_frequency((s32)network_info->ch, IEEE80211_BAND_2GHZ);
+				freq = ieee80211_channel_to_frequency((s32)network_info->ch, NL80211_BAND_2GHZ);
 				channel = ieee80211_get_channel(wiphy, freq);
 
 				rssi = get_rssi_avg(network_info);
@@ -409,7 +409,7 @@ static void CfgScanResult(enum scan_event scan_event,
 				return;
 
 			if (network_info) {
-				s32Freq = ieee80211_channel_to_frequency((s32)network_info->ch, IEEE80211_BAND_2GHZ);
+				s32Freq = ieee80211_channel_to_frequency((s32)network_info->ch, NL80211_BAND_2GHZ);
 				channel = ieee80211_get_channel(wiphy, s32Freq);
 
 				if (!channel)
@@ -1451,7 +1451,7 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 			return;
 		}
 	} else {
-		s32Freq = ieee80211_channel_to_frequency(curr_channel, IEEE80211_BAND_2GHZ);
+		s32Freq = ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
 
 		if (ieee80211_is_action(buff[FRAME_TYPE_ID])) {
 			if (priv->bCfgScanning && time_after_eq(jiffies, (unsigned long)pstrWFIDrv->p2p_timeout)) {
@@ -2246,7 +2246,7 @@ static struct wireless_dev *WILC_WFI_CfgAlloc(void)
 	WILC_WFI_band_2ghz.ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K;
 	WILC_WFI_band_2ghz.ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
 
-	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &WILC_WFI_band_2ghz;
+	wdev->wiphy->bands[NL80211_BAND_2GHZ] = &WILC_WFI_band_2ghz;
 
 	return wdev;
 
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 8bad018eda47..2438cf7cc695 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -415,7 +415,7 @@ static int prism2_scan(struct wiphy *wiphy,
 		ie_len = ie_buf[1] + 2;
 		memcpy(&ie_buf[2], &(msg2.ssid.data.data), msg2.ssid.data.len);
 		freq = ieee80211_channel_to_frequency(msg2.dschannel.data,
-						      IEEE80211_BAND_2GHZ);
+						      NL80211_BAND_2GHZ);
 		bss = cfg80211_inform_bss(wiphy,
 			ieee80211_get_channel(wiphy, freq),
 			CFG80211_BSS_FTYPE_UNKNOWN,
@@ -758,9 +758,9 @@ static struct wiphy *wlan_create_wiphy(struct device *dev, wlandevice_t *wlandev
 	priv->band.n_channels = ARRAY_SIZE(prism2_channels);
 	priv->band.bitrates = priv->rates;
 	priv->band.n_bitrates = ARRAY_SIZE(prism2_rates);
-	priv->band.band = IEEE80211_BAND_2GHZ;
+	priv->band.band = NL80211_BAND_2GHZ;
 	priv->band.ht_cap.ht_supported = false;
-	wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+	wiphy->bands[NL80211_BAND_2GHZ] = &priv->band;
 
 	set_wiphy_dev(wiphy, dev);
 	wiphy->privid = prism2_wiphy_privid;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5ec20369ceb8..183916e168f1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -68,26 +68,6 @@ struct wiphy;
  */
 
 /**
- * enum ieee80211_band - supported frequency bands
- *
- * The bands are assigned this way because the supported
- * bitrates differ in these bands.
- *
- * @IEEE80211_BAND_2GHZ: 2.4GHz ISM band
- * @IEEE80211_BAND_5GHZ: around 5GHz band (4.9-5.7)
- * @IEEE80211_BAND_60GHZ: around 60 GHz band (58.32 - 64.80 GHz)
- * @IEEE80211_NUM_BANDS: number of defined bands
- */
-enum ieee80211_band {
-	IEEE80211_BAND_2GHZ = NL80211_BAND_2GHZ,
-	IEEE80211_BAND_5GHZ = NL80211_BAND_5GHZ,
-	IEEE80211_BAND_60GHZ = NL80211_BAND_60GHZ,
-
-	/* keep last */
-	IEEE80211_NUM_BANDS
-};
-
-/**
  * enum ieee80211_channel_flags - channel flags
  *
  * Channel flags set by the regulatory control code.
@@ -167,7 +147,7 @@ enum ieee80211_channel_flags {
  * @dfs_cac_ms: DFS CAC time in milliseconds, this is valid for DFS channels.
  */
 struct ieee80211_channel {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	u16 center_freq;
 	u16 hw_value;
 	u32 flags;
@@ -324,7 +304,7 @@ struct ieee80211_sta_vht_cap {
 struct ieee80211_supported_band {
 	struct ieee80211_channel *channels;
 	struct ieee80211_rate *bitrates;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	int n_channels;
 	int n_bitrates;
 	struct ieee80211_sta_ht_cap ht_cap;
@@ -1370,7 +1350,7 @@ struct mesh_setup {
 	bool user_mpm;
 	u8 dtim_period;
 	u16 beacon_interval;
-	int mcast_rate[IEEE80211_NUM_BANDS];
+	int mcast_rate[NUM_NL80211_BANDS];
 	u32 basic_rates;
 };
 
@@ -1468,7 +1448,7 @@ struct cfg80211_scan_request {
 	size_t ie_len;
 	u32 flags;
 
-	u32 rates[IEEE80211_NUM_BANDS];
+	u32 rates[NUM_NL80211_BANDS];
 
 	struct wireless_dev *wdev;
 
@@ -1860,7 +1840,7 @@ struct cfg80211_ibss_params {
 	bool privacy;
 	bool control_port;
 	bool userspace_handles_dfs;
-	int mcast_rate[IEEE80211_NUM_BANDS];
+	int mcast_rate[NUM_NL80211_BANDS];
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
 };
@@ -1872,7 +1852,7 @@ struct cfg80211_ibss_params {
  * @delta: value of RSSI level adjustment.
  */
 struct cfg80211_bss_select_adjust {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	s8 delta;
 };
 
@@ -1887,7 +1867,7 @@ struct cfg80211_bss_select_adjust {
 struct cfg80211_bss_selection {
 	enum nl80211_bss_select_attr behaviour;
 	union {
-		enum ieee80211_band band_pref;
+		enum nl80211_band band_pref;
 		struct cfg80211_bss_select_adjust adjust;
 	} param;
 };
@@ -1990,7 +1970,7 @@ struct cfg80211_bitrate_mask {
 		u8 ht_mcs[IEEE80211_HT_MCS_MASK_LEN];
 		u16 vht_mcs[NL80211_VHT_NSS_MAX];
 		enum nl80211_txrate_gi gi;
-	} control[IEEE80211_NUM_BANDS];
+	} control[NUM_NL80211_BANDS];
 };
 /**
  * struct cfg80211_pmksa - PMK Security Association
@@ -2677,7 +2657,7 @@ struct cfg80211_ops {
 	int	(*leave_ibss)(struct wiphy *wiphy, struct net_device *dev);
 
 	int	(*set_mcast_rate)(struct wiphy *wiphy, struct net_device *dev,
-				  int rate[IEEE80211_NUM_BANDS]);
+				  int rate[NUM_NL80211_BANDS]);
 
 	int	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
 
@@ -3323,7 +3303,7 @@ struct wiphy {
 	 * help determine whether you own this wiphy or not. */
 	const void *privid;
 
-	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
+	struct ieee80211_supported_band *bands[NUM_NL80211_BANDS];
 
 	/* Lets us get back the wiphy on the callback */
 	void (*reg_notifier)(struct wiphy *wiphy,
@@ -3658,7 +3638,7 @@ static inline void *wdev_priv(struct wireless_dev *wdev)
  * @band: band, necessary due to channel number overlap
  * Return: The corresponding frequency (in MHz), or 0 if the conversion failed.
  */
-int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band);
+int ieee80211_channel_to_frequency(int chan, enum nl80211_band band);
 
 /**
  * ieee80211_frequency_to_channel - convert frequency to channel number
@@ -5089,7 +5069,7 @@ void cfg80211_ch_switch_started_notify(struct net_device *dev,
  * Returns %true if the conversion was successful, %false otherwise.
  */
 bool ieee80211_operating_class_to_band(u8 operating_class,
-				       enum ieee80211_band *band);
+				       enum nl80211_band *band);
 
 /**
  * ieee80211_chandef_to_operating_class - convert chandef to operation class
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ebc5a408acc2..07ef9378df2b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -549,7 +549,7 @@ struct ieee80211_bss_conf {
 	u8 sync_dtim_count;
 	u32 basic_rates;
 	struct ieee80211_rate *beacon_rate;
-	int mcast_rate[IEEE80211_NUM_BANDS];
+	int mcast_rate[NUM_NL80211_BANDS];
 	u16 ht_operation_mode;
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
@@ -938,8 +938,8 @@ struct ieee80211_tx_info {
  * @common_ie_len: length of the common_ies
  */
 struct ieee80211_scan_ies {
-	const u8 *ies[IEEE80211_NUM_BANDS];
-	size_t len[IEEE80211_NUM_BANDS];
+	const u8 *ies[NUM_NL80211_BANDS];
+	size_t len[NUM_NL80211_BANDS];
 	const u8 *common_ies;
 	size_t common_ie_len;
 };
@@ -1754,7 +1754,7 @@ struct ieee80211_sta_rates {
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction)
  */
 struct ieee80211_sta {
-	u32 supp_rates[IEEE80211_NUM_BANDS];
+	u32 supp_rates[NUM_NL80211_BANDS];
 	u8 addr[ETH_ALEN];
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
@@ -4404,7 +4404,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
  */
 __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
-					enum ieee80211_band band,
+					enum nl80211_band band,
 					size_t frame_len,
 					struct ieee80211_rate *rate);
 
@@ -5357,7 +5357,7 @@ struct rate_control_ops {
 };
 
 static inline int rate_supported(struct ieee80211_sta *sta,
-				 enum ieee80211_band band,
+				 enum nl80211_band band,
 				 int index)
 {
 	return (sta == NULL || sta->supp_rates[band] & BIT(index));
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b4606288ef7a..1df655d8aa52 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3653,11 +3653,15 @@ enum nl80211_txrate_gi {
  * @NL80211_BAND_2GHZ: 2.4 GHz ISM band
  * @NL80211_BAND_5GHZ: around 5 GHz band (4.9 - 5.7 GHz)
  * @NL80211_BAND_60GHZ: around 60 GHz band (58.32 - 64.80 GHz)
+ * @NUM_NL80211_BANDS: number of bands, avoid using this in userspace
+ *	since newer kernel versions may support more bands
  */
 enum nl80211_band {
 	NL80211_BAND_2GHZ,
 	NL80211_BAND_5GHZ,
 	NL80211_BAND_60GHZ,
+
+	NUM_NL80211_BANDS,
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fc4730b938d0..0c12e4001f19 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1049,7 +1049,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	int ret = 0;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	enum nl80211_band band = ieee80211_get_sdata_band(sdata);
 	u32 mask, set;
 
 	sband = local->hw.wiphy->bands[band];
@@ -1848,7 +1848,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 				struct bss_parameters *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	u32 changed = 0;
 
 	if (!sdata_dereference(sdata->u.ap.beacon, sdata))
@@ -1867,7 +1867,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	}
 
 	if (!sdata->vif.bss_conf.use_short_slot &&
-	    band == IEEE80211_BAND_5GHZ) {
+	    band == NL80211_BAND_5GHZ) {
 		sdata->vif.bss_conf.use_short_slot = true;
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
@@ -2097,12 +2097,12 @@ static int ieee80211_leave_ocb(struct wiphy *wiphy, struct net_device *dev)
 }
 
 static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
-				    int rate[IEEE80211_NUM_BANDS])
+				    int rate[NUM_NL80211_BANDS])
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	memcpy(sdata->vif.bss_conf.mcast_rate, rate,
-	       sizeof(int) * IEEE80211_NUM_BANDS);
+	       sizeof(int) * NUM_NL80211_BANDS);
 
 	return 0;
 }
@@ -2507,7 +2507,7 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 			return ret;
 	}
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		struct ieee80211_supported_band *sband = wiphy->bands[i];
 		int j;
 
@@ -3135,7 +3135,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_tx_info *info;
 	struct sta_info *sta;
 	struct ieee80211_chanctx_conf *chanctx_conf;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	int ret;
 
 	/* the lock is needed to assign the cookie later */
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 37ea30e0754c..a5ba739cd2a7 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -169,21 +169,21 @@ static ssize_t ieee80211_if_write_##name(struct file *file,		\
 	IEEE80211_IF_FILE_R(name)
 
 /* common attributes */
-IEEE80211_IF_FILE(rc_rateidx_mask_2ghz, rc_rateidx_mask[IEEE80211_BAND_2GHZ],
+IEEE80211_IF_FILE(rc_rateidx_mask_2ghz, rc_rateidx_mask[NL80211_BAND_2GHZ],
 		  HEX);
-IEEE80211_IF_FILE(rc_rateidx_mask_5ghz, rc_rateidx_mask[IEEE80211_BAND_5GHZ],
+IEEE80211_IF_FILE(rc_rateidx_mask_5ghz, rc_rateidx_mask[NL80211_BAND_5GHZ],
 		  HEX);
 IEEE80211_IF_FILE(rc_rateidx_mcs_mask_2ghz,
-		  rc_rateidx_mcs_mask[IEEE80211_BAND_2GHZ], HEXARRAY);
+		  rc_rateidx_mcs_mask[NL80211_BAND_2GHZ], HEXARRAY);
 IEEE80211_IF_FILE(rc_rateidx_mcs_mask_5ghz,
-		  rc_rateidx_mcs_mask[IEEE80211_BAND_5GHZ], HEXARRAY);
+		  rc_rateidx_mcs_mask[NL80211_BAND_5GHZ], HEXARRAY);
 
 static ssize_t ieee80211_if_fmt_rc_rateidx_vht_mcs_mask_2ghz(
 				const struct ieee80211_sub_if_data *sdata,
 				char *buf, int buflen)
 {
 	int i, len = 0;
-	const u16 *mask = sdata->rc_rateidx_vht_mcs_mask[IEEE80211_BAND_2GHZ];
+	const u16 *mask = sdata->rc_rateidx_vht_mcs_mask[NL80211_BAND_2GHZ];
 
 	for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
 		len += scnprintf(buf + len, buflen - len, "%04x ", mask[i]);
@@ -199,7 +199,7 @@ static ssize_t ieee80211_if_fmt_rc_rateidx_vht_mcs_mask_5ghz(
 				char *buf, int buflen)
 {
 	int i, len = 0;
-	const u16 *mask = sdata->rc_rateidx_vht_mcs_mask[IEEE80211_BAND_5GHZ];
+	const u16 *mask = sdata->rc_rateidx_vht_mcs_mask[NL80211_BAND_5GHZ];
 
 	for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
 		len += scnprintf(buf + len, buflen - len, "%04x ", mask[i]);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index c6d4b75eb60b..a31d30713d08 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -126,7 +126,7 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (sband->band == IEEE80211_BAND_2GHZ) {
+	if (sband->band == NL80211_BAND_2GHZ) {
 		*pos++ = WLAN_EID_DS_PARAMS;
 		*pos++ = 1;
 		*pos++ = ieee80211_frequency_to_channel(
@@ -348,11 +348,11 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	 *
 	 * HT follows these specifications (IEEE 802.11-2012 20.3.18)
 	 */
-	sdata->vif.bss_conf.use_short_slot = chan->band == IEEE80211_BAND_5GHZ;
+	sdata->vif.bss_conf.use_short_slot = chan->band == NL80211_BAND_5GHZ;
 	bss_change |= BSS_CHANGED_ERP_SLOT;
 
 	/* cf. IEEE 802.11 9.2.12 */
-	if (chan->band == IEEE80211_BAND_2GHZ && have_higher_than_11mbit)
+	if (chan->band == NL80211_BAND_2GHZ && have_higher_than_11mbit)
 		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
@@ -989,7 +989,7 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_channel *channel)
 {
 	struct sta_info *sta;
-	enum ieee80211_band band = rx_status->band;
+	enum nl80211_band band = rx_status->band;
 	enum nl80211_bss_scan_width scan_width;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
@@ -1109,7 +1109,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_channel *channel;
 	u64 beacon_timestamp, rx_timestamp;
 	u32 supp_rates = 0;
-	enum ieee80211_band band = rx_status->band;
+	enum nl80211_band band = rx_status->band;
 
 	channel = ieee80211_get_channel(local->hw.wiphy, rx_status->freq);
 	if (!channel)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8857b01b82d0..9438c9406687 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -896,13 +896,13 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_if_ap *bss;
 
 	/* bitmap of allowed (non-MCS) rate indexes for rate control */
-	u32 rc_rateidx_mask[IEEE80211_NUM_BANDS];
+	u32 rc_rateidx_mask[NUM_NL80211_BANDS];
 
-	bool rc_has_mcs_mask[IEEE80211_NUM_BANDS];
-	u8  rc_rateidx_mcs_mask[IEEE80211_NUM_BANDS][IEEE80211_HT_MCS_MASK_LEN];
+	bool rc_has_mcs_mask[NUM_NL80211_BANDS];
+	u8  rc_rateidx_mcs_mask[NUM_NL80211_BANDS][IEEE80211_HT_MCS_MASK_LEN];
 
-	bool rc_has_vht_mcs_mask[IEEE80211_NUM_BANDS];
-	u16 rc_rateidx_vht_mcs_mask[IEEE80211_NUM_BANDS][NL80211_VHT_NSS_MAX];
+	bool rc_has_vht_mcs_mask[NUM_NL80211_BANDS];
+	u16 rc_rateidx_vht_mcs_mask[NUM_NL80211_BANDS][NL80211_VHT_NSS_MAX];
 
 	union {
 		struct ieee80211_if_ap ap;
@@ -957,10 +957,10 @@ sdata_assert_lock(struct ieee80211_sub_if_data *sdata)
 	lockdep_assert_held(&sdata->wdev.mtx);
 }
 
-static inline enum ieee80211_band
+static inline enum nl80211_band
 ieee80211_get_sdata_band(struct ieee80211_sub_if_data *sdata)
 {
-	enum ieee80211_band band = IEEE80211_BAND_2GHZ;
+	enum nl80211_band band = NL80211_BAND_2GHZ;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 
 	rcu_read_lock();
@@ -1231,7 +1231,7 @@ struct ieee80211_local {
 	struct cfg80211_scan_request __rcu *scan_req;
 	struct ieee80211_scan_request *hw_scan_req;
 	struct cfg80211_chan_def scan_chandef;
-	enum ieee80211_band hw_scan_band;
+	enum nl80211_band hw_scan_band;
 	int scan_channel_idx;
 	int scan_ies_len;
 	int hw_scan_ies_bufsize;
@@ -1738,10 +1738,10 @@ void ieee80211_process_mu_groups(struct ieee80211_sub_if_data *sdata,
 				 struct ieee80211_mgmt *mgmt);
 u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
                                   struct sta_info *sta, u8 opmode,
-				  enum ieee80211_band band);
+				  enum nl80211_band band);
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band);
+				 enum nl80211_band band);
 void ieee80211_apply_vhtcap_overrides(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_sta_vht_cap *vht_cap);
 void ieee80211_get_vht_mask_from_cap(__le16 vht_cap,
@@ -1769,7 +1769,7 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
  */
 int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				 struct ieee802_11_elems *elems,
-				 enum ieee80211_band current_band,
+				 enum nl80211_band current_band,
 				 u32 sta_flags, u8 *bssid,
 				 struct ieee80211_csa_ie *csa_ie);
 
@@ -1794,7 +1794,7 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 
 /* utility functions/constants */
 extern const void *const mac80211_wiphy_privid; /* for wiphy privid */
-int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
+int ieee80211_frame_duration(enum nl80211_band band, size_t len,
 			     int rate, int erp, int short_preamble,
 			     int shift);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
@@ -1804,12 +1804,12 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 
 void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb, int tid,
-				 enum ieee80211_band band);
+				 enum nl80211_band band);
 
 static inline void
 ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 			  struct sk_buff *skb, int tid,
-			  enum ieee80211_band band)
+			  enum nl80211_band band)
 {
 	rcu_read_lock();
 	__ieee80211_tx_skb_tid_band(sdata, skb, tid, band);
@@ -1964,7 +1964,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata,
 
 u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 			    struct ieee802_11_elems *elems,
-			    enum ieee80211_band band, u32 *basic_rates);
+			    enum nl80211_band band, u32 *basic_rates);
 int __ieee80211_request_smps_mgd(struct ieee80211_sub_if_data *sdata,
 				 enum ieee80211_smps_mode smps_mode);
 int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
@@ -1987,10 +1987,10 @@ int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
 			     const u8 *srates, int srates_len, u32 *rates);
 int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb, bool need_basic,
-			    enum ieee80211_band band);
+			    enum nl80211_band band);
 int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb, bool need_basic,
-				enum ieee80211_band band);
+				enum nl80211_band band);
 u8 *ieee80211_add_wmm_info_ie(u8 *buf, u8 qosinfo);
 
 /* channel management */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 097ece8b5c02..6a33f0b4d839 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1800,7 +1800,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	INIT_DELAYED_WORK(&sdata->dec_tailroom_needed_wk,
 			  ieee80211_delayed_tailroom_dec);
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		struct ieee80211_supported_band *sband;
 		sband = local->hw.wiphy->bands[i];
 		sdata->rc_rateidx_mask[i] =
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 33c80de61eca..7ee91d6151d1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -801,7 +801,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	int result, i;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	int channels, max_bitrates;
 	bool supp_ht, supp_vht;
 	netdev_features_t feature_whitelist;
@@ -874,7 +874,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	max_bitrates = 0;
 	supp_ht = false;
 	supp_vht = false;
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		struct ieee80211_supported_band *sband;
 
 		sband = local->hw.wiphy->bands[band];
@@ -936,7 +936,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (!local->int_scan_req)
 		return -ENOMEM;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		if (!local->hw.wiphy->bands[band])
 			continue;
 		local->int_scan_req->rates[band] = (u32) -1;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index dcc1facc807c..4c6404e1ad6e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -415,7 +415,7 @@ int mesh_add_ht_cap_ie(struct ieee80211_sub_if_data *sdata,
 		       struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	enum nl80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
 
@@ -478,7 +478,7 @@ int mesh_add_vht_cap_ie(struct ieee80211_sub_if_data *sdata,
 			struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	enum nl80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
 
@@ -680,7 +680,7 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct mesh_csa_settings *csa;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
 	int hdr_len = offsetof(struct ieee80211_mgmt, u.beacon) +
@@ -930,7 +930,7 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_csa_settings params;
 	struct ieee80211_csa_ie csa_ie;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	enum nl80211_band band = ieee80211_get_sdata_band(sdata);
 	int err;
 	u32 sta_flags;
 
@@ -1084,7 +1084,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_channel *channel;
 	size_t baselen;
 	int freq;
-	enum ieee80211_band band = rx_status->band;
+	enum nl80211_band band = rx_status->band;
 
 	/* ignore ProbeResp to foreign address */
 	if (stype == IEEE80211_STYPE_PROBE_RESP &&
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 563bea050383..79f2a0a13db8 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -93,18 +93,18 @@ static inline void mesh_plink_fsm_restart(struct sta_info *sta)
 static u32 mesh_set_short_slot_time(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	enum nl80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
 	struct sta_info *sta;
 	u32 erp_rates = 0, changed = 0;
 	int i;
 	bool short_slot = false;
 
-	if (band == IEEE80211_BAND_5GHZ) {
+	if (band == NL80211_BAND_5GHZ) {
 		/* (IEEE 802.11-2012 19.4.5) */
 		short_slot = true;
 		goto out;
-	} else if (band != IEEE80211_BAND_2GHZ)
+	} else if (band != NL80211_BAND_2GHZ)
 		goto out;
 
 	for (i = 0; i < sband->n_bitrates; i++)
@@ -247,7 +247,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.self_prot.action_code = action;
 
 	if (action != WLAN_SP_MESH_PEERING_CLOSE) {
-		enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+		enum nl80211_band band = ieee80211_get_sdata_band(sdata);
 
 		/* capability info */
 		pos = skb_put(skb, 2);
@@ -385,7 +385,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 			       struct ieee802_11_elems *elems, bool insert)
 {
 	struct ieee80211_local *local = sdata->local;
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	enum nl80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband;
 	u32 rates, basic_rates = 0, changed = 0;
 	enum ieee80211_sta_rx_bandwidth bw = sta->sta.bandwidth;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d3c75ac8a029..885f4ca0888d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -661,7 +661,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 	capab = WLAN_CAPABILITY_ESS;
 
-	if (sband->band == IEEE80211_BAND_2GHZ) {
+	if (sband->band == NL80211_BAND_2GHZ) {
 		capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
 		capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
@@ -1100,7 +1100,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *cbss = ifmgd->associated;
 	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
-	enum ieee80211_band current_band;
+	enum nl80211_band current_band;
 	struct ieee80211_csa_ie csa_ie;
 	struct ieee80211_channel_switch ch_switch;
 	int res;
@@ -1257,11 +1257,11 @@ ieee80211_find_80211h_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	default:
 		WARN_ON_ONCE(1);
 		/* fall through */
-	case IEEE80211_BAND_2GHZ:
-	case IEEE80211_BAND_60GHZ:
+	case NL80211_BAND_2GHZ:
+	case NL80211_BAND_60GHZ:
 		chan_increment = 1;
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		chan_increment = 4;
 		break;
 	}
@@ -1861,7 +1861,7 @@ static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 	}
 
 	use_short_slot = !!(capab & WLAN_CAPABILITY_SHORT_SLOT_TIME);
-	if (ieee80211_get_sdata_band(sdata) == IEEE80211_BAND_5GHZ)
+	if (ieee80211_get_sdata_band(sdata) == NL80211_BAND_5GHZ)
 		use_short_slot = true;
 
 	if (use_protection != bss_conf->use_cts_prot) {
@@ -4375,7 +4375,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.basic_rates = basic_rates;
 
 		/* cf. IEEE 802.11 9.2.12 */
-		if (cbss->channel->band == IEEE80211_BAND_2GHZ &&
+		if (cbss->channel->band == NL80211_BAND_2GHZ &&
 		    have_higher_than_11mbit)
 			sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 		else
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index a4e2f4e67f94..206698bc93f4 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -287,7 +287,7 @@ static void __rate_control_send_low(struct ieee80211_hw *hw,
 	u32 rate_flags =
 		ieee80211_chandef_rate_flags(&hw->conf.chandef);
 
-	if ((sband->band == IEEE80211_BAND_2GHZ) &&
+	if ((sband->band == NL80211_BAND_2GHZ) &&
 	    (info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
 		rate_flags |= IEEE80211_RATE_ERP_G;
 
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index b54f398cda5d..14c5ba3a1b1c 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -436,7 +436,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 
 
 static void
-calc_rate_durations(enum ieee80211_band band,
+calc_rate_durations(enum nl80211_band band,
 		    struct minstrel_rate *d,
 		    struct ieee80211_rate *rate,
 		    struct cfg80211_chan_def *chandef)
@@ -579,7 +579,7 @@ minstrel_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 	if (!mi)
 		return NULL;
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		sband = hw->wiphy->bands[i];
 		if (sband && sband->n_bitrates > max_rates)
 			max_rates = sband->n_bitrates;
@@ -621,7 +621,7 @@ minstrel_init_cck_rates(struct minstrel_priv *mp)
 	u32 rate_flags = ieee80211_chandef_rate_flags(&mp->hw->conf.chandef);
 	int i, j;
 
-	sband = mp->hw->wiphy->bands[IEEE80211_BAND_2GHZ];
+	sband = mp->hw->wiphy->bands[NL80211_BAND_2GHZ];
 	if (!sband)
 		return;
 
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index d77a9a842338..30fbabf4bcbc 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1137,7 +1137,7 @@ minstrel_ht_update_cck(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 {
 	int i;
 
-	if (sband->band != IEEE80211_BAND_2GHZ)
+	if (sband->band != NL80211_BAND_2GHZ)
 		return;
 
 	if (!ieee80211_hw_check(mp->hw, SUPPORTS_HT_CCK_RATES))
@@ -1335,7 +1335,7 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 	int max_rates = 0;
 	int i;
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		sband = hw->wiphy->bands[i];
 		if (sband && sband->n_bitrates > max_rates)
 			max_rates = sband->n_bitrates;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c2b659e9a9f9..c5678703921e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -322,7 +322,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	else if (status->flag & RX_FLAG_5MHZ)
 		channel_flags |= IEEE80211_CHAN_QUARTER;
 
-	if (status->band == IEEE80211_BAND_5GHZ)
+	if (status->band == NL80211_BAND_5GHZ)
 		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ;
 	else if (status->flag & (RX_FLAG_HT | RX_FLAG_VHT))
 		channel_flags |= IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ;
@@ -2823,7 +2823,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 
 		switch (mgmt->u.action.u.measurement.action_code) {
 		case WLAN_ACTION_SPCT_MSR_REQ:
-			if (status->band != IEEE80211_BAND_5GHZ)
+			if (status->band != NL80211_BAND_5GHZ)
 				break;
 
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
@@ -4043,7 +4043,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
-	if (WARN_ON(status->band >= IEEE80211_NUM_BANDS))
+	if (WARN_ON(status->band >= NUM_NL80211_BANDS))
 		goto drop;
 
 	sband = local->hw.wiphy->bands[status->band];
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 41aa728e5468..f9648ef9e31f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -272,7 +272,7 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 		n_chans = req->n_channels;
 	} else {
 		do {
-			if (local->hw_scan_band == IEEE80211_NUM_BANDS)
+			if (local->hw_scan_band == NUM_NL80211_BANDS)
 				return false;
 
 			n_chans = 0;
@@ -485,7 +485,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 	int i;
 	struct ieee80211_sub_if_data *sdata;
 	struct cfg80211_scan_request *scan_req;
-	enum ieee80211_band band = local->hw.conf.chandef.chan->band;
+	enum nl80211_band band = local->hw.conf.chandef.chan->band;
 	u32 tx_flags;
 
 	scan_req = rcu_dereference_protected(local->scan_req,
@@ -953,7 +953,7 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	int ret = -EBUSY, i, n_ch = 0;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	mutex_lock(&local->mtx);
 
@@ -965,7 +965,7 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 	if (!channels) {
 		int max_n;
 
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		for (band = 0; band < NUM_NL80211_BANDS; band++) {
 			if (!local->hw.wiphy->bands[band])
 				continue;
 
@@ -1085,7 +1085,7 @@ int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_scan_ies sched_scan_ies = {};
 	struct cfg80211_chan_def chandef;
 	int ret, i, iebufsz, num_bands = 0;
-	u32 rate_masks[IEEE80211_NUM_BANDS] = {};
+	u32 rate_masks[NUM_NL80211_BANDS] = {};
 	u8 bands_used = 0;
 	u8 *ie;
 	size_t len;
@@ -1097,7 +1097,7 @@ int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	if (!local->ops->sched_scan_start)
 		return -ENOTSUPP;
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		if (local->hw.wiphy->bands[i]) {
 			bands_used |= BIT(i);
 			rate_masks[i] = (u32) -1;
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 06e6ac8cc693..2ddc661f0988 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -23,11 +23,11 @@
 
 int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				 struct ieee802_11_elems *elems,
-				 enum ieee80211_band current_band,
+				 enum nl80211_band current_band,
 				 u32 sta_flags, u8 *bssid,
 				 struct ieee80211_csa_ie *csa_ie)
 {
-	enum ieee80211_band new_band;
+	enum nl80211_band new_band;
 	int new_freq;
 	u8 new_chan_no;
 	struct ieee80211_channel *new_chan;
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index a29ea813b7d5..1c7d45a6d93e 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -47,7 +47,7 @@ static void ieee80211_tdls_add_ext_capab(struct ieee80211_sub_if_data *sdata,
 			   NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
 	bool wider_band = ieee80211_hw_check(&local->hw, TDLS_WIDER_BW) &&
 			  !ifmgd->tdls_wider_bw_prohibited;
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	enum nl80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
 	bool vht = sband && sband->vht_cap.vht_supported;
 	u8 *pos = (void *)skb_put(skb, 10);
@@ -184,7 +184,7 @@ static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata,
 	if (status_code != 0)
 		return 0;
 
-	if (ieee80211_get_sdata_band(sdata) == IEEE80211_BAND_2GHZ) {
+	if (ieee80211_get_sdata_band(sdata) == NL80211_BAND_2GHZ) {
 		return WLAN_CAPABILITY_SHORT_SLOT_TIME |
 		       WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
@@ -357,7 +357,7 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 				   u8 action_code, bool initiator,
 				   const u8 *extra_ies, size_t extra_ies_len)
 {
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	enum nl80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sta_ht_cap ht_cap;
@@ -544,7 +544,7 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	size_t offset = 0, noffset;
 	struct sta_info *sta, *ap_sta;
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	enum nl80211_band band = ieee80211_get_sdata_band(sdata);
 	u8 *pos;
 
 	mutex_lock(&local->sta_mtx);
@@ -611,7 +611,7 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
 
 	/* only include VHT-operation if not on the 2.4GHz band */
-	if (band != IEEE80211_BAND_2GHZ && sta->sta.vht_cap.vht_supported) {
+	if (band != NL80211_BAND_2GHZ && sta->sta.vht_cap.vht_supported) {
 		/*
 		 * if both peers support WIDER_BW, we can expand the chandef to
 		 * a wider compatible one, up to 80MHz
@@ -1773,7 +1773,7 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 	u8 target_channel, oper_class;
 	bool local_initiator;
 	struct sta_info *sta;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_tdls_data *tf = (void *)skb->data;
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	int baselen = offsetof(typeof(*tf), u.chan_switch_req.variable);
@@ -1805,10 +1805,10 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 	if ((oper_class == 112 || oper_class == 2 || oper_class == 3 ||
 	     oper_class == 4 || oper_class == 5 || oper_class == 6) &&
 	     target_channel < 14)
-		band = IEEE80211_BAND_5GHZ;
+		band = NL80211_BAND_5GHZ;
 	else
-		band = target_channel < 14 ? IEEE80211_BAND_2GHZ :
-					     IEEE80211_BAND_5GHZ;
+		band = target_channel < 14 ? NL80211_BAND_2GHZ :
+					     NL80211_BAND_5GHZ;
 
 	freq = ieee80211_channel_to_frequency(target_channel, band);
 	if (freq == 0) {
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 8c3b7ae103bc..77e4c53baefb 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -401,7 +401,7 @@ TRACE_EVENT(drv_bss_info_changed,
 		__field(u32, sync_device_ts)
 		__field(u8, sync_dtim_count)
 		__field(u32, basic_rates)
-		__array(int, mcast_rate, IEEE80211_NUM_BANDS)
+		__array(int, mcast_rate, NUM_NL80211_BANDS)
 		__field(u16, ht_operation_mode)
 		__field(s32, cqm_rssi_thold);
 		__field(s32, cqm_rssi_hyst);
@@ -1265,8 +1265,8 @@ TRACE_EVENT(drv_set_bitrate_mask,
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
-		__entry->legacy_2g = mask->control[IEEE80211_BAND_2GHZ].legacy;
-		__entry->legacy_5g = mask->control[IEEE80211_BAND_5GHZ].legacy;
+		__entry->legacy_2g = mask->control[NL80211_BAND_2GHZ].legacy;
+		__entry->legacy_5g = mask->control[NL80211_BAND_5GHZ].legacy;
 	),
 
 	TP_printk(
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e04d850726c5..203044379ce0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -150,7 +150,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 			rate = DIV_ROUND_UP(r->bitrate, 1 << shift);
 
 		switch (sband->band) {
-		case IEEE80211_BAND_2GHZ: {
+		case NL80211_BAND_2GHZ: {
 			u32 flag;
 			if (tx->sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
 				flag = IEEE80211_RATE_MANDATORY_G;
@@ -160,13 +160,13 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 				mrate = r->bitrate;
 			break;
 		}
-		case IEEE80211_BAND_5GHZ:
+		case NL80211_BAND_5GHZ:
 			if (r->flags & IEEE80211_RATE_MANDATORY_A)
 				mrate = r->bitrate;
 			break;
-		case IEEE80211_BAND_60GHZ:
+		case NL80211_BAND_60GHZ:
 			/* TODO, for now fall through */
-		case IEEE80211_NUM_BANDS:
+		case NUM_NL80211_BANDS:
 			WARN_ON(1);
 			break;
 		}
@@ -2138,7 +2138,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	u16 info_id = 0;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_sub_if_data *ap_sdata;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	int ret;
 
 	if (IS_ERR(sta))
@@ -3597,7 +3597,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata = NULL;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_tx_rate_control txrc;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	int csa_off_base = 0;
@@ -4165,7 +4165,7 @@ EXPORT_SYMBOL(ieee80211_unreserve_tid);
 
 void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb, int tid,
-				 enum ieee80211_band band)
+				 enum nl80211_band band)
 {
 	int ac = ieee802_1d_to_ac[tid & 7];
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0319d6d4f863..905003f75c4d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -59,7 +59,7 @@ void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 	}
 }
 
-int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
+int ieee80211_frame_duration(enum nl80211_band band, size_t len,
 			     int rate, int erp, int short_preamble,
 			     int shift)
 {
@@ -77,7 +77,7 @@ int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 	 * is assumed to be 0 otherwise.
 	 */
 
-	if (band == IEEE80211_BAND_5GHZ || erp) {
+	if (band == NL80211_BAND_5GHZ || erp) {
 		/*
 		 * OFDM:
 		 *
@@ -129,7 +129,7 @@ int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 /* Exported duration function for driver use */
 __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
-					enum ieee80211_band band,
+					enum nl80211_band band,
 					size_t frame_len,
 					struct ieee80211_rate *rate)
 {
@@ -1129,7 +1129,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	use_11b = (chanctx_conf &&
-		   chanctx_conf->def.chan->band == IEEE80211_BAND_2GHZ) &&
+		   chanctx_conf->def.chan->band == NL80211_BAND_2GHZ) &&
 		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
 	rcu_read_unlock();
 
@@ -1301,7 +1301,7 @@ void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 					 u8 *buffer, size_t buffer_len,
 					 const u8 *ie, size_t ie_len,
-					 enum ieee80211_band band,
+					 enum nl80211_band band,
 					 u32 rate_mask,
 					 struct cfg80211_chan_def *chandef,
 					 size_t *offset)
@@ -1375,7 +1375,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 		pos += ext_rates_len;
 	}
 
-	if (chandef->chan && sband->band == IEEE80211_BAND_2GHZ) {
+	if (chandef->chan && sband->band == NL80211_BAND_2GHZ) {
 		if (end - pos < 3)
 			goto out_err;
 		*pos++ = WLAN_EID_DS_PARAMS;
@@ -1479,7 +1479,7 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 
 	memset(ie_desc, 0, sizeof(*ie_desc));
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		if (bands_used & BIT(i)) {
 			pos += ieee80211_build_preq_ies_band(local,
 							     buffer + pos,
@@ -1522,7 +1522,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	int ies_len;
-	u32 rate_masks[IEEE80211_NUM_BANDS] = {};
+	u32 rate_masks[NUM_NL80211_BANDS] = {};
 	struct ieee80211_scan_ies dummy_ie_desc;
 
 	/*
@@ -1582,7 +1582,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata,
 
 u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 			    struct ieee802_11_elems *elems,
-			    enum ieee80211_band band, u32 *basic_rates)
+			    enum nl80211_band band, u32 *basic_rates)
 {
 	struct ieee80211_supported_band *sband;
 	size_t num_rates;
@@ -2520,7 +2520,7 @@ int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
 
 int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb, bool need_basic,
-			    enum ieee80211_band band)
+			    enum nl80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -2565,7 +2565,7 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 
 int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb, bool need_basic,
-				enum ieee80211_band band)
+				enum nl80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -2711,7 +2711,7 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 
 		if (status->flag & RX_FLAG_MACTIME_PLCP_START) {
 			/* TODO: handle HT/VHT preambles */
-			if (status->band == IEEE80211_BAND_5GHZ) {
+			if (status->band == NL80211_BAND_5GHZ) {
 				ts += 20 << shift;
 				mpdu_offset += 2;
 			} else if (status->flag & RX_FLAG_SHORTPRE) {
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index e590e2ef9eaf..ee715764a828 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -418,7 +418,7 @@ void ieee80211_sta_set_rx_nss(struct sta_info *sta)
 
 u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				  struct sta_info *sta, u8 opmode,
-				  enum ieee80211_band band)
+				  enum nl80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -504,7 +504,7 @@ EXPORT_SYMBOL_GPL(ieee80211_update_mu_groups);
 
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band)
+				 enum nl80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 59cabc9bce69..a6631fb319c1 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -768,7 +768,7 @@ static bool cfg80211_ir_permissive_chan(struct wiphy *wiphy,
 		if (chan == other_chan)
 			return true;
 
-		if (chan->band != IEEE80211_BAND_5GHZ)
+		if (chan->band != NL80211_BAND_5GHZ)
 			continue;
 
 		r1 = cfg80211_get_unii(chan->center_freq);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5327e4b974fa..7f7b9409bf4c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -557,7 +557,7 @@ int wiphy_register(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	int res;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
 	bool have_band = false;
 	int i;
@@ -647,7 +647,7 @@ int wiphy_register(struct wiphy *wiphy)
 		return res;
 
 	/* sanity check supported bands/channels */
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		sband = wiphy->bands[band];
 		if (!sband)
 			continue;
@@ -659,7 +659,7 @@ int wiphy_register(struct wiphy *wiphy)
 		 * on 60GHz band, there are no legacy rates, so
 		 * n_bitrates is 0
 		 */
-		if (WARN_ON(band != IEEE80211_BAND_60GHZ &&
+		if (WARN_ON(band != NL80211_BAND_60GHZ &&
 			    !sband->n_bitrates))
 			return -EINVAL;
 
@@ -669,7 +669,7 @@ int wiphy_register(struct wiphy *wiphy)
 		 * global structure for that.
 		 */
 		if (cfg80211_disable_40mhz_24ghz &&
-		    band == IEEE80211_BAND_2GHZ &&
+		    band == NL80211_BAND_2GHZ &&
 		    sband->ht_cap.ht_supported) {
 			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 454157717efa..5d453916a417 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -69,7 +69,7 @@ static ssize_t ht40allow_map_read(struct file *file,
 	struct wiphy *wiphy = file->private_data;
 	char *buf;
 	unsigned int offset = 0, buf_size = PAGE_SIZE, i, r;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
 
 	buf = kzalloc(buf_size, GFP_KERNEL);
@@ -78,7 +78,7 @@ static ssize_t ht40allow_map_read(struct file *file,
 
 	rtnl_lock();
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		sband = wiphy->bands[band];
 		if (!sband)
 			continue;
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 4c55fab9b4e4..4a4dda53bdf1 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -104,7 +104,7 @@ static int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		struct ieee80211_supported_band *sband =
 			rdev->wiphy.bands[params->chandef.chan->band];
 		int j;
-		u32 flag = params->chandef.chan->band == IEEE80211_BAND_5GHZ ?
+		u32 flag = params->chandef.chan->band == NL80211_BAND_5GHZ ?
 			IEEE80211_RATE_MANDATORY_A :
 			IEEE80211_RATE_MANDATORY_B;
 
@@ -236,7 +236,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev)
 {
 	struct cfg80211_cached_keys *ck = NULL;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	int i, err;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -248,7 +248,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 	if (!wdev->wext.ibss.chandef.chan) {
 		struct ieee80211_channel *new_chan = NULL;
 
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		for (band = 0; band < NUM_NL80211_BANDS; band++) {
 			struct ieee80211_supported_band *sband;
 			struct ieee80211_channel *chan;
 
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 092300b30c37..fa2066b56f36 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -128,9 +128,9 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 
 	if (!setup->chandef.chan) {
 		/* if we don't have that either, use the first usable channel */
-		enum ieee80211_band band;
+		enum nl80211_band band;
 
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		for (band = 0; band < NUM_NL80211_BANDS; band++) {
 			struct ieee80211_supported_band *sband;
 			struct ieee80211_channel *chan;
 			int i;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index ff328250bc44..c284d883c349 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -726,7 +726,7 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 	wiphy = &rdev->wiphy;
 
 	rtnl_lock();
-	for (bandid = 0; bandid < IEEE80211_NUM_BANDS; bandid++) {
+	for (bandid = 0; bandid < NUM_NL80211_BANDS; bandid++) {
 		sband = wiphy->bands[bandid];
 		if (!sband)
 			continue;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4f45a2913104..13ef553b99d4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1277,7 +1277,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 	struct nlattr *nl_bands, *nl_band;
 	struct nlattr *nl_freqs, *nl_freq;
 	struct nlattr *nl_cmds;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_channel *chan;
 	int i;
 	const struct ieee80211_txrx_stypes *mgmt_stypes =
@@ -1410,7 +1410,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			goto nla_put_failure;
 
 		for (band = state->band_start;
-		     band < IEEE80211_NUM_BANDS; band++) {
+		     band < NUM_NL80211_BANDS; band++) {
 			struct ieee80211_supported_band *sband;
 
 			sband = rdev->wiphy.bands[band];
@@ -1472,7 +1472,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		}
 		nla_nest_end(msg, nl_bands);
 
-		if (band < IEEE80211_NUM_BANDS)
+		if (band < NUM_NL80211_BANDS)
 			state->band_start = band + 1;
 		else
 			state->band_start = 0;
@@ -3493,7 +3493,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	params.pbss = nla_get_flag(info->attrs[NL80211_ATTR_PBSS]);
-	if (params.pbss && !rdev->wiphy.bands[IEEE80211_BAND_60GHZ])
+	if (params.pbss && !rdev->wiphy.bands[NL80211_BAND_60GHZ])
 		return -EOPNOTSUPP;
 
 	wdev_lock(wdev);
@@ -5821,9 +5821,9 @@ static int validate_scan_freqs(struct nlattr *freqs)
 	return n_channels;
 }
 
-static bool is_band_valid(struct wiphy *wiphy, enum ieee80211_band b)
+static bool is_band_valid(struct wiphy *wiphy, enum nl80211_band b)
 {
-	return b < IEEE80211_NUM_BANDS && wiphy->bands[b];
+	return b < NUM_NL80211_BANDS && wiphy->bands[b];
 }
 
 static int parse_bss_select(struct nlattr *nla, struct wiphy *wiphy,
@@ -6018,10 +6018,10 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 			i++;
 		}
 	} else {
-		enum ieee80211_band band;
+		enum nl80211_band band;
 
 		/* all channels */
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		for (band = 0; band < NUM_NL80211_BANDS; band++) {
 			int j;
 			if (!wiphy->bands[band])
 				continue;
@@ -6066,7 +6066,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		       request->ie_len);
 	}
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+	for (i = 0; i < NUM_NL80211_BANDS; i++)
 		if (wiphy->bands[i])
 			request->rates[i] =
 				(1 << wiphy->bands[i]->n_bitrates) - 1;
@@ -6075,9 +6075,9 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		nla_for_each_nested(attr,
 				    info->attrs[NL80211_ATTR_SCAN_SUPP_RATES],
 				    tmp) {
-			enum ieee80211_band band = nla_type(attr);
+			enum nl80211_band band = nla_type(attr);
 
-			if (band < 0 || band >= IEEE80211_NUM_BANDS) {
+			if (band < 0 || band >= NUM_NL80211_BANDS) {
 				err = -EINVAL;
 				goto out_free;
 			}
@@ -6265,7 +6265,7 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct cfg80211_sched_scan_request *request;
 	struct nlattr *attr;
 	int err, tmp, n_ssids = 0, n_match_sets = 0, n_channels, i, n_plans = 0;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	size_t ie_len;
 	struct nlattr *tb[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1];
 	s32 default_match_rssi = NL80211_SCAN_RSSI_THOLD_OFF;
@@ -6430,7 +6430,7 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 		}
 	} else {
 		/* all channels */
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		for (band = 0; band < NUM_NL80211_BANDS; band++) {
 			int j;
 			if (!wiphy->bands[band])
 				continue;
@@ -7538,14 +7538,14 @@ static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
 
 static bool
 nl80211_parse_mcast_rate(struct cfg80211_registered_device *rdev,
-			 int mcast_rate[IEEE80211_NUM_BANDS],
+			 int mcast_rate[NUM_NL80211_BANDS],
 			 int rateval)
 {
 	struct wiphy *wiphy = &rdev->wiphy;
 	bool found = false;
 	int band, i;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		struct ieee80211_supported_band *sband;
 
 		sband = wiphy->bands[band];
@@ -7725,7 +7725,7 @@ static int nl80211_set_mcast_rate(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
-	int mcast_rate[IEEE80211_NUM_BANDS];
+	int mcast_rate[NUM_NL80211_BANDS];
 	u32 nla_rate;
 	int err;
 
@@ -8130,7 +8130,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	connect.pbss = nla_get_flag(info->attrs[NL80211_ATTR_PBSS]);
-	if (connect.pbss && !rdev->wiphy.bands[IEEE80211_BAND_60GHZ]) {
+	if (connect.pbss && !rdev->wiphy.bands[NL80211_BAND_60GHZ]) {
 		kzfree(connkeys);
 		return -EOPNOTSUPP;
 	}
@@ -8550,7 +8550,7 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 
 	memset(&mask, 0, sizeof(mask));
 	/* Default to all rates enabled */
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		sband = rdev->wiphy.bands[i];
 
 		if (!sband)
@@ -8574,14 +8574,14 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 
 	/*
 	 * The nested attribute uses enum nl80211_band as the index. This maps
-	 * directly to the enum ieee80211_band values used in cfg80211.
+	 * directly to the enum nl80211_band values used in cfg80211.
 	 */
 	BUILD_BUG_ON(NL80211_MAX_SUPP_HT_RATES > IEEE80211_HT_MCS_MASK_LEN * 8);
 	nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES], rem) {
-		enum ieee80211_band band = nla_type(tx_rates);
+		enum nl80211_band band = nla_type(tx_rates);
 		int err;
 
-		if (band < 0 || band >= IEEE80211_NUM_BANDS)
+		if (band < 0 || band >= NUM_NL80211_BANDS)
 			return -EINVAL;
 		sband = rdev->wiphy.bands[band];
 		if (sband == NULL)
@@ -10746,7 +10746,7 @@ static int nl80211_tdls_channel_switch(struct sk_buff *skb,
 	 * section 10.22.6.2.1. Disallow 5/10Mhz channels as well for now, the
 	 * specification is not defined for them.
 	 */
-	if (chandef.chan->band == IEEE80211_BAND_2GHZ &&
+	if (chandef.chan->band == NL80211_BAND_2GHZ &&
 	    chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
 	    chandef.width != NL80211_CHAN_WIDTH_20)
 		return -EINVAL;
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 8ae0c04f9fc7..85ff30bee2b9 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1048,7 +1048,7 @@ rdev_start_radar_detection(struct cfg80211_registered_device *rdev,
 static inline int
 rdev_set_mcast_rate(struct cfg80211_registered_device *rdev,
 		    struct net_device *dev,
-		    int mcast_rate[IEEE80211_NUM_BANDS])
+		    int mcast_rate[NUM_NL80211_BANDS])
 {
 	int ret = -ENOTSUPP;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c5fb317eee68..e271dea6bc02 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1546,12 +1546,12 @@ static void reg_process_ht_flags_band(struct wiphy *wiphy,
 
 static void reg_process_ht_flags(struct wiphy *wiphy)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	if (!wiphy)
 		return;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+	for (band = 0; band < NUM_NL80211_BANDS; band++)
 		reg_process_ht_flags_band(wiphy, wiphy->bands[band]);
 }
 
@@ -1673,7 +1673,7 @@ static void reg_check_channels(void)
 static void wiphy_update_regulatory(struct wiphy *wiphy,
 				    enum nl80211_reg_initiator initiator)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct regulatory_request *lr = get_last_request();
 
 	if (ignore_reg_update(wiphy, initiator)) {
@@ -1690,7 +1690,7 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 
 	lr->dfs_region = get_cfg80211_regdom()->dfs_region;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+	for (band = 0; band < NUM_NL80211_BANDS; band++)
 		handle_band(wiphy, initiator, wiphy->bands[band]);
 
 	reg_process_beacons(wiphy);
@@ -1786,14 +1786,14 @@ static void handle_band_custom(struct wiphy *wiphy,
 void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 				   const struct ieee80211_regdomain *regd)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	unsigned int bands_set = 0;
 
 	WARN(!(wiphy->regulatory_flags & REGULATORY_CUSTOM_REG),
 	     "wiphy should have REGULATORY_CUSTOM_REG\n");
 	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		if (!wiphy->bands[band])
 			continue;
 		handle_band_custom(wiphy, wiphy->bands[band], regd);
@@ -2228,7 +2228,7 @@ static void reg_process_self_managed_hints(void)
 	struct wiphy *wiphy;
 	const struct ieee80211_regdomain *tmp;
 	const struct ieee80211_regdomain *regd;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct regulatory_request request = {};
 
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
@@ -2246,7 +2246,7 @@ static void reg_process_self_managed_hints(void)
 		rcu_assign_pointer(wiphy->regd, regd);
 		rcu_free_regdom(tmp);
 
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+		for (band = 0; band < NUM_NL80211_BANDS; band++)
 			handle_band_custom(wiphy, wiphy->bands[band], regd);
 
 		reg_process_ht_flags(wiphy);
@@ -2404,7 +2404,7 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 }
 EXPORT_SYMBOL(regulatory_hint);
 
-void regulatory_hint_country_ie(struct wiphy *wiphy, enum ieee80211_band band,
+void regulatory_hint_country_ie(struct wiphy *wiphy, enum nl80211_band band,
 				const u8 *country_ie, u8 country_ie_len)
 {
 	char alpha2[2];
@@ -2504,11 +2504,11 @@ static void restore_alpha2(char *alpha2, bool reset_user)
 static void restore_custom_reg_settings(struct wiphy *wiphy)
 {
 	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_channel *chan;
 	int i;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		sband = wiphy->bands[band];
 		if (!sband)
 			continue;
@@ -2623,9 +2623,9 @@ void regulatory_hint_disconnect(void)
 
 static bool freq_is_chan_12_13_14(u16 freq)
 {
-	if (freq == ieee80211_channel_to_frequency(12, IEEE80211_BAND_2GHZ) ||
-	    freq == ieee80211_channel_to_frequency(13, IEEE80211_BAND_2GHZ) ||
-	    freq == ieee80211_channel_to_frequency(14, IEEE80211_BAND_2GHZ))
+	if (freq == ieee80211_channel_to_frequency(12, NL80211_BAND_2GHZ) ||
+	    freq == ieee80211_channel_to_frequency(13, NL80211_BAND_2GHZ) ||
+	    freq == ieee80211_channel_to_frequency(14, NL80211_BAND_2GHZ))
 		return true;
 	return false;
 }
@@ -2650,7 +2650,7 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 
 	if (beacon_chan->beacon_found ||
 	    beacon_chan->flags & IEEE80211_CHAN_RADAR ||
-	    (beacon_chan->band == IEEE80211_BAND_2GHZ &&
+	    (beacon_chan->band == NL80211_BAND_2GHZ &&
 	     !freq_is_chan_12_13_14(beacon_chan->center_freq)))
 		return 0;
 
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 9f495d76eca0..f6ced316b5a4 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -104,7 +104,7 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
  * information for a band the BSS is not present in it will be ignored.
  */
 void regulatory_hint_country_ie(struct wiphy *wiphy,
-			 enum ieee80211_band band,
+			 enum nl80211_band band,
 			 const u8 *country_ie,
 			 u8 country_ie_len);
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 50ea8e3fcbeb..abdf651a70d9 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -531,7 +531,7 @@ static int cmp_bss(struct cfg80211_bss *a,
 }
 
 static bool cfg80211_bss_type_match(u16 capability,
-				    enum ieee80211_band band,
+				    enum nl80211_band band,
 				    enum ieee80211_bss_type bss_type)
 {
 	bool ret = true;
@@ -540,7 +540,7 @@ static bool cfg80211_bss_type_match(u16 capability,
 	if (bss_type == IEEE80211_BSS_TYPE_ANY)
 		return ret;
 
-	if (band == IEEE80211_BAND_60GHZ) {
+	if (band == NL80211_BAND_60GHZ) {
 		mask = WLAN_CAPABILITY_DMG_TYPE_MASK;
 		switch (bss_type) {
 		case IEEE80211_BSS_TYPE_ESS:
@@ -1006,7 +1006,7 @@ cfg80211_inform_bss_data(struct wiphy *wiphy,
 	if (!res)
 		return NULL;
 
-	if (channel->band == IEEE80211_BAND_60GHZ) {
+	if (channel->band == NL80211_BAND_60GHZ) {
 		bss_type = res->pub.capability & WLAN_CAPABILITY_DMG_TYPE_MASK;
 		if (bss_type == WLAN_CAPABILITY_DMG_TYPE_AP ||
 		    bss_type == WLAN_CAPABILITY_DMG_TYPE_PBSS)
@@ -1089,7 +1089,7 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	if (!res)
 		return NULL;
 
-	if (channel->band == IEEE80211_BAND_60GHZ) {
+	if (channel->band == NL80211_BAND_60GHZ) {
 		bss_type = res->pub.capability & WLAN_CAPABILITY_DMG_TYPE_MASK;
 		if (bss_type == WLAN_CAPABILITY_DMG_TYPE_AP ||
 		    bss_type == WLAN_CAPABILITY_DMG_TYPE_PBSS)
@@ -1185,7 +1185,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	struct iw_scan_req *wreq = NULL;
 	struct cfg80211_scan_request *creq = NULL;
 	int i, err, n_channels = 0;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
 	if (!netif_running(dev))
 		return -ENETDOWN;
@@ -1229,7 +1229,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 
 	/* translate "Scan on frequencies" request */
 	i = 0;
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		int j;
 
 		if (!wiphy->bands[band])
@@ -1289,7 +1289,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 			creq->n_ssids = 0;
 	}
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+	for (i = 0; i < NUM_NL80211_BANDS; i++)
 		if (wiphy->bands[i])
 			creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
 
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 1fba41676428..e22e5b83cfa9 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -81,7 +81,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 		return -ENOMEM;
 
 	if (wdev->conn->params.channel) {
-		enum ieee80211_band band = wdev->conn->params.channel->band;
+		enum nl80211_band band = wdev->conn->params.channel->band;
 		struct ieee80211_supported_band *sband =
 			wdev->wiphy->bands[band];
 
@@ -93,11 +93,11 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 		request->rates[band] = (1 << sband->n_bitrates) - 1;
 	} else {
 		int i = 0, j;
-		enum ieee80211_band band;
+		enum nl80211_band band;
 		struct ieee80211_supported_band *bands;
 		struct ieee80211_channel *channel;
 
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		for (band = 0; band < NUM_NL80211_BANDS; band++) {
 			bands = wdev->wiphy->bands[band];
 			if (!bands)
 				continue;
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 8da1fae23cfb..3c1091ae6c36 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -110,7 +110,7 @@
 				conf->dot11MeshHWMPconfirmationInterval;      \
 	} while (0)
 
-#define CHAN_ENTRY __field(enum ieee80211_band, band) \
+#define CHAN_ENTRY __field(enum nl80211_band, band) \
 		   __field(u16, center_freq)
 #define CHAN_ASSIGN(chan)					  \
 	do {							  \
@@ -125,7 +125,7 @@
 #define CHAN_PR_FMT "band: %d, freq: %u"
 #define CHAN_PR_ARG __entry->band, __entry->center_freq
 
-#define CHAN_DEF_ENTRY __field(enum ieee80211_band, band)		\
+#define CHAN_DEF_ENTRY __field(enum nl80211_band, band)		\
 		       __field(u32, control_freq)			\
 		       __field(u32, width)				\
 		       __field(u32, center_freq1)			\
@@ -2647,7 +2647,7 @@ TRACE_EVENT(cfg80211_scan_done,
 	TP_STRUCT__entry(
 		__field(u32, n_channels)
 		__dynamic_array(u8, ie, request ? request->ie_len : 0)
-		__array(u32, rates, IEEE80211_NUM_BANDS)
+		__array(u32, rates, NUM_NL80211_BANDS)
 		__field(u32, wdev_id)
 		MAC_ENTRY(wiphy_mac)
 		__field(bool, no_cck)
@@ -2658,7 +2658,7 @@ TRACE_EVENT(cfg80211_scan_done,
 			memcpy(__get_dynamic_array(ie), request->ie,
 			       request->ie_len);
 			memcpy(__entry->rates, request->rates,
-			       IEEE80211_NUM_BANDS);
+			       NUM_NL80211_BANDS);
 			__entry->wdev_id = request->wdev ?
 					request->wdev->identifier : 0;
 			if (request->wiphy)
@@ -2883,25 +2883,25 @@ TRACE_EVENT(rdev_start_radar_detection,
 
 TRACE_EVENT(rdev_set_mcast_rate,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 int mcast_rate[IEEE80211_NUM_BANDS]),
+		 int mcast_rate[NUM_NL80211_BANDS]),
 	TP_ARGS(wiphy, netdev, mcast_rate),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		NETDEV_ENTRY
-		__array(int, mcast_rate, IEEE80211_NUM_BANDS)
+		__array(int, mcast_rate, NUM_NL80211_BANDS)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		NETDEV_ASSIGN;
 		memcpy(__entry->mcast_rate, mcast_rate,
-		       sizeof(int) * IEEE80211_NUM_BANDS);
+		       sizeof(int) * NUM_NL80211_BANDS);
 	),
 	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", "
 		  "mcast_rates [2.4GHz=0x%x, 5.2GHz=0x%x, 60GHz=0x%x]",
 		  WIPHY_PR_ARG, NETDEV_PR_ARG,
-		  __entry->mcast_rate[IEEE80211_BAND_2GHZ],
-		  __entry->mcast_rate[IEEE80211_BAND_5GHZ],
-		  __entry->mcast_rate[IEEE80211_BAND_60GHZ])
+		  __entry->mcast_rate[NL80211_BAND_2GHZ],
+		  __entry->mcast_rate[NL80211_BAND_5GHZ],
+		  __entry->mcast_rate[NL80211_BAND_60GHZ])
 );
 
 TRACE_EVENT(rdev_set_coalesce,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 9f440a9de63b..f36039888eb5 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -47,7 +47,7 @@ u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
 	if (WARN_ON(!sband))
 		return 1;
 
-	if (sband->band == IEEE80211_BAND_2GHZ) {
+	if (sband->band == NL80211_BAND_2GHZ) {
 		if (scan_width == NL80211_BSS_CHAN_WIDTH_5 ||
 		    scan_width == NL80211_BSS_CHAN_WIDTH_10)
 			mandatory_flag = IEEE80211_RATE_MANDATORY_G;
@@ -65,26 +65,26 @@ u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
 }
 EXPORT_SYMBOL(ieee80211_mandatory_rates);
 
-int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band)
+int ieee80211_channel_to_frequency(int chan, enum nl80211_band band)
 {
 	/* see 802.11 17.3.8.3.2 and Annex J
 	 * there are overlapping channel numbers in 5GHz and 2GHz bands */
 	if (chan <= 0)
 		return 0; /* not supported */
 	switch (band) {
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		if (chan == 14)
 			return 2484;
 		else if (chan < 14)
 			return 2407 + chan * 5;
 		break;
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		if (chan >= 182 && chan <= 196)
 			return 4000 + chan * 5;
 		else
 			return 5000 + chan * 5;
 		break;
-	case IEEE80211_BAND_60GHZ:
+	case NL80211_BAND_60GHZ:
 		if (chan < 5)
 			return 56160 + chan * 2160;
 		break;
@@ -116,11 +116,11 @@ EXPORT_SYMBOL(ieee80211_frequency_to_channel);
 struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
 						  int freq)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
 	int i;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		sband = wiphy->bands[band];
 
 		if (!sband)
@@ -137,12 +137,12 @@ struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
 EXPORT_SYMBOL(__ieee80211_get_channel);
 
 static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
-				     enum ieee80211_band band)
+				     enum nl80211_band band)
 {
 	int i, want;
 
 	switch (band) {
-	case IEEE80211_BAND_5GHZ:
+	case NL80211_BAND_5GHZ:
 		want = 3;
 		for (i = 0; i < sband->n_bitrates; i++) {
 			if (sband->bitrates[i].bitrate == 60 ||
@@ -155,7 +155,7 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 		}
 		WARN_ON(want);
 		break;
-	case IEEE80211_BAND_2GHZ:
+	case NL80211_BAND_2GHZ:
 		want = 7;
 		for (i = 0; i < sband->n_bitrates; i++) {
 			if (sband->bitrates[i].bitrate == 10) {
@@ -185,12 +185,12 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 		}
 		WARN_ON(want != 0 && want != 3 && want != 6);
 		break;
-	case IEEE80211_BAND_60GHZ:
+	case NL80211_BAND_60GHZ:
 		/* check for mandatory HT MCS 1..4 */
 		WARN_ON(!sband->ht_cap.ht_supported);
 		WARN_ON((sband->ht_cap.mcs.rx_mask[0] & 0x1e) != 0x1e);
 		break;
-	case IEEE80211_NUM_BANDS:
+	case NUM_NL80211_BANDS:
 		WARN_ON(1);
 		break;
 	}
@@ -198,9 +198,9 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 
 void ieee80211_set_bitrate_flags(struct wiphy *wiphy)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+	for (band = 0; band < NUM_NL80211_BANDS; band++)
 		if (wiphy->bands[band])
 			set_mandatory_flags_band(wiphy->bands[band], band);
 }
@@ -1399,22 +1399,22 @@ size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
 EXPORT_SYMBOL(ieee80211_ie_split_ric);
 
 bool ieee80211_operating_class_to_band(u8 operating_class,
-				       enum ieee80211_band *band)
+				       enum nl80211_band *band)
 {
 	switch (operating_class) {
 	case 112:
 	case 115 ... 127:
 	case 128 ... 130:
-		*band = IEEE80211_BAND_5GHZ;
+		*band = NL80211_BAND_5GHZ;
 		return true;
 	case 81:
 	case 82:
 	case 83:
 	case 84:
-		*band = IEEE80211_BAND_2GHZ;
+		*band = NL80211_BAND_2GHZ;
 		return true;
 	case 180:
-		*band = IEEE80211_BAND_60GHZ;
+		*band = NL80211_BAND_60GHZ;
 		return true;
 	}
 
@@ -1726,10 +1726,10 @@ int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 
 unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy)
 {
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	unsigned int n_channels = 0;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+	for (band = 0; band < NUM_NL80211_BANDS; band++)
 		if (wiphy->bands[band])
 			n_channels += wiphy->bands[band]->n_channels;
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index fd682832a0e3..4c89f0ca61ba 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -32,13 +32,13 @@ int cfg80211_wext_giwname(struct net_device *dev,
 	if (!wdev)
 		return -EOPNOTSUPP;
 
-	sband = wdev->wiphy->bands[IEEE80211_BAND_5GHZ];
+	sband = wdev->wiphy->bands[NL80211_BAND_5GHZ];
 	if (sband) {
 		is_a = true;
 		is_ht |= sband->ht_cap.ht_supported;
 	}
 
-	sband = wdev->wiphy->bands[IEEE80211_BAND_2GHZ];
+	sband = wdev->wiphy->bands[NL80211_BAND_2GHZ];
 	if (sband) {
 		int i;
 		/* Check for mandatory rates */
@@ -143,7 +143,7 @@ int cfg80211_wext_giwrange(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct iw_range *range = (struct iw_range *) extra;
-	enum ieee80211_band band;
+	enum nl80211_band band;
 	int i, c = 0;
 
 	if (!wdev)
@@ -215,7 +215,7 @@ int cfg80211_wext_giwrange(struct net_device *dev,
 		}
 	}
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band ++) {
 		struct ieee80211_supported_band *sband;
 
 		sband = wdev->wiphy->bands[band];
@@ -265,11 +265,11 @@ int cfg80211_wext_freq(struct iw_freq *freq)
 	 * -EINVAL for impossible things.
 	 */
 	if (freq->e == 0) {
-		enum ieee80211_band band = IEEE80211_BAND_2GHZ;
+		enum nl80211_band band = NL80211_BAND_2GHZ;
 		if (freq->m < 0)
 			return 0;
 		if (freq->m > 14)
-			band = IEEE80211_BAND_5GHZ;
+			band = NL80211_BAND_5GHZ;
 		return ieee80211_channel_to_frequency(freq->m, band);
 	} else {
 		int i, div = 1000000;
@@ -1245,7 +1245,7 @@ static int cfg80211_wext_siwrate(struct net_device *dev,
 		maxrate = rate->value / 100000;
 	}
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		sband = wdev->wiphy->bands[band];
 		if (sband == NULL)
 			continue;
-- 
2.7.0

