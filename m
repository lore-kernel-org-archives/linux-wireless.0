Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46228 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934246AbeF0QAK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 12:00:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v6,(resend),1/3] bitfield: fix *_encode_bits()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180620065830.6612-2-johannes@sipsolutions.net>
References: <20180620065830.6612-2-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Message-Id: <20180627160009.7F9BC606FA@smtp.codeaurora.org> (sfid-20180627_180025_701928_49215CB0)
Date: Wed, 27 Jun 2018 16:00:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:

> There's a bug in *_encode_bits() in using ~field_multiplier() for
> the check whether or not the constant value fits into the field,
> this is wrong and clearly ~field_mask() was intended. This was
> triggering for me for both constant and non-constant values.
> 
> Additionally, make this case actually into an compile error.
> Declaring the extern function that will never exist with just a
> warning is pointless as then later we'll just get a link error.
> 
> While at it, also fix the indentation in those lines I'm touching.
> 
> Finally, as suggested by Andy Shevchenko, add some tests and for
> that introduce also u8 helpers. The tests don't compile without
> the fix, showing that it's necessary.
> 
> Fixes: 00b0c9b82663 ("Add primitives for manipulating bitfields both in host- and fixed-endian.")
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

3 patches applied to wireless-drivers-next.git, thanks.

e7d4a95da86e bitfield: fix *_encode_bits()
37a3862e1238 bitfield: add u8 helpers
0e2dc70e3d0d bitfield: add tests

-- 
https://patchwork.kernel.org/patch/10476545/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
