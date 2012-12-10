Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23291 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2LJWVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:21:32 -0500
Date: Tue, 11 Dec 2012 01:21:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kbuild@01.org
Subject: [wireless-next:master 345/347]
 drivers/net/wireless/ath/ath9k/init.c:636 ath9k_init_softc() error: we
 previously assumed 'pdata' could be null (see line 582)
Message-ID: <20121210222108.GS22569@mwanda> (sfid-20121210_232138_426400_C9201848)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gabor,

FYI, there are new smatch warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   78f18df4b323d2ac14d6c82e2fc3c8dc4556bccc
commit: ab5c4f71d8c7add173a2d32e5beefdaaf1b7cbbc [345/347] ath9k: allow to load EEPROM content via firmware API

+ drivers/net/wireless/ath/ath9k/init.c:636 ath9k_init_softc() error: we previously assumed 'pdata' could be null (see line 582)
+ drivers/net/wireless/ath/ath9k/init.c:647 ath9k_init_softc() warn: variable dereferenced before check 'pdata' (see line 639)

git remote update wireless-next
git checkout ab5c4f71d8c7add173a2d32e5beefdaaf1b7cbbc
vim +636 +/pdata drivers/net/wireless/ath/ath9k/init.c

845e03c9 Felix Fietkau             2011-03-23  576  	ah->reg_ops.rmw = ath9k_reg_rmw;
e8fe7336 Rajkumar Manoharan        2011-08-05  577  	atomic_set(&ah->intr_ref_cnt, -1);
285f2dda Sujith                    2010-01-08  578  	sc->sc_ah = ah;
285f2dda Sujith                    2010-01-08  579  
8e92d3f2 Zefir Kurtisi             2012-04-03  580  	sc->dfs_detector = dfs_pattern_detector_init(NL80211_DFS_UNSET);
8e92d3f2 Zefir Kurtisi             2012-04-03  581  
6de66dd9 Felix Fietkau             2011-03-19 @582  	if (!pdata) {
a05b5d45 Felix Fietkau             2010-11-17  583  		ah->ah_flags |= AH_USE_EEPROM;
6de66dd9 Felix Fietkau             2011-03-19  584  		sc->sc_ah->led_pin = -1;
6de66dd9 Felix Fietkau             2011-03-19  585  	} else {
6de66dd9 Felix Fietkau             2011-03-19  586  		sc->sc_ah->gpio_mask = pdata->gpio_mask;
6de66dd9 Felix Fietkau             2011-03-19  587  		sc->sc_ah->gpio_val = pdata->gpio_val;
6de66dd9 Felix Fietkau             2011-03-19  588  		sc->sc_ah->led_pin = pdata->led_pin;
f2f5f2a1 Vasanthakumar Thiagarajan 2011-04-19  589  		ah->is_clk_25mhz = pdata->is_clk_25mhz;
3762561a Gabor Juhos               2011-06-21  590  		ah->get_mac_revision = pdata->get_mac_revision;
7d95847c Gabor Juhos               2011-06-21  591  		ah->external_reset = pdata->external_reset;
6de66dd9 Felix Fietkau             2011-03-19  592  	}
a05b5d45 Felix Fietkau             2010-11-17  593  
285f2dda Sujith                    2010-01-08  594  	common = ath9k_hw_common(ah);
f9f84e96 Felix Fietkau             2011-03-23  595  	common->ops = &ah->reg_ops;
285f2dda Sujith                    2010-01-08  596  	common->bus_ops = bus_ops;
285f2dda Sujith                    2010-01-08  597  	common->ah = ah;
285f2dda Sujith                    2010-01-08  598  	common->hw = sc->hw;
285f2dda Sujith                    2010-01-08  599  	common->priv = sc;
285f2dda Sujith                    2010-01-08  600  	common->debug_mask = ath9k_debug;
8f5dcb1c Vasanthakumar Thiagarajan 2010-11-26  601  	common->btcoex_enabled = ath9k_btcoex_enable == 1;
05c0be2f Mohammed Shafi Shajakhan  2011-05-26  602  	common->disable_ani = false;
e09f2dc7 Sujith Manoharan          2012-09-16  603  
e09f2dc7 Sujith Manoharan          2012-09-16  604  	/*
e09f2dc7 Sujith Manoharan          2012-09-16  605  	 * Enable Antenna diversity only when BTCOEX is disabled
e09f2dc7 Sujith Manoharan          2012-09-16  606  	 * and the user manually requests the feature.
e09f2dc7 Sujith Manoharan          2012-09-16  607  	 */
e09f2dc7 Sujith Manoharan          2012-09-16  608  	if (!common->btcoex_enabled && ath9k_enable_diversity)
e09f2dc7 Sujith Manoharan          2012-09-16  609  		common->antenna_diversity = 1;
e09f2dc7 Sujith Manoharan          2012-09-16  610  
20b25744 Ben Greear                2010-10-15  611  	spin_lock_init(&common->cc_lock);
285f2dda Sujith                    2010-01-08  612  
285f2dda Sujith                    2010-01-08  613  	spin_lock_init(&sc->sc_serial_rw);
285f2dda Sujith                    2010-01-08  614  	spin_lock_init(&sc->sc_pm_lock);
285f2dda Sujith                    2010-01-08  615  	mutex_init(&sc->mutex);
5baec742 Felix Fietkau             2012-03-03  616  #ifdef CONFIG_ATH9K_MAC_DEBUG
5baec742 Felix Fietkau             2012-03-03  617  	spin_lock_init(&sc->debug.samp_lock);
5baec742 Felix Fietkau             2012-03-03  618  #endif
285f2dda Sujith                    2010-01-08  619  	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
fb6e252f Sujith Manoharan          2012-07-17  620  	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
285f2dda Sujith                    2010-01-08  621  		     (unsigned long)sc);
285f2dda Sujith                    2010-01-08  622  
aaa1ec46 Sujith Manoharan          2012-06-04  623  	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
aaa1ec46 Sujith Manoharan          2012-06-04  624  	INIT_WORK(&sc->hw_check_work, ath_hw_check);
aaa1ec46 Sujith Manoharan          2012-06-04  625  	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
aaa1ec46 Sujith Manoharan          2012-06-04  626  	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
aaa1ec46 Sujith Manoharan          2012-06-04  627  	setup_timer(&sc->rx_poll_timer, ath_rx_poll, (unsigned long)sc);
aaa1ec46 Sujith Manoharan          2012-06-04  628  
285f2dda Sujith                    2010-01-08  629  	/*
285f2dda Sujith                    2010-01-08  630  	 * Cache line size is used to size and align various
285f2dda Sujith                    2010-01-08  631  	 * structures used to communicate with the hardware.
285f2dda Sujith                    2010-01-08  632  	 */
285f2dda Sujith                    2010-01-08  633  	ath_read_cachesize(common, &csz);
285f2dda Sujith                    2010-01-08  634  	common->cachelsz = csz << 2; /* convert to bytes */
285f2dda Sujith                    2010-01-08  635  
ab5c4f71 Gabor Juhos               2012-12-10 @636  	if (pdata->eeprom_name) {
ab5c4f71 Gabor Juhos               2012-12-10  637  		ret = ath9k_eeprom_request(sc, pdata->eeprom_name);
ab5c4f71 Gabor Juhos               2012-12-10  638  		if (ret)
ab5c4f71 Gabor Juhos               2012-12-10 @639  			goto err_eeprom;
ab5c4f71 Gabor Juhos               2012-12-10  640  	}
ab5c4f71 Gabor Juhos               2012-12-10  641  
d70357d5 Luis R. Rodriguez         2010-04-15  642  	/* Initializes the hardware for all supported chipsets */
285f2dda Sujith                    2010-01-08  643  	ret = ath9k_hw_init(ah);
d70357d5 Luis R. Rodriguez         2010-04-15  644  	if (ret)
285f2dda Sujith                    2010-01-08  645  		goto err_hw;
55624204 Sujith                    2010-01-08  646  
6fb1b1e1 Felix Fietkau             2011-03-19 @647  	if (pdata && pdata->macaddr)
6fb1b1e1 Felix Fietkau             2011-03-19  648  		memcpy(common->macaddr, pdata->macaddr, ETH_ALEN);
6fb1b1e1 Felix Fietkau             2011-03-19  649  
285f2dda Sujith                    2010-01-08  650  	ret = ath9k_init_queues(sc);

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
