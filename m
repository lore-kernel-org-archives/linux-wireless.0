Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34844 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaFEQIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 12:08:35 -0400
Message-ID: <53909602.5010703@candelatech.com> (sfid-20140605_180842_617163_B0AEF0AD)
Date: Thu, 05 Jun 2014 09:08:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Andy Lutomirski <luto@amacapital.net>,
	Michal Kazior <michal.kazior@tieto.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: compat-wireless-2014-05-22 breaks ath10k in an Archer C7 v2
References: <CALCETrU=8+tnptdfva4p27nA-5=E31DwXagoLqUxYcLtEKrB+w@mail.gmail.com> <CA+BoTQmUyvTr+ga81EacbMkE4UVtMBP2PfBs_vH-PF4OvHuZQg@mail.gmail.com> <CALCETrUDWvXddiACacre3erhwrKCjO53iHVKmPrApTi65Z5yBA@mail.gmail.com> <87r433ps7w.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87r433ps7w.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2014 03:26 AM, Kalle Valo wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
> 
>> On Thu, May 29, 2014 at 12:48 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>> +ath10k@lists.infradead.org
>>>
>>> On 28 May 2014 20:35, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> It dies with 'otp calibration failed: 2'.
>>>>
>>>> Some older version of the driver seemed to work fine.
>>>
>>> ath10k did not verify otp result before so it could load successfully
>>> despite errors.
>>>
>>> Someone raised this problem yesterday on IRC. I'm not really sure how
>>> we should deal with this properly.
>>
>> Ideally, someone from Atheros could figure out what the error is.
> 
> Michal already did. The error means that for some reason the
> calibaration data was not found from OTP. OTP is the storage area where
> the calibration data is normally stored within QCA9880.

I fought this with .387 firmware and WLE900VX NICs.  If it's a common
problem with more than a single NIC (ie, not just a bad piece of
hardware), then one could load my firmware and my ath10k patches.

I have a way to effectively get text debug messages out of the
OTP firmware code and can probably debug this (eventually...busy
with other things currently).

If you know the basic hardware architecture of the NIC, then you can at least
make a better guess of the calibration data and choose an eeprom
table that is a better match than just total failure of OTP.

>> Barring that, the card seems to work okay without otp (I don't even
>> know what otp is), so just warning and continuing to load might be
>> better than bailing.
> 
> This means that your card is not properly calibrated and it doesn't
> function in an optimal way (for example range or throughput is less than
> what it could be).

And, your MAC address will be wrong and identical to all other devices of this
type, which means the second one of these NICs
on your network will make everything go to hell.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

