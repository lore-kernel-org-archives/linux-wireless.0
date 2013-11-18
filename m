Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:37637 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3KRPKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 10:10:15 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21130.11458.534881.511198@gargle.gargle.HOWL> (sfid-20131118_161019_154262_9314C14F)
Date: Mon, 18 Nov 2013 20:35:38 +0530
To: Matthias May <matthias.may@neratec.com>
Cc: nbd@openwrt.org, Sven Eckelmann <sven@open-mesh.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <simon@open-mesh.com>,
	"ath9k-devel\@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [OpenWrt-Devel] ath9k: Deaf QCA9558 when setting
 rxchainmask
In-Reply-To: <528A17EA.1020505@neratec.com>
References: <19772470.YgPhAz9cYD@bentobox>
	<87B8D697-4540-4D0E-975B-125531E6833B@net.t-labs.tu-berlin.de>
	<CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com>
	<2985619.kldLYNDlSX@bentobox>
	<21120.58000.344447.562435@gargle.gargle.HOWL>
	<528A0F79.1040807@neratec.com>
	<21130.4681.687594.315193@gargle.gargle.HOWL>
	<528A17EA.1020505@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias May wrote:
> root@CHD500279:/# echo 0x40d8 > 
> /sys/kernel/debug/ieee80211/phy6/ath9k/regidx
> root@CHD500279:/# cat /sys/kernel/debug/ieee80211/phy6/ath9k/regval
> 0x00000004
> 
> On another device showing the same behaviour (but with various other 
> patches and based on compat-wireless-2013-06-27) 0x04000004.

This commit removed code from the driver which handled
a quirk that is probably required for the enterprise variants.

Felix, we do require the code that handles AR_ENT_OTP_CHAIN2_DISABLE, right ?

commit 56266bff6df685d9c26d08904ae1d43bad162539
Author: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Date:   Sat Aug 13 10:28:13 2011 +0530

    ath9k_hw: Remove unnecessary chainmask configuration
    
    The chainmasks were already configured at process_ini
    before doing init calibration.


Sujith
