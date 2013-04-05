Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50563 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3DELd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 07:33:28 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20830.46610.23754.783231@gargle.gargle.HOWL> (sfid-20130405_133332_219936_B5F36758)
Date: Fri, 5 Apr 2013 17:01:30 +0530
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Adrian Chadd <adrian@freebsd.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
In-Reply-To: <1365152761.13005.YahooMailNeo@web193505.mail.sg3.yahoo.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmoksRR8Xd4wEM_obENyP1mFqbgKDm+DEjLS=W8WAPBPLRg@mail.gmail.com>
	<1365131280.68622.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-VmokqjXqkJEN1cwgsOcJ7p8cvCsRxUG8Qc9gE8fWXaq+E0g@mail.gmail.com>
	<1365148844.61162.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-VmonhbW06GU30S9oKYTEvbum2WbY63Y07tvS=ZQJcB6o+Dg@mail.gmail.com>
	<1365152761.13005.YahooMailNeo@web193505.mail.sg3.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sandeep suresh wrote:
> I had a look at the source code for Ath9k. For 2-wire coexistence, other than
> GPIO configuration (direction, Mux etc) for WLAN_ACTIVE and BT_ACTIVITY, is
> there also weight register configuration for BT and WLAN for 2-wire?  What
> exactly is the meaning of these weight registers?

BTCOEX protocol in ath9k can be of 3 types: 2-wire, 3-wire and MCI.

All chips in the pre-AR9003 family have separate WLAN and BT devices
as part of the same board. In a 2-wire connection between the devices, they
are marked as BT_ACTIVE and WLAN_ACTIVE. BT_ACTIVE is driven by the BT device
and WLAN_ACTIVE by the WLAN device, obviously.

If the Bluetooth device is expecting to TX or RX, it asserts BT_ACTIVE. If
WLAN traffic has been prioritized over BT traffic, WLAN_ACTIVE is asserted and
Bluetooth traffic is "stomped".

Now, the means of "prioritizing" traffic is done based on "weights". For each
combination of BT_PRIORITY/BT_[TX|RX], weights are programmed in the HW.
The same is done for WLAN. So, when the card is operational and BT_ACTIVE is
asserted and if there is current WLAN traffic, the HW checks if the weight
of the BT traffic is lower than WLAN and if so, continues to transmit WLAN frames.
If BT priority is higher, the HW will *abort* WLAN traffic like there was
a collision. I'd assume that at this point, backoff will kick in.

2-wire doesn't have BT_PRIORITY, so traffic classification is very primitive
and coexistence is not optimal. 3-wire is much better and the best of the breed
is the MCI based scheme implemented in AR9462 and AR9565. These two chips, unlike
other WLAN+BT cards like WB195, WB225, WB197 etc. are *combo* chips and hence
have a complex system of message-passing to exchange information between the
BT-core and WLAN. MCI is built on 3-wire, so it uses the same lines at a basic level.

Now, these lines (either 2 or 3) are connected by GPIOs at the WLAN side. They
can be programmed as either input or output and the GPIO number is fixed for
each card. The WLAN-driven line WLAN_ACTIVE is configured as output and the
signals coming in from BT are configured as input. The actual pin numbers can be
found in ath9k_hw_btcoex_init_scheme().

This is only the basic picture - there are a lot of other components which
interact with each other to provide a more dynamic algorithm to distribute
airtime between WLAN and BT. Most of the stuff is in gpio.c and btcoex.c

Hope this helps.

Sujith
