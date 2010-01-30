Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f173.google.com ([209.85.223.173]:63627 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab0A3Vz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 16:55:59 -0500
Received: by iwn3 with SMTP id 3so3023218iwn.23
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2010 13:55:58 -0800 (PST)
Message-ID: <4B64AAEB.9020806@lwfinger.net>
Date: Sat, 30 Jan 2010 15:55:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in b43 with BCM4311/2
References: <4B64A2F2.6060608@lwfinger.net> <1264887027.3546.207.camel@johannes.local>
In-Reply-To: <1264887027.3546.207.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2010 03:30 PM, Johannes Berg wrote:
> Larry,
> 
>> commit c7ab5ef9bcd281135c21b4732c9be779585181be
>> Author: Johannes Berg <johannes@sipsolutions.net>
>> Date:   Wed Oct 29 20:02:12 2008 +0100
>>
>>     b43: implement short slot and basic rate handling
> 
>> It seemed unlikely that the short slot handling was the cause, thus I have
>> concentrated on the basic rate handling. I found that the returns from
>> ieee80211_get_response_rate() were not what I expected. I'm not sure the routine
>> is correct; however, the value for "brates" at entry to b43_update_basic_rates()
>> is 0xF, thus only the CCK rates are enabled, but sband->n_bitrates is 12, which
>> includes all the 802.11g rates.
> 
> It doesn't really depend on your supported rates, if your AP says that
> only CCK rates are basic rates (you can see that in iw scan output, they
> are marked with a *) then they need to be used for response frames, as
> per 802.11-2007 9.6 paragraph 7:
> 
>         To allow the transmitting STA to calculate the contents of the
>         Duration/ID field, a STA responding to a received frame shall
>         transmit its Control Response frame (either CTS or ACK), other
>         than the BlockAck control frame, at the highest rate in the
>         BSSBasicRateSet parameter that is less than or equal to the rate
>         of the immediately previous frame in the frame exchange sequence
>         (as defined in 9.12) and that is of the same modulation class
>         (see 9.6.1) as the received frame. If no rate contained in the
>         BSSBasicRateSet parameter meets these conditions, then the
>         control frame sent in response to a received frame shall be
>         transmitted at the highest mandatory rate of the PHY that is
>         less than or equal to the rate of the received frame, and that
>         is of the same modulation class as the received frame. In
>         addition, the Control Response frame shall be sent using the
>         same PHY options as the received frame, unless they conflict
>         with the requirement to use the BSSBasicRateSet parameter.
>         
> 
> Then again, if I read that correctly, we should be checking the
> modulation classes, will have to take a closer look at 9.6.1.

My AP returns the following in the scan output:

Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
          24 Mb/s; 36 Mb/s; 54 Mb/s
Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s

I don't see any * markings.

>> Is b43 missing something needed to set the basic_rates member of struct
>> ieee80211_bxx_conf to a more reasonable value when b43_op_bss_info_changed() is
>> entered? I think it should be 0xFFF, not 0xF. I have tested with the larger
>> value and found that this change did not improve transmit rates.
> 
> So you're saying it doesn't help anyway?

Yes, it does not help. Since my previous message, I have also tested the short
slot logic. Inverting the test made no difference.

Larry
