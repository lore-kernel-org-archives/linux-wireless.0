Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24952 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab3AGVpy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 16:45:54 -0500
Date: Tue, 08 Jan 2013 05:42:50 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [wireless-next:master 3/61]
 drivers/net/wireless/ath/ath9k/mci.c:478:22: warning: unused variable 'buf'
Message-ID: <50eb415a.wnA28ztMgDDb7ipQ%fengguang.wu@intel.com> (sfid-20130107_224558_910188_4A4187BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   e7f767a7d9f809c494bfffffeda2bbdbfec110b4
commit: b81950b165ff71d826fcac851153f9265a83d9ab [3/61] ath9k: use the devres API for allocations/mappings
config: make ARCH=x86_64 allmodconfig

All warnings:

drivers/net/wireless/ath/ath9k/mci.c: In function 'ath_mci_cleanup':
drivers/net/wireless/ath/ath9k/mci.c:478:22: warning: unused variable 'buf' [-Wunused-variable]

vim +/buf +478 drivers/net/wireless/ath/ath9k/mci.c

69c6ac60 Sujith Manoharan         2012-09-26  462  	if (ret) {
69c6ac60 Sujith Manoharan         2012-09-26  463  		ath_err(common, "Failed to initialize MCI\n");
69c6ac60 Sujith Manoharan         2012-09-26  464  		return ret;
69c6ac60 Sujith Manoharan         2012-09-26  465  	}
ea510e4b Sujith Manoharan         2012-02-22  466  
3c7992e3 Rajkumar Manoharan       2012-06-12  467  	INIT_WORK(&sc->mci_work, ath9k_mci_work);
ea510e4b Sujith Manoharan         2012-02-22  468  	ath_dbg(common, MCI, "MCI Initialized\n");
ea510e4b Sujith Manoharan         2012-02-22  469  
ea510e4b Sujith Manoharan         2012-02-22  470  	return 0;
9e25365f Mohammed Shafi Shajakhan 2011-11-30  471  }
9e25365f Mohammed Shafi Shajakhan 2011-11-30  472  
9e25365f Mohammed Shafi Shajakhan 2011-11-30  473  void ath_mci_cleanup(struct ath_softc *sc)
9e25365f Mohammed Shafi Shajakhan 2011-11-30  474  {
ea510e4b Sujith Manoharan         2012-02-22  475  	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
9e25365f Mohammed Shafi Shajakhan 2011-11-30  476  	struct ath_hw *ah = sc->sc_ah;
9e25365f Mohammed Shafi Shajakhan 2011-11-30  477  	struct ath_mci_coex *mci = &sc->mci_coex;
ea510e4b Sujith Manoharan         2012-02-22 @478  	struct ath_mci_buf *buf = &mci->sched_buf;
9e25365f Mohammed Shafi Shajakhan 2011-11-30  479  
9e25365f Mohammed Shafi Shajakhan 2011-11-30  480  	ar9003_mci_cleanup(ah);
ea510e4b Sujith Manoharan         2012-02-22  481  
ea510e4b Sujith Manoharan         2012-02-22  482  	ath_dbg(common, MCI, "MCI De-Initialized\n");
9e25365f Mohammed Shafi Shajakhan 2011-11-30  483  }
19686ddf Mohammed Shafi Shajakhan 2011-11-30  484  
19686ddf Mohammed Shafi Shajakhan 2011-11-30  485  void ath_mci_intr(struct ath_softc *sc)
19686ddf Mohammed Shafi Shajakhan 2011-11-30  486  {

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
