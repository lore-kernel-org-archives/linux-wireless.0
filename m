Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54158 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaCOHvo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 03:51:44 -0400
Message-ID: <53240683.1000305@rempel-privat.de> (sfid-20140315_085215_392199_2F26A765)
Date: Sat, 15 Mar 2014 08:51:31 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 00/23] ath9k|ath9k_htc: move dups to common-beacon
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de> <21266.37896.937680.416439@gargle.gargle.HOWL> <5312DD46.3030800@rempel-privat.de> <21266.58035.719712.344551@gargle.gargle.HOWL> <20140306184235.GA7788@tuxdriver.com> <5319978F.6060803@rempel-privat.de> <21273.40172.734118.220513@gargle.gargle.HOWL> <531DD589.1090109@rempel-privat.de> <20140314192212.GD20339@tuxdriver.com>
In-Reply-To: <20140314192212.GD20339@tuxdriver.com>
Content-Type: multipart/mixed;
 boundary="------------040905020308020906090306"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040905020308020906090306
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Am 14.03.2014 20:22, schrieb John W. Linville:
> On Mon, Mar 10, 2014 at 04:08:57PM +0100, Oleksij Rempel wrote:
>> Am 07.03.2014 11:18, schrieb Sujith Manoharan:
>>> Oleksij Rempel wrote:
>>>> Last response was about initvals, my patch set affect only beacon code.
>>>> Since i don't plan to rewrite ath9k_htc from scratch, i would assume it
>>>> will be better to continue this periodic clean work.
>>>
>>> I didn't review the patches, but someone else needs to make sure that
>>> nothing is broken in ath9k.
>>
>> I use this code one week ind STA mode. But if you need more directed
>> alternate testing, who is good candidate for this work?
> 
> I applied the series and attempted a build.  But...
> 
>   CC      drivers/net/wireless/ath/ath9k/tx99.o
> In file included from include/linux/bitops.h:33:0,
>                  from include/linux/kernel.h:10,
>                  from include/linux/skbuff.h:17,
>                  from include/linux/if_ether.h:23,
>                  from include/linux/etherdevice.h:25,
>                  from drivers/net/wireless/ath/ath9k/ath9k.h:20,
>                  from drivers/net/wireless/ath/ath9k/tx99.c:17:
> drivers/net/wireless/ath/ath9k/tx99.c: In function ‘ath9k_tx99_init’:
> drivers/net/wireless/ath/ath9k/tx99.c:111:15: error: ‘SC_OP_INVALID’ undeclared (first use in this function)
>   if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
>                ^
> /home/linville/git/wireless-next/arch/x86/include/asm/bitops.h:338:25: note: in definition of macro ‘test_bit’
>   (__builtin_constant_p((nr))  \
>                          ^
> drivers/net/wireless/ath/ath9k/tx99.c:111:15: note: each undeclared identifier is reported only once for each function it appears in
>   if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
>                ^
> /home/linville/git/wireless-next/arch/x86/include/asm/bitops.h:338:25: note: in definition of macro ‘test_bit’
>   (__builtin_constant_p((nr))  \
>                          ^
> drivers/net/wireless/ath/ath9k/tx99.c:111:33: error: ‘struct ath_softc’ has no member named ‘sc_flags’
>   if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
>                                  ^
> /home/linville/git/wireless-next/arch/x86/include/asm/bitops.h:339:30: note: in definition of macro ‘test_bit’
>    ? constant_test_bit((nr), (addr)) \
>                               ^
> drivers/net/wireless/ath/ath9k/tx99.c:111:33: error: ‘struct ath_softc’ has no member named ‘sc_flags’
>   if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
>                                  ^
> /home/linville/git/wireless-next/arch/x86/include/asm/bitops.h:340:30: note: in definition of macro ‘test_bit’
>    : variable_test_bit((nr), (addr)))
>                               ^
> make[3]: *** [drivers/net/wireless/ath/ath9k/tx99.o] Error 1
> make[2]: *** [drivers/net/wireless/ath/ath9k] Error 2
> make[1]: *** [drivers/net/wireless/ath] Error 2
> make: *** [drivers/net/wireless/] Error 2
> 
> I'll be backing this out for now...

thank you. I missed CONFIG_EXPERT :/
in attachment is second version of affected patch.

-- 
Regards,
Oleksij

--------------040905020308020906090306
Content-Type: text/x-patch;
 name="0001-ath9k-move-sc_flags-to-ath_common.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-ath9k-move-sc_flags-to-ath_common.patch"

=46rom 7b2ff07b8b01362ac5ab8395ce5000ae3cf81c57 Mon Sep 17 00:00:00 2001
From: Oleksij Rempel <linux@rempel-privat.de>
Date: Thu, 27 Feb 2014 11:40:46 +0100
Subject: [PATCH 05/23 v2] ath9k: move sc_flags to ath_common

we will need it for ath9k_htc, may be other drivers too

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath.h          | 10 ++++++++
 drivers/net/wireless/ath/ath9k/ahb.c    |  7 ++---
 drivers/net/wireless/ath/ath9k/ath9k.h  | 10 --------
 drivers/net/wireless/ath/ath9k/beacon.c | 18 +++++++------
 drivers/net/wireless/ath/ath9k/debug.c  |  2 +-
 drivers/net/wireless/ath/ath9k/link.c   | 16 +++++++-----
 drivers/net/wireless/ath/ath9k/main.c   | 45 ++++++++++++++++++---------=
------
 drivers/net/wireless/ath/ath9k/mci.c    |  2 +-
 drivers/net/wireless/ath/ath9k/pci.c    |  8 +++---
 drivers/net/wireless/ath/ath9k/tx99.c   |  2 +-
 drivers/net/wireless/ath/ath9k/wow.c    |  4 +--
 drivers/net/wireless/ath/ath9k/xmit.c   |  9 ++++---
 12 files changed, 73 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/at=
h.h
index d239acc..a889fd6 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -56,6 +56,15 @@ enum ath_device_state {
 	ATH_HW_INITIALIZED,
 };
=20
+enum ath_op_flags {
+	ATH_OP_INVALID,
+	ATH_OP_BEACONS,
+	ATH_OP_ANI_RUN,
+	ATH_OP_PRIM_STA_VIF,
+	ATH_OP_HW_RESET,
+	ATH_OP_SCANNING,
+};
+
 enum ath_bus_type {
 	ATH_PCI,
 	ATH_AHB,
@@ -130,6 +139,7 @@ struct ath_common {
 	struct ieee80211_hw *hw;
 	int debug_mask;
 	enum ath_device_state state;
+	unsigned long op_flags;
=20
 	struct ath_ani ani;
=20
diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/=
ath/ath9k/ahb.c
index 2dff276..a5684c3 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -82,6 +82,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	int irq;
 	int ret =3D 0;
 	struct ath_hw *ah;
+	struct ath_common *common;
 	char hw_name[64];
=20
 	if (!dev_get_platdata(&pdev->dev)) {
@@ -124,9 +125,6 @@ static int ath_ahb_probe(struct platform_device *pdev=
)
 	sc->mem =3D mem;
 	sc->irq =3D irq;
=20
-	/* Will be cleared in ath9k_start() */
-	set_bit(SC_OP_INVALID, &sc->sc_flags);
-
 	ret =3D request_irq(irq, ath_isr, IRQF_SHARED, "ath9k", sc);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
@@ -144,6 +142,9 @@ static int ath_ahb_probe(struct platform_device *pdev=
)
 	wiphy_info(hw->wiphy, "%s mem=3D0x%lx, irq=3D%d\n",
 		   hw_name, (unsigned long)mem, irq);
=20
+	common =3D ath9k_hw_common(sc->sc_ah);
+	/* Will be cleared in ath9k_start() */
+	set_bit(ATH_OP_INVALID, &common->op_flags);
 	return 0;
=20
  err_irq:
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireles=
s/ath/ath9k/ath9k.h
index b54bcae..7f87f33 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -688,15 +688,6 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct =
ath_rx_status *rs);
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
 #define MAX_GTT_CNT             5
=20
-enum sc_op_flags {
-	SC_OP_INVALID,
-	SC_OP_BEACONS,
-	SC_OP_ANI_RUN,
-	SC_OP_PRIM_STA_VIF,
-	SC_OP_HW_RESET,
-	SC_OP_SCANNING,
-};
-
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
 #define PS_WAIT_FOR_CAB           BIT(1)
@@ -726,7 +717,6 @@ struct ath_softc {
 	struct completion paprd_complete;
 	wait_queue_head_t tx_wait;
=20
-	unsigned long sc_flags;
 	unsigned long driver_data;
=20
 	u8 gtt_cnt;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wirele=
ss/ath/ath9k/beacon.c
index 02eb4f1..6372671 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -328,7 +328,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 	bool edma =3D !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
 	int slot;
=20
-	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags)) {
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags)) {
 		ath_dbg(common, RESET,
 			"reset work is pending, skip beaconing now\n");
 		return;
@@ -524,7 +524,7 @@ static void ath9k_beacon_config_sta(struct ath_softc =
*sc,
 	u64 tsf;
=20
 	/* No need to configure beacon if we are not associated */
-	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+	if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
 		ath_dbg(common, BEACON,
 			"STA is not yet associated..skipping beacon config\n");
 		return;
@@ -629,7 +629,7 @@ static void ath9k_beacon_config_adhoc(struct ath_soft=
c *sc,
 	 * joiner case in IBSS mode.
 	 */
 	if (!conf->ibss_creator && conf->enable_beacon)
-		set_bit(SC_OP_BEACONS, &sc->sc_flags);
+		set_bit(ATH_OP_BEACONS, &common->op_flags);
 }
=20
 static bool ath9k_allow_beacon_config(struct ath_softc *sc,
@@ -649,7 +649,7 @@ static bool ath9k_allow_beacon_config(struct ath_soft=
c *sc,
=20
 	if (sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_STATION) {
 		if ((vif->type =3D=3D NL80211_IFTYPE_STATION) &&
-		    test_bit(SC_OP_BEACONS, &sc->sc_flags) &&
+		    test_bit(ATH_OP_BEACONS, &common->op_flags) &&
 		    !avp->primary_sta_vif) {
 			ath_dbg(common, CONFIG,
 				"Beacon already configured for a station interface\n");
@@ -700,6 +700,8 @@ void ath9k_beacon_config(struct ath_softc *sc, struct=
 ieee80211_vif *vif,
 {
 	struct ieee80211_bss_conf *bss_conf =3D &vif->bss_conf;
 	struct ath_beacon_config *cur_conf =3D &sc->cur_beacon_conf;
+        struct ath_hw *ah =3D sc->sc_ah;
+        struct ath_common *common =3D ath9k_hw_common(ah);
 	unsigned long flags;
 	bool skip_beacon =3D false;
=20
@@ -712,7 +714,7 @@ void ath9k_beacon_config(struct ath_softc *sc, struct=
 ieee80211_vif *vif,
 	if (sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_STATION) {
 		ath9k_cache_beacon_config(sc, bss_conf);
 		ath9k_set_beacon(sc);
-		set_bit(SC_OP_BEACONS, &sc->sc_flags);
+		set_bit(ATH_OP_BEACONS, &common->op_flags);
 		return;
 	}
=20
@@ -751,13 +753,13 @@ void ath9k_beacon_config(struct ath_softc *sc, stru=
ct ieee80211_vif *vif,
 		}
=20
 		/*
-		 * Do not set the SC_OP_BEACONS flag for IBSS joiner mode
+		 * Do not set the ATH_OP_BEACONS flag for IBSS joiner mode
 		 * here, it is done in ath9k_beacon_config_adhoc().
 		 */
 		if (cur_conf->enable_beacon && !skip_beacon)
-			set_bit(SC_OP_BEACONS, &sc->sc_flags);
+			set_bit(ATH_OP_BEACONS, &common->op_flags);
 		else
-			clear_bit(SC_OP_BEACONS, &sc->sc_flags);
+			clear_bit(ATH_OP_BEACONS, &common->op_flags);
 	}
 }
=20
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireles=
s/ath/ath9k/debug.c
index f8924ef..016a872 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -210,7 +210,7 @@ static ssize_t write_file_ani(struct file *file,
 	common->disable_ani =3D !ani;
=20
 	if (common->disable_ani) {
-		clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+		clear_bit(ATH_OP_ANI_RUN, &common->op_flags);
 		ath_stop_ani(sc);
 	} else {
 		ath_check_ani(sc);
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless=
/ath/ath9k/link.c
index 30dcef5..72a715f 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -115,13 +115,14 @@ void ath_hw_pll_work(struct work_struct *work)
 	u32 pll_sqsum;
 	struct ath_softc *sc =3D container_of(work, struct ath_softc,
 					    hw_pll_work.work);
+	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
 	/*
 	 * ensure that the PLL WAR is executed only
 	 * after the STA is associated (or) if the
 	 * beaconing had started in interfaces that
 	 * uses beacons.
 	 */
-	if (!test_bit(SC_OP_BEACONS, &sc->sc_flags))
+	if (!test_bit(ATH_OP_BEACONS, &common->op_flags))
 		return;
=20
 	if (sc->tx99_state)
@@ -414,7 +415,7 @@ void ath_start_ani(struct ath_softc *sc)
 	unsigned long timestamp =3D jiffies_to_msecs(jiffies);
=20
 	if (common->disable_ani ||
-	    !test_bit(SC_OP_ANI_RUN, &sc->sc_flags) ||
+	    !test_bit(ATH_OP_ANI_RUN, &common->op_flags) ||
 	    (sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
 		return;
=20
@@ -438,6 +439,7 @@ void ath_stop_ani(struct ath_softc *sc)
 void ath_check_ani(struct ath_softc *sc)
 {
 	struct ath_hw *ah =3D sc->sc_ah;
+	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
 	struct ath_beacon_config *cur_conf =3D &sc->cur_beacon_conf;
=20
 	/*
@@ -453,23 +455,23 @@ void ath_check_ani(struct ath_softc *sc)
 			 * Disable ANI only when there are no
 			 * associated stations.
 			 */
-			if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
+			if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags))
 				goto stop_ani;
 		}
 	} else if (ah->opmode =3D=3D NL80211_IFTYPE_STATION) {
-		if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
+		if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags))
 			goto stop_ani;
 	}
=20
-	if (!test_bit(SC_OP_ANI_RUN, &sc->sc_flags)) {
-		set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+	if (!test_bit(ATH_OP_ANI_RUN, &common->op_flags)) {
+		set_bit(ATH_OP_ANI_RUN, &common->op_flags);
 		ath_start_ani(sc);
 	}
=20
 	return;
=20
 stop_ani:
-	clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+	clear_bit(ATH_OP_ANI_RUN, &common->op_flags);
 	ath_stop_ani(sc);
 }
=20
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless=
/ath/ath9k/main.c
index 42a1803..d69853b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -229,16 +229,16 @@ static bool ath_complete_reset(struct ath_softc *sc=
, bool start)
 	ath9k_cmn_update_txpow(ah, sc->curtxpow,
 			       sc->config.txpowlimit, &sc->curtxpow);
=20
-	clear_bit(SC_OP_HW_RESET, &sc->sc_flags);
+	clear_bit(ATH_OP_HW_RESET, &common->op_flags);
 	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
=20
 	if (!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL) && start) {
-		if (!test_bit(SC_OP_BEACONS, &sc->sc_flags))
+		if (!test_bit(ATH_OP_BEACONS, &common->op_flags))
 			goto work;
=20
 		if (ah->opmode =3D=3D NL80211_IFTYPE_STATION &&
-		    test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+		    test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
 			spin_lock_irqsave(&sc->sc_pm_lock, flags);
 			sc->ps_flags |=3D PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
 			spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
@@ -336,7 +336,7 @@ static int ath_set_channel(struct ath_softc *sc, stru=
ct cfg80211_chan_def *chand
 	int old_pos =3D -1;
 	int r;
=20
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags))
+	if (test_bit(ATH_OP_INVALID, &common->op_flags))
 		return -EIO;
=20
 	offchannel =3D !!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL);
@@ -402,7 +402,7 @@ static int ath_set_channel(struct ath_softc *sc, stru=
ct cfg80211_chan_def *chand
 			chan->center_freq);
 	} else {
 		/* perform spectral scan if requested. */
-		if (test_bit(SC_OP_SCANNING, &sc->sc_flags) &&
+		if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
 			sc->spectral_mode =3D=3D SPECTRAL_CHANSCAN)
 			ath9k_spectral_scan_trigger(hw);
 	}
@@ -566,6 +566,7 @@ irqreturn_t ath_isr(int irq, void *dev)
=20
 	struct ath_softc *sc =3D dev;
 	struct ath_hw *ah =3D sc->sc_ah;
+	struct ath_common *common =3D ath9k_hw_common(ah);
 	enum ath9k_int status;
 	u32 sync_cause =3D 0;
 	bool sched =3D false;
@@ -575,7 +576,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 	 * touch anything. Note this can happen early
 	 * on if the IRQ is shared.
 	 */
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags))
+	if (test_bit(ATH_OP_INVALID, &common->op_flags))
 		return IRQ_NONE;
=20
 	/* shared irq, not for us */
@@ -583,7 +584,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (!ath9k_hw_intrpend(ah))
 		return IRQ_NONE;
=20
-	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags)) {
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags)) {
 		ath9k_hw_kill_interrupts(ah);
 		return IRQ_HANDLED;
 	}
@@ -684,10 +685,11 @@ int ath_reset(struct ath_softc *sc)
=20
 void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type)
 {
+	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
 #ifdef CONFIG_ATH9K_DEBUGFS
 	RESET_STAT_INC(sc, type);
 #endif
-	set_bit(SC_OP_HW_RESET, &sc->sc_flags);
+	set_bit(ATH_OP_HW_RESET, &common->op_flags);
 	ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 }
=20
@@ -768,7 +770,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
=20
 	ath_mci_enable(sc);
=20
-	clear_bit(SC_OP_INVALID, &sc->sc_flags);
+	clear_bit(ATH_OP_INVALID, &common->op_flags);
 	sc->sc_ah->is_monitoring =3D false;
=20
 	if (!ath_complete_reset(sc, false))
@@ -885,7 +887,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
=20
 	ath_cancel_work(sc);
=20
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
+	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
 		ath_dbg(common, ANY, "Device not present\n");
 		mutex_unlock(&sc->mutex);
 		return;
@@ -940,7 +942,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
=20
 	ath9k_ps_restore(sc);
=20
-	set_bit(SC_OP_INVALID, &sc->sc_flags);
+	set_bit(ATH_OP_INVALID, &common->op_flags);
 	sc->ps_idle =3D prev_idle;
=20
 	mutex_unlock(&sc->mutex);
@@ -1081,7 +1083,7 @@ static void ath9k_calculate_summary_state(struct ie=
ee80211_hw *hw,
 	 */
 	if (ah->opmode =3D=3D NL80211_IFTYPE_STATION &&
 	    old_opmode =3D=3D NL80211_IFTYPE_AP &&
-	    test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+	    test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
 		ieee80211_iterate_active_interfaces_atomic(
 			sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
 			ath9k_sta_vif_iter, sc);
@@ -1590,7 +1592,7 @@ static void ath9k_set_assoc_state(struct ath_softc =
*sc,
 	struct ieee80211_bss_conf *bss_conf =3D &vif->bss_conf;
 	unsigned long flags;
=20
-	set_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
+	set_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
 	avp->primary_sta_vif =3D true;
=20
 	/*
@@ -1625,8 +1627,9 @@ static void ath9k_bss_assoc_iter(void *data, u8 *ma=
c, struct ieee80211_vif *vif)
 {
 	struct ath_softc *sc =3D data;
 	struct ieee80211_bss_conf *bss_conf =3D &vif->bss_conf;
+	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
=20
-	if (test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
+	if (test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags))
 		return;
=20
 	if (bss_conf->assoc)
@@ -1657,18 +1660,18 @@ static void ath9k_bss_info_changed(struct ieee802=
11_hw *hw,
 			bss_conf->bssid, bss_conf->assoc);
=20
 		if (avp->primary_sta_vif && !bss_conf->assoc) {
-			clear_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
+			clear_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
 			avp->primary_sta_vif =3D false;
=20
 			if (ah->opmode =3D=3D NL80211_IFTYPE_STATION)
-				clear_bit(SC_OP_BEACONS, &sc->sc_flags);
+				clear_bit(ATH_OP_BEACONS, &common->op_flags);
 		}
=20
 		ieee80211_iterate_active_interfaces_atomic(
 			sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
 			ath9k_bss_assoc_iter, sc);
=20
-		if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags) &&
+		if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags) &&
 		    ah->opmode =3D=3D NL80211_IFTYPE_STATION) {
 			memset(common->curbssid, 0, ETH_ALEN);
 			common->curaid =3D 0;
@@ -1897,7 +1900,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, u3=
2 queues, bool drop)
 		return;
 	}
=20
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
+	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
 		ath_dbg(common, ANY, "Device not present\n");
 		mutex_unlock(&sc->mutex);
 		return;
@@ -2070,13 +2073,15 @@ static int ath9k_get_antenna(struct ieee80211_hw =
*hw, u32 *tx_ant, u32 *rx_ant)
 static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc =3D hw->priv;
-	set_bit(SC_OP_SCANNING, &sc->sc_flags);
+	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
+	set_bit(ATH_OP_SCANNING, &common->op_flags);
 }
=20
 static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc =3D hw->priv;
-	clear_bit(SC_OP_SCANNING, &sc->sc_flags);
+	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
+	clear_bit(ATH_OP_SCANNING, &common->op_flags);
 }
=20
 static void ath9k_channel_switch_beacon(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/=
ath/ath9k/mci.c
index 71799fc..a0dbcc4 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -555,7 +555,7 @@ void ath_mci_intr(struct ath_softc *sc)
 		mci_int_rxmsg &=3D ~AR_MCI_INTERRUPT_RX_MSG_GPM;
=20
 		while (more_data =3D=3D MCI_GPM_MORE) {
-			if (test_bit(SC_OP_HW_RESET, &sc->sc_flags))
+			if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
 				return;
=20
 			pgpm =3D mci->gpm_buf.bf_addr;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/=
ath/ath9k/pci.c
index 55724b0..25304ad 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -784,6 +784,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
 {
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
+	struct ath_common *common;
 	u8 csz;
 	u32 val;
 	int ret =3D 0;
@@ -858,9 +859,6 @@ static int ath_pci_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
 	sc->mem =3D pcim_iomap_table(pdev)[0];
 	sc->driver_data =3D id->driver_data;
=20
-	/* Will be cleared in ath9k_start() */
-	set_bit(SC_OP_INVALID, &sc->sc_flags);
-
 	ret =3D request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath9k", sc);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
@@ -879,6 +877,10 @@ static int ath_pci_probe(struct pci_dev *pdev, const=
 struct pci_device_id *id)
 	wiphy_info(hw->wiphy, "%s mem=3D0x%lx, irq=3D%d\n",
 		   hw_name, (unsigned long)sc->mem, pdev->irq);
=20
+	/* Will be cleared in ath9k_start() */
+	common =3D ath9k_hw_common(sc->sc_ah);
+	set_bit(ATH_OP_INVALID, &common->op_flags);
+
 	return 0;
=20
 err_init:
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless=
/ath/ath9k/tx99.c
index b686a74..a65cfb9 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -108,7 +108,7 @@ static int ath9k_tx99_init(struct ath_softc *sc)
 	struct ath_tx_control txctl;
 	int r;
=20
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
+	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
 		ath_err(common,
 			"driver is in invalid state unable to use TX99");
 		return -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/=
ath/ath9k/wow.c
index 1b3230f..2879887 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -198,7 +198,7 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 	ath_cancel_work(sc);
 	ath_stop_ani(sc);
=20
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
+	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
 		ath_dbg(common, ANY, "Device not present\n");
 		ret =3D -EINVAL;
 		goto fail_wow;
@@ -224,7 +224,7 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 	 * STA.
 	 */
=20
-	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+	if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
 		ath_dbg(common, WOW, "None of the STA vifs are associated\n");
 		ret =3D 1;
 		goto fail_wow;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless=
/ath/ath9k/xmit.c
index 550e4d2b..81d8a70 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1769,7 +1769,7 @@ bool ath_drain_all_txq(struct ath_softc *sc)
 	int i;
 	u32 npend =3D 0;
=20
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags))
+	if (test_bit(ATH_OP_INVALID, &common->op_flags))
 		return true;
=20
 	ath9k_hw_abort_tx_dma(ah);
@@ -1817,11 +1817,12 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct=
 ath_txq *txq)
  */
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 {
+	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_ac *ac, *last_ac;
 	struct ath_atx_tid *tid, *last_tid;
 	bool sent =3D false;
=20
-	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags) ||
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags) ||
 	    list_empty(&txq->axq_acq))
 		return;
=20
@@ -2471,7 +2472,7 @@ static void ath_tx_processq(struct ath_softc *sc, s=
truct ath_txq *txq)
=20
 	ath_txq_lock(sc, txq);
 	for (;;) {
-		if (test_bit(SC_OP_HW_RESET, &sc->sc_flags))
+		if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
 			break;
=20
 		if (list_empty(&txq->axq_q)) {
@@ -2554,7 +2555,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 	int status;
=20
 	for (;;) {
-		if (test_bit(SC_OP_HW_RESET, &sc->sc_flags))
+		if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
 			break;
=20
 		status =3D ath9k_hw_txprocdesc(ah, NULL, (void *)&ts);
--=20
1.9.0


--------------040905020308020906090306--
