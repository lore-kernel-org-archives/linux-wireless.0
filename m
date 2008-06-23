Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:37226 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYFWKCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 06:02:36 -0400
Received: by py-out-1112.google.com with SMTP id p76so915168pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2008 03:02:33 -0700 (PDT)
Message-ID: <1ba2fa240806230302x11c0ed0dn6210c8fe745fdf6d@mail.gmail.com> (sfid-20080623_120240_113509_E834D52D)
Date: Mon, 23 Jun 2008 13:02:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: Rfkill on ifconfig up.
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Dan Williams" <dcbw@redhat.com>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
In-Reply-To: <20080623050514.GA9926@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806221609p1b0cd641g2304d0812b61ecb3@mail.gmail.com>
	 <20080623050514.GA9926@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2008 at 8:05 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Mon, 23 Jun 2008, Tomas Winkler wrote:
>> Little RF KILL design question from user space perspective.
>> What should be desired return value of ifconfig up when HW rfkill is
>> on (radio is off).
>
> This isn't really about rfkill, its design doesn't call for any particular
> behaviour.  IMHO we should go with the principle of least suprise, and also
> more convenience for the user.

No, this is about ifconfig up

> In the end, it will depend on the capabilities of the hardware, I suppose.
> Assuming the hardware CAN bring its interface up without going bonkers
> because the transmitter is not transmitting anything, that's exactly what it
> should do IMO.
>
> What it must never do is to unblock the transmiter because of a ifconfig up
> :-)
>
>> rfkill on (radio off)
>> ifconfig wlan0 up
>> rfkill off (radio on)
>>
>> Will it be ok for these sequence to require additional ifconfig up to
>> make driver to work, providing the first ifconfig up failed?
>
> It would be nice if it didn't fail the first ifconfig, and therefore needed
> nothing special to work other than a rfkill unblock.

Everything is doable just 'would be nice'  is not good reason enough :)
Thanks anyway
Tomas
