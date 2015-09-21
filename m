Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34416 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbbIUFvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 01:51:15 -0400
Received: by wicfx3 with SMTP id fx3so129665529wic.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2015 22:51:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55F1BFBF.5060901@candelatech.com>
References: <773DB8A82AB6A046AE0195C68612A31901BBD213@sbs2003.acksys.local>
	<55F1BFBF.5060901@candelatech.com>
Date: Mon, 21 Sep 2015 07:51:14 +0200
Message-ID: <CA+BoTQkOOmUZ8qW4Y5h7mrJpvqEsWi2ZGP-+XwesRdxx1z+_+Q@mail.gmail.com> (sfid-20150921_075119_265853_FE6AC1F7)
Subject: Re: Ath10K issue
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Cedric VONCKEN <cedric.voncken@acksys.fr>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think anything from
https://github.com/kvalo/ath10k-firmware/tree/master/10.2.4/untested
should support mgmt-over-htt.


Michał

On 10 September 2015 at 19:37, Ben Greear <greearb@candelatech.com> wrote:
> You probably need a firmware with mgt over htt.  CT firmware has this, but
> you have to run our
> kernel patches to allow CT htt-mgt firmware to work.
>
> Upstream may have it as well in latest firmware...I'm not sure exactly what
> versions
> do support that though.
>
> Thanks,
> Ben
>
>
>
> On 09/09/2015 10:13 AM, Cedric VONCKEN wrote:
>>
>>         I'm using compat-wireless 2015-03-09 from openwrt.
>>
>>         At the power up, these equipments worked in AP mode and several
>> sta can do an association.
>>         Randomly it is not possible to make association to several AP.
>>
>>         If I look the log file I see cyclically these error messages.
>> Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.116104] ath10k_warn: 186
>> callbacks suppressed
>> Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.133185] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 3, skipped old beacon
>> Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.153058] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 0, skipped old beacon
>> Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.157255] ath10k_pci
>> 0001:02:00.0: reached WMI management transmit queue limit
>> Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.157260] ath10k_pci
>> 0001:02:00.0: failed to transmit packet, dropping: -16
>> Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.212297] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 2, skipped old beacon
>> Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.232087] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 3, skipped old beacon
>> Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.252874] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 0, skipped old beacon
>> Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.286774] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 2, skipped old beacon
>> Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.320914] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 3, skipped old beacon
>> Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.355043] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 0, skipped old beacon
>> Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.167694] ath10k_warn: 193
>> callbacks suppressed
>> Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.184778] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 0, skipped old beacon
>> Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.204514] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 2, skipped old beacon
>> Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.225098] ath10k_pci
>> 0001:02:00.0: reached WMI management transmit queue limit
>> Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.235968] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 3, skipped old beacon
>> Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.264524] ath10k_pci
>> 0001:02:00.0: failed to transmit packet, dropping: -16
>> Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.270094] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 0, skipped old beacon
>> Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.303945] ath10k_pci
>> 0001:02:00.0: failed to transmit management frame via WMI: -11
>> Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.304408] ath10k_pci
>> 0001:02:00.0: reached WMI management transmit queue limit
>> Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.304414] ath10k_pci
>> 0001:02:00.0: failed to transmit packet, dropping: -16
>> Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.363876] ath10k_pci
>> 0001:02:00.0: SWBA overrun on vdev 2, skipped old beacon
>> Wed Sep  9 10:29:59 2015 kern.warn kernel: [17664.219316] ath10k_warn: 208
>> callbacks suppressed
>>
>>         To reestablish my access point I need to restart the Wifi (wifi up
>> in openwrt).
>>
>>         Have you any idea of this issue?
>>
>>         Regards.
>>
>> Cédric Voncken.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
