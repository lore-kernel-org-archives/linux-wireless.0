Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58662 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaI2GyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 02:54:04 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath: Add support for tracing
References: <1411804665-6954-1-git-send-email-sujith@msujith.org>
	<87vbo72bb7.fsf@kamboji.qca.qualcomm.com>
	<21544.64579.558712.465388@gargle.gargle.HOWL>
Date: Mon, 29 Sep 2014 09:53:57 +0300
In-Reply-To: <21544.64579.558712.465388@gargle.gargle.HOWL> (Sujith
	Manoharan's message of "Mon, 29 Sep 2014 11:59:23 +0530")
Message-ID: <87r3yu3oje.fsf@kamboji.qca.qualcomm.com> (sfid-20140929_085410_853040_FF6BA87C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Kalle Valo wrote:
>> Why add it to ath.ko module? What drivers are going to use this?
>
> The debug code for ath9k is in ath.ko.

You mean ath_printk() & friends? But that doesn't require tracing code
to be in ath.ko as well, right? If I understood correctly, trace.c could
be under ath9k directory and the kconfig option could be
ATH9K_TRACEPOINTS.

I think it's just misleading and confusing for the user to call it
"Atheros wireless tracing" when it only affects ath9k. It's easier to
understand if each driver has it's own "tracing" kconfig option.

-- 
Kalle Valo
