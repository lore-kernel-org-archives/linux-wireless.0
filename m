Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41919 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3LMOV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 09:21:59 -0500
Message-ID: <52AB17E7.9080807@candelatech.com> (sfid-20131213_152202_280014_0E38F8EF)
Date: Fri, 13 Dec 2013 06:21:27 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: Question on software-crypt mode.
References: <52A87FBD.4000901@candelatech.com> <CA+BoTQkO+FyuAnLfo473QH=QK1FKtS7bQ8ZTXdOj67xSqUxWOw@mail.gmail.com>
In-Reply-To: <CA+BoTQkO+FyuAnLfo473QH=QK1FKtS7bQ8ZTXdOj67xSqUxWOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2013 02:53 AM, Michal Kazior wrote:
> On 11 December 2013 16:07, Ben Greear <greearb@candelatech.com> wrote:
>> Hello!
>>
>> I am trying to implement software-crypt for ath10k so that it can do crypt
>> with multiple stations connected to same AP.
>>
>> I tried using ath9k's approach and just not setting keys, but that does not
>> work at all
>> (no stations can communicate).
>>
>> If I basically leave code as is, then secondary stations can associate but
>> never
>> get DHCP.  I see FCS and hw-crypt errored packets being received from the
>> ath10k firmware/chip.  This is probably because the chip/firmware decodes
>> the
>> secondary station's packets with the first station's keys.
>> Transmitted packets (as sniffed from the AP) do appear fine.
>
> This sounds a lot like a multi-BSS issues that were discovered
> recently on AP branch firmware.

I think that it may be mostly impossible to
get hardware to do crypt with multiple STA associated to same AP
because hardware/firmware wants to hash on peer's MAC, and in this case,
I have multiple peers with same MAC.  I wanted to just ignore the RX crypt
errors and have the software RX path handle it up in mac80211, but
I did not make much progress when trying that.

I made some progress with software-only crypt, but I had to modify
firmware because it will not transmit the 4/4 handshake message until
key has been configured, and with sw-crypt, the key will never be
set.

With this change to the firmware, I can authenticate/connect to the AP, but DHCP will not work,
and the AP shows no received data packets.  I suspect the firmware is expecting the
tx packets to be un-encrypted and is either trying to crypt them again or is getting
confused when it cannot find packet headers where it expects them.

When I find time I will dig back into the firmware to work on this some more.

> See commit:
>
>    ath10k: fix multi BSSID with WPA on FW 10.1
>
> You could try applying the commit and remove the following code from it:
>
>    if (arvif->vdev_type != WMI_VDEV_TYPE_AP)
>      return;
>
> The commit was originally only tested against AP interfaces but I was
> suspecting the same thing (i.e. corrupted Tx) could be happening on
> multi-STA.

I will look at that as well.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

