Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36446 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbcGDJIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2016 05:08:53 -0400
Received: by mail-pa0-f44.google.com with SMTP id zl15so17022110pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2016 02:08:53 -0700 (PDT)
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name
 dt property
To: Arnd Bergmann <arnd@arndb.de>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
 <7975990.MvNRQ06u39@wuerfel>
 <ac480a61-5bfd-5d0c-26fe-b85220ee5076@broadcom.com>
 <5756670.9hMGo8oEyl@wuerfel>
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
	linux-sunxi@googlegroups.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6cc6dabf-e6da-d70d-3cce-a7f1804f233e@broadcom.com> (sfid-20160704_110857_160978_780024A1)
Date: Mon, 4 Jul 2016 11:08:38 +0200
MIME-Version: 1.0
In-Reply-To: <5756670.9hMGo8oEyl@wuerfel>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 4-7-2016 10:55, Arnd Bergmann wrote:
> On Monday, July 4, 2016 10:41:20 AM CEST Arend Van Spriel wrote:
>> On 2-7-2016 23:30, Arnd Bergmann wrote:
>>> On Saturday, July 2, 2016 8:20:35 PM CEST Arend Van Spriel wrote:
>>>>> If you want a separate property, then I repeat my very first
>>>>> suggestion, the well defined model property.
>>>>> e.g.
>>>>>
>>>>> brcmf@0 {
>>>>>         model = "ampak,ap6210";
>>>>>         compatible = "brcm,bcm4329-fmac";
>>>>>         ...
>>>>> };
>>>>>
>>>>> All device nodes may have a model property, not just the top "machine" one.
>>>>
>>>> I heard you the first time  I just was not sure what the implications
>>>> would be to use it. Hence I suggested a vendor specific property.
>>>> However, looking up and reading the definition in ePAPRv1.1 I suppose it
>>>> is fine to use the model property:
>>>>
>>>> Property: model
>>>> Value type: <string>
>>>> Description:
>>>> The model property value is a <string> that specifies the manufacturer’s
>>>> model number of the device.
>>>>
>>>> The recommended format is: “manufacturer,model”, where manufacturer is a
>>>> string describing the name of the manufacturer (such as a stock ticker
>>>> symbol), and model specifies the model number.
>>>
>>> The model property is very similar to compatible, except that there is
>>> only one entry rather than a list of entries from most specific to
>>> most generic.
>>
>> They seem very similar, but I think there is a conceptual difference.
>> The compatible property is mainly used to select the appropriate driver
>> and as such the property is typically ignored by device drivers.
>> Probably there are exceptions to be found.
>>
>>> I think by writing the above example as
>>>
>>>       compatible = "ampak,ap6210", "brcm,bcm4329-fmac";
>>>
>>> we can provide the same functionality in a slightly simpler way, the driver
>>> then just goes on to look for the nvram file for each entry in sequence until
>>> it finds one.
>>
>> Not sure why this would be simpler. Why would traversing the compatible
>> string be simpler than handling the model property if present and
>> otherwise fallback to the default nvram naming.
> 
> Because you have to walk the list anyway to find the other firmware files:
> when you have a specialization of a device that requires listing both values
> as compatible, the driver has no idea which of the entries to use, unless
> you add a lookup table that adds more complexity.

Currently, the brcmfmac bindings describe a single compatible string,
ie. "brcm,bcm4329-fmac", which selects the driver/programming model. If
that programming model supports "use model property if present,
otherwise use default" there is nothing to traverse. The default way in
the driver to determine firmware and nvram filename already has a lookup
table which uses the chip id and chip revision as key, which are read
from the device.

Regards,
Arend
