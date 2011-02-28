Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57141 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab1B1Tas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 14:30:48 -0500
Date: Mon, 28 Feb 2011 14:17:29 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: netdev@vger.kernel.org, jcliburn@gmail.com, chris.snook@gmail.com,
	jie.yang@atheros.com, romieu@fr.zoreil.com, sorbica@icplus.com.tw,
	cooldavid@cooldavid.org, Larry.Finger@lwfinger.net,
	chaoming_li@realsil.com.cn, e1000-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: use pci_dev->revision, again
Message-ID: <20110228191728.GE2515@tuxdriver.com>
References: <201102282136.44374.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201102282136.44374.sshtylyov@ru.mvista.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 28, 2011 at 09:36:43PM +0300, Sergei Shtylyov wrote:
> Several more network drivers that read the device's revision ID
> from the PCI configuration register were merged after the commit
> 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all drivers
> to use pci_device->revision), so it's time to do another pass of
> conversion to using the 'revision' field of 'struct pci_dev'...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> ---
> The patch is against the recent Linus' tree.
> 
>  drivers/net/atl1e/atl1e_main.c          |    2 +-
>  drivers/net/atlx/atl2.c                 |    2 +-
>  drivers/net/cnic.c                      |   14 +++++---------
>  drivers/net/e1000e/ethtool.c            |    6 ++----
>  drivers/net/igbvf/ethtool.c             |    6 ++----
>  drivers/net/igbvf/netdev.c              |    3 +--
>  drivers/net/ipg.c                       |    4 +---
>  drivers/net/ixgbevf/ixgbevf_main.c      |    2 +-
>  drivers/net/jme.c                       |    2 +-
>  drivers/net/vxge/vxge-main.c            |   18 +-----------------
>  drivers/net/wireless/iwlwifi/iwl-3945.c |    4 +---
>  drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
>  drivers/net/wireless/rtlwifi/pci.c      |    4 +---
>  13 files changed, 19 insertions(+), 50 deletions(-)

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
