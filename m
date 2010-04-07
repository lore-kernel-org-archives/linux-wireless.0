Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:32791 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742Ab0DGKZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 06:25:21 -0400
Received: by qyk9 with SMTP id 9so975830qyk.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Apr 2010 03:25:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19388.22296.196628.670656@gargle.gargle.HOWL>
References: <19387.1459.438884.832345@gargle.gargle.HOWL>
	 <p2od82e647a1004060618vc8b95400hbaf1cfaecc2defd3@mail.gmail.com>
	 <19388.4470.438422.209224@gargle.gargle.HOWL>
	 <n2gd82e647a1004062351o1d7c68c7j79c6bf253363254b@mail.gmail.com>
	 <19388.22296.196628.670656@gargle.gargle.HOWL>
Date: Wed, 7 Apr 2010 18:25:20 +0800
Message-ID: <h2vd82e647a1004070325ob39d6615tffe01da944e696dd@mail.gmail.com>
Subject: Re: [PATCH 1/5] ath9k_htc: Protect RX stream variables
From: Ming Lei <tom.leiming@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/7 Sujith <Sujith.Manoharan@atheros.com>:
> Ming Lei wrote:
>> I am not sure if the same irq handler can run concurrently on different CPUs.
>> Even though it is, ehci/uhci handler have done such protection, so it
>> is not necessary to add such protection in the complete handler of usb
>> interface driver.
>
> What protection is done by ehci ?
> Is more information on this available anywhere ?

I should have thought that ehci->lock(ehci_irq()) may do such things, but
it is released before calling urb->complete, so the patch is correct, sorry for
my noise.

Thanks,

-- 
Lei Ming
