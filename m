Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49062 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3IZGSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 02:18:14 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath10k: implement firmware IE container support
References: <20130925210455.2596.36889.stgit@localhost6.localdomain6>
	<20130925210848.2596.56332.stgit@localhost6.localdomain6>
	<CA+BoTQ=BhtjC1YNLs9OYBPN6TiYhyrwYoK2A1wifS01HVJp1YA@mail.gmail.com>
	<878uykunyc.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=v0snRLTP44LXVdQx2UVKYxLCW-JiWyMWOR4eEzMvFKA@mail.gmail.com>
Date: Thu, 26 Sep 2013 09:18:05 +0300
In-Reply-To: <CA+BoTQ=v0snRLTP44LXVdQx2UVKYxLCW-JiWyMWOR4eEzMvFKA@mail.gmail.com>
	(Michal Kazior's message of "Thu, 26 Sep 2013 08:04:39 +0200")
Message-ID: <87vc1ot8bm.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_081825_814432_A1E7222B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 26 September 2013 07:55, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> Did you skip board file intentionally?
>>
>> Yes, because my understanding is that the board file is not tied to any
>> particular firmware version. The board file should be specific to the
>> hardware configuration in use, or at least that's how it is with ath6kl.
>
> But the board file is not loaded at all for API 2. The api_1 variant
> requests 3 files and can result with up to 3 binaries loaded. api_n
> requests 1 file and can result with up to 2 binaries loaded.

Oops, that's clearly a bug. How did it even pass my tests without the
board file? I'll send v2 to fix that.

So my idea is that with API 2 we load only firmware-2.bin and board.bin
from user space. With API 1 we continue loading firmware.bin, otp.bin
(optional) and board.bin, just as before. And firmware-2.bin can contain
the old firmware.bin (mandatory) and otp.bin (optional) images.

I just realised that I'm missing a check that there really is a firmware
image inside firmware-2.bin, need to add that as well.

-- 
Kalle Valo
