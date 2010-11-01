Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.birdnet.se ([213.88.146.6]:49384 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751183Ab0KAWwP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 18:52:15 -0400
Message-ID: <20101101224533.5647.qmail@stuge.se>
Date: Mon, 1 Nov 2010 23:45:33 +0100
From: Peter Stuge <peter@stuge.se>
To: =?utf-8?B?QmrDtnJu?= Smedman <bjorn.smedman@venatech.se>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [RFC] ath9k: Insert wmb before linking dma
	descriptors
References: <20101005131744.GB4074@tuxdriver.com> <20101005195039.GD11831@tux> <AANLkTikxayNdakE-MrCQWS10nZ3ZQk1pnEcHC+sMck1p@mail.gmail.com> <4CB0890D.3050208@openwrt.org> <4CCA0908.6000105@candelatech.com> <4CCA0B26.5010008@openwrt.org> <AANLkTinu4_EcvzgS6AhxRYtSg=y=iwfcFtk0AhgOK-bS@mail.gmail.com> <AANLkTi=+L+R1HowfmcLc7fTP+p0=u0T8bcYcob-TNyNb@mail.gmail.com> <AANLkTinVu-DPdS43rMjDc0MMVDXMPHvKtbVfQJE8Ny=C@mail.gmail.com> <AANLkTikqw5oVTd66DeQGrPgyPAqh66dm6jCvNFSeHpQi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTikqw5oVTd66DeQGrPgyPAqh66dm6jCvNFSeHpQi@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Björn Smedman wrote:
> long and unwanted weekend of debugging ath9k DMA errors

Yeah, I've seen those as well, especially with AR5008 but also AR9002.

I have severe intermittent issues with PCI functionality of an AR9280
card. It locks up in a state where it either returns absolute garbage
so severe that the kernel plain rejects it, or just mildly garbage
data so that it reports corrupt PCI ids. It can fix itself in a
running system, so that a later lspci shows the correct device ids
and the driver actually loads and runs.

I typically get PCI fatal interrupts after resurrecting the card
(that takes a couple of power cycles including removing the laptop
battery). I don't suppose anyone can explain *in detail* what causee
these issues and what could be done to fix them?

Finally I've also experienced complete system lockup after a
previously working system was left on but idle overnight.

All this fun with commit 2d10d8737ccdba752d60106abbc6ed4f37404923 but
I believe these problems are nothing new.


//Peter
