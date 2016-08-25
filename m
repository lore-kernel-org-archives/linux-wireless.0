Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:32955 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758942AbcHYPAR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 11:00:17 -0400
Received: by mail-oi0-f48.google.com with SMTP id c15so70103379oig.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2016 07:59:32 -0700 (PDT)
Subject: Re: rtl8192ce
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Lobachevskii Vitalii <silverunicorn2011@yandex.ru>
References: <321381b3-5dea-f16a-56cb-11120d4a38ef@yandex.ru>
 <72b958e1-0200-cd6f-2012-e04ff6fb74cb@yandex.ru>
 <wrfjmvk1asxp.fsf@redhat.com>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <6f06ce56-6289-6931-973f-1c52886e2b45@lwfinger.net> (sfid-20160825_170058_017825_CDE68E3D)
Date: Thu, 25 Aug 2016 09:59:30 -0500
MIME-Version: 1.0
In-Reply-To: <wrfjmvk1asxp.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/25/2016 08:17 AM, Jes Sorensen wrote:
> Lobachevskii Vitalii <silverunicorn2011@yandex.ru> writes:
>> Hello,
>>
>> The RTL8192CE device seems to work fine without any firmware, so you may
>> make it fully optional, removing dependency on FW_LOADER. Of course that
>> require some patching, but if I understood the driver internals
>> correctly, simple complete(&rtlpriv->firmware_loading_complete); would
>> be enough when firmware loading machinery is unavailable, that is, when
>> request_firmware_nowait returns -EINVAL (currently that may only happen
>> in improperly configured or patched kernels, like Linux-libre; see
>> attached messages for more information)
>>
>> Of course I will try to fix Linux-libre “deblobbing” technique, as it
>> should never break anything that may work without a firmware. But
>> anyway, if a device and its driver may work without a certain kernel
>> feature, that feature should not be selected, I think.
>
> The realtek devices all require firmwere to operate correctly,
> including the 8192c series. There are a bunch of commands flying back
> and forth between the driver and the firmware.
>
> If your device happens to work without loading the firmware then you
> have an old firmware blob loaded.
>
> At least this is the case for the USB version of the device, and I find
> it highly unlikely the PCIe version is any different.
>
> Trying to remove the firmware loading error is just plain silly.

I have not bothered my Realtek contacts with such a question, but I have a 
plausible explanation. If an RTL8192CE functions without loading external 
firmware, it is because the device has minimal function built in the default 
firmware. Mostly this rudimentary firmware is used to boot the device and to 
download the firmware for complex wireless communication. Rudimentary wifi 
functions would be needed for wake-on-lan operations. The fact that Realtek has 
never implemented WOL for the 8192C chips is highly suggestive that they do not 
function very well in that capacity.

If the RTL8192CE actually runs without loading external firmware, then I am 
quite sure that it will be restricted to 802.11g at the most, and more likely 
802.11b. If it handles any 802.11n capabilities, then that firmware will 
certainly not have any of the bug fixes applied to the firmware since the 
earliest release.

You are certainly allowed to configure your system any way you want, but please 
do not send any such "fixes" to the kernel sources. They will NEVER be accepted!

Configuring a kernel without firmware loading capacity is indeed silly.

Larry
