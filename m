Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35614 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbbIGLJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 07:09:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>, Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v3] Add new mac80211 driver mwlwifi.
References: <909c66d61ee943f5a5ca202040944f2d@SC-EXCH02.marvell.com>
	<1435225107.2096.12.camel@sipsolutions.net>
	<9228e2c85d5d4bab9ad2cc859fa6c946@SC-EXCH02.marvell.com>
Date: Mon, 07 Sep 2015 14:09:24 +0300
In-Reply-To: <9228e2c85d5d4bab9ad2cc859fa6c946@SC-EXCH02.marvell.com> (David
	Lin's message of "Fri, 26 Jun 2015 01:25:56 +0000")
Message-ID: <87zj0yeba3.fsf@kamboji.qca.qualcomm.com> (sfid-20150907_130934_655096_CA9C8F86)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

replying to an older thread:

David Lin <dlin@marvell.com> writes:

>> > +++ b/drivers/net/wireless/mwlwifi/Kconfig
>> > @@ -0,0 +1,17 @@
>> > +config MWLWIFI
>> > +	tristate "Marvell Wireless WiFi driver (mwlwifi)"
>> > +	depends on PCI && MAC80211 && MWIFIEX_PCIE=n
>> 
>> Uh, what's with the exclusion of MWIFIEX_PCIE? Couldn't use a different PCI ID?
>> I really think you need to get rid of this, otherwise people can't even
>> *build-test* their wifi changes fully.
>
> Both the drivers are operable for the same chip part number 8897 and
> its modules (boards) manufactured out there. The PCI Device ID is a
> fixed value (by chip/manufacturer) on those modules. As said earlier,
> the two drivers are for mac80211 host mac, and firmware mac
> respectively. They serve different purposes. Users need to choose
> which driver they want to use for the same wifi hardware, and they
> cannot use both of them at the same time. The mwifiex is more widely
> used now and sta centric. We do not want to break it.

Can you explain more about different purposes between mwifiex and
mwlwifi? Is it so that mwifiex is for client devices and mwlwifi for AP
devices?

> I am not sure but I believe they are also multiple flavors of driver
> for some other chips. Any advice how they are handled, considering
> that changing the hardware/board is not an option? I guess we want the
> community to be better served using the same hardware. Opinion from
> others are welcomed.

So the goal is that the same kernel binary image will work with all
supported devices. No kconfig tinkering, no recompilation or anything
like that, the devices will automatically just work. By creating mwlwifi
using same device id as miwfiex you break that. But I don't know how to
fix this either, as mwlwifi uses mac80211 and mwifiex cfg80211.

Like I said with rtl8xxxu, I don't like the idea that we have two
drivers claiming to support the same device _by default_. So currently
my understanding is that mwlwifi supports these two devices:

static struct pci_device_id mwl_pci_id_tbl[] = {
	{ PCI_VDEVICE(MARVELL, 0x2a55), .driver_data = MWL8864, },
	{ PCI_VDEVICE(MARVELL, 0x2b38), .driver_data = MWL8897, },
	{ },
};

MWL8864 is only supported by mwlwifi, correct?

But the problem is MWL8897 as it conflicts with mwifiex. And with the
current way you have handled this I'm worried that it will break
existing setups as you don't really know which one of the drivers is
loaded. Is MWL8897 support really needed? Or should there be a separate
Kconfig entry to enable MWL8897 support separately?

All ideas welcome.

-- 
Kalle Valo
