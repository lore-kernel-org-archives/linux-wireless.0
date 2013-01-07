Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39469 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab3AGUPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 15:15:20 -0500
Date: Mon, 7 Jan 2013 15:00:06 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Golle <dgolle@allnet.de>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	juhosg@openwrt.org, john@phrozen.org
Subject: Re: [rt2x00-users] [PATCH 0/3] introduce rt2x00_platform
Message-ID: <20130107200005.GA2203@tuxdriver.com> (sfid-20130107_211523_451878_80B0027B)
References: <20121211100336.GA7807@earthship.arig>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121211100336.GA7807@earthship.arig>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 11, 2012 at 12:03:39PM +0200, Daniel Golle wrote:
> On embedded systems built-in or PCIe connected WiFi modules usually lack their
> own EEPROM and use a mtd partition instead of that. In OpenWrt, this is solved
> by requesting a firmware and the handling the resulting hotplug call in
> userspace which will then extract the needed file from mtd and supply it to
> the driver.
> In other cases, PCIe modules might come with an actual EEPROM, but yet some
> board-specific hacks are required, such as disabling bands or overriding the
> modules MAC address with a board-supplied one.
> 
> The original author of those patches is Gabor Juhos.
> According to his remarks, 3 patches related to overriding the whole eeprom and
> introducing rt2x00_platform.h were merged into a single patch.
> 
> Daniel Golle (3):
>   rt2x00: allow overriding eeprom through platform_data
>   rt2x00: allow disabling bands through platform_data
>   rt2x00: add platform_data mac address
> 
>  drivers/net/wireless/rt2x00/Kconfig        |  4 ++
>  drivers/net/wireless/rt2x00/Makefile       |  1 +
>  drivers/net/wireless/rt2x00/rt2800pci.c    | 34 ++++++-----
>  drivers/net/wireless/rt2x00/rt2x00.h       | 10 +++
>  drivers/net/wireless/rt2x00/rt2x00dev.c    | 37 +++++++++++
>  drivers/net/wireless/rt2x00/rt2x00eeprom.c | 98 ++++++++++++++++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2x00lib.h    | 16 +++++
>  drivers/net/wireless/rt2x00/rt2x00pci.c    |  7 +++
>  drivers/net/wireless/rt2x00/rt2x00soc.c    |  1 +
>  drivers/net/wireless/rt2x00/rt61pci.c      |  5 ++
>  include/linux/rt2x00_platform.h            | 23 +++++++
>  11 files changed, 222 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/net/wireless/rt2x00/rt2x00eeprom.c
>  create mode 100644 include/linux/rt2x00_platform.h

It looks like we need a repost of this series?  I'm dropping the old series...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
