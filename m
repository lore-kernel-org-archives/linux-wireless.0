Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35971 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2GZFBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 01:01:52 -0400
Received: by vbbff1 with SMTP id ff1so1301219vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 22:01:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XFjioVy_pmKxcJAe1U_M+zKNiiPEsb0bmkAfEWzmnnDBjLFw@mail.gmail.com>
References: <CAAT9HsjZ7wPbkRMH94HDNBS+vOhLigKLYULqfyQobh_Oyt9M4w@mail.gmail.com>
 <501030E9.3090707@lwfinger.net> <CAAT9Hshwb+iPMALGvP1P2UHzEQbyvYNM0_zz0dHp0mJuy6KwLA@mail.gmail.com>
 <50103BE8.1020203@lwfinger.net> <CAAT9HsjQ_tkm77NT_Rn5_Pi9BHGhY9Vz7jcVzkwdDUjUoKamtw@mail.gmail.com>
 <501061C8.5010108@lwfinger.net> <CA+XFjioVy_pmKxcJAe1U_M+zKNiiPEsb0bmkAfEWzmnnDBjLFw@mail.gmail.com>
From: Tim and Alison Bentley <Home@TRARBentley.net>
Date: Thu, 26 Jul 2012 06:01:31 +0100
Message-ID: <CAAT9HsgXHe-0qZ5vTvCuU8QZ006MrsCyu7Zc_PRFccz52TWcUw@mail.gmail.com> (sfid-20120726_070156_721763_DB4772BD)
Subject: Re: New Laptop and Driver
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 July 2012 02:25, Gábor Stefanik <netrolller.3d@gmail.com> wrote:
> On Wed, Jul 25, 2012 at 11:14 PM, Larry Finger
> <Larry.Finger@lwfinger.net> wrote:
>> On 07/25/2012 01:54 PM, Tim and Alison Bentley wrote:
>>>
>>> On 25 July 2012 19:33, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>>>
>>>> On 07/25/2012 01:00 PM, Tim and Alison Bentley wrote:
>>>>>
>>>>>
>>>>> 01:00.0 VGA compatible controller [0300]: nVidia Corporation Device
>>>>> [10de:0de9] (rev a1)
>>>>> 03:00.0 Network controller [0280]: Atheros Communications Inc. Device
>>>>> [168c:0037] (rev 01)
>>>>> 04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
>>>>> RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev
>>>>> 07)
>>>>
>>>>
>>>>
>>>> The Realtek device is the one used for your wired network.
>>>>
>>>> The Atheros device is not in the tables for the latest version of any
>>>> wireless driver. Perhaps it will work if you do the following:
>>>>
>>>> su -
>>>> modprobe -v ath9k
>>>> echo "168c 0037" > /sys/bus/pci/drivers/ath9k/new_id
>>>> exit
>>>>
>>>> The above will work if the driver handles the device, but it is not yet
>>>> in
>>>> the tables. Perhaps the Atheros developers will know the status of that
>>>> device.
>>>>
>>>> When replying to E-mail in this list, and most other technical mailing
>>>> lists, please do not top post. Always put your answer below the quoted
>>>> material as I did here.
>>>>
>>>> Larry
>>>>
>>>>
>>>>
>>> Sorry for top posting, bad habbit
>>> No luck with the suggestion and I tried a reboot for luck with no success.
>>
>>
>> The effect of those commands would have disappeared after a reboot. One last
>> thing to do is to check /var/log/messages to see if it complained about
>> missing firmware after you entered the new_id. There should be some kind of
>> error messages at that point, but it is likely that no Linux driver handles
>> this device.
>>
>> You might try ndiswrapper and the Windows driver, but if the system is
>> 64-bit, then that might not work either.
>>
>> Larry
>
> 168c:0037 appears to be a chipset called "AR1111", based on Windows
> drivers. However, I suspect this is a provisional/placeholder name.

Re ran the commands and have the /var/log/messages output

Jul 26 05:58:23 tigger2 kernel: [ 1546.876477] cfg80211: Calling CRDA
to update world regulatory domain
Jul 26 05:58:23 tigger2 kernel: [ 1546.916447] cfg80211: World
regulatory domain updated:
Jul 26 05:58:23 tigger2 kernel: [ 1546.916450] cfg80211:   (start_freq
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 26 05:58:23 tigger2 kernel: [ 1546.916453] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 26 05:58:23 tigger2 kernel: [ 1546.916455] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jul 26 05:58:23 tigger2 kernel: [ 1546.916457] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jul 26 05:58:23 tigger2 kernel: [ 1546.916459] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 26 05:58:23 tigger2 kernel: [ 1546.916461] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 26 05:58:30 tigger2 kernel: [ 1553.767939] ath: phy0: Hardware
device ID 0x0037 not supported
Jul 26 05:58:30 tigger2 kernel: [ 1553.767948] ath9k 0000:03:00.0:
Failed to initialize device
Jul 26 05:58:30 tigger2 kernel: [ 1553.768137] ath9k: probe of
0000:03:00.0 failed with error -95


-- 
Tim and Alison Bentley
Home@TRARBentley.net
