Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46771 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3KNIoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 03:44:04 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21124.35907.609941.149884@gargle.gargle.HOWL> (sfid-20131114_094428_422904_2CDFA856)
Date: Thu, 14 Nov 2013 14:09:31 +0530
To: Alex Hacker <hacker@epn.ru>
Cc: Sven Eckelmann <sven@open-mesh.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <simon@open-mesh.com>,
	"ath9k-devel\@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [OpenWrt-Devel] ath9k: Deaf QCA9558 when setting rxchainmask
In-Reply-To: <20131112071232.GB11218@infinet.ru>
References: <19772470.YgPhAz9cYD@bentobox>
	<87B8D697-4540-4D0E-975B-125531E6833B@net.t-labs.tu-berlin.de>
	<CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com>
	<2985619.kldLYNDlSX@bentobox>
	<21120.58000.344447.562435@gargle.gargle.HOWL>
	<20131112071232.GB11218@infinet.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alex Hacker wrote:
> Thank you Sujith. Probably I understood the following patch in a wrong way.
> Felix removed all chain masks checking. If the mask 5 is invalid, how about
> the mask 4 and 6?

The patch is correct. For calibration, the mask that is calibrated in
the EEPROM has to be used. Even if you change the mask config dynamically,
either using the antenna API or ath9k's debugs, it will be disregarded
when calibration is done.

Sujith
