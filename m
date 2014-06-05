Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60581 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaFEKjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 06:39:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Michal Kazior <michal.kazior@tieto.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: compat-wireless-2014-05-22 breaks ath10k in an Archer C7 v2
In-Reply-To: <CALCETrUDWvXddiACacre3erhwrKCjO53iHVKmPrApTi65Z5yBA@mail.gmail.com>
	(Andy Lutomirski's message of "Thu, 29 May 2014 10:52:32 -0700")
References: <CALCETrU=8+tnptdfva4p27nA-5=E31DwXagoLqUxYcLtEKrB+w@mail.gmail.com>
	<CA+BoTQmUyvTr+ga81EacbMkE4UVtMBP2PfBs_vH-PF4OvHuZQg@mail.gmail.com>
	<CALCETrUDWvXddiACacre3erhwrKCjO53iHVKmPrApTi65Z5yBA@mail.gmail.com>
Date: Thu, 5 Jun 2014 13:26:43 +0300
Message-ID: <87r433ps7w.fsf@kamboji.qca.qualcomm.com> (sfid-20140605_123909_585733_50D4E121)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Lutomirski <luto@amacapital.net> writes:

> On Thu, May 29, 2014 at 12:48 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> +ath10k@lists.infradead.org
>>
>> On 28 May 2014 20:35, Andy Lutomirski <luto@amacapital.net> wrote:
>>> It dies with 'otp calibration failed: 2'.
>>>
>>> Some older version of the driver seemed to work fine.
>>
>> ath10k did not verify otp result before so it could load successfully
>> despite errors.
>>
>> Someone raised this problem yesterday on IRC. I'm not really sure how
>> we should deal with this properly.
>
> Ideally, someone from Atheros could figure out what the error is.

Michal already did. The error means that for some reason the
calibaration data was not found from OTP. OTP is the storage area where
the calibration data is normally stored within QCA9880.

> Barring that, the card seems to work okay without otp (I don't even
> know what otp is), so just warning and continuing to load might be
> better than bailing.

This means that your card is not properly calibrated and it doesn't
function in an optimal way (for example range or throughput is less than
what it could be).

Do you see that with all Archer C7 v2 devices or with just one? One
possibility is that the calibration data is actually stored outside of
QCA9880 board, for example in the host flash or similar. I don't have
that AP, can someone else see where the calibration data is stored?

I know that ath9k supports this kind of setup, most likely ath10k should
as well.

-- 
Kalle Valo
