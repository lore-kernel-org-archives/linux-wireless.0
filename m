Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm25-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.73]:28371 "EHLO
	nm25-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759710Ab3BYKfr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 05:35:47 -0500
References: <1361616101.52110.YahooMailNeo@web124704.mail.ne1.yahoo.com> <5129FD42.5020202@hauke-m.de>
Message-ID: <1361788546.95773.YahooMailNeo@web124704.mail.ne1.yahoo.com> (sfid-20130225_113554_552855_F9ACDA4D)
Date: Mon, 25 Feb 2013 02:35:46 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Reply-To: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: compat-wireless/drivers - slew of warnings and issues (older kernel)
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"backports@vger.kernel.org" <backports@vger.kernel.org>
In-Reply-To: <5129FD42.5020202@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke

To answer your questions. The compat-drivers I'm quoting is 3.7.6.1-stable and from the daily build tars (2.20.13).
GCC version is 4.2.3

C-D compiles, but as noted with a tonne of warnings. We have several servers with specific purposes running 2.6.24 kernels and I decided to try a C-D on them.
I guess the question now is, do we drop support for c-wireless/drivers for 2.6.24 - 2.6.29(?) and bump the minimum kernel to a 2.6.30?

Walter





----- Original Message -----
From: Hauke Mehrtens <hauke@hauke-m.de>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>; Luis R. Rodriguez <mcgrof@gmail.com>; "backports@vger.kernel.org" <backports@vger.kernel.org>
Sent: Sunday, February 24, 2013 1:45 PM
Subject: Re: compat-wireless/drivers - slew of warnings and issues (older kernel)

On 02/23/2013 11:41 AM, Walter Goldens wrote:
> A recent (stable) compat-wireless/drivers compilation exhibited a great deal of warnings on an older kernel (2.6.24  to 2.6.30 I think). Is 2.6.24 still supported?

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
>   CC [M]  /drivers/net/wireless/rt2x00/rt2x00dev.o
> /include/net/cfg80211.h: In function ‘wiphy_name’:
> /include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type

I do not get these warnings when compiling compat-drivers-3.8 against
kernel 2.6.30. There are some other warnings with gcc 4.7 therefor I
used "export KCFLAGS="-Wno-unused-but-set-variable"" with these old
kernels, newer kernel versions already do this in the main Makefile.

Hauke

