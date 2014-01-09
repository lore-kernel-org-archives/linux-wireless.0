Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:43369 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaAIWen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 17:34:43 -0500
Date: Thu, 9 Jan 2014 23:34:42 +0100
From: Andreas Mohr <andi@lisas.de>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Andreas Mohr <andi@lisas.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, openwrt-devel@lists.openwrt.org
Subject: Re: OpenWrt kernel_menuconfig issue?
Message-ID: <20140109223442.GA12704@rhlx01.hs-esslingen.de> (sfid-20140109_233446_948795_2A094228)
References: <20140106140103.GA24241@rhlx01.hs-esslingen.de>
 <1389017367.5891.13.camel@jlt4.sipsolutions.net>
 <20140106191808.GA7179@rhlx01.hs-esslingen.de>
 <52CBC88C.90706@lri.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52CBC88C.90706@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 07, 2014 at 10:27:40AM +0100, Nicolas Cavallari wrote:
> On 06/01/2014 20:18, Andreas Mohr wrote:
> > Can someone else confirm and/or elaborate on this improper visibility problem
> > which seems to be specific to OpenWrt's kernel configuration management?
> > (which does do certain config things in a rather custom way, I might add)
> 
> This patch explains it all:
> 
> https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-3.12/255-lib80211_kconfig_hacks.patch

Oh darn it, I completely missed that small change, via that OpenWrt addition!
So in short OpenWrt did modify Kconfig to have a prompt,
yet forgot to then also add the then-necessary dependency information:

[[ Johannes Berg originally replied:
| Well, then your 'make menuconfig' is somehow broken - on mainline
| options that have no prompt are not shown, and indeed 'make menuconfig'
| on the current mainline kernel confirms that those options are not
| possible to select manually.
]]

I'll try to send a repair patch (add dependency)
for these various OpenWrt kernel patch files soon,
unless this is not the way to go...

Thank you very much for your input,

Andreas Mohr
