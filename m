Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:43799 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668Ab1CaVez convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 17:34:55 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Hauke Mehrtens <hauke@hauke-m.de>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"lrodriguez@atheros.com" <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Frank Huang <frankh@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Marc Yang <yangyang@marvell.com>
Date: Thu, 31 Mar 2011 14:34:38 -0700
Subject: RE: [PATCH 1/5] compat-wireless: add support for mwifiex
Message-ID: <477F20668A386D41ADCC57781B1F704307FA844A89@SC-VEXCH1.marvell.com>
References: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Hauke Mehrtens [mailto:hauke@hauke-m.de]
> Sent: Thursday, March 31, 2011 9:22 AM
> To: mcgrof@gmail.com; lrodriguez@atheros.com
> Cc: linux-wireless@vger.kernel.org; Hauke Mehrtens; Bing Zhao
> Subject: [PATCH 1/5] compat-wireless: add support for mwifiex
> 
> This adds support for mwifiex into compat-wireless.
> 
> This is only compile tested as I do not have such a device.

Hi Hauke and Luis,

I'm getting an error in "compat-wireless-2.6.39-rc1-3-s/net/wireless/util.c:799" while compiling compat-wireless-2.6.39-rc1-3-s.tar.bz2.


/home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s/config.mk:204: "WARNING: CONFIG_CFG80211_WEXT will be deactivated or not working because kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface like iwconfig will not work. To activate it build your kernel e.g. with CONFIG_LIBIPW=m."

...

/home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s/net/wireless/util.c: In function 'cfg80211_change_iface':
/home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s/net/wireless/util.c:799: error: implicit declaration of function 'br_port_exists'
make[3]: *** [/home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s/net/wireless/util.o] Error 1
make[2]: *** [/home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s/net/wireless] Error 2
make[1]: *** [_module_/home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s] Error 2
make: *** [modules] Error 2


I have wireless-testing.git master-2011-03-30 (2.6.39-rc1).

Could you please help?

Thanks,

Bing

> 
> CC: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  config.mk                                 |    4 +
>  patches/01-netdev.patch                   |   11 ++++
>  patches/25-multicast-list_head.patch      |   42 ++++++++++++--
>  patches/26-sdio-quirks.patch              |   12 ++++
>  patches/29-libertas_sdio_no_suspend.patch |   34 -----------
>  patches/29-sdio_no_suspend.patch          |   86 +++++++++++++++++++++++++++++
>  scripts/admin-update.sh                   |    1 +
>  7 files changed, 151 insertions(+), 39 deletions(-)
>  delete mode 100644 patches/29-libertas_sdio_no_suspend.patch
>  create mode 100644 patches/29-sdio_no_suspend.patch

