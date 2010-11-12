Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:46452 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab0KLTvw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:51:52 -0500
Date: Fri, 12 Nov 2010 20:51:45 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>
Message-ID: <1298013311.4723.1289591505420.JavaMail.root@idefix>
In-Reply-To: <4CDD9753.80909@openwrt.org>
Subject: Re: [PATCH 8/9] ath5k: AHB port. Add AHB bus support.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: "Felix Fietkau" <nbd@openwrt.org>
> To: "Bob Copeland" <me@bobcopeland.com>
> Cc: "Wojciech Dubowik" <dubowoj@neratec.com>, linville@tuxdriver.com, linux-wireless@vger.kernel.org
> Sent: Freitag, 12. November 2010 20:36:51
> Subject: Re: [PATCH 8/9] ath5k: AHB port. Add AHB bus support.
> On 2010-11-12 8:26 PM, Bob Copeland wrote:
> > On Thu, Nov 11, 2010 at 9:58 AM, Wojciech Dubowik
> > <dubowoj@neratec.com> wrote:
> >>
> >> AHB specific functions are now in ahb.c file. There is no common
> >> init functions which tries first pci and then ahb becasue on some
> >
> > 'because'
> >
> >> --- a/drivers/net/wireless/ath/ath5k/Makefile
> >> +++ b/drivers/net/wireless/ath/ath5k/Makefile
> >> @@ -15,5 +15,5 @@ ath5k-y += rfkill.o
> >>  ath5k-y += ani.o
> >>  ath5k-y += sysfs.o
> >>  ath5k-$(CONFIG_ATH5K_DEBUG) += debug.o
> >> -ath5k-y += pci.o
> >> +ath5k-y += $(if $(CONFIG_ATHEROS_AR231X),ahb,pci).o
> >>  obj-$(CONFIG_ATH5K) += ath5k.o
> >
> > This is not the right way.. what if someone wants both in one
> > kernel?
> Having both in the kernel is completely pointless. There are no
> devices
> that can support both, nor will there ever be.
> 
> - Felix

I agree. The only advantage would be that some of the typos and missing
functions in either of the files would be detected during compile time.
My AR5312 board crashes when I enable PCI. I guess it's fixable but it's
out of the scope of the ath5k driver...

br,
Wojtek
