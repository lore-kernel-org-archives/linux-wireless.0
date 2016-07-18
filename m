Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33624 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbcGRHvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 03:51:21 -0400
Received: by mail-pf0-f175.google.com with SMTP id y134so35132675pfg.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 00:51:21 -0700 (PDT)
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name
 dt property
To: Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
 <3354017.XSBSmHHtrQ@wuerfel>
 <bb1beb8d-652d-aa97-e24b-e3e27397dd2e@broadcom.com>
 <3996482.D5xdKXDiGl@wuerfel> <20160717214502.GA11498@rob-hp-laptop>
Cc: Jonas Gorski <jonas.gorski@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Priit Laes <plaes@plaes.org>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <44803976-7e34-991f-5ee0-0a548f6cefc6@broadcom.com> (sfid-20160718_095125_988427_D97AA4F0)
Date: Mon, 18 Jul 2016 09:51:14 +0200
MIME-Version: 1.0
In-Reply-To: <20160717214502.GA11498@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-7-2016 23:45, Rob Herring wrote:
> On Thu, Jul 07, 2016 at 10:46:28AM +0200, Arnd Bergmann wrote:
>> On Wednesday, July 6, 2016 9:19:41 PM CEST Arend Van Spriel wrote:
>>> On 6-7-2016 15:42, Arnd Bergmann wrote:
>>>> On Wednesday, July 6, 2016 10:08:55 AM CEST Arend Van Spriel wrote:
>>>>> On Tue, Jul 5, 2016 at 3:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>> All existing uses of the model property in arch/arm/boot/dts and most of
>>>> the ones in arch/powerpc/boot/dts are against the intended usage in
>>>> one way or another, but adding different kind of incorrect usage won't
>>>> improve that.
>>>>
>>>> The only way I can see the model property being used correctly would
>>>> be to have it match the first entry in the compatible property, but
>>>> that is completely redundant, so we tend to omit it, except for the
>>>> root node in which it is required. For the root node however, the
>>>> historic practice that has crept in on ARM is to put something completely
>>>> different in there, which is a human-readable description of the
>>>> machine rather than something we can use as a unique indentifier.
>>>>
>>>> I'd just consider the "model" property burned, and not use it for anything
>>>> that doesn't already use it, just like we handle "device_type": a few
>>>> things require it, nothing else should use it.
>>>
>>> If that is the agreed approach in devicetree arena I am fine with it. I
>>> have been unaware of this and just looked at the suggestion from Jonas
>>> seeing a solution to the problem at hand.
>>
>> I don't think it has been discussed or decided before as the question
>> has not come up, so for now this is my personal view. Maybe one of
>> the devicetree maintainers can comment on this.
> 
> Back from vacation and getting caught up.
> 
> I agree with Arnd here. In my view model is the OEM branding on the 
> device, compatible is the h/w. If you have different firmware related 
> files, that goes beyond OEM branding.

Thanks, Rob

We are talking about hardware variants here. So using the model property
is off the table.

Regards,
Arend
