Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:17903 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab0DGGvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 02:51:47 -0400
Received: by qw-out-2122.google.com with SMTP id 8so272333qwh.37
        for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 23:51:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19388.4470.438422.209224@gargle.gargle.HOWL>
References: <19387.1459.438884.832345@gargle.gargle.HOWL>
	 <p2od82e647a1004060618vc8b95400hbaf1cfaecc2defd3@mail.gmail.com>
	 <19388.4470.438422.209224@gargle.gargle.HOWL>
Date: Wed, 7 Apr 2010 14:51:43 +0800
Message-ID: <n2gd82e647a1004062351o1d7c68c7j79c6bf253363254b@mail.gmail.com>
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
>> 2010/4/6 Sujith <Sujith.Manoharan@atheros.com>:
>> > Use a spin lock to prevent concurrent access
>> > to variables dealing with RX stream mode handling.
>>
>> which variables are needed to be protected?
>>
>> It seems hif_dev->rx_transfer_len, hif_dev->remain_skb
>> and hif_dev->rx_pkt_len are only accessed in ath9k_hif_usb_rx_stream,
>> which is only called in hard irq(urb->complete) context and now is
>> serialized strictly, so the protection is useless, isn't it?
>
> On a SMP machine, the RX callback can run on two CPUs, in this case,
> appropriate protection is needed between the two hard-irq handlers.

I am not sure if the same irq handler can run concurrently on different CPUs.
Even though it is, ehci/uhci handler have done such protection, so it
is not necessary to add such protection in the complete handler of usb
interface driver.

>
>> > Currently, no protection is implemented - which
>> > causes problems in RX.
>>
>> which problems? Could you describe them in detail?
>
> The RX stream position-hooks would get mangled up if two
> IRQ handlers access them without any kind of protection.
> This corrupts the stream data - causing data loss.
>
> Sujith
>



-- 
Lei Ming
