Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21462 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab2KUHYg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 02:24:36 -0500
Date: Wed, 21 Nov 2012 15:24:13 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [wireless-next:master 203/214]
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:573:17: sparse: Using plain integer as NULL pointer
Message-ID: <50ac819d.deUknDDzRBMUnMNp%fengguang.wu@intel.com> (sfid-20121121_082439_760367_FBCCF7D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   e2ff0498409af6f2023f91aba07b281e5e87ee15
commit: b353dda485038d5033b066cc946dfcf66afae128 [203/214] brcmsmac: Use debug macros for general error and debug statements


sparse warnings:

+ drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:573:17: sparse: Using plain integer as NULL pointer
drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:1311:6: sparse: context imbalance in 'brcms_down' - unexpected unlock
drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:1598:6: sparse: context imbalance in 'brcms_rfkill_set_hw_state' - unexpected unlock

vim +573 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c

5b435de0 Arend van Spriel 2011-10-05  557  static void
5b435de0 Arend van Spriel 2011-10-05  558  brcms_ops_configure_filter(struct ieee80211_hw *hw,
5b435de0 Arend van Spriel 2011-10-05  559  			unsigned int changed_flags,
5b435de0 Arend van Spriel 2011-10-05  560  			unsigned int *total_flags, u64 multicast)
5b435de0 Arend van Spriel 2011-10-05  561  {
5b435de0 Arend van Spriel 2011-10-05  562  	struct brcms_info *wl = hw->priv;
b353dda4 Seth Forshee     2012-11-15  563  	struct bcma_device *core = wl->wlc->hw->d11core;
5b435de0 Arend van Spriel 2011-10-05  564  
5b435de0 Arend van Spriel 2011-10-05  565  	changed_flags &= MAC_FILTERS;
5b435de0 Arend van Spriel 2011-10-05  566  	*total_flags &= MAC_FILTERS;
be667669 Alwin Beukers    2011-11-22  567  
5b435de0 Arend van Spriel 2011-10-05  568  	if (changed_flags & FIF_PROMISC_IN_BSS)
b353dda4 Seth Forshee     2012-11-15  569  		brcms_dbg_info(core, "FIF_PROMISC_IN_BSS\n");
5b435de0 Arend van Spriel 2011-10-05  570  	if (changed_flags & FIF_ALLMULTI)
b353dda4 Seth Forshee     2012-11-15  571  		brcms_dbg_info(core, "FIF_ALLMULTI\n");
5b435de0 Arend van Spriel 2011-10-05  572  	if (changed_flags & FIF_FCSFAIL)
b353dda4 Seth Forshee     2012-11-15 @573  		brcms_dbg_info(core, 0, "FIF_FCSFAIL\n");
5b435de0 Arend van Spriel 2011-10-05  574  	if (changed_flags & FIF_CONTROL)
b353dda4 Seth Forshee     2012-11-15  575  		brcms_dbg_info(core, "FIF_CONTROL\n");
5b435de0 Arend van Spriel 2011-10-05  576  	if (changed_flags & FIF_OTHER_BSS)
b353dda4 Seth Forshee     2012-11-15  577  		brcms_dbg_info(core, "FIF_OTHER_BSS\n");
be667669 Alwin Beukers    2011-11-22  578  	if (changed_flags & FIF_PSPOLL)
b353dda4 Seth Forshee     2012-11-15  579  		brcms_dbg_info(core, "FIF_PSPOLL\n");
be667669 Alwin Beukers    2011-11-22  580  	if (changed_flags & FIF_BCN_PRBRESP_PROMISC)
b353dda4 Seth Forshee     2012-11-15  581  		brcms_dbg_info(core, "FIF_BCN_PRBRESP_PROMISC\n");

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
