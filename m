Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queue02.mail.zen.net.uk ([212.23.3.27]:40330 "EHLO
	queue02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab0IGWV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 18:21:56 -0400
Message-ID: <4C86BA9B.7030406@csr.com>
Date: Tue, 07 Sep 2010 23:20:11 +0100
From: David Vrabel <david.vrabel@csr.com>
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>
References: <1283858949-11073-1-git-send-email-ohad@wizery.com> <1283858949-11073-9-git-send-email-ohad@wizery.com> <4C8637D2.5070703@csr.com> <AANLkTimgk9JM_c20vcZegBufGDx07PBYK_+omMxBMZq-@mail.gmail.com>
In-Reply-To: <AANLkTimgk9JM_c20vcZegBufGDx07PBYK_+omMxBMZq-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [PATCH v1 8/8] wireless: wl1271_sdio: enable Runtime PM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2010 14:15, Ohad Ben-Cohen wrote:
> On Tue, Sep 7, 2010 at 4:02 PM, David Vrabel <david.vrabel@csr.com> wrote:
>> Ohad Ben-Cohen wrote:
>>> Enable runtime pm for the wl1271 SDIO device.
>>>
>>> We request power whenever the WLAN interface is brought up,
>>> and release it after the WLAN interface is taken down.
>>>
>>> As a result, power is released immediately after probe returns,
>>> since at that point power has not been explicitly requested yet
>>> (i.e. the WLAN interface is still down).
>> [...]
>>> @@ -233,6 +241,8 @@ static int __devinit wl1271_probe(struct sdio_func *func,
>>>
>>>       sdio_set_drvdata(func, wl);
>>>
>>> +     pm_runtime_put_noidle(&func->dev);
>>
>> I find this a little odd and confusing as this is releasing the
>> reference taken by mmc core from inside the function driver.
> 
> This is done in order to still support function drivers that are not
> aware of runtime pm (same approach was taken in the PCI implementation
> of runtime pm).

Best to do the same as PCI then.

David
