Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58852 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXKICCe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2007 21:02:34 -0500
Subject: Re: [PATCH 3/5] iwlwifi: cleanup namespace
From: Zhu Yi <yi.zhu@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20071108182254.GA32063@lst.de>
References: <11944155883607-git-send-email-reinette.chatre@intel.com>
	 <1194415589137-git-send-email-reinette.chatre@intel.com>
	 <11944155913421-git-send-email-reinette.chatre@intel.com>
	 <11944155923015-git-send-email-reinette.chatre@intel.com>
	 <20071108182254.GA32063@lst.de>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 09:53:41 +0800
Message-Id: <1194573222.31257.366.camel@debian.sh.intel.com> (sfid-20071109_020240_305360_1D32A0CB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2007-11-08 at 19:22 +0100, Christoph Hellwig wrote:
> Any chance we can get this whole patch series into 2.6.24?  It's just
> a blind cleanup of the symbols and having two new drivers that can't
> be built into the kernel or loaded into the kernel is rather
> embarassing.

No. It's not a that "simple" cleanup. We actually found a endless
recursive bug in your previous patch (already fixed in this one). There
is a static iwl_init_hw_rates() in iwl4965-base.c and there is also a
public iwl4965_init_hw_rates() in iwl-4965.c. When you do the string
replacement, it became a endless recursive for iwl4965_init_hw_rates().

Furthermore, although both of the drivers can be built into kernel at
the same time, it is useless if you do so now. Because if you make a
network driver build in the kernel, it is initialized in a very early
stage (before hd, sata). Currently the iwlwifi drivers (I think also
other wireless drivers) load the firmware in pci_probe(), we have to
move it to interface open() time to resolve this problem. But this is
not so easy as it looks like: iwlwifi drivers cannot get MAC address
before firmware is loaded and running, but mac80211 requires MAC address
from the driver when ieee80211_register_hw() is called.
ieee80211_register_hw() creates the wlan0 interface. You have no
interface if you don't call ieee80211_register_hw() at pci_probe()...

I'll come up a patch to delay the device MAC address get until
wlan0->start() is called for mac80211. So that I can delay the firmware
loading from pci probe to interface open time for iwlwifi drivers. In
conclusion, the patch only makes iwlwifi drivers compile but not work
for the kernel build in case. More patches will come. And we have to
target it for 2.6.25.

Thanks,
-yi
