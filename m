Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34477 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab0IGNPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 09:15:39 -0400
MIME-Version: 1.0
In-Reply-To: <4C8637D2.5070703@csr.com>
References: <1283858949-11073-1-git-send-email-ohad@wizery.com>
 <1283858949-11073-9-git-send-email-ohad@wizery.com> <4C8637D2.5070703@csr.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 7 Sep 2010 16:15:19 +0300
Message-ID: <AANLkTimgk9JM_c20vcZegBufGDx07PBYK_+omMxBMZq-@mail.gmail.com>
Subject: Re: [PATCH v1 8/8] wireless: wl1271_sdio: enable Runtime PM
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 7, 2010 at 4:02 PM, David Vrabel <david.vrabel@csr.com> wrote:
> Ohad Ben-Cohen wrote:
>> Enable runtime pm for the wl1271 SDIO device.
>>
>> We request power whenever the WLAN interface is brought up,
>> and release it after the WLAN interface is taken down.
>>
>> As a result, power is released immediately after probe returns,
>> since at that point power has not been explicitly requested yet
>> (i.e. the WLAN interface is still down).
> [...]
>> @@ -233,6 +241,8 @@ static int __devinit wl1271_probe(struct sdio_func *func,
>>
>>       sdio_set_drvdata(func, wl);
>>
>> +     pm_runtime_put_noidle(&func->dev);
>
> I find this a little odd and confusing as this is releasing the
> reference taken by mmc core from inside the function driver.

This is done in order to still support function drivers that are not
aware of runtime pm (same approach was taken in the PCI implementation
of runtime pm).

> Instead, I would suggest changing all existing SDIO function drivers to
> call pm_runtime_get() in probe() and pm_runtime_put() in remove().

If we are willing to require runtime pm awareness from all SDIO
function drivers then we can do this (obviously we will break all
out-of-tree drivers by doing so).

> think this makes the runtime PM usage more obvious from a function
> driver point of view.
>
>> +
>>       wl1271_notice("initialized");
>>
>>       return 0;
>> @@ -255,6 +265,8 @@ static void __devexit wl1271_remove(struct sdio_func *func)
>>
>>       wl1271_unregister_hw(wl);
>>       wl1271_free_hw(wl);
>> +
>> +     pm_runtime_get_noresume(&func->dev);
>>  }
>>
>>  static struct sdio_driver wl1271_sdio_driver = {
>
> David
> --
> David Vrabel, Senior Software Engineer, Drivers
> CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
> Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
>
>
> Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
>
