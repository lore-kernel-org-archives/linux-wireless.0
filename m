Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54570 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbdAWT5F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 14:57:05 -0500
Subject: Re: [RFC 0/1] ath9k: Frame corruption simulator
To: Wojciech Dubowik <wojciech.dubowik@neratec.com>
References: <1484922570-23659-1-git-send-email-Wojciech.Dubowik@neratec.com>
 <58822285.30008@candelatech.com>
 <86f1a341-f1f4-7d49-9cf2-88aa815b0890@neratec.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <665b8830-c245-bb68-9e56-100cacc6f0c0@candelatech.com> (sfid-20170123_205709_108323_FBC9E15D)
Date: Mon, 23 Jan 2017 11:57:04 -0800
MIME-Version: 1.0
In-Reply-To: <86f1a341-f1f4-7d49-9cf2-88aa815b0890@neratec.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2017 07:26 AM, Wojciech Dubowik wrote:
>
>
> On 20/01/17 15:45, Ben Greear wrote:
>>
>>
>> On 01/20/2017 06:29 AM, Wojciech Dubowik wrote:
>>> I have been debugging customer reported timeout and loss of
>>> communication and I have relaized that I don't have such a lossy
>>> environment available in the lab. To speed up debugging I have
>>> written frame corruption simulator which will allow me to
>>> totally loose specific types of packets. I have been mostly
>>> using it with the mask 0x5000 which drops some EAPOL
>>> and deauthentication frames. This way I was able to test better
>>> timeouts and fail paths.
>>> At the moment only management, null function and EAPOL frames
>>> are supported. One can add more if necessary.
>>
>> Would it be worth having a unique percentage configurable for each
>> of the selected packet types?
> I wanted to keep it simple. I have been just repeating test when I didn't have
> luck with specific frame loss sequence. In real life conditions frame are not lost
> more or less depending on the type. Unless there is a hacker behind;o)
>>
>> How about moving this up into mac80211 so other drivers could
>> be supported as well?  Couldn't you just drop the frames instead
>> of corrupting their checksum?  That would work with things like ath10k
>> as well.
> I have started so but then:
>  1) no more tx flags available

Look through the kernel code for SO_NOFCS.  I bet that path would give you
the ability to pass down a corrupted FCS on demand.

>  2) how other drivers can handle tx frame corruption in HW so it is eqivalent
>   to frame corruption in the air
>  3) info.control.flags are being freed at some point in ath9k and I don't know
>    how it works in other drivers
>  4) dropping is not equal tx failed with no ack as status for tx drop status is always ok
> seen from mac layer.

You should be able to lie to the mac80211 stack and tell it the frame had a tx-failure.

I also plan to start hacking some logic into wpa_supplicant later this week to allow it to delay and/or
corrupt the 4-way auth messages (and others after that).  That feature may also help
with your testing...

Thanks,
Ben

>   For example it makes a difference for hostapd with EAPOL TX Status. There, mlme
>  sends an event when no ack is received and whole series failed. Actually one could
> specify whether to drop, to corrupt or just add random data.
>
> Wojtek
>>
>> I would like to have something like this, but with the added ability
>> to corrupt specific things like information-elements in management
>> frames to better test the receiver's packet parsing and error checking
>> logic.  For this feature, checksum would not be corrupted.
>>
>> Thanks,
>> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
