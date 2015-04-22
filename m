Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54705 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756400AbbDVNZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 09:25:40 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] mac80211: remove support for IFF_PROMISC
Date: Wed, 22 Apr 2015 15:25:19 +0200
Message-Id: <1429709122-13734-1-git-send-email-johannes@sipsolutions.net> (sfid-20150422_152546_976046_97BF43FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This support is essentially useless as typically networks are encrypted,
frames will be filtered by hardware, and rate scaling will be done with
the intended recipient in mind. For real monitoring of the network, the
monitor mode support should be used instead.

Removing it removes a lot of corner cases.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/adm8211.c                     |  7 +----
 drivers/net/wireless/at76c50x-usb.h                |  2 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |  3 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  4 +--
 drivers/net/wireless/ath/ath5k/ath5k.h             |  1 -
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      | 15 ++--------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  9 +-----
 drivers/net/wireless/ath/ath9k/main.c              |  3 +-
 drivers/net/wireless/ath/ath9k/recv.c              |  5 ----
 drivers/net/wireless/ath/carl9170/fw.c             |  3 +-
 drivers/net/wireless/ath/carl9170/main.c           |  7 ++---
 drivers/net/wireless/b43/main.c                    |  8 ++----
 drivers/net/wireless/b43legacy/main.c              |  8 ++----
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  5 +---
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  2 +-
 drivers/net/wireless/cw1200/sta.c                  | 10 ++-----
 drivers/net/wireless/iwlegacy/3945-mac.c           |  4 +--
 drivers/net/wireless/iwlegacy/4965-mac.c           |  4 +--
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  4 +--
 drivers/net/wireless/libertas_tf/main.c            |  7 ++---
 drivers/net/wireless/mac80211_hwsim.c              |  2 --
 drivers/net/wireless/mwl8k.c                       |  2 +-
 drivers/net/wireless/p54/fwio.c                    |  3 +-
 drivers/net/wireless/p54/main.c                    |  6 ++--
 drivers/net/wireless/rt2x00/rt2400pci.c            |  4 +--
 drivers/net/wireless/rt2x00/rt2500pci.c            |  4 +--
 drivers/net/wireless/rt2x00/rt2500usb.c            |  4 +--
 drivers/net/wireless/rt2x00/rt2800lib.c            |  3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |  6 +---
 drivers/net/wireless/rt2x00/rt61pci.c              |  4 +--
 drivers/net/wireless/rt2x00/rt73usb.c              |  4 +--
 drivers/net/wireless/rtlwifi/core.h                |  3 +-
 drivers/net/wireless/ti/wl1251/main.c              |  9 ++----
 drivers/net/wireless/ti/wlcore/main.c              |  3 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |  4 +--
 drivers/staging/vt6655/device_main.c               | 11 +-------
 drivers/staging/vt6656/main_usb.c                  | 11 +-------
 include/net/mac80211.h                             |  9 ++----
 net/mac80211/ieee80211_i.h                         |  6 ++--
 net/mac80211/iface.c                               | 19 ++-----------
 net/mac80211/main.c                                |  3 --
 net/mac80211/rx.c                                  | 33 ++++++----------------
 43 files changed, 63 insertions(+), 204 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index f07a61899545..413528295d72 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1353,12 +1353,7 @@ static void adm8211_configure_filter(struct ieee80211_hw *dev,
 
 	new_flags = 0;
 
-	if (*total_flags & FIF_PROMISC_IN_BSS) {
-		new_flags |= FIF_PROMISC_IN_BSS;
-		priv->nar |= ADM8211_NAR_PR;
-		priv->nar &= ~ADM8211_NAR_MM;
-		mc_filter[1] = mc_filter[0] = ~0;
-	} else if (*total_flags & FIF_ALLMULTI || multicast == ~(0ULL)) {
+	if (*total_flags & FIF_ALLMULTI || multicast == ~(0ULL)) {
 		new_flags |= FIF_ALLMULTI;
 		priv->nar &= ~ADM8211_NAR_PR;
 		priv->nar |= ADM8211_NAR_MM;
diff --git a/drivers/net/wireless/at76c50x-usb.h b/drivers/net/wireless/at76c50x-usb.h
index 55090a38ac95..ae03271f878e 100644
--- a/drivers/net/wireless/at76c50x-usb.h
+++ b/drivers/net/wireless/at76c50x-usb.h
@@ -447,7 +447,7 @@ struct at76_priv {
 	int mac80211_registered;
 };
 
-#define AT76_SUPPORTED_FILTERS FIF_PROMISC_IN_BSS
+#define AT76_SUPPORTED_FILTERS 0
 
 #define SCAN_POLL_INTERVAL	(HZ / 4)
 
diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 5147ebe4cd05..14937cbeca56 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1319,8 +1319,7 @@ out_unlock:
 
 }
 
-#define AR5523_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
-				  FIF_ALLMULTI | \
+#define AR5523_SUPPORTED_FILTERS (FIF_ALLMULTI | \
 				  FIF_FCSFAIL | \
 				  FIF_OTHER_BSS)
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4120fe5fc7bc..fcd08b2f8d26 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -773,7 +773,6 @@ static int ath10k_monitor_recalc(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	should_start = ar->monitor ||
-		       ar->filter_flags & FIF_PROMISC_IN_BSS ||
 		       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
@@ -3493,8 +3492,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
  * FIXME: Has to be verified.
  */
 #define SUPPORTED_FILTERS			\
-	(FIF_PROMISC_IN_BSS |			\
-	FIF_ALLMULTI |				\
+	(FIF_ALLMULTI |				\
 	FIF_CONTROL |				\
 	FIF_PSPOLL |				\
 	FIF_OTHER_BSS |				\
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 7ca0d6f930fd..e22b0e778927 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1280,7 +1280,6 @@ struct ath5k_hw {
 
 	DECLARE_BITMAP(status, 4);
 #define ATH_STAT_INVALID	0		/* disable hardware accesses */
-#define ATH_STAT_PROMISC	1
 #define ATH_STAT_LEDSOFT	2		/* enable LED gpio status */
 #define ATH_STAT_STARTED	3		/* opened & irqs enabled */
 #define ATH_STAT_RESET		4		/* hw reset */
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 3b4a6463d87a..0210630972d6 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -369,7 +369,7 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 		       unsigned int *new_flags, u64 multicast)
 {
 #define SUPPORTED_FIF_FLAGS \
-	(FIF_PROMISC_IN_BSS |  FIF_ALLMULTI | FIF_FCSFAIL | \
+	(FIF_ALLMULTI | FIF_FCSFAIL | \
 	FIF_PLCPFAIL | FIF_CONTROL | FIF_OTHER_BSS | \
 	FIF_BCN_PRBRESP_PROMISC)
 
@@ -393,16 +393,6 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 		(AR5K_RX_FILTER_UCAST | AR5K_RX_FILTER_BCAST |
 		AR5K_RX_FILTER_MCAST);
 
-	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
-		if (*new_flags & FIF_PROMISC_IN_BSS)
-			__set_bit(ATH_STAT_PROMISC, ah->status);
-		else
-			__clear_bit(ATH_STAT_PROMISC, ah->status);
-	}
-
-	if (test_bit(ATH_STAT_PROMISC, ah->status))
-		rfilt |= AR5K_RX_FILTER_PROM;
-
 	/* Note, AR5K_RX_FILTER_MCAST is already enabled */
 	if (*new_flags & FIF_ALLMULTI) {
 		mfilt[0] =  ~0;
@@ -418,8 +408,7 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	if ((*new_flags & FIF_BCN_PRBRESP_PROMISC) || (ah->nvifs > 1))
 		rfilt |= AR5K_RX_FILTER_BEACON;
 
-	/* FIF_CONTROL doc says that if FIF_PROMISC_IN_BSS is not
-	 * set we should only pass on control frames for this
+	/* FIF_CONTROL doc says we should only pass on control frames for this
 	 * station. This needs testing. I believe right now this
 	 * enables *all* control frames, which is OK.. but
 	 * but we should see if we can improve on granularity */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 564923c0df87..b71f3072fd9a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1238,8 +1238,7 @@ out:
 }
 
 #define SUPPORTED_FILTERS			\
-	(FIF_PROMISC_IN_BSS |			\
-	FIF_ALLMULTI |				\
+	(FIF_ALLMULTI |				\
 	FIF_CONTROL |				\
 	FIF_PSPOLL |				\
 	FIF_OTHER_BSS |				\
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index a0f58e2aa553..cc9648f844ae 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -872,14 +872,7 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 	if (priv->rxfilter & FIF_PROBE_REQ)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
-	/*
-	 * Set promiscuous mode when FIF_PROMISC_IN_BSS is enabled for station
-	 * mode interface or when in monitor mode. AP mode does not need this
-	 * since it receives all in-BSS frames anyway.
-	 */
-	if (((ah->opmode != NL80211_IFTYPE_AP) &&
-	     (priv->rxfilter & FIF_PROMISC_IN_BSS)) ||
-	    ah->is_monitoring)
+	if (ah->is_monitoring)
 		rfilt |= ATH9K_RX_FILTER_PROM;
 
 	if (priv->rxfilter & FIF_CONTROL)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b0badef71ce7..d285e3a89853 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1442,8 +1442,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 }
 
 #define SUPPORTED_FILTERS			\
-	(FIF_PROMISC_IN_BSS |			\
-	FIF_ALLMULTI |				\
+	(FIF_ALLMULTI |				\
 	FIF_CONTROL |				\
 	FIF_PSPOLL |				\
 	FIF_OTHER_BSS |				\
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6fb40ef86fd6..6c75fb1ab77d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -392,11 +392,6 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->cur_chan->rxfilter & FIF_PROBE_REQ)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
-	/*
-	 * Set promiscuous mode when FIF_PROMISC_IN_BSS is enabled for station
-	 * mode interface or when in monitor mode. AP mode does not need this
-	 * since it receives all in-BSS frames anyway.
-	 */
 	if (sc->sc_ah->is_monitoring)
 		rfilt |= ATH9K_RX_FILTER_PROM;
 
diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 47d5c2e910ad..020cd46471f5 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -310,8 +310,7 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 	if (SUPP(CARL9170FW_RX_FILTER)) {
 		ar->fw.rx_filter = true;
 		ar->rx_filter_caps = FIF_FCSFAIL | FIF_PLCPFAIL |
-			FIF_CONTROL | FIF_PSPOLL | FIF_OTHER_BSS |
-			FIF_PROMISC_IN_BSS;
+			FIF_CONTROL | FIF_PSPOLL | FIF_OTHER_BSS;
 	}
 
 	if (SUPP(CARL9170FW_HW_COUNTERS))
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index f1455a04cb62..59db6732d4e3 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1011,9 +1011,8 @@ static void carl9170_op_configure_filter(struct ieee80211_hw *hw,
 	if (multicast != ar->cur_mc_hash)
 		WARN_ON(carl9170_update_multicast(ar, multicast));
 
-	if (changed_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS)) {
-		ar->sniffer_enabled = !!(*new_flags &
-			(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS));
+	if (changed_flags & FIF_OTHER_BSS) {
+		ar->sniffer_enabled = !!(*new_flags & FIF_OTHER_BSS);
 
 		WARN_ON(carl9170_set_operating_mode(ar));
 	}
@@ -1033,7 +1032,7 @@ static void carl9170_op_configure_filter(struct ieee80211_hw *hw,
 		if (!(*new_flags & FIF_PSPOLL))
 			rx_filter |= CARL9170_RX_FILTER_CTL_PSPOLL;
 
-		if (!(*new_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS))) {
+		if (!(*new_flags & FIF_OTHER_BSS)) {
 			rx_filter |= CARL9170_RX_FILTER_OTHER_RA;
 			rx_filter |= CARL9170_RX_FILTER_DECRY_FAIL;
 		}
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index b2f9521fe551..f40992969b4a 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3131,8 +3131,6 @@ static void b43_adjust_opmode(struct b43_wldev *dev)
 		ctl |= B43_MACCTL_KEEP_BAD;
 	if (wl->filter_flags & FIF_PLCPFAIL)
 		ctl |= B43_MACCTL_KEEP_BADPLCP;
-	if (wl->filter_flags & FIF_PROMISC_IN_BSS)
-		ctl |= B43_MACCTL_PROMISC;
 	if (wl->filter_flags & FIF_BCN_PRBRESP_PROMISC)
 		ctl |= B43_MACCTL_BEACPROMISC;
 
@@ -4310,16 +4308,14 @@ static void b43_op_configure_filter(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	*fflags &= FIF_PROMISC_IN_BSS |
-		  FIF_ALLMULTI |
+	*fflags &= FIF_ALLMULTI |
 		  FIF_FCSFAIL |
 		  FIF_PLCPFAIL |
 		  FIF_CONTROL |
 		  FIF_OTHER_BSS |
 		  FIF_BCN_PRBRESP_PROMISC;
 
-	changed &= FIF_PROMISC_IN_BSS |
-		   FIF_ALLMULTI |
+	changed &= FIF_ALLMULTI |
 		   FIF_FCSFAIL |
 		   FIF_PLCPFAIL |
 		   FIF_CONTROL |
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index c77b7f59505c..39d49d6cd07f 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2055,8 +2055,6 @@ static void b43legacy_adjust_opmode(struct b43legacy_wldev *dev)
 		ctl |= B43legacy_MACCTL_KEEP_BAD;
 	if (wl->filter_flags & FIF_PLCPFAIL)
 		ctl |= B43legacy_MACCTL_KEEP_BADPLCP;
-	if (wl->filter_flags & FIF_PROMISC_IN_BSS)
-		ctl |= B43legacy_MACCTL_PROMISC;
 	if (wl->filter_flags & FIF_BCN_PRBRESP_PROMISC)
 		ctl |= B43legacy_MACCTL_BEACPROMISC;
 
@@ -2922,16 +2920,14 @@ static void b43legacy_op_configure_filter(struct ieee80211_hw *hw,
 	}
 
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	*fflags &= FIF_PROMISC_IN_BSS |
-		  FIF_ALLMULTI |
+	*fflags &= FIF_ALLMULTI |
 		  FIF_FCSFAIL |
 		  FIF_PLCPFAIL |
 		  FIF_CONTROL |
 		  FIF_OTHER_BSS |
 		  FIF_BCN_PRBRESP_PROMISC;
 
-	changed &= FIF_PROMISC_IN_BSS |
-		   FIF_ALLMULTI |
+	changed &= FIF_ALLMULTI |
 		   FIF_FCSFAIL |
 		   FIF_PLCPFAIL |
 		   FIF_CONTROL |
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 48135063347e..b46cab250615 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -41,8 +41,7 @@
 #define BRCMS_FLUSH_TIMEOUT	500 /* msec */
 
 /* Flags we support */
-#define MAC_FILTERS (FIF_PROMISC_IN_BSS | \
-	FIF_ALLMULTI | \
+#define MAC_FILTERS (FIF_ALLMULTI | \
 	FIF_FCSFAIL | \
 	FIF_CONTROL | \
 	FIF_OTHER_BSS | \
@@ -743,8 +742,6 @@ brcms_ops_configure_filter(struct ieee80211_hw *hw,
 	changed_flags &= MAC_FILTERS;
 	*total_flags &= MAC_FILTERS;
 
-	if (changed_flags & FIF_PROMISC_IN_BSS)
-		brcms_dbg_info(core, "FIF_PROMISC_IN_BSS\n");
 	if (changed_flags & FIF_ALLMULTI)
 		brcms_dbg_info(core, "FIF_ALLMULTI\n");
 	if (changed_flags & FIF_FCSFAIL)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 369527e27689..9728be0e704b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3571,7 +3571,7 @@ void brcms_c_mac_promisc(struct brcms_c_info *wlc, uint filter_flags)
 
 	wlc->filter_flags = filter_flags;
 
-	if (filter_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS))
+	if (filter_flags & FIF_OTHER_BSS)
 		promisc_bits |= MCTL_PROMISC;
 
 	if (filter_flags & FIF_BCN_PRBRESP_PROMISC)
diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index b0f65fa09428..b86500b4418f 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -578,13 +578,11 @@ void cw1200_configure_filter(struct ieee80211_hw *dev,
 {
 	struct cw1200_common *priv = dev->priv;
 	bool listening = !!(*total_flags &
-			    (FIF_PROMISC_IN_BSS |
-			     FIF_OTHER_BSS |
+			    (FIF_OTHER_BSS |
 			     FIF_BCN_PRBRESP_PROMISC |
 			     FIF_PROBE_REQ));
 
-	*total_flags &= FIF_PROMISC_IN_BSS |
-			FIF_OTHER_BSS |
+	*total_flags &= FIF_OTHER_BSS |
 			FIF_FCSFAIL |
 			FIF_BCN_PRBRESP_PROMISC |
 			FIF_PROBE_REQ;
@@ -592,14 +590,12 @@ void cw1200_configure_filter(struct ieee80211_hw *dev,
 	down(&priv->scan.lock);
 	mutex_lock(&priv->conf_mutex);
 
-	priv->rx_filter.promiscuous = (*total_flags & FIF_PROMISC_IN_BSS)
-			? 1 : 0;
+	priv->rx_filter.promiscuous = 0;
 	priv->rx_filter.bssid = (*total_flags & (FIF_OTHER_BSS |
 			FIF_PROBE_REQ)) ? 1 : 0;
 	priv->rx_filter.fcs = (*total_flags & FIF_FCSFAIL) ? 1 : 0;
 	priv->disable_beacon_filter = !(*total_flags &
 					(FIF_BCN_PRBRESP_PROMISC |
-					 FIF_PROMISC_IN_BSS |
 					 FIF_PROBE_REQ));
 	if (priv->listening != listening) {
 		priv->listening = listening;
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index e5665804d986..189cdf58084b 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3048,7 +3048,7 @@ il3945_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	D_MAC80211("Enter: changed: 0x%x, total: 0x%x\n", changed_flags,
 		   *total_flags);
 
-	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
+	CHK(FIF_OTHER_BSS, RXON_FILTER_PROMISC_MSK);
 	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK);
 	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
 
@@ -3074,7 +3074,7 @@ il3945_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	 * filters into the device.
 	 */
 	*total_flags &=
-	    FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
+	    FIF_OTHER_BSS | FIF_ALLMULTI |
 	    FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 976f65fe9c38..e4b175cbeefd 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6166,7 +6166,7 @@ il4965_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	D_MAC80211("Enter: changed: 0x%x, total: 0x%x\n", changed_flags,
 		   *total_flags);
 
-	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
+	CHK(FIF_OTHER_BSS, RXON_FILTER_PROMISC_MSK);
 	/* Setting _just_ RXON_FILTER_CTL2HOST_MSK causes FH errors */
 	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_PROMISC_MSK);
 	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
@@ -6192,7 +6192,7 @@ il4965_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	 * filters into the device.
 	 */
 	*total_flags &=
-	    FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
+	    FIF_OTHER_BSS | FIF_ALLMULTI |
 	    FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 5abd62ed8cb4..c7bc01d92f2f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1061,7 +1061,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "Enter: changed: 0x%x, total: 0x%x\n",
 			changed_flags, *total_flags);
 
-	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
+	CHK(FIF_OTHER_BSS, RXON_FILTER_PROMISC_MSK);
 	/* Setting _just_ RXON_FILTER_CTL2HOST_MSK causes FH errors */
 	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_PROMISC_MSK);
 	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
@@ -1088,7 +1088,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 	 * since we currently do not support programming multicast
 	 * filters into the device.
 	 */
-	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
+	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI |
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index ed02e4bf2c26..1bdf18674fb8 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -439,7 +439,7 @@ static u64 lbtf_op_prepare_multicast(struct ieee80211_hw *hw,
 	return mc_count;
 }
 
-#define SUPPORTED_FIF_FLAGS  (FIF_PROMISC_IN_BSS | FIF_ALLMULTI)
+#define SUPPORTED_FIF_FLAGS  FIF_ALLMULTI
 static void lbtf_op_configure_filter(struct ieee80211_hw *hw,
 			unsigned int changed_flags,
 			unsigned int *new_flags,
@@ -458,10 +458,7 @@ static void lbtf_op_configure_filter(struct ieee80211_hw *hw,
 		return;
 	}
 
-	if (*new_flags & (FIF_PROMISC_IN_BSS))
-		priv->mac_control |= CMD_ACT_MAC_PROMISCUOUS_ENABLE;
-	else
-		priv->mac_control &= ~CMD_ACT_MAC_PROMISCUOUS_ENABLE;
+	priv->mac_control &= ~CMD_ACT_MAC_PROMISCUOUS_ENABLE;
 	if (*new_flags & (FIF_ALLMULTI) ||
 	    multicast > MRVDRV_MAX_MULTICAST_LIST_SIZE) {
 		priv->mac_control |= CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 07626cc21d6e..4994269f4ac1 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1554,8 +1554,6 @@ static void mac80211_hwsim_configure_filter(struct ieee80211_hw *hw,
 	wiphy_debug(hw->wiphy, "%s\n", __func__);
 
 	data->rx_filter = 0;
-	if (*total_flags & FIF_PROMISC_IN_BSS)
-		data->rx_filter |= FIF_PROMISC_IN_BSS;
 	if (*total_flags & FIF_ALLMULTI)
 		data->rx_filter |= FIF_ALLMULTI;
 
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 95921167b53f..b71fc74d14ab 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5192,7 +5192,7 @@ mwl8k_configure_filter_sniffer(struct ieee80211_hw *hw,
 		priv->sniffer_enabled = true;
 	}
 
-	*total_flags &=	FIF_PROMISC_IN_BSS | FIF_ALLMULTI |
+	*total_flags &=	FIF_ALLMULTI |
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL |
 			FIF_OTHER_BSS;
 
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 275408eaf95e..257a9eadd595 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -351,8 +351,7 @@ int p54_setup_mac(struct p54_common *priv)
 		 * "TRANSPARENT and PROMISCUOUS are mutually exclusive"
 		 * STSW45X0C LMAC API - page 12
 		 */
-		if (((priv->filter_flags & FIF_PROMISC_IN_BSS) ||
-		     (priv->filter_flags & FIF_OTHER_BSS)) &&
+		if (priv->filter_flags & FIF_OTHER_BSS &&
 		    (mode != P54_FILTER_TYPE_PROMISCUOUS))
 			mode |= P54_FILTER_TYPE_TRANSPARENT;
 	} else {
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index e79674f73dc5..2947ad21053c 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -395,13 +395,11 @@ static void p54_configure_filter(struct ieee80211_hw *dev,
 {
 	struct p54_common *priv = dev->priv;
 
-	*total_flags &= FIF_PROMISC_IN_BSS |
-			FIF_ALLMULTI |
-			FIF_OTHER_BSS;
+	*total_flags &= FIF_ALLMULTI | FIF_OTHER_BSS;
 
 	priv->filter_flags = *total_flags;
 
-	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS))
+	if (changed_flags & FIF_OTHER_BSS)
 		p54_setup_mac(priv);
 
 	if (changed_flags & FIF_ALLMULTI || multicast)
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index bdf5590ba304..7da138892026 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -273,10 +273,8 @@ static void rt2400pci_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_PLCPFAIL));
 	rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL,
 			   !(filter_flags & FIF_CONTROL));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
-			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME, 1);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
-			   !(filter_flags & FIF_PROMISC_IN_BSS) &&
 			   !rt2x00dev->intf_ap_count);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
 	rt2x00mmio_register_write(rt2x00dev, RXCSR0, reg);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 79f4fe65a119..4ea53aa9ede3 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -274,10 +274,8 @@ static void rt2500pci_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_PLCPFAIL));
 	rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL,
 			   !(filter_flags & FIF_CONTROL));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
-			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME, 1);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
-			   !(filter_flags & FIF_PROMISC_IN_BSS) &&
 			   !rt2x00dev->intf_ap_count);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 05c64597838d..237bbb54c7a8 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -434,10 +434,8 @@ static void rt2500usb_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_PLCPFAIL));
 	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CONTROL,
 			   !(filter_flags & FIF_CONTROL));
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_NOT_TO_ME,
-			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_NOT_TO_ME, 1);
 	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_TODS,
-			   !(filter_flags & FIF_PROMISC_IN_BSS) &&
 			   !rt2x00dev->intf_ap_count);
 	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_VERSION_ERROR, 1);
 	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_MULTICAST,
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index be2d54f257b1..09135192c516 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1513,8 +1513,7 @@ void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_FCSFAIL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PHY_ERROR,
 			   !(filter_flags & FIF_PLCPFAIL));
-	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_TO_ME,
-			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_TO_ME, 1);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_MY_BSSD, 0);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_VER_ERROR, 1);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_MULTICAST,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 300876df056f..1b8a459a412b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -359,8 +359,7 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 	    FIF_PLCPFAIL |
 	    FIF_CONTROL |
 	    FIF_PSPOLL |
-	    FIF_OTHER_BSS |
-	    FIF_PROMISC_IN_BSS;
+	    FIF_OTHER_BSS;
 
 	/*
 	 * Apply some rules to the filters:
@@ -369,9 +368,6 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 	 * - Multicast filter seems to kill broadcast traffic so never use it.
 	 */
 	*total_flags |= FIF_ALLMULTI;
-	if (*total_flags & FIF_OTHER_BSS ||
-	    *total_flags & FIF_PROMISC_IN_BSS)
-		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
 
 	/*
 	 * If the device has a single filter for all control frames,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 819455009fe4..c8a967247a9a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -530,10 +530,8 @@ static void rt61pci_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_PLCPFAIL));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
 			   !(filter_flags & (FIF_CONTROL | FIF_PSPOLL)));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
-			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
-			   !(filter_flags & FIF_PROMISC_IN_BSS) &&
 			   !rt2x00dev->intf_ap_count);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index a5458cf01fb2..65ce3afb888a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -480,10 +480,8 @@ static void rt73usb_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_PLCPFAIL));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
 			   !(filter_flags & (FIF_CONTROL | FIF_PSPOLL)));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
-			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
-			   !(filter_flags & FIF_PROMISC_IN_BSS) &&
 			   !rt2x00dev->intf_ap_count);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
diff --git a/drivers/net/wireless/rtlwifi/core.h b/drivers/net/wireless/rtlwifi/core.h
index 82733c6b8c46..782ac2fc4b28 100644
--- a/drivers/net/wireless/rtlwifi/core.h
+++ b/drivers/net/wireless/rtlwifi/core.h
@@ -27,8 +27,7 @@
 #define __RTL_CORE_H__
 
 #define RTL_SUPPORTED_FILTERS		\
-	(FIF_PROMISC_IN_BSS | \
-	FIF_ALLMULTI | FIF_CONTROL | \
+	(FIF_ALLMULTI | FIF_CONTROL | \
 	FIF_OTHER_BSS | \
 	FIF_FCSFAIL | \
 	FIF_BCN_PRBRESP_PROMISC)
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 5d54d16a59e7..f238ee54226c 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -763,8 +763,7 @@ static u64 wl1251_op_prepare_multicast(struct ieee80211_hw *hw,
 	return (u64)(unsigned long)fp;
 }
 
-#define WL1251_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
-				  FIF_ALLMULTI | \
+#define WL1251_SUPPORTED_FILTERS (FIF_ALLMULTI | \
 				  FIF_FCSFAIL | \
 				  FIF_BCN_PRBRESP_PROMISC | \
 				  FIF_CONTROL | \
@@ -795,10 +794,6 @@ static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 	wl->rx_config = WL1251_DEFAULT_RX_CONFIG;
 	wl->rx_filter = WL1251_DEFAULT_RX_FILTER;
 
-	if (*total & FIF_PROMISC_IN_BSS) {
-		wl->rx_config |= CFG_BSSID_FILTER_EN;
-		wl->rx_config |= CFG_RX_ALL_GOOD;
-	}
 	if (*total & FIF_ALLMULTI)
 		/*
 		 * CFG_MC_FILTER_EN in rx_config needs to be 0 to receive
@@ -825,7 +820,7 @@ static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	if (*total & FIF_ALLMULTI || *total & FIF_PROMISC_IN_BSS)
+	if (*total & FIF_ALLMULTI)
 		ret = wl1251_acx_group_address_tbl(wl, false, NULL, 0);
 	else if (fp)
 		ret = wl1251_acx_group_address_tbl(wl, fp->enabled,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 34cef10aefc5..257b9d5821a6 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3175,8 +3175,7 @@ static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw,
 	return (u64)(unsigned long)fp;
 }
 
-#define WL1271_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
-				  FIF_ALLMULTI | \
+#define WL1271_SUPPORTED_FILTERS (FIF_ALLMULTI | \
 				  FIF_FCSFAIL | \
 				  FIF_BCN_PRBRESP_PROMISC | \
 				  FIF_CONTROL | \
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index e7af261e9198..89b6f69f09c8 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1230,7 +1230,7 @@ static u64 zd_op_prepare_multicast(struct ieee80211_hw *hw,
 }
 
 #define SUPPORTED_FIF_FLAGS \
-	(FIF_PROMISC_IN_BSS | FIF_ALLMULTI | FIF_FCSFAIL | FIF_CONTROL | \
+	(FIF_ALLMULTI | FIF_FCSFAIL | FIF_CONTROL | \
 	FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC)
 static void zd_op_configure_filter(struct ieee80211_hw *hw,
 			unsigned int changed_flags,
@@ -1256,7 +1256,7 @@ static void zd_op_configure_filter(struct ieee80211_hw *hw,
 	 * we will have some issue with IPv6 which uses multicast for link
 	 * layer address resolution.
 	 */
-	if (*new_flags & (FIF_PROMISC_IN_BSS | FIF_ALLMULTI))
+	if (*new_flags & FIF_ALLMULTI)
 		zd_mc_add_all(&hash);
 
 	spin_lock_irqsave(&mac->lock, flags);
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 4bb4f8ee4132..6b2f813afb52 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1516,21 +1516,12 @@ static void vnt_configure(struct ieee80211_hw *hw,
 	struct vnt_private *priv = hw->priv;
 	u8 rx_mode = 0;
 
-	*total_flags &= FIF_ALLMULTI | FIF_OTHER_BSS | FIF_PROMISC_IN_BSS |
-		FIF_BCN_PRBRESP_PROMISC;
+	*total_flags &= FIF_ALLMULTI | FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC;
 
 	VNSvInPortB(priv->PortOffset + MAC_REG_RCR, &rx_mode);
 
 	dev_dbg(&priv->pcid->dev, "rx mode in = %x\n", rx_mode);
 
-	if (changed_flags & FIF_PROMISC_IN_BSS) {
-		/* unconditionally log net taps */
-		if (*total_flags & FIF_PROMISC_IN_BSS)
-			rx_mode |= RCR_UNICAST;
-		else
-			rx_mode &= ~RCR_UNICAST;
-	}
-
 	if (changed_flags & FIF_ALLMULTI) {
 		if (*total_flags & FIF_ALLMULTI) {
 			unsigned long flags;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ab3ab84cb0a7..0d97b6457ead 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -785,8 +785,7 @@ static void vnt_configure(struct ieee80211_hw *hw,
 	u8 rx_mode = 0;
 	int rc;
 
-	*total_flags &= FIF_ALLMULTI | FIF_OTHER_BSS | FIF_PROMISC_IN_BSS |
-		FIF_BCN_PRBRESP_PROMISC;
+	*total_flags &= FIF_ALLMULTI | FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC;
 
 	rc = vnt_control_in(priv, MESSAGE_TYPE_READ, MAC_REG_RCR,
 		MESSAGE_REQUEST_MACREG, sizeof(u8), &rx_mode);
@@ -796,14 +795,6 @@ static void vnt_configure(struct ieee80211_hw *hw,
 
 	dev_dbg(&priv->usb->dev, "rx mode in = %x\n", rx_mode);
 
-	if (changed_flags & FIF_PROMISC_IN_BSS) {
-		/* unconditionally log net taps */
-		if (*total_flags & FIF_PROMISC_IN_BSS)
-			rx_mode |= RCR_UNICAST;
-		else
-			rx_mode &= ~RCR_UNICAST;
-	}
-
 	if (changed_flags & FIF_ALLMULTI) {
 		if (*total_flags & FIF_ALLMULTI) {
 			if (priv->mc_list_count > 2)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0af7464ef57b..4feb74da5eaf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2507,10 +2507,6 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * stack. It is always safe to pass more frames than requested,
  * but this has negative impact on power consumption.
  *
- * @FIF_PROMISC_IN_BSS: promiscuous mode within your BSS,
- *	think of the BSS as your network segment and then this corresponds
- *	to the regular ethernet device promiscuous mode.
- *
  * @FIF_ALLMULTI: pass all multicast frames, this is used if requested
  *	by the user or if the hardware is not capable of filtering by
  *	multicast address.
@@ -2527,8 +2523,8 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  *	mac80211 needs to do and the amount of CPU wakeups, so you should
  *	honour this flag if possible.
  *
- * @FIF_CONTROL: pass control frames (except for PS Poll), if PROMISC_IN_BSS
- * 	is not set then only those addressed to this station.
+ * @FIF_CONTROL: pass control frames (except for PS Poll) addressed to this
+ *	station
  *
  * @FIF_OTHER_BSS: pass frames destined to other BSSes
  *
@@ -2538,7 +2534,6 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * @FIF_PROBE_REQ: pass probe request frames
  */
 enum ieee80211_filter_flags {
-	FIF_PROMISC_IN_BSS	= 1<<0,
 	FIF_ALLMULTI		= 1<<1,
 	FIF_FCSFAIL		= 1<<2,
 	FIF_PLCPFAIL		= 1<<3,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 556051f68ad7..7d12ba5a4a36 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -725,7 +725,6 @@ struct ieee80211_if_mesh {
  * enum ieee80211_sub_if_data_flags - virtual interface flags
  *
  * @IEEE80211_SDATA_ALLMULTI: interface wants all multicast packets
- * @IEEE80211_SDATA_PROMISC: interface is promisc
  * @IEEE80211_SDATA_OPERATING_GMODE: operating in G-only mode
  * @IEEE80211_SDATA_DONT_BRIDGE_PACKETS: bridge packets between
  *	associated stations and deliver multicast frames both
@@ -735,7 +734,6 @@ struct ieee80211_if_mesh {
  */
 enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_ALLMULTI		= BIT(0),
-	IEEE80211_SDATA_PROMISC			= BIT(1),
 	IEEE80211_SDATA_OPERATING_GMODE		= BIT(2),
 	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(3),
 	IEEE80211_SDATA_DISCONNECT_RESUME	= BIT(4),
@@ -1211,8 +1209,8 @@ struct ieee80211_local {
 
 	atomic_t agg_queue_stop[IEEE80211_MAX_QUEUES];
 
-	/* number of interfaces with corresponding IFF_ flags */
-	atomic_t iff_allmultis, iff_promiscs;
+	/* number of interfaces with allmulti RX */
+	atomic_t iff_allmultis;
 
 	struct rate_control_ref *rate_ctrl;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b4ac596a7cb7..7791a08a560a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -697,9 +697,6 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
 		atomic_inc(&local->iff_allmultis);
 
-	if (sdata->flags & IEEE80211_SDATA_PROMISC)
-		atomic_inc(&local->iff_promiscs);
-
 	if (coming_up)
 		local->open_count++;
 
@@ -827,13 +824,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	WARN_ON_ONCE((sdata->vif.type != NL80211_IFTYPE_WDS && flushed > 0) ||
 		     (sdata->vif.type == NL80211_IFTYPE_WDS && flushed != 1));
 
-	/* don't count this interface for promisc/allmulti while it is down */
+	/* don't count this interface for allmulti while it is down */
 	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
 		atomic_dec(&local->iff_allmultis);
 
-	if (sdata->flags & IEEE80211_SDATA_PROMISC)
-		atomic_dec(&local->iff_promiscs);
-
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		local->fif_pspoll--;
 		local->fif_probe_req--;
@@ -1047,12 +1041,10 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	int allmulti, promisc, sdata_allmulti, sdata_promisc;
+	int allmulti, sdata_allmulti;
 
 	allmulti = !!(dev->flags & IFF_ALLMULTI);
-	promisc = !!(dev->flags & IFF_PROMISC);
 	sdata_allmulti = !!(sdata->flags & IEEE80211_SDATA_ALLMULTI);
-	sdata_promisc = !!(sdata->flags & IEEE80211_SDATA_PROMISC);
 
 	if (allmulti != sdata_allmulti) {
 		if (dev->flags & IFF_ALLMULTI)
@@ -1062,13 +1054,6 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
 		sdata->flags ^= IEEE80211_SDATA_ALLMULTI;
 	}
 
-	if (promisc != sdata_promisc) {
-		if (dev->flags & IFF_PROMISC)
-			atomic_inc(&local->iff_promiscs);
-		else
-			atomic_dec(&local->iff_promiscs);
-		sdata->flags ^= IEEE80211_SDATA_PROMISC;
-	}
 	spin_lock_bh(&local->filter_lock);
 	__hw_addr_sync(&local->mc_list, &dev->mc, dev->addr_len);
 	spin_unlock_bh(&local->filter_lock);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ea31f119234b..b144de971366 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -41,9 +41,6 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
 	unsigned int changed_flags;
 	unsigned int new_flags = 0;
 
-	if (atomic_read(&local->iff_promiscs))
-		new_flags |= FIF_PROMISC_IN_BSS;
-
 	if (atomic_read(&local->iff_allmultis))
 		new_flags |= FIF_ALLMULTI;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6e3b564b6dea..99fb5d80e60a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2331,11 +2331,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_frames);
 	ieee80211_add_pending_skb(local, fwd_skb);
  out:
-	if (is_multicast_ether_addr(hdr->addr1) ||
-	    sdata->dev->flags & IFF_PROMISC)
+	if (is_multicast_ether_addr(hdr->addr1))
 		return RX_CONTINUE;
-	else
-		return RX_DROP_MONITOR;
+	return RX_DROP_MONITOR;
 }
 #endif
 
@@ -3266,12 +3264,8 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 		if (!bssid && !sdata->u.mgd.use_4addr)
 			return false;
 		if (!multicast &&
-		    !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
-			if (!(sdata->dev->flags & IFF_PROMISC) ||
-			    sdata->u.mgd.use_4addr)
-				return false;
-			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
-		}
+		    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
+			return false;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		if (!bssid)
@@ -3285,9 +3279,7 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 			return false;
 		} else if (!multicast &&
 			   !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
-			if (!(sdata->dev->flags & IFF_PROMISC))
-				return false;
-			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
+			return false;
 		} else if (!rx->sta) {
 			int rate_idx;
 			if (status->flag & (RX_FLAG_HT | RX_FLAG_VHT))
@@ -3309,12 +3301,7 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 		} else if (!multicast &&
 			   !ether_addr_equal(sdata->dev->dev_addr,
 					     hdr->addr1)) {
-			/* if we are in promisc mode we also accept
-			 * packets not destined for us
-			 */
-			if (!(sdata->dev->flags & IFF_PROMISC))
-				return false;
-			rx->flags &= ~IEEE80211_RX_RA_MATCH;
+			return false;
 		} else if (!rx->sta) {
 			int rate_idx;
 			if (status->flag & RX_FLAG_HT)
@@ -3327,12 +3314,8 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		if (!multicast &&
-		    !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
-			if (!(sdata->dev->flags & IFF_PROMISC))
-				return false;
-
-			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
-		}
+		    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
+			return false;
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_AP:
-- 
2.1.4

