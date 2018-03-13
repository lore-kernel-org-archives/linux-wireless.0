Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35198 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752397AbeCMUT1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 16:19:27 -0400
Received: by mail-wm0-f41.google.com with SMTP id x7so280528wmc.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2018 13:19:26 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Add support for getting nvram contents from EFI
 variables
To: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180311214751.12769-1-hdegoede@redhat.com>
 <5AA6409E.6050300@broadcom.com>
 <e98afbfb-35d0-8ae7-1377-d5e31a76dc4c@redhat.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AA8324C.4030505@broadcom.com> (sfid-20180313_211933_644660_A3C3ABB4)
Date: Tue, 13 Mar 2018 21:19:24 +0100
MIME-Version: 1.0
In-Reply-To: <e98afbfb-35d0-8ae7-1377-d5e31a76dc4c@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/12/2018 10:45 AM, Hans de Goede wrote:
> Hi,
>
> On 12-03-18 09:55, Arend van Spriel wrote:
>> On 3/11/2018 10:47 PM, Hans de Goede wrote:
>>> Various models Asus laptops with a SDIO attached brcmfmac wifi chip,
>>> store
>>> the nvram contents in a special EFI variable. This commit adds
>>> support for
>>> getting nvram directly from this EFI variable, without the user
>>> needing to
>>> manually copy it.
>>>
>>> This makes Wifi / Bluetooth work out of the box on these devices
>>> instead of
>>> requiring manual setup.
>>>
>>> Note that at least on the Asus T200TA the nvram from the EFI variable
>>> wrongly contains "ccode=ALL" which the firmware does not understand, the
>>> code to fetch the nvram from the EFI variable will fix this up to:
>>> "ccode=XV" which is the correct way to specify the worldwide broadcast
>>> regime.
>>>
>>> This has been tested on the following models: Asus T100CHI, Asus T100HA,
>>> Asus T100TA and Asus T200TA
>>
>> Hi Hans,
>>
>> I like to have this as well, but .... (see below)
>>
>>> Tested-by: Hans de Goede <hdegoede@redhat.com>
>>
>> Duh. I would expect anyone to have tested their patches although you
>> can not cover every system out there obviously :-p
>
> Heh, I added it in this case as I went to the trouble of finding 4 devices
> which use this and test it on all 4 devices.

Not really a problem, but it looked funny :-)

>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>> ---
>>>   .../broadcom/brcm80211/brcmfmac/firmware.c         | 68
>>> +++++++++++++++++++++-
>>>   1 file changed, 67 insertions(+), 1 deletion(-)
>>>
>>> diff --git
>>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>>> index 091b52979e03..cbac407ae132 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>>> @@ -14,6 +14,8 @@
>>>    * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>>>    */
>>>
>>> +#include <linux/dmi.h>
>>> +#include <linux/efi.h>
>>>   #include <linux/kernel.h>
>>>   #include <linux/slab.h>
>>>   #include <linux/device.h>
>>> @@ -446,6 +448,67 @@ struct brcmf_fw {
>>>                void *nvram_image, u32 nvram_len);
>>>   };
>>>
>>> +#ifdef CONFIG_EFI
>>> +static u8 *brcmf_fw_nvram_from_efi(size_t *data_len_ret)
>>> +{
>>> +    const u16 name[] = { 'n', 'v', 'r', 'a', 'm', 0 };
>>
>> Isn't there some helper function to make this conversion to u16 array?
>> Hmm, maybe it is my itch to scratch later :-)
>
> Nope, I copied this style from existing code under drivers/firmware/efi

Maybe I add a helper function at some point.

>>> +    struct efivar_entry *nvram_efivar;
>>> +    unsigned long data_len = 0;
>>> +    u8 *data = NULL;
>>> +    char *ccode;
>>> +    int err;
>>> +
>>> +    /* So far only Asus devices store the nvram in an EFI var */
>>> +    if (!dmi_name_in_vendors("ASUSTeK COMPUTER INC."))
>>> +        return NULL;
>>
>> Actually had a Sony device with nvram in EFI. Why not just drop this
>> optimization.
>
> Ok, do you know if that variable had the same name and guid though ?
> Because
> if it doesn't then this code is not going to work for the Sony case.

If I am not mistaken the name and guid are defined by Broadcom/Microsoft.

> Anyways the overhead is small and this only runs once, so I will drop the
> check for v2.

Due to XV issue we may want to keep the check for now.

>>> +    nvram_efivar = kzalloc(sizeof(*nvram_efivar), GFP_KERNEL);
>>> +    if (!nvram_efivar)
>>> +        return NULL;
>>> +
>>> +    memcpy(&nvram_efivar->var.VariableName, name, sizeof(name));
>>> +    nvram_efivar->var.VendorGuid = EFI_GUID(0x74b00bd9, 0x805a, 0x4d61,
>>> +                        0xb5, 0x1f, 0x43, 0x26,
>>> +                        0x81, 0x23, 0xd1, 0x13);
>>> +
>>> +    err = efivar_entry_size(nvram_efivar, &data_len);
>>> +    if (err)
>>> +        goto fail;
>>> +
>>> +    data = kmalloc(data_len, GFP_KERNEL);
>>> +    if (!data)
>>> +        goto fail;
>>> +
>>> +    err = efivar_entry_get(nvram_efivar, NULL, &data_len, data);
>>> +    if (err)
>>> +        goto fail;
>>> +
>>> +    /* In some cases the EFI-var stored nvram contains "ccode=ALL" but
>>> +     * the firmware does not understand "ALL" change this to "XV" which
>>> +     * is the correct way to specify the "worldwide" compatible
>>> settings.
>>> +     */
>>
>> This is actually quite bad. The ALL ccode should never end up on the
>> market as it is intended for internal use only during bringup project
>> phase so these seems to be programmed wrong.
>
> I see lots of cheap Windows 10 and ARM devices with brcmfmac sdio wifi
> which ship with on disk nvram files using the "ALL" ccode. I actually have
> pinned my home wifi at channel 13 to catch this, because channel 13 does
> not work with the ALL ccode. If I understand correctly the worldwide
> domain starts with channel 13/14 in passive/listen only mode and allows
> using them once it has seen valid wifi traffic on them, so they do allow
> communicating with an AP on channel 13 here in the Netherlands where that
> is allowed?

*sigh* (regarding ALL being shipped)

>> Also simply selecting XV instead is not correct. There is not just one
>> worldwide domain in the regulatory database of the firmware image.
>
> Right, I've read elsewhere that "X2" is the right magic value to use and
> I've tested that on some other devices and that does seem to work.
>
> I've also seen "XY" but the other Asus devices all use "XV" and that
> works (makes channel 13 work) so it seemed like a good value.
>
> Can you help me understand this problem a bit better? Is the problem with
> "XV" that it may not work with all firmware versions, so on some firmware
> versions it will be as bad as using ALL which the firmware also does not
> understand? Or do all firmwares understand XV / XY / X2 but are there
> subtle differences?

The firmware has a per-device recipe of what should be in the regulatory 
database and per release branch it can differ. So for the same device 
customer A could get XV and XY in the firmware regdb and customer B 
could get XY and X2.

> So how do you suggest we deal with this?
>
> One solution I see is:
>
> 1) check for ccode=ALL
> 2) if found use DMI strings to match the specific model and set a different
> ccode based on the model (so for now use XV for the T200TA only)
> 3) if found and the model is not known, warn about this and do nothing
>
> Would that work for you ?

I think so. I hope to get some more clarification from our regulatory 
team about the use of ALL and XV. Could you tell me what happens with 
T200TA when you leave ccode=ALL in place. What output do you get from 
"iw list"? Only channels 1 to 11 and no 5G? Or does it only have 2G.

>>>       if (raw_nvram)
>>> -        bcm47xx_nvram_release_contents(data);
>>> +        kvfree(data); /* vfree for bcm47xx case / kfree for efi case */
>>
>> While this clearly works I can not say I like this. If you want to do
>> it this way, please submit a patch to remove
>> bcm47xx_nvram_release_contents() as it is no longer needed since we
>> now have kvfree(). From maintainance perspective also drop the postfix
>> comment. We just might end up doing vmalloc in efi case at some point
>> and this would likely be forgotten.
>
> It might be better if I replace the raw_nvram variable which is poorly
> named with
> a "bool free_bcm47xx_nvram = false;" and add a "bool kfree_nvram = false;"
>
> Would that work for you ?

Sure.

Regards,
Arend
