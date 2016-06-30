Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:34468 "EHLO
	mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbcF3Khi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 06:37:38 -0400
MIME-Version: 1.0
In-Reply-To: <14a3aa66-5851-5537-f6cd-7681fb4cde07@redhat.com>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
 <ea10ff70-26e6-e151-5cea-c54bd12a054c@redhat.com> <f8995599-115d-87e5-7928-c029b48584f1@broadcom.com>
 <6402170.5s0abZDqlD@wuerfel> <1467230078.2598.2.camel@plaes.org>
 <87eg7f6odi.fsf@kamboji.qca.qualcomm.com> <e94f58fe-f709-94bd-21f6-144c4e038d17@redhat.com>
 <87a8i36ls9.fsf@kamboji.qca.qualcomm.com> <14a3aa66-5851-5537-f6cd-7681fb4cde07@redhat.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 30 Jun 2016 12:18:40 +0200
Message-ID: <CAOiHx==82LHOeQMNVD+dybFifXX690Q6AJTcMBMynjSfUOyGUw@mail.gmail.com> (sfid-20160630_123741_987010_4220DAED)
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name
 dt property
To: Hans de Goede <hdegoede@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, Priit Laes <plaes@plaes.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Arend Van Spriel <arend.vanspriel@broadcom.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 30 June 2016 at 12:04, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
>
> On 30-06-16 11:58, Kalle Valo wrote:
>>
>> Hans de Goede <hdegoede@redhat.com> writes:
>>
>>> Hi,
>>>
>>> On 30-06-16 11:02, Kalle Valo wrote:
>>>>
>>>> Priit Laes <plaes@plaes.org> writes:
>>>>
>>>>>> What is the size of this nvram file? As it's board specific, I wonder
>>>>>> if we can simply include it inside of the DT verbatim. I remember
>>>>>> doing that (in the pre-dtb days, on real open firmware) for the
>>>>>> "spidernet"
>>>>>> ethernet driver.
>>>>>
>>>>>
>>>>> It contains a bit too much info:
>>>>>
>>>>> This is what CubieTruck requires:
>>>>>
>>>>>
>>>>> http://dl.cubieboard.org/public/Cubieboard/benn/firmware/ap6210/nvram_ap6210.txt
>>>>
>>>>
>>>> In the nvram file I see lots of identifiers:
>>>>
>>>> manfid=0x2d0
>>>> prodid=0x492
>>>> vendid=0x14e4
>>>> devid=0x4343
>>>> boardtype=0x0598
>>>> boardrev=0x1307
>>>> boardnum=777
>>>>
>>>> Are any of these (or a combination of them) unique for each board type?
>>>> What if one of these is provided through DT and then the driver could
>>>> choose the nvram file based on the board id? Just another idea...
>>>
>>>
>>> That would require updating a table in the driver every time a new
>>> board comes out, I do not believe that that is a good solution.
>>
>>
>> You don't necessarily need to have a table in the driver if you embed
>> the id to the filename, for example something like this:
>>
>> nvram-0598-1307.txt
>> nvram-<boardtype>-<boardrev>.txt
>
>
> Downside of this is, that as Arend already said, the nvram files are not
> readily available.
>
> Typically the boards we are talking about are shipped with android,
> and the mainline kernel bringup is done by a user, not the manufacturer.
>
> So the nvram file needs to be extracted from e.g. an android image,
> having ap6210 in the filename allows the user to see that his module
> (which is clearly labelled ap6210 is already supported, where as the
> boardtype/boardrev magic numbers are a big unknown.
>
> So I believe that using a human readable string is better here.

So then how about making use of a more specific compatible string?

e.g.

brcmf {
        compatible = "foo,ap6210", "brcm,bcm4329-fmac";
        ...
};

and if the compatible has more than one element you request
FW_NAME_<compatible>.txt as the nvram file. Or try each comptible (and
lastly no suffix) until you get a match. (AFAICT, this is what the
"model" property was originally intended for anyway, but almost nobody
did it right, and everyone put a user readable string into "model" for
boards instead of the ePAPR defined compatible string).


Regards
Jonas
