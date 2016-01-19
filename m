Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41426 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbcASND5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 08:03:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-kernel@vger.kernel.org, Michael Buesch <m@bues.ch>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH, RESEND^2] ssb: mark ssb_bus_register as __maybe_unused
References: <8128014.DbbgBtKY3z@wuerfel>
	<8760ywd5fe.fsf@kamboji.qca.qualcomm.com> <6063400.39vor3soEb@wuerfel>
Date: Tue, 19 Jan 2016 15:03:45 +0200
In-Reply-To: <6063400.39vor3soEb@wuerfel> (Arnd Bergmann's message of "Mon, 18
	Jan 2016 20:39:56 +0100")
Message-ID: <877fj567ri.fsf@kamboji.qca.qualcomm.com> (sfid-20160119_140423_124874_B838D7B1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> The SoC variant of the ssb code is now optional like the other
> ones, which means we can build the framwork without any
> front-end, but that results in a warning:
>
> drivers/ssb/main.c:616:12: warning: 'ssb_bus_register' defined but not used [-Wunused-function]
>
> This annotates the ssb_bus_register function as __maybe_unused to
> shut up the warning. A configuration like this will not work on
> any hardware of course, but we still want this to silently build
> without warnings if the configuration is allowed in the first
> place.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 845da6e58e19 ("ssb: add Kconfig entry for compiling SoC related code")
> Acked-by: Michael Buesch <m@bues.ch>
> ---
> Resent to linux-wireless as requested

Thanks, and sorry for the hassle. I'm planning to push this to 4.5.

-- 
Kalle Valo
