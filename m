Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:32770 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbdCBMi4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 07:38:56 -0500
Received: by mail-wr0-f180.google.com with SMTP id u48so51090382wrc.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Mar 2017 04:37:08 -0800 (PST)
Subject: Re: Hostapd de-auth connected clients
To: ravin goyal <ravirocks1021@gmail.com>
References: <CANU0Mn0MbLW8JypG7_CFtAjeb6uY+EmBT-+sfu5y3=vKj6UYRA@mail.gmail.com>
 <20170225080233.GC4073@w1.fi>
 <CANU0Mn1pr6DMnAVKHEL63=8DU9CB=-srHzpmY166ZXmBKZs=uA@mail.gmail.com>
 <CANU0Mn17uPo15RrVF-rpTXi1zKwwfC+xuT-dDD0vn-QHZ1Ng6g@mail.gmail.com>
 <20170228222851.GA28908@w1.fi>
 <3a810235-736d-733a-b647-5b62fef5672f@broadcom.com>
 <CANU0Mn0yHhf+wjmTfo5-KPbqcWZMDOfs32ZWQndhftyQRFDBUw@mail.gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
        wpa_supplicant <hostap@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <04d7fcd5-52eb-760d-a74b-c93756321c9e@broadcom.com> (sfid-20170302_133859_811011_D1A8F809)
Date: Thu, 2 Mar 2017 13:37:05 +0100
MIME-Version: 1.0
In-Reply-To: <CANU0Mn0yHhf+wjmTfo5-KPbqcWZMDOfs32ZWQndhftyQRFDBUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

On 2-3-2017 10:28, ravin goyal wrote:
> Hi Arend
> 
> Thanks, I will certainly try with brcmfmac if you say so.
> Currently I am testing hostapd on orange pi zero board running debian
> jessie and its wlan driver is xradio_wlan and it is working fine.
> I don't know why raspbian and debian have introduced bcmdhd for WLAN
> in their distros.
> I have filed bug on raspbian but received on response yet.

Now it gets confusing. From what I found xradio_wlan is for some
Allwinner flavor based on ST/Ericsson chipset with sdio id 0020:2281.
That would not be a device that bcmdhd would try to bind to.

Regards,
Arend

> Regards
> Ravin
> 
> On 1 March 2017 at 18:59, Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>> On 28-2-2017 23:28, Jouni Malinen wrote:
>>> On Tue, Feb 28, 2017 at 04:06:48PM +0530, ravin goyal wrote:
>>>> I am sharing link to recent debug log related to de-auth messages in
>>>> hostapd, I hope it might help to figure out what's really happening
>>>> and to know whether it is due to driver or hostapd.
>>>>
>>>> Please take a look at this.
>>>>
>>>> link to log file: https://clbin.com/0flGD
>>>
>>> It looks like number of the disconnections in the two logs are triggered
>>> by station inactivity check:
>>>
>>> 1488275056.529235: wlan0: Station 00:73:8d:43:87:2e has been inactive too long: 308 sec, max allowed: 300
>>> 1488275056.529389:   Polling STA
>>> 1488275056.529457: nl80211: send_mlme - da= 00:73:8d:43:87:2e noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0x248 (WLAN_FC_STYPE_NULLFUNC) nlmode=3
>>> 1488275056.529574: nl80211: Use bss->freq=2442
>>> 1488275056.529634: nl80211: CMD_FRAME freq=2442 wait=0 no_cck=0 no_ack=0 offchanok=0
>>> 1488275056.529711: CMD_FRAME - hexdump(len=24): 48 02 00 00 00 73 8d 43 87 2e 02 1a 11 f5 47 06 02 1a 11 f5 47 06 00 00
>>> 1488275056.530129: nl80211: Frame command failed: ret=-22 (Invalid argument) (freq=2442 wait=0)
>>> 1488275056.530231: nl80211_send_null_frame: Failed to send poll frame
>>> 1488275056.530295: ap_handle_timer: register ap_handle_timer timeout for 00:73:8d:43:87:2e (1 seconds - AP_DISASSOC_DELAY)
>>>
>>>
>>> This code should not have been triggered at all if the driver reported
>>> activity in the expected way, so I'm assuming the driver does not
>>> support that.. And then it does not support sending out the poll frame
>>> to check whether the STA is still there.
>>>
>>> You might be able to work around this by setting a significantly larger
>>> ap_max_inactivity value in hostapd.conf, but for a proper fix, someone
>>> more familiar with the particular driver would need to take a look at
>>> what's happening and why the driver does not indicate station activity.
>>
>> I would suggest trying brcmfmac instead of bcmdhd. The bcmdhd is
>> specifically for Android and verification is done on Android targets.
>> Not saying your problems will be gone, but at least you can ask me for help.
>>
>> Regards,
>> Arend
