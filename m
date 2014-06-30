Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45053 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaF3H7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 03:59:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Denton Gentry <denton.gentry@gmail.com>
Subject: Re: [RFC/RFT 2/2] ath10k: fix Rx aggregation reordering
References: <1403860015-31601-1-git-send-email-michal.kazior@tieto.com>
	<1403860015-31601-3-git-send-email-michal.kazior@tieto.com>
	<8761jmtp1y.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=n-NGGbJ9tJ+Q=7Lhnd2XxWTWRZLBV-q1gDoc7bFitrA@mail.gmail.com>
Date: Mon, 30 Jun 2014 10:59:44 +0300
In-Reply-To: <CA+BoTQ=n-NGGbJ9tJ+Q=7Lhnd2XxWTWRZLBV-q1gDoc7bFitrA@mail.gmail.com>
	(Michal Kazior's message of "Mon, 30 Jun 2014 07:41:07 +0200")
Message-ID: <8738emsu8f.fsf@kamboji.qca.qualcomm.com> (sfid-20140630_095953_588945_28396027)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 27 June 2014 16:17, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>>> @@ -21,6 +21,7 @@
>>>  #include "txrx.h"
>>>  #include "debug.h"
>>>  #include "trace.h"
>>> +#include "mac.h"
>>
>> Why this? At least from a quick search I didn't see any reason to add this.
>
> ath10k_get_arvif()

Ah, ok. BTW, in the future we should rename it to ath10k_mac_get_arvif()
to make it clear it's coming from mac.c.

-- 
Kalle Valo
