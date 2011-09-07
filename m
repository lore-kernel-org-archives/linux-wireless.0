Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54114 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab1IGE1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 00:27:16 -0400
Received: by yxj19 with SMTP id 19so3584214yxj.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2011 21:27:16 -0700 (PDT)
Subject: Re: [PATCH] p54: Use do_div for 64-bit division to fix 32-bit
 kernels
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 07 Sep 2011 00:27:13 -0400
In-Reply-To: <201108252347.35706.chunkeey@googlemail.com>
References: <201108252347.35706.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1315369635.3089.1.camel@ayu> (sfid-20110907_062736_540785_41C9F1AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-25 at 23:47 +0200, Christian Lamparter wrote:
> Use the do_div macro for 64-bit division. Otherwise, the module will
> reference __udivdi3 under 32-bit kernels, which is not allowed in
> kernel space.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c

> +		do_div(survey->channel_time, 1024);
> +		do_div(survey->channel_time_tx, 1024);
> +		do_div(survey->channel_time_busy, 1024);

You're doing a division by a power of two here, why not just use a
bit-shift operation ">> 10" instead of a full division operation?

-- 
Calvin Walton <calvin.walton@kepstin.ca>

