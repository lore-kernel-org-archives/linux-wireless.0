Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbbLJLJz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 06:09:55 -0500
Date: Thu, 10 Dec 2015 12:08:02 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, nico@linaro.org
Subject: Re: [PATCH] iwlegacy: mark il_adjust_beacon_interval as noinline
Message-ID: <20151210110801.GA2010@redhat.com> (sfid-20151210_121104_396493_D596562D)
References: <36263581.L8412YxJjp@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <36263581.L8412YxJjp@wuerfel>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 09, 2015 at 05:42:41PM +0100, Arnd Bergmann wrote:
> With the new optimized do_div() code, some versions of gcc
> produce obviously incorrect code that leads to a link error
> in iwlegacy/common.o:
> 
> drivers/built-in.o: In function `il_send_rxon_timing':
> :(.text+0xa6b4d4): undefined reference to `____ilog2_NaN'
> :(.text+0xa6b4f0): undefined reference to `__aeabi_uldivmod'
> 
> In a few thousand randconfig builds, I have seen this problem
> a couple of times in this file, but never anywhere else in the
> kernel, so we can try to work around this in the only file
> that shows the behavior, by marking the il_adjust_beacon_interval
> function as noinline, which convinces gcc to use the unoptimized
> do_div() all the time.

I don't think this is good way to "fix" the issue, but also have
nothing against to this particular change.

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
