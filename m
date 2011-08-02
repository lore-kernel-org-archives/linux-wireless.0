Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54344 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1HBKPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 06:15:18 -0400
Received: by vxh35 with SMTP id 35so4832281vxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 03:15:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN=pzdJdFCqvif2qgq-jwDJ2h7n-nS7S8=A63BL_qBZqM7W5Xw@mail.gmail.com>
References: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com>
	<CAN=pzd+EFcyRnexjiMMLNR86hT_UKiePr=yCkZZk5dD4sqYSew@mail.gmail.com>
	<CAN=pzdL596WrhmaWWE6s_ouAmR-zSr1bUki2YVzLKgE1Y2VijQ@mail.gmail.com>
	<201107220929.35836.helmut.schaa@googlemail.com>
	<CAN=pzdJdFCqvif2qgq-jwDJ2h7n-nS7S8=A63BL_qBZqM7W5Xw@mail.gmail.com>
Date: Tue, 2 Aug 2011 14:15:18 +0400
Message-ID: <CAN=pzdLV3WBb_WxLLo2NefP7--TJ+4zByC8JfpVDJT_=2tQh0Q@mail.gmail.com> (sfid-20110802_121522_048530_8B27319A)
Subject: Re: rt2x00, AP mode, 802.11n is not working properly
From: Stanislav Demakov <s.demakov@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Any update on fixing poor tx speed in rt2x00 driver?

2011/7/22 Stanislav Demakov <s.demakov@gmail.com>:
> Thank you for the assistance, ask If you'll need anyhitng else to test.
>
> By the way I've tested transfer speed in both directions and the results are:
>
> from Server to Client: ~2.5 MB/s (after applying your patch and
> changing value 8 back to 64)
> from Client to Server: ~5.3 MB/s
>
> Both machines uses 1T1R modules and connection is 65mbps (20mhz, MCS7)
> So I guess in ideal case Server to Client speed should be at least
> twice faster than it is now.
> Interesting that in G mode(54mbps) the same transmit speed is around 3.2 MB/s.
>
> 2011/7/22 Helmut Schaa <helmut.schaa@googlemail.com>:
>> Am Donnerstag, 21. Juli 2011 schrieb Stanislav Demakov:
>>> Quick note: changed .entry_num value back to 64 and the speed raised
>>> even more! Now it's about 2.5 MB/s.
>>
>> 64 is not a safe value in this case and rt2800usb_txdone_entry_check tries
>> to protect against a special case where the tx status for single frames
>> gets "lost". But at least we now know a little more about this issue.
>>
>>> But still there is still room for improvement. :)
>>> Looks like rt2800usb_txdone_entry_check was the major cause for the delay.
>>
>> Ok, thanks for trying. I'll think about a proper solution without causing
>> regressions ...
>>
>> Helmut
>>
>
