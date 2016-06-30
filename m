Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36208 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbcF3TYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 15:24:11 -0400
Received: by mail-pf0-f182.google.com with SMTP id t190so32268807pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 12:24:10 -0700 (PDT)
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name
 dt property
To: Arnd Bergmann <arnd@arndb.de>, Hans de Goede <hdegoede@redhat.com>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
 <CAOiHx==82LHOeQMNVD+dybFifXX690Q6AJTcMBMynjSfUOyGUw@mail.gmail.com>
 <8d8bd933-717b-48e4-f002-7b834abed6fd@redhat.com>
 <3960223.GqB9zXL8s8@wuerfel>
Cc: jonas.gorski@gmail.com, Kalle Valo <kvalo@codeaurora.org>,
	Priit Laes <plaes@plaes.org>,
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
Message-ID: <1f44df41-0111-441b-4671-718eec0c4346@broadcom.com> (sfid-20160630_212421_781967_BC1A3F76)
Date: Thu, 30 Jun 2016 21:23:56 +0200
MIME-Version: 1.0
In-Reply-To: <3960223.GqB9zXL8s8@wuerfel>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 30-6-2016 13:31, Arnd Bergmann wrote:
> On Thursday, June 30, 2016 12:25:15 PM CEST Hans de Goede wrote:
>>> So then how about making use of a more specific compatible string?
>>>
>>> e.g.
>>>
>>> brcmf {
>>>         compatible = "foo,ap6210", "brcm,bcm4329-fmac";
>>>         ...
>>> };
>>>
>>> and if the compatible has more than one element you request
>>> FW_NAME_<compatible>.txt as the nvram file. Or try each comptible (and
>>> lastly no suffix) until you get a match. (AFAICT, this is what the
>>> "model" property was originally intended for anyway, but almost nobody
>>> did it right, and everyone put a user readable string into "model" for
>>> boards instead of the ePAPR defined compatible string).
>>
>> Hmm, interesting idea. Not sure how easy / hard it will be to implement
>> this, but from a dt binding point of view it seems elegant.
>>
>> Kalle, Arend, what do you think of this ?

At first glance I like the suggestion, but this would mean updating the
bindings document for each new wifi module that we want to add. Not a
big problem, but it makes that I have a slight preference to using a
property for it, eg. brcm,module = "ap6210";

> I think that's reasonable. Also, we have precedent for using things like
> the boardid as part of the compatible string, which would help do what
> Kalle suggested earlier with "nvram-<boardtype>-<boardrev>.txt",
> as we get that for free by trying out all the compatible strings.

The suggestion from Kalle was to use the field in the nvram file, but
things are a bit more complicated. The fields are only used if it is not
stored on the device in OTP or SROM. The 43362 does not have a SROM, but
it still has a small OTP storage if I am not mistaken. The brcmfmac
exposes a revinfo file in debugfs containing boardtype and boardrev, but
that is after starting the firmware. Still worth to check if those
values match the values in the ap6210 nvram file.

Regards,
Arend
