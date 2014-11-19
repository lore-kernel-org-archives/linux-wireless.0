Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40798 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbaKSUJG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 15:09:06 -0500
Message-ID: <1416427738.9374.27.camel@sipsolutions.net> (sfid-20141119_210911_086728_5AD2A1AE)
Subject: Re: [mac80211-next:master 75/115]
 include/linux/unaligned/be_struct.h:6:19: error: redefinition of
 'get_unaligned_be16'
From: Johannes Berg <johannes@sipsolutions.net>
To: Fengguang Wu <fengguang.wu@intel.com>,
	Arend van Spriel <arend@broadcom.com>
Cc: "Kaufman, Liad" <liad.kaufman@intel.com>,
	"kbuild-all@01.org" <kbuild-all@01.org>,
	Arik Nemtsov <arik@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 19 Nov 2014 21:08:58 +0100
In-Reply-To: <201411200314.fjIX4L3M%fengguang.wu@intel.com>
References: <201411200314.fjIX4L3M%fengguang.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-19 at 19:13 +0000, Wu, Fengguang wrote:

>    In file included from arch/microblaze/include/asm/unaligned.h:21:0,
>                     from include/linux/ieee80211.h:22,
>                     from drivers/net/wireless/brcm80211/include/brcmu_wifi.h:21,
>                     from drivers/net/wireless/brcm80211/brcmfmac/pcie.c:30:
> >> include/linux/unaligned/be_struct.h:6:19: error: redefinition of 'get_unaligned_be16'
>     static inline u16 get_unaligned_be16(const void *p)
>                       ^
>    In file included from drivers/net/wireless/brcm80211/brcmfmac/pcie.c:22:0:
>    include/linux/unaligned/access_ok.h:22:19: note: previous definition of 'get_unaligned_be16' was here
>     static inline u16 get_unaligned_be16(const void *p)
>                       ^

This is a bug in brcmfmac, it shouldn't be including
<linux/unaligned/access_ok.h> but should include <asm/unaligned.h>
instead.

Now that ieee80211.h is doing the latter, but on microblaze using a
different implementation (not access_ok.h), we get the double
definitions here.

Note that this means that this part of brcmfmac is very broken on all
platforms where access_ok.h cannot be used.

johannes

