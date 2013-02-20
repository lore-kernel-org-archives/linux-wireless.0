Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:53388 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934649Ab3BTG0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 01:26:23 -0500
MIME-Version: 1.0
In-Reply-To: <512437FA.2030105@lwfinger.net>
References: <20130219.005206.397289032011003833.davem@davemloft.net>
 <AE90C24D6B3A694183C094C60CF0A2F6026B7152@saturn3.aculab.com>
 <5123BCFF.5090408@lwfinger.net> <20130219.131553.787630407148880340.davem@davemloft.net>
 <5123C43D.2020602@lwfinger.net> <CAGRGNgWZ0qUJSSkjmP8o4VaPRBdN67J=RPy5+45rWaQQXWnWrQ@mail.gmail.com>
 <512437FA.2030105@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 20 Feb 2013 07:26:01 +0100
Message-ID: <CA+XFjipJHGTvzUx6yy1DTc74kbrPEQxM08zW=N1uf43=Q6pwdg@mail.gmail.com> (sfid-20130220_072627_408369_624BAE44)
Subject: Re: [PATCH] b43: Increase number of RX DMA slots
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	David Miller <davem@davemloft.net>, David.Laight@aculab.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, bittorf@bluebottle.com,
	stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2013 at 3:42 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 02/19/2013 06:47 PM, Julian Calaby wrote:
>>
>>
>> Is it be possible to increase the number of slots at runtime? Maybe an
>> even better solution would be to keep the existing number of slots,
>> and if they run out, reset and increase incrementally to some sensible
>> maximum value.
>
>
> The number could be increased a bit, but on systems with 32-bit DMA such as
> the BCM4318, the maximum size of the ring buffer is 4KB. Even more
> importantly, each slot is allocated an skb of 2390 bytes. Even at 256 slots,
> the memory allocation is pretty large.
>
> Larry
>

Is this an issue that vendor drivers are also vulnerable to? If it is
a firmware issue, I would certainly think so.
