Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:33724 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbcGBSUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jul 2016 14:20:43 -0400
Received: by mail-wm0-f50.google.com with SMTP id r190so14953920wmr.0
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jul 2016 11:20:42 -0700 (PDT)
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name
 dt property
To: Jonas Gorski <jonas.gorski@gmail.com>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
 <CAOiHx==82LHOeQMNVD+dybFifXX690Q6AJTcMBMynjSfUOyGUw@mail.gmail.com>
 <8d8bd933-717b-48e4-f002-7b834abed6fd@redhat.com>
 <3960223.GqB9zXL8s8@wuerfel>
 <1f44df41-0111-441b-4671-718eec0c4346@broadcom.com>
 <CAOiHx=m8Zf0T4=BTG6BMRjj3kOHzt4YaQa3yzutmrhFSOyZMmA@mail.gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hans de Goede <hdegoede@redhat.com>,
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
	linux-sunxi@googlegroups.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ced2a770-2724-bdc9-7e2a-3dc9f76abf29@broadcom.com> (sfid-20160702_202047_267727_F07DD3F8)
Date: Sat, 2 Jul 2016 20:20:35 +0200
MIME-Version: 1.0
In-Reply-To: <CAOiHx=m8Zf0T4=BTG6BMRjj3kOHzt4YaQa3yzutmrhFSOyZMmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1-7-2016 10:58, Jonas Gorski wrote:
> Hi,
> 
> On 30 June 2016 at 21:23, Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>
>>
>> On 30-6-2016 13:31, Arnd Bergmann wrote:
>>> On Thursday, June 30, 2016 12:25:15 PM CEST Hans de Goede wrote:
>>>>> So then how about making use of a more specific compatible string?
>>>>>
>>>>> e.g.
>>>>>
>>>>> brcmf {
>>>>>         compatible = "foo,ap6210", "brcm,bcm4329-fmac";
>>>>>         ...
>>>>> };
>>>>>
>>>>> and if the compatible has more than one element you request
>>>>> FW_NAME_<compatible>.txt as the nvram file. Or try each comptible (and
>>>>> lastly no suffix) until you get a match. (AFAICT, this is what the
>>>>> "model" property was originally intended for anyway, but almost nobody
>>>>> did it right, and everyone put a user readable string into "model" for
>>>>> boards instead of the ePAPR defined compatible string).
>>>>
>>>> Hmm, interesting idea. Not sure how easy / hard it will be to implement
>>>> this, but from a dt binding point of view it seems elegant.
>>>>
>>>> Kalle, Arend, what do you think of this ?
>>
>> At first glance I like the suggestion, but this would mean updating the
>> bindings document for each new wifi module that we want to add. Not a
>> big problem, but it makes that I have a slight preference to using a
>> property for it, eg. brcm,module = "ap6210";
> 
> If you want a separate property, then I repeat my very first
> suggestion, the well defined model property.
> e.g.
> 
> brcmf@0 {
>         model = "ampak,ap6210";
>         compatible = "brcm,bcm4329-fmac";
>         ...
> };
> 
> All device nodes may have a model property, not just the top "machine" one.

I heard you the first time :-p I just was not sure what the implications
would be to use it. Hence I suggested a vendor specific property.
However, looking up and reading the definition in ePAPRv1.1 I suppose it
is fine to use the model property:

Property: model
Value type: <string>
Description:
The model property value is a <string> that specifies the manufacturer’s
model number of the device.

The recommended format is: “manufacturer,model”, where manufacturer is a
string describing the name of the manufacturer (such as a stock ticker
symbol), and model specifies the model number.

Regards,
Arend
