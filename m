Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab1HLMgZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 08:36:25 -0400
Date: Fri, 12 Aug 2011 14:35:10 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	Adrian Chadd <adrian@freebsd.org>, lrodriguez@atheros.com,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH -next 0/8] ath9k: ASPM fixes
Message-ID: <20110812123509.GA13328@redhat.com> (sfid-20110812_143627_302345_87131B6A)
References: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
 <20110811160847.GD2566@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110811160847.GD2566@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 11, 2011 at 12:08:48PM -0400, John W. Linville wrote:
> On Fri, Aug 05, 2011 at 01:10:31PM +0200, Stanislaw Gruszka wrote:
> > This patch series try to fix ath9k ASPM. Some of patches are cleanup
> > only or do merging common code (with e1000e driver).
> > 
> > With CONFIG_PCIEASPM it's possible to change ASPM settings on runtime
> > via /sys/module/pcie_aspm/parameters/policy . However most drivers
> > I looked at assume this setting is constant. I add a callback to pci
> > driver to inform about the change, and allow driver to do needed hw
> > related changes. Currently only ath9k implement the callback, but
> > I think it will be useful for other drivers i.e. iwlwifi, rtlwifi
> > that do some own ASPM handling.
> > 
> > Would be nice to get some testing on patches on different
> > platforms with ath9k devices on kernel compiled with CONFIG_PCIEASPM
> > (default) and mixing up commands:
> > 
> > echo powersave > /sys/module/pcie_aspm/parameters/policy  
> > echo performance > /sys/module/pcie_aspm/parameters/policy  
> > ifconfig wlan0 down
> > ifconfig wlan0 up
> > pm-suspend
> > 
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Cc: linux-pci@vger.kernel.org
> > Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Cc: e1000-devel@lists.sourceforge.net
> > ---
> >  drivers/net/e1000e/netdev.c                |   31 ----------
> >  drivers/net/wireless/ath/ath9k/ar9002_hw.c |   12 ---
> >  drivers/net/wireless/ath/ath9k/ar9003_hw.c |   12 ---
> >  drivers/net/wireless/ath/ath9k/hw-ops.h    |    9 +-
> >  drivers/net/wireless/ath/ath9k/hw.c        |   17 +++--
> >  drivers/net/wireless/ath/ath9k/hw.h        |   12 +--
> >  drivers/net/wireless/ath/ath9k/main.c      |    8 --
> >  drivers/net/wireless/ath/ath9k/pci.c       |   88 ++++++++++++++++++++++-------
> >  drivers/pci/pcie/Makefile                  |    3 
> >  drivers/pci/pcie/aspm.c                    |   46 ++++++++++++++-
> >  include/linux/pci-aspm.h                   |    2 
> >  include/linux/pci.h                        |    3 
> >  12 files changed, 148 insertions(+), 95 deletions(-)
> 
> I'm happy to take patches 1-3 through my tree.  But maybe patches 4-8
> should go through a PCI tree?  Or at least get some ACKS from the
> appropriate maintainers to take these changes through the wireless
> trees?

Getting ACKs from Jesse and Jeff would be best since ath9k patches
5 and 8 depends on 1-3. But, crap, seems my scripts does not eval Cc
from email body to actual Cc list. Not sure if pci and e1000 guys
saw these patches. If not, I'm gona repost this set and Cc it
fully to pci and e1000 guys.

Stanislaw
