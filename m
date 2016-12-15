Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:34645 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbcLOUNA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 15:13:00 -0500
Received: by mail-qt0-f171.google.com with SMTP id n6so68263619qtd.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 12:12:51 -0800 (PST)
Subject: Re: wl1251 & mac address & calibration data
To: =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <201611111820.52072@pali> <201611241749.33681@pali>
 <20161124181138.4i6ehkpohjxfgpbn@earth> <201611241935.32796@pali>
 <87d1gtli57.fsf@purkki.adurom.net> <1481816017.2090.2.camel@Pali-Nokia-N900>
Cc: Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Michal Kazior <michal.kazior@tieto.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <76365770-f5ba-9565-3fca-710518f64d81@broadcom.com> (sfid-20161215_211321_568984_20BA1BD6)
Date: Thu, 15 Dec 2016 21:12:47 +0100
MIME-Version: 1.0
In-Reply-To: <1481816017.2090.2.camel@Pali-Nokia-N900>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-12-2016 16:33, Pali Rohár wrote:
> On Thu Dec 15 09:18:44 2016 Kalle Valo <kvalo@codeaurora.org> wrote:
>> (Adding Luis because he has been working on request_firmware() lately)
>>
>> Pali Rohár <pali.rohar@gmail.com> writes:
>>
>>>>> So no, there is no argument against... request_firmware() in
>>>>> fallback mode with userspace helper is by design blocking and
>>>>> waiting for userspace. But waiting for some change in DTS in
>>>>> kernel is just nonsense.
>>>>
>>>> I would just mark the wlan device with status = "disabled" and
>>>> enable it in the overlay together with adding the NVS & MAC info.
>>>
>>> So if you think that this solution make sense, we can wait what net 
>>> wireless maintainers say about it...
>>>
>>> For me it looks like that solution can be:
>>>
>>> extending request_firmware() to use only userspace helper
>>
>> I haven't followed the discussion very closely but this is my preference
>> what drivers should do:
>>
>> 1) First the driver should do try to get the calibration data and mac
>>        address from the device tree.
>>
> 
> Ok, but there is no (dynamic, device specific) data in DTS for N900. So 1) is noop.

Uhm. What do you mean? You can propose a patch to the DT bindings [1] to
get it in there and create your N900 DTB or am I missing something here.
Are there hardware restrictions that do not allow you to boot with your
own DTB.

>> 2) If they are not in DT the driver should retrieve the calibration data
>>        with request_firmware(). BUT with an option for user space to
>>        implement that with a helper script so that the data can be created
>>        dynamically, which I believe openwrt does with ath10k calibration
>>        data right now.
> 
> Currently there is flag for request_firmware() that it should fallback to user helper if direct VFS access not find needed firmware.
> 
> But this flag is not suitable as /lib/firmware already provides default (not device specific) calibration data.
> 
> So I would suggest to add another flag/function which will primary use user helper.

I recall Luis saying that user-mode helper (fallback) should be
discouraged, because there is no assurance that there is a user-mode
helper so you might just be pissing in the wind. The idea was to have a
dedicated API call that explicitly does the request towards user-space.

By the way, are we talking here about wl1251 device or driver as you
also mentioned wl12xx? I did not read the entire thread.

Regards,
Arend
