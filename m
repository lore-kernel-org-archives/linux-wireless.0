Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34705 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3KKODN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 09:03:13 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21120.58000.344447.562435@gargle.gargle.HOWL> (sfid-20131111_150317_078384_C1F9EDC9)
Date: Mon, 11 Nov 2013 19:28:40 +0530
To: Sven Eckelmann <sven@open-mesh.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	Simon Wunderlich <simon@open-mesh.com>,
	"ath9k-devel\@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [OpenWrt-Devel] [ath9k-devel] ath9k: Deaf QCA9558 when setting rxchainmask
In-Reply-To: <2985619.kldLYNDlSX@bentobox>
References: <19772470.YgPhAz9cYD@bentobox>
	<87B8D697-4540-4D0E-975B-125531E6833B@net.t-labs.tu-berlin.de>
	<CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com>
	<2985619.kldLYNDlSX@bentobox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann wrote:
> You are talking about ar9003_phy.c -> ar9003_hw_set_chain_masks? No, the 
> device is 3x3 and ah->caps.tx_chainmask & ah->caps.rx_chainmask are 7 and not 
> 5. The AR_PHY_ANALOG_SWAP := AR_PHY_SWAP_ALT_CHAIN is only done when one of 
> them would be 5. But I am not really sure what this register setting is really 
> doing. Maybe you can explain it when you think it could be related. Thanks

"0x5" chainmask is an invalid mask for AR9300 - for all revisions, including AR9580.

If a 2-stream card is required based on AR9300 for custom designs, the only
way is to use Chain 0 and Chain 2, since there are HW limitations with Chain 1.
In this case, a chainmask of 0x7 has to be used and the middle chain disabled in the
driver. This is done by a few vendors who use the 5Ghz AR9580 radio but want 2x2
instead of the usual 3x3.

Sujith
