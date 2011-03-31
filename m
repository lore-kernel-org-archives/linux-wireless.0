Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54402 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab1CaWBv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 18:01:51 -0400
Message-ID: <4D94F9C8.9060804@hauke-m.de>
Date: Fri, 01 Apr 2011 00:01:44 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>
CC: "mcgrof@gmail.com" <mcgrof@gmail.com>,
	"lrodriguez@atheros.com" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Frank Huang <frankh@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Marc Yang <yangyang@marvell.com>
Subject: Re: [PATCH 1/5] compat-wireless: add support for mwifiex
References: <1301588527-16615-1-git-send-email-hauke@hauke-m.de> <477F20668A386D41ADCC57781B1F704307FA844A89@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FA844A89@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On 03/31/2011 11:34 PM, Bing Zhao wrote:
>> Subject: [PATCH 1/5] compat-wireless: add support for mwifiex
>>
>> This adds support for mwifiex into compat-wireless.
>>
>> This is only compile tested as I do not have such a device.
> 
> Hi Hauke and Luis,
> 
> I'm getting an error in "compat-wireless-2.6.39-rc1-3-s/net/wireless/util.c:799" while compiling compat-wireless-2.6.39-rc1-3-s.tar.bz2.

mwifiex is not integrated in the last compat-wireless release from today
it will be in compat-wireless-2011-04-01.
The kernel version number in the compat-wireless release is the version
the code is from. So compat-wireless-2.6.39-rc1-3-s is based on the
source code from kernel version 2.6.39-rc1, it should compile and work
with every kernel from 2.6.24 to 2.6.39.

You could build your own version based on the latest version of
linux-next. It is described at:
http://wireless.kernel.org/en/users/Download/hacking

I created a self made version with the lasted fixes for compat-wireless
and and mwifiex at:
http://hauke-m.de/fileadmin/openwrt/compat-wireless-2011-03-31-1.tar.bz2

> /home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s/config.mk:204: "WARNING: CONFIG_CFG80211_WEXT will be deactivated or not working because kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface like iwconfig will not work. To activate it build your kernel e.g. with CONFIG_LIBIPW=m."

This just says that the wext interface will not work, because your
kernel was compiled with CONFIG_WIRELESS_EXT=n, if you do not need wext
just ignore it otherwise compile your kernel with CONFIG_WIRELESS_EXT
enabled.

> /home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s/net/wireless/util.c: In function 'cfg80211_change_iface':
> /home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s/net/wireless/util.c:799: error: implicit declaration of function 'br_port_exists'
> make[3]: *** [/home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s/net/wireless/util.o] Error 1
> make[2]: *** [/home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s/net/wireless] Error 2
> make[1]: *** [_module_/home/bzhao/git-10.80.114.125/mwifiex-devel/compat-wireless-2.6.39-rc1-3-s] Error 2
> make: *** [modules] Error 2

This is a bug which will be fixed in the next release. ;-)
Build your own compat-wireless version from git, wait till tomorrow or
use my version at this will be fixed.

Hauke
