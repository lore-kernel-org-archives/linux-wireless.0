Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33836 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3KRNRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 08:17:14 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21130.4681.687594.315193@gargle.gargle.HOWL> (sfid-20131118_141717_328596_4679DA5A)
Date: Mon, 18 Nov 2013 18:42:41 +0530
To: Matthias May <matthias.may@neratec.com>
Cc: Sven Eckelmann <sven@open-mesh.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <simon@open-mesh.com>,
	"ath9k-devel\@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [OpenWrt-Devel] ath9k: Deaf QCA9558 when setting
 rxchainmask
In-Reply-To: <528A0F79.1040807@neratec.com>
References: <19772470.YgPhAz9cYD@bentobox>
	<87B8D697-4540-4D0E-975B-125531E6833B@net.t-labs.tu-berlin.de>
	<CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com>
	<2985619.kldLYNDlSX@bentobox>
	<21120.58000.344447.562435@gargle.gargle.HOWL>
	<528A0F79.1040807@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias May wrote:
> I'm in the position where i want to use a 9390 as 2x2 instead of 3x3.
> I use backports-3.12-1.
> I've set the rx and tx mask in eeprom to 0x5.
> Every 30 seconds there is a short disconnect.
> Enabling some logging in
> echo "0x0000050C" > /sys/kernel/debug/ieee80211/phy0/ath9k/debug
> shows that something seems to go wrong during noise calibration. (See 
> attached log).
> What seems odd to me, that for IQ cal it tries to calibrate chain 1 
> instead of chain 2.

What is the value of 0x40d8 register ?

echo 0x40d8 > /sys/kernel/debug/ieee80211/phy0/ath9k/regidx
cat /sys/kernel/debug/ieee80211/phy0/ath9k/regval

Sujith
