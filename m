Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:58771 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaFEQYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 12:24:02 -0400
Received: by mail-ve0-f175.google.com with SMTP id jw12so1496607veb.20
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 09:24:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53909602.5010703@candelatech.com>
References: <CALCETrU=8+tnptdfva4p27nA-5=E31DwXagoLqUxYcLtEKrB+w@mail.gmail.com>
 <CA+BoTQmUyvTr+ga81EacbMkE4UVtMBP2PfBs_vH-PF4OvHuZQg@mail.gmail.com>
 <CALCETrUDWvXddiACacre3erhwrKCjO53iHVKmPrApTi65Z5yBA@mail.gmail.com>
 <87r433ps7w.fsf@kamboji.qca.qualcomm.com> <53909602.5010703@candelatech.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 5 Jun 2014 09:23:41 -0700
Message-ID: <CALCETrVugM9gTB20ACOmiFie8kuiGBSrJTV8q2AZTqCULRLzyw@mail.gmail.com> (sfid-20140605_182406_883486_B3333A3C)
Subject: Re: compat-wireless-2014-05-22 breaks ath10k in an Archer C7 v2
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 5, 2014 at 9:08 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 06/05/2014 03:26 AM, Kalle Valo wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Thu, May 29, 2014 at 12:48 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>>> +ath10k@lists.infradead.org
>>>>
>>>> On 28 May 2014 20:35, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>> It dies with 'otp calibration failed: 2'.
>>>>>
>>>>> Some older version of the driver seemed to work fine.
>>>>
>>>> ath10k did not verify otp result before so it could load successfully
>>>> despite errors.
>>>>
>>>> Someone raised this problem yesterday on IRC. I'm not really sure how
>>>> we should deal with this properly.
>>>
>>> Ideally, someone from Atheros could figure out what the error is.
>>
>> Michal already did. The error means that for some reason the
>> calibaration data was not found from OTP. OTP is the storage area where
>> the calibration data is normally stored within QCA9880.
>
> I fought this with .387 firmware and WLE900VX NICs.  If it's a common
> problem with more than a single NIC (ie, not just a bad piece of
> hardware), then one could load my firmware and my ath10k patches.

No clue.  I can buy another one of these things to find out, though,
if that would help.

>
> I have a way to effectively get text debug messages out of the
> OTP firmware code and can probably debug this (eventually...busy
> with other things currently).

Is this something you can send me?  If not, and if you have time, I'd
be happy to mail you your very own Archer C7 v2.

OTOH, if this is likely to be it, then it might be a decent thing to play with:

http://web.mit.edu/luto/www/archerc7_gpl/atheros/otp.c

This hardware has two Atheros WLANs: a platform device ath9k and a
minipcie ath10k.  Would ath9k also have something called 'OTP'?

>
> If you know the basic hardware architecture of the NIC, then you can at least
> make a better guess of the calibration data and choose an eeprom
> table that is a better match than just total failure of OTP.
>

I don't even know what that means. :(

>>> Barring that, the card seems to work okay without otp (I don't even
>>> know what otp is), so just warning and continuing to load might be
>>> better than bailing.
>>
>> This means that your card is not properly calibrated and it doesn't
>> function in an optimal way (for example range or throughput is less than
>> what it could be).
>
> And, your MAC address will be wrong and identical to all other devices of this
> type, which means the second one of these NICs
> on your network will make everything go to hell.
>

Heh.  I'm already overriding the MAC address with a locally administered one.

> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
