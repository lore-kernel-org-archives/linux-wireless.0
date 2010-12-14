Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61709 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab0LNSog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 13:44:36 -0500
Received: by qyk12 with SMTP id 12so1069084qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 10:44:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012141849.48488.helmut.schaa@googlemail.com>
References: <201012131231.28313.IvDoorn@gmail.com>
	<201012131236.19791.IvDoorn@gmail.com>
	<201012131236.39071.IvDoorn@gmail.com>
	<201012141849.48488.helmut.schaa@googlemail.com>
Date: Tue, 14 Dec 2010 19:44:35 +0100
Message-ID: <AANLkTimMGtZsY-ZhbR4Nt7Mh4W8KSAfAhbe3yF07ezaO@mail.gmail.com>
Subject: Re: [PATCH 14/17] rt2x00: Fix WMM Queue naming
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Johannes Stezenbach <js@sig21.net>, jay.weihung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> The Queue names were incorrectly copied from the legacy drivers,
>> as a result the queue names were inversed to what was expected.
>>
>> This renames the queues using this mapping:
>>       QID_AC_BK -> QID_AC_VO (priority 0)
>>       QID_AC_BE -> QID_AC_VI (priority 1)
>>       QID_AC_VI -> QID_AC_BE (priority 2)
>>       QID_AC_VO -> QID_AC_BK (priority 3)
>>
>> Note that this was a naming problem only, which didn't affect
>> the assignment of frames to their respective queues.
>>
>> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>
> Ivo, due to the latest info from Ralink I'd say we should drop this patch
> and instead introduce a mac80211_to_rt2x00_qid mapper that maps from
> ieee80211_ac_numbers to data_queue_qid.
>
> This patch doesn't cause any harm, but we would have to revert it partly
> if we introduce the queue mapping as needed by the rt2x00 devices.

I don't agree, this patch can safely be applied, since the mapping
is in the endpoint assignment, rather the register value usage,
I think the more optimal solution is fixing rt2x00usb_assign_endpoints.
In there it currently assigns endpoints assuming the first endpoint
is the highest priority, while we should be able to simply swap that
to invert the logic.

Ivo
