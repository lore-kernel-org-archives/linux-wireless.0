Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54896 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab3BXLpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 06:45:15 -0500
Message-ID: <5129FD42.5020202@hauke-m.de> (sfid-20130224_124520_926788_54611928)
Date: Sun, 24 Feb 2013 12:45:06 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"backports@vger.kernel.org" <backports@vger.kernel.org>
Subject: Re: compat-wireless/drivers - slew of warnings and issues (older
 kernel)
References: <1361616101.52110.YahooMailNeo@web124704.mail.ne1.yahoo.com>
In-Reply-To: <1361616101.52110.YahooMailNeo@web124704.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2013 11:41 AM, Walter Goldens wrote:
> A recent (stable) compat-wireless/drivers compilation exhibited a great deal of warnings on an older kernel (2.6.24  to 2.6.30 I think). Is 2.6.24 still supported?

What version of compat-drivers are you using?
What version of gcc are your using?

Some parts of compat-drivers are still compiling against kernel 2.6.24,
but I would not recommend using a so old kernel. I haven't done run time
testes with 2.6.24 for a long time.

> Also, there was an issue with 50-compat_firmware.rules. Ubuntu 8.04 looks for it at /lib/udev/rules.d/ which gave me severe problems with firmware loading and system freezes. I had to copy/symlink 50-compat_firmware.rules from /lib/udev/rules.d/ to /etc/udev/rules.d/.

Could you provide a patch for this, I do not have a ubuntu 8.04
installation any more, this is pretty old.

> Warning log (partial). It compiles, but warnings galore. Is anyone up for backporting?
> 
>   CC [M]  /drivers/net/wireless/rt2x00/rt2x00dev.o
> /include/net/cfg80211.h: In function ‘wiphy_name’:
> /include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type

I do not get these warnings when compiling compat-drivers-3.8 against
kernel 2.6.30. There are some other warnings with gcc 4.7 therefor I
used "export KCFLAGS="-Wno-unused-but-set-variable"" with these old
kernels, newer kernel versions already do this in the main Makefile.

Hauke
