Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12025 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673Ab2K2BOC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 20:14:02 -0500
Date: Thu, 29 Nov 2012 09:13:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: kbuild@01.org, Julia Lawall <julia.lawall@lip6.fr>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [wireless-next:master 207/237]
 drivers/net/wireless/brcm80211/brcmsmac/dma.c:352:20-24: ERROR: di is NULL
 but dereferenced.
Message-ID: <20121129011337.GA5785@localhost> (sfid-20121129_021406_884902_92F7C410)
References: <50b6477a.KNKuUJi++FBSGGYg%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50b6477a.KNKuUJi++FBSGGYg%fengguang.wu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Seth,

FYI, there are coccinelle warnings in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   0751f8654602e4255f0b9c17784d8100d5896010
commit: 90123e045cac4ce8ec13e266f030c618fa674554 [207/237] brcmsmac: Add brcms_dbg_dma() debug macro

+ drivers/net/wireless/brcm80211/brcmsmac/dma.c:352:20-24: ERROR: di is NULL but dereferenced.

vim +352 drivers/net/wireless/brcm80211/brcmsmac/dma.c

5b435de0 Arend van Spriel 2011-10-05  336  
5b435de0 Arend van Spriel 2011-10-05  337  static uint ntxdactive(struct dma_info *di, uint h, uint t)
5b435de0 Arend van Spriel 2011-10-05  338  {
5b435de0 Arend van Spriel 2011-10-05  339  	return txd(di, t-h);
5b435de0 Arend van Spriel 2011-10-05  340  }
5b435de0 Arend van Spriel 2011-10-05  341  
5b435de0 Arend van Spriel 2011-10-05  342  static uint nrxdactive(struct dma_info *di, uint h, uint t)
5b435de0 Arend van Spriel 2011-10-05  343  {
5b435de0 Arend van Spriel 2011-10-05  344  	return rxd(di, t-h);
5b435de0 Arend van Spriel 2011-10-05  345  }
5b435de0 Arend van Spriel 2011-10-05  346  
5b435de0 Arend van Spriel 2011-10-05  347  static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
5b435de0 Arend van Spriel 2011-10-05  348  {
ae8e4672 Arend van Spriel 2011-10-29  349  	uint dmactrlflags;
5b435de0 Arend van Spriel 2011-10-05  350  
5b435de0 Arend van Spriel 2011-10-05  351  	if (di == NULL) {
90123e04 Seth Forshee     2012-11-15 @352  		brcms_dbg_dma(di->core, "NULL dma handle\n");
5b435de0 Arend van Spriel 2011-10-05  353  		return 0;
5b435de0 Arend van Spriel 2011-10-05  354  	}
5b435de0 Arend van Spriel 2011-10-05  355  
ae8e4672 Arend van Spriel 2011-10-29  356  	dmactrlflags = di->dma.dmactrlflags;
5b435de0 Arend van Spriel 2011-10-05  357  	dmactrlflags &= ~mask;
5b435de0 Arend van Spriel 2011-10-05  358  	dmactrlflags |= flags;
5b435de0 Arend van Spriel 2011-10-05  359  
5b435de0 Arend van Spriel 2011-10-05  360  	/* If trying to enable parity, check if parity is actually supported */

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
