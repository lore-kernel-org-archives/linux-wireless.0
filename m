Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f182.google.com ([209.85.210.182]:50484 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0CAIMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 03:12:49 -0500
MIME-Version: 1.0
In-Reply-To: <20100301075953.GA32038@jm.kir.nu>
References: <9c30dffe1002281458w5705378fj52f36c5d352593fb@mail.gmail.com>
	 <20100301075953.GA32038@jm.kir.nu>
Date: Mon, 1 Mar 2010 09:12:48 +0100
Message-ID: <9c30dffe1003010012l5b3a912fma5655e630b83ce9f@mail.gmail.com>
Subject: Re: Problem with bridges and wireless NIC's
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Jouni Malinen <j@w1.fi>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/1 Jouni Malinen <j@w1.fi>:
> On Sun, Feb 28, 2010 at 11:58:10PM +0100, Bjarke Istrup Pedersen wrote:
>
>> There is a problem when trying to create a bridge containing a normal
>> NIC and a wireless NIC, and using hostapd.
>>
>> The problem is, that it is not possible to create a bridge containing
>> a wireless NIC, if it hasn't been setup first.
>>
>> Does anyone have a solution for this?
>
> How about first creating the br0, then starting hostapd, and finally
> adding wlan0 into br0?
>
>> (The commit that introduced this problem is
>> ad4bb6f8883a13bb0f65b194dae36c62a02ac779 , reverting it solves the
>> problem).
>
> I don't know whether I would call that a solution, but well..
>
>> For more info, please have a look at this bug report:
>> http://bugs.gentoo.org/show_bug.cgi?id=298824
>
> I'm not sure whether I understood the description correctly, but this
> sounds like a limitation in the way the network setup is done. Forcing
> br0 to be created with wlan0 before wlan0 has been configured is not
> going to work. I would consider removing wlan0 from the static
> configuration of br0 and just creating br0 with eth0 with the setup
> scripts and allowing hostapd to add wlan0 into br0 once the interface
> has been configured properly (support for this was added in hostapd
> 0.7.1).
>
> --
> Jouni Malinen                                            PGP id EFC895FA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Hey,

That sounds interresting, is there any chance that that functionality
can be added to the 0.6.x branch too? (I'm maintaining hostapd in
Gentoo, but cannot stabilize a 0.7.x build, due to it being a
development branch)

Best regards,
Bjarke I. Pedersen
