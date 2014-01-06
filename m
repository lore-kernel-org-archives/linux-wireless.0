Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:40793 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaAFTSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 14:18:10 -0500
Date: Mon, 6 Jan 2014 20:18:08 +0100
From: Andreas Mohr <andi@lisas.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andreas Mohr <andi@lisas.de>, linux-wireless@vger.kernel.org,
	openwrt-devel@lists.openwrt.org
Subject: OpenWrt kernel_menuconfig issue? (was: Re: BUG: build fail due to
 dependency issue (LIB80211_CRYPT_* failed to depend on LIB80211))
Message-ID: <20140106191808.GA7179@rhlx01.hs-esslingen.de> (sfid-20140106_201820_505780_B230C68D)
References: <20140106140103.GA24241@rhlx01.hs-esslingen.de>
 <1389017367.5891.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389017367.5891.13.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

[CC openwrt-devel, remove linux-kernel]

On Mon, Jan 06, 2014 at 03:09:27PM +0100, Johannes Berg wrote:
> On Mon, 2014-01-06 at 15:01 +0100, Andreas Mohr wrote:
> 
> > config LIB80211
> >         tristate
> 
> > config LIB80211_CRYPT_WEP
> >         tristate
> > 
> > config LIB80211_CRYPT_CCMP
> >         tristate
> > 
> > config LIB80211_CRYPT_TKIP
> >         tristate
> 
> >     make menuconfig
> > showed these three crypt options rather very prominently,
> 
> Well, then your 'make menuconfig' is somehow broken - on mainline
> options that have no prompt are not shown, and indeed 'make menuconfig'
> on the current mainline kernel confirms that those options are not
> possible to select manually.

Indeed, I should have managed to mention that this happened using
    make kernel_menuconfig
of OpenWrt fame instead.

I now copied my OpenWrt trunk to a separate directory,
make distclean:ed it, removed all .config files that I could see,
then re-did make menuconfig, make kernel_menuconfig,
resulting in the LIB80211_CRYPT_* issue in
Networking support ---> Wireless to remain problematic as before.

Can someone else confirm and/or elaborate on this improper visibility problem
which seems to be specific to OpenWrt's kernel configuration management?
(which does do certain config things in a rather custom way, I might add)

Thanks,

Andreas Mohr
