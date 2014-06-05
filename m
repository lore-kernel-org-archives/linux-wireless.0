Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:62591 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaFEQEn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 12:04:43 -0400
Received: by mail-ve0-f176.google.com with SMTP id jz11so1459261veb.21
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 09:04:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r433ps7w.fsf@kamboji.qca.qualcomm.com>
References: <CALCETrU=8+tnptdfva4p27nA-5=E31DwXagoLqUxYcLtEKrB+w@mail.gmail.com>
 <CA+BoTQmUyvTr+ga81EacbMkE4UVtMBP2PfBs_vH-PF4OvHuZQg@mail.gmail.com>
 <CALCETrUDWvXddiACacre3erhwrKCjO53iHVKmPrApTi65Z5yBA@mail.gmail.com> <87r433ps7w.fsf@kamboji.qca.qualcomm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 5 Jun 2014 09:04:22 -0700
Message-ID: <CALCETrUQxF68b86POMfAurBcR0bZbXc8NmhXopksWh3nojeauA@mail.gmail.com> (sfid-20140605_180452_589433_0A41B03A)
Subject: Re: compat-wireless-2014-05-22 breaks ath10k in an Archer C7 v2
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 5, 2014 at 3:26 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
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

Ah -- I misunderstood.  I assumed that the OTP read was failing
mysteriously and that expert input was needed to resolve that mystery
:)

>
>> Barring that, the card seems to work okay without otp (I don't even
>> know what otp is), so just warning and continuing to load might be
>> better than bailing.
>
> This means that your card is not properly calibrated and it doesn't
> function in an optimal way (for example range or throughput is less than
> what it could be).
>
> Do you see that with all Archer C7 v2 devices or with just one? One
> possibility is that the calibration data is actually stored outside of
> QCA9880 board, for example in the host flash or similar. I don't have
> that AP, can someone else see where the calibration data is stored?

I only have one of these.  I put a likely looking directory of the GPL
sources here:

http://web.mit.edu/luto/www/archerc7_gpl/atheros/

I'm not entirely sure what I'm looking for, but this might be it:

http://web.mit.edu/luto/www/archerc7_gpl/atheros/otp.c

I don't really know what I'm looking for, though.

--Andy
