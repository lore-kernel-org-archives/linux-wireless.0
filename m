Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:15787 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752328AbdATPfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 10:35:07 -0500
Subject: Re: [RFC 0/1] ath9k: Frame corruption simulator
To: Ben Greear <greearb@candelatech.com>
References: <1484922570-23659-1-git-send-email-Wojciech.Dubowik@neratec.com>
 <58822285.30008@candelatech.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
From: Wojciech Dubowik <wojciech.dubowik@neratec.com>
Message-ID: <86f1a341-f1f4-7d49-9cf2-88aa815b0890@neratec.com> (sfid-20170120_163511_465907_9256FBD4)
Date: Fri, 20 Jan 2017 16:26:02 +0100
MIME-Version: 1.0
In-Reply-To: <58822285.30008@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 20/01/17 15:45, Ben Greear wrote:
>
>
> On 01/20/2017 06:29 AM, Wojciech Dubowik wrote:
>> I have been debugging customer reported timeout and loss of
>> communication and I have relaized that I don't have such a lossy
>> environment available in the lab. To speed up debugging I have
>> written frame corruption simulator which will allow me to
>> totally loose specific types of packets. I have been mostly
>> using it with the mask 0x5000 which drops some EAPOL
>> and deauthentication frames. This way I was able to test better
>> timeouts and fail paths.
>> At the moment only management, null function and EAPOL frames
>> are supported. One can add more if necessary.
>
> Would it be worth having a unique percentage configurable for each
> of the selected packet types?
I wanted to keep it simple. I have been just repeating test when I 
didn't have
luck with specific frame loss sequence. In real life conditions frame 
are not lost
more or less depending on the type. Unless there is a hacker behind;o)
>
> How about moving this up into mac80211 so other drivers could
> be supported as well?  Couldn't you just drop the frames instead
> of corrupting their checksum?  That would work with things like ath10k
> as well.
I have started so but then:
  1) no more tx flags available
  2) how other drivers can handle tx frame corruption in HW so it is 
eqivalent
   to frame corruption in the air
  3) info.control.flags are being freed at some point in ath9k and I 
don't know
    how it works in other drivers
  4) dropping is not equal tx failed with no ack as status for tx drop 
status is always ok
seen from mac layer.
   For example it makes a difference for hostapd with EAPOL TX Status. 
There, mlme
  sends an event when no ack is received and whole series failed. 
Actually one could
specify whether to drop, to corrupt or just add random data.

Wojtek
>
> I would like to have something like this, but with the added ability
> to corrupt specific things like information-elements in management
> frames to better test the receiver's packet parsing and error checking
> logic.  For this feature, checksum would not be corrupted.
>
> Thanks,
> Ben
