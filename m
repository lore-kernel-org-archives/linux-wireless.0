Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:6258 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYHSST5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 14:19:57 -0400
Received: by rn-out-0910.google.com with SMTP id k40so70540rnd.17
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2008 11:19:57 -0700 (PDT)
Message-ID: <81b0412b0808191119y3fe473bbi43ca5524ff4d20ac@mail.gmail.com> (sfid-20080819_202002_040563_69907531)
Date: Tue, 19 Aug 2008 20:19:56 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: rt2500pci: rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <200808192003.45072.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080819173524.GA4708@steel.home>
	 <200808192003.45072.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/8/19 Ivo van Doorn <ivdoorn@gmail.com>:
>> The rt2500 driver in 2.6.27-rc3 (v2.6.27-rc3-552-g3c3a15a) constantly
>> produces a lot of this messages in log (slowdown quite noticable):
>>
>>     kernel: phy0 -> rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
>>     kernel: phy0 -> rt2500pci_bbp_write: Error - BBPCSR register busy. Write failed.
>>     last message repeated 40 times
>>     kernel: phy0 -> rt2500pci_rf_write: Error - RFCSR register busy. Write failed.
>>     last message repeated 7 times
>>     kernel: phy0 -> rt2500pci_bbp_write: Error - BBPCSR register busy. Write failed.
>
> This is a bad sign, the slowdown is expected since the driver is continuously looping
> waiting for the registers to become available. Did this PCI card work in the past, and
> if so with what driver?

It surely did, but I honestly don't remember what with. I'll try to bisect.

> Does this card work on another PC, or does the windows or legacy driver work with
> this card?

No Windows here, but see below

> (Yes, all suggestions above imply suspicion about the hardware itself rather then the driver)

Well, it used to crash some industrial board (I believe it was some
Boser, HS-series, with
this card in a PCI slot of its backplane). So you're not alone in your
suspicions (OTOH,
that board was known to misbehave itself).

I have no particular need for that card, so if someone wants it for
testing I gladly
part with it (and if you happen be in Germany, I'll just mail it).
