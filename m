Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:18617 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaI3FUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 01:20:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath: Add support for tracing
References: <1411804665-6954-1-git-send-email-sujith@msujith.org>
	<87vbo72bb7.fsf@kamboji.qca.qualcomm.com>
	<21544.64579.558712.465388@gargle.gargle.HOWL>
	<87r3yu3oje.fsf@kamboji.qca.qualcomm.com>
	<21545.4248.512297.913983@gargle.gargle.HOWL>
Date: Tue, 30 Sep 2014 08:20:41 +0300
In-Reply-To: <21545.4248.512297.913983@gargle.gargle.HOWL> (Sujith Manoharan's
	message of "Mon, 29 Sep 2014 13:26:08 +0530")
Message-ID: <87k34ly992.fsf@kamboji.qca.qualcomm.com> (sfid-20140930_072053_258996_915AA7DC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Kalle Valo wrote:
>> You mean ath_printk() & friends? But that doesn't require tracing code
>> to be in ath.ko as well, right? If I understood correctly, trace.c could
>> be under ath9k directory and the kconfig option could be
>> ATH9K_TRACEPOINTS.
>> 
>> I think it's just misleading and confusing for the user to call it
>> "Atheros wireless tracing" when it only affects ath9k. It's easier to
>> understand if each driver has it's own "tracing" kconfig option.
>
> We have CONFIG_ATH_DEBUG, which is used by ath9k and ath9k_htc.
> I think it is okay to have CONFIG_ATH_TRACEPOINTS, which can be
> used by ath9k/ath9k_htc too.

In my opinion that just creates even a bigger mess.

> The original motive of ath.ko was to have a common module with
> debugging facilities that can be shared by Atheros drivers. But,
> each driver has ended up reinventing things.

The current debug printing code in ath10k is something like 100 lines, I
don't see the point of trying to make that common with all ath* drivers.

In my opinion ath.ko should only have code which used at least two
different drivers (and I consider ath9k.ko and ath9k_htc.ko as one
driver). So the right thing here would be to actually move all debugging
code from ath.ko to ath9k, as it's the only user anyway.

> Since it is mentioned in the help text that ath9k is the only driver
> making use of ATH_DEBUG/ATH_TRACEPOINTS, I don't think it is
> confusing.

To me it is. But it's a mess already so I guess I'm worrying nothing.

-- 
Kalle Valo
