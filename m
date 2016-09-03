Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48036 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752654AbcICOa4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 10:30:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ErrHandling:Make IS_ERR_VALUE_U32 as generic API to avoid
 IS_ERR_VALUE abuses.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1468083696-15283-1-git-send-email-arvind.yadav.cs@gmail.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: zajec5@gmail.com, viresh.kumar@linaro.org,
        akpm@linux-foundation.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linville@tuxdriver.com,
        Arvind Yadav <arvind.yadav.cs@gmail.com>
Message-Id: <20160903142913.16FBA6216D@smtp.codeaurora.org> (sfid-20160903_163100_804575_3A3C9862)
Date: Sat,  3 Sep 2016 14:29:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:
> IS_ERR_VALUE() assumes that its parameter is an unsigned long.
> It can not be used to check if an 'unsigned int' reflects an error.
> As they pass an 'unsigned int' into a function that takes an
> 'unsigned long' argument. This happens to work because the type
> is sign-extended on 64-bit architectures before it gets converted
> into an unsigned type.
> 
> However, anything that passes an 'unsigned short' or 'unsigned int'
> argument into IS_ERR_VALUE() is guaranteed to be broken, as are
> 8-bit integers and types that are wider than 'unsigned long'.
> 
> It would be nice to any users that are not passing 'unsigned int'
> arguments.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

This touches include/linux/err.h and I'm not very enthusiastic to change
anything in include directory without wider support. I recommend first to just
fix bcma.  And separately you can try to improve linux/err.h via some more
approariate tree, not via wireless trees.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9222139/
