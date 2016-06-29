Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36583 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbcF2SwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 14:52:04 -0400
Received: by mail-wm0-f51.google.com with SMTP id f126so193126521wma.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2016 11:51:50 -0700 (PDT)
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name
 dt property
To: Hans de Goede <hdegoede@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
 <CAOiHx=n6itfmvwYQh+jUSDNguQFkos=MzjkDWP=GsupdgvF6KQ@mail.gmail.com>
 <b49a9e4b-d591-d978-8005-413f39ebf2bd@redhat.com>
 <871t3gdj6p.fsf@purkki.adurom.net>
 <ea10ff70-26e6-e151-5cea-c54bd12a054c@redhat.com>
Cc: Jonas Gorski <jonas.gorski@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f8995599-115d-87e5-7928-c029b48584f1@broadcom.com> (sfid-20160629_205228_556318_59F4838C)
Date: Wed, 29 Jun 2016 20:51:44 +0200
MIME-Version: 1.0
In-Reply-To: <ea10ff70-26e6-e151-5cea-c54bd12a054c@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29-6-2016 20:01, Hans de Goede wrote:
> Hi,
> 
> On 29-06-16 19:00, Kalle Valo wrote:
>> Hans de Goede <hdegoede@redhat.com> writes:
>>
>>> Hi,
>>>
>>> On 29-06-16 16:42, Jonas Gorski wrote:
>>>> Hi,
>>>>
>>>> On 29 June 2016 at 16:04, Hans de Goede <hdegoede@redhat.com> wrote:
>>>>> Add a brcm,nvram_file_name dt property to allow overruling the default
>>>>> nvram filename for sdio devices. The idea is that we can specify a
>>>>> board specific nvram file, e.g. brcmfmac43362-ap6210.txt for boards
>>>>> with an ap6210 wifi sdio module and ship this in linux-firmware, so
>>>>> that wifi will work out of the box, without requiring users to find
>>>>> and then manually install the right nvram file for their board.
>>>>
>>>> Directly defining a filename doesn't seem like a good OS-agnostic
>>>> approach. Maybe an alternative would be to add a model-property to the
>>>> nodes (this is allowed) and make brcmfmac to request
>>>> "FWFILENAME-<model>" as firmware if set? That would leave it to the OS
>>>> on how the filename is set.
>>>
>>> It only defines the base-filename, not the entire path, how / where
>>> this file is searched for / loaded-from is then left up to the os
>>
>> It's still a bad idea. The filename, including the path, should be
>> created in the driver. Can't you provide chipname (or similar) via
>> device tree and then the driver can choose what image to use?
> 
> No, the driver already does that, but this is not ...
> 
>> Can you tell more about the naming the firmware image, how does it work
>> exactly?
> 
> About firmware, this is about the nvram file which is board specific,
> rather then chip specific.

The nvram filename is determined pretty much the same as the firmware
filename, but indeed the nvram data is board specific. This is main
reason why we do not submit nvram files to linux-firmware, because we
simply do not have those files.

> Typical wifi devices will have some sort of non volatile storage
> on board to not only store the ethernet(mac) address, but also
> to contain e.g. info about the antenna gain so that the firmware
> and/or the driver can take the antenna gain into account and ensure
> that they never exceed the maximum allowed broadcast strength.
> 
> However on some embedded devices there is no non-volatile storage
> for the wifi (for cost reasons) and instead this configuration info
> (which is board / pcb specific) is loaded in the form of a
> file which contains the contents which would normally be in the
> non-volatile storage.
> 
> Since we are dealing with a per-board config-file here, which is
> loaded from the os filesystem we really need to specify a basename
> here as the list of possible boards is endless, so we cannot
> have a lookup table in the driver.

As Jonas mentioned the general principle of device tree is to be
agnostic with regards to OS and/or driver as you undoubtedly know. His
proposal seems like a usable solution for your problem while complying
to the device tree principle. So instead of overriding the default
brcmfmac should modify it when dt specifies the "module" property, ie:

no "module" in DT:	nvram filename = brcm/brcmfmac43362-sdio.txt
"module=ap6210" in DT:	nvram filename = brcm/brcmfmac43362-ap6210.txt

By the way, the example in the bindings file does not seem to specify a
basename, but path+basename+fileext.

Regards,
Arend
