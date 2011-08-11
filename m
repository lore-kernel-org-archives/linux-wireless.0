Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49819 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1HKQPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 12:15:32 -0400
Date: Thu, 11 Aug 2011 12:08:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	Adrian Chadd <adrian@freebsd.org>, lrodriguez@atheros.com
Subject: Re: [PATCH -next 0/8] ath9k: ASPM fixes
Message-ID: <20110811160847.GD2566@tuxdriver.com> (sfid-20110811_181536_171754_F7B2FFED)
References: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 05, 2011 at 01:10:31PM +0200, Stanislaw Gruszka wrote:
> This patch series try to fix ath9k ASPM. Some of patches are cleanup
> only or do merging common code (with e1000e driver).
> 
> With CONFIG_PCIEASPM it's possible to change ASPM settings on runtime
> via /sys/module/pcie_aspm/parameters/policy . However most drivers
> I looked at assume this setting is constant. I add a callback to pci
> driver to inform about the change, and allow driver to do needed hw
> related changes. Currently only ath9k implement the callback, but
> I think it will be useful for other drivers i.e. iwlwifi, rtlwifi
> that do some own ASPM handling.
> 
> Would be nice to get some testing on patches on different
> platforms with ath9k devices on kernel compiled with CONFIG_PCIEASPM
> (default) and mixing up commands:
> 
> echo powersave > /sys/module/pcie_aspm/parameters/policy  
> echo performance > /sys/module/pcie_aspm/parameters/policy  
> ifconfig wlan0 down
> ifconfig wlan0 up
> pm-suspend
> 
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: e1000-devel@lists.sourceforge.net
> ---
>  drivers/net/e1000e/netdev.c                |   31 ----------
>  drivers/net/wireless/ath/ath9k/ar9002_hw.c |   12 ---
>  drivers/net/wireless/ath/ath9k/ar9003_hw.c |   12 ---
>  drivers/net/wireless/ath/ath9k/hw-ops.h    |    9 +-
>  drivers/net/wireless/ath/ath9k/hw.c        |   17 +++--
>  drivers/net/wireless/ath/ath9k/hw.h        |   12 +--
>  drivers/net/wireless/ath/ath9k/main.c      |    8 --
>  drivers/net/wireless/ath/ath9k/pci.c       |   88 ++++++++++++++++++++++-------
>  drivers/pci/pcie/Makefile                  |    3 
>  drivers/pci/pcie/aspm.c                    |   46 ++++++++++++++-
>  include/linux/pci-aspm.h                   |    2 
>  include/linux/pci.h                        |    3 
>  12 files changed, 148 insertions(+), 95 deletions(-)

I'm happy to take patches 1-3 through my tree.  But maybe patches 4-8
should go through a PCI tree?  Or at least get some ACKS from the
appropriate maintainers to take these changes through the wireless
trees?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
