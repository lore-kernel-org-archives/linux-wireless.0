Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:33395 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1HYOEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 10:04:33 -0400
Message-ID: <4E565535.1050901@adurom.com> (sfid-20110825_160436_206636_67568637)
Date: Thu, 25 Aug 2011 16:59:17 +0300
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: car9170: undefined reference to `__udivdi3'
References: <87aaaxon58.fsf@purkki.adurom.net> <201108251500.54814.lach1012@hs-karlsruhe.de>
In-Reply-To: <201108251500.54814.lach1012@hs-karlsruhe.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/25/2011 04:00 PM, Christian Lamparter wrote:
> Please try the attached patch:
> ---
> [PATCH v1] carl9170: Use do_div for 64-bit division to fix 32-bit kernels
> 
> Use the do_div macro for 64-bit division. Otherwise, the module will
> reference __udivdi3 under 32-bit kernels, which is not allowed in
> kernel space.
> 
> drivers/built-in.o: In function `carl9170_collect_tally':
> cmd.c:191: undefined reference to `__udivdi3'
> cmd.c:192: undefined reference to `__udivdi3'
> cmd.c:193: undefined reference to `__udivdi3'

Works. Thanks for fixing this quickly.

> Reported-by: Kalle Valo <kvalo@adurom.com>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

Tested-by: Kalle Valo <kvalo@adurom.com>

Kalle
