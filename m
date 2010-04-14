Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:34401 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab0DNHI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 03:08:26 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: read default MAC address from EEPROM when  available
References: <1271110884-18545-1-git-send-email-notasas@gmail.com>
	<87fx2znuzq.fsf@purkki.valot.fi>
	<q2k6ed0b2681004131434ma73a9d77yf13e2469e8c49def@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 14 Apr 2010 10:08:23 +0300
In-Reply-To: <q2k6ed0b2681004131434ma73a9d77yf13e2469e8c49def@mail.gmail.com> (Grazvydas Ignotas's message of "Wed\, 14 Apr 2010 00\:34\:28 +0300")
Message-ID: <87y6gqmryw.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

>>> +             udelay(200);
>>> +     }
>>
>> Is the udelay() really needed here? In my opinion msleep(), for
>> example with a value of 5 ms, would be nicer from system point of
>> view. It doesn't matter if this function takes few milliseconds
>> longer, because this is called only in op_start(). What do you think?
>
> It normally takes something like 700-1000us, so I guess I can replace
> with msleep(1) if you think it's better.

Yes, that's better. It's always good to avoid busylooping.

-- 
Kalle Valo
