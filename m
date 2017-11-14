Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:53791 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753804AbdKNMuQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 07:50:16 -0500
Received: by mail-pf0-f174.google.com with SMTP id b6so14105846pff.10
        for <linux-wireless@vger.kernel.org>; Tue, 14 Nov 2017 04:50:16 -0800 (PST)
Subject: Re: Slow connection with rtl8xxxu and 8192eu chipset
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
References: <1195e649-c57f-1247-a0dc-2f0cc0732a00@gmail.com>
 <87inedkp5h.fsf@purkki.adurom.net>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <c1ef2d69-a30a-ceb2-d258-cca023117e07@gmail.com> (sfid-20171114_135023_864486_9C4054AD)
Date: Tue, 14 Nov 2017 14:50:09 +0200
MIME-Version: 1.0
In-Reply-To: <87inedkp5h.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14.11.2017 14:42, Kalle Valo wrote:
> Nikolay Borisov <n.borisov.lkml@gmail.com> writes:
> 
>> (Please CC as I'm not subscribed)
>>
>> Hello,
>>
>> I have the tp-link tl-wn822N usb wifi dongle. lsbusb reports it as
>>
>> Bus 001 Device 003: ID 2357:0108
>>
>> Unfortunately with the in-kernel rtl8xxxu driver I don't get very good
>> results:
>>
>> wifi1     IEEE 802.11  ESSID:"HOME"
>>           Mode:Managed  Frequency:2.462 GHz  Access Point:
>> 30:B5:C2:75:A4:CD
>>           Bit Rate=1 Mb/s   Tx-Power=20 dBm
>>           Retry short limit:7   RTS thr=2347 B   Fragment thr:off
>>           Power Management:off
>>           Link Quality=26/70  Signal level=-84 dBm
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:0  Invalid misc:165   Missed beacon:0
>>
>>
>> At the same time if I use an out of tree driver acquired from github:
>> https://github.com/Mange/rtl8192eu-linux-driver I get the following:
>>
>> wifi1     IEEE 802.11bgn  ESSID:"HOME"  Nickname:"<WIFI@REALTEK>"
>>           Mode:Managed  Frequency:2.462 GHz  Access Point:
>> 30:B5:C2:75:A4:CD
>>           Bit Rate:144.4 Mb/s   Sensitivity:0/0
>>           Retry:off   RTS thr:off   Fragment thr:off
>>           Power Management:off
>>           Link Quality=81/100  Signal level=100/100  Noise level=0/100
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>
>> Clearly this is a software problem of the in-kernel driver.
> 
> iwconfig is old and not really properly supported anymore. Instead use
> iw and specifically 'iw wlan0 link' to check the transmit rate. And then
> testing speed it's best to use tools like iperf to verify the real
> speed, not just rely on what tools report.

To measure the speed I actually used a proper internet transfer. So in
reality I could hardly get more than 10 megabits with the built-in
adapter, whereas I'm getting 70-80 megabits otherwise. Of course the
test was performed to the same location everytime to reduce noise.

> 
