Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38843 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3KRO5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 09:57:19 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <21130.10685.758161.252763@gargle.gargle.HOWL> (sfid-20131118_155722_988904_42BCBBB6)
Date: Mon, 18 Nov 2013 20:22:45 +0530
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

0x5 is not a valid chainmask on AR9390. The official statement is:

"We intentionally didn’t productize the chain mask of 0x5 on AR9380/AR9580
because of the complexities of register addressing and getting through the ASIC
self-calibrations in this configuration."

I think for 2x2 operation, 0x3 is the only option. The problem with Chain-1
(which was mentioned in http://www.spinics.net/lists/linux-wireless/msg114607.html)
is probably for a specific board. So maybe you can just set 0x3 using iw and
see if things are okay.

> Nov 18 13:39:45 CHD500279 kernel: [16510.563694] ath: phy11: NF calibrated [ctl] [chain 0] is -105
> Nov 18 13:39:45 CHD500279 kernel: [16510.563698] ath: phy11: NF calibrated [ctl] [chain 2] is -50
> Nov 18 13:39:45 CHD500279 kernel: [16510.563701] ath: phy11: NF[2] (-50) > MAX (-100), correcting to MAX
> Nov 18 13:39:45 CHD500279 kernel: [16510.563705] ath: phy11: NF calibrated [ext] [chain 0] is -105
> Nov 18 13:39:45 CHD500279 kernel: [16510.563708] ath: phy11: NF calibrated [ext] [chain 2] is -50
> Nov 18 13:39:45 CHD500279 kernel: [16510.563712] ath: phy11: NF[5] (-50) > MAX (-100), correcting to MAX

Again, this is the side effect of using the unsupported mask, 0x5.

But, this is also a bug in ath9k. Right now the CCA registers assigned
in ar9003_hw_attach_phy_ops() are used in a sequential manner.

But, as per our systems engineers:

AR_PHY_CCA_0 - for 1st active chain, (value always valid).
AR_PHY_CCA_1 - for 2nd active chain, (value should be ignored except for chain mask 3,5,7).
AR_PHY_CCA_2 - for 3rd active chain, (value should be ignored except for chain mask 7).

So, if 0x5 is used, AR_PHY_CCA_0 and AR_PHY_CCA_1 should be used.
But, ath9k currently uses AR_PHY_CCA_0 and AR_PHY_CCA_2 for 0x5
(in ar9003_hw_do_getnf).

In any case, I don't think this needs to be fixed, since 0x5 is invalid.

Sujith
