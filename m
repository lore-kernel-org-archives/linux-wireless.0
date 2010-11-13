Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2478 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab0KMOKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 09:10:42 -0500
Date: Sat, 13 Nov 2010 08:27:37 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Wojciech Dubowik <dubowoj@neratec.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/9] ath5k: AHB port. Add AHB bus support.
Message-ID: <20101113132736.GA22348@hash.localnet>
References: <1298013311.4723.1289591505420.JavaMail.root@idefix> <4CDD9BB8.1040305@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CDD9BB8.1040305@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 12, 2010 at 08:55:36PM +0100, Felix Fietkau wrote:
> On 2010-11-12 8:51 PM, Wojciech Dubowik wrote:
> >> Having both in the kernel is completely pointless. There are no
> >> devices
> >> that can support both, nor will there ever be.
> > 
> > I agree. The only advantage would be that some of the typos and missing
> > functions in either of the files would be detected during compile time.

Compile-testing coverage is a fine reason to allow people to compile
both modules.  Ok, I accept that it's a bit of a pain to create separate
modules, but can we at least do it like:

ath5k-$(CONFIG_ATH5K_PCI) += pci.o
ath5k-$(CONFIG_ATH5K_AHB) += ahb.o

and add the appropriate selects and mutual exclusion to the Kconfig?
Of course, that presupposes a Kconfig entry for CONFIG_ATHEROS_AR2316
where there is not one currently.

-- 
Bob Copeland %% www.bobcopeland.com

