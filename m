Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53404 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752436AbdASMpi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 07:45:38 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: libertas: fix improper return value
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1480760857-4549-1-git-send-email-bianpan2016@163.com>
References: <1480760857-4549-1-git-send-email-bianpan2016@163.com>
To: Pan Bian <bianpan2016@163.com>
Cc: Andreas Kemnade <andreas@kemnade.info>,
        Johannes Berg <johannes.berg@intel.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Message-Id: <20170119123913.B75AE60911@smtp.codeaurora.org> (sfid-20170119_134608_271164_5A665106)
Date: Thu, 19 Jan 2017 12:39:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pan Bian <bianpan2016@163.com> wrote:
> Function lbs_cmd_802_11_sleep_params() always return 0, even if the call
> to lbs_cmd_with_response() fails. In this case, the parameter @sp will
> keep uninitialized. Because the return value is 0, its caller (say
> lbs_sleepparams_read()) will not detect the error, and will copy the
> uninitialized stack memory to user sapce, resulting in stack information
> leak. To avoid the bug, this patch returns variable ret (which takes
> the return value of lbs_cmd_with_response()) instead of 0.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188451
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Patch applied to wireless-drivers-next.git, thanks.

259010c509b6 libertas: fix improper return value

-- 
https://patchwork.kernel.org/patch/9459597/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
