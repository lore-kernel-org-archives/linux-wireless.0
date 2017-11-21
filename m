Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:34054 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbdKUOIV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 09:08:21 -0500
Received: by mail-wr0-f176.google.com with SMTP id k18so6470669wre.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Nov 2017 06:08:20 -0800 (PST)
Subject: Re: rtl8723be on Fedora27
To: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
References: <f5876284-360c-e6bf-01c8-ed95c4298647@gmail.com>
 <3a1fc541-9104-2d13-409f-c8e64845a86d@lwfinger.net>
 <c6662534-db2f-61dc-142e-8015984c6813@gmail.com>
 <2524fe93-9d8a-523e-3256-2b495c951eb0@lwfinger.net>
From: =?UTF-8?Q?R=c3=a1kosi_Gergely?= <rakosi.gergely@gmail.com>
Message-ID: <d4ba5178-3d60-76b0-3819-e70e3e173fac@gmail.com> (sfid-20171121_150828_393859_251DAEDF)
Date: Tue, 21 Nov 2017 15:08:16 +0100
MIME-Version: 1.0
In-Reply-To: <2524fe93-9d8a-523e-3256-2b495c951eb0@lwfinger.net>
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2017-11-18 16:52 keltezéssel, Larry Finger írta:
> On 11/17/2017 06:22 PM, Rákosi Gergely wrote:
>> Hello Larry,
>>
>> First of all, thanks your help.
>> Lets see...here is the kernel version: 4.13.12-300
>> The machine is an Asus ROG 553VE
>>
>> The firmware which loading in the dmesg is : rtlwifi/rtl8723befw_36.bin
>> The output of md5sum is : 1850c1308fbcd95e9f6a7f58ede1e35f
>
> In mailing lists like this, top posting is not recommended. Please
> read http://www.idallen.com/topposting.html for a good explanation why
> top posting is not good, particularly for complicated threads.
>
> You have the correct firmware. By the way, the code in 4.13.12 should
> be better that rtlwifi_new. That latter repo is deliberately kept a
> little bit behind just in case there is a regression.
>
> With NO options in the loading, please run the following:
>
> iw dev
>
> You should only see one device. On the "Interface" line, note what
> your system calls the wifi device. Substitute that for the "wlan0" in
> the next command:
>
> sudo iw dev wlan0 scan | egrep "SSID|signal"
>
> Post that output. In addition, copy the dmesg output to some pastebin
> and post the link as well.
>
> Larry
>
Hello Larry,

I hope this email post format is good, and fit to the rules.
Here is the output:

root@skynet-x2 ~]# iw dev wlp2s0 scan | egrep "SSID|signal"
        signal: -46.00 dBm
        SSID: SKYNET-X2
        signal: -46.00 dBm
        SSID: SKYNET-GYEREK
        signal: -56.00 dBm
        SSID: BALUHALO
        signal: -52.00 dBm
        SSID: Apavik
        signal: -54.00 dBm
        SSID: UPC Wi-Free
        signal: -56.00 dBm
        SSID: CsomadAirport
        signal: -54.00 dBm
        SSID: Apavik2
[root@skynet-x2 ~]#

And the dmesg output:

https://pastebin.com/iqQSu2hD

Thanks,
Gergely
