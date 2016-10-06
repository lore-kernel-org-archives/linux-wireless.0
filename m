Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59110 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934432AbcJFHPm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 03:15:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] ath6kl: fix busreqs so they can be reused when sg is
 cleaned up
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1475517604-17710-2-git-send-email-james.minor@ni.com>
References: <1475517604-17710-2-git-send-email-james.minor@ni.com>
To: James Minor <james.minor@ni.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>,
        <julia.cartwright@ni.com>, <steve.derosier@lairdtech.com>,
        James Minor <james.minor@ni.com>
Message-ID: <49c440770f3f43ef9d8e9fd2d3719227@euamsexm01a.eu.qualcomm.com> (sfid-20161006_091546_306529_87FA5181)
Date: Thu, 6 Oct 2016 09:15:33 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Minor <james.minor@ni.com> wrote:
> To reuse the busreqs in case of hardware restart, they must be
> properly reinitialized.  If the scat_req pointer isn't reset to
> 0, __ath6kl_sdio_write_async() will assume there is sg work to be
> done (causing a kernel OOPS).
> 
> Signed-off-by: James Minor <james.minor@ni.com>
> Reviewed-by: Steve deRosier <steve.derosier@lairdtech.com>

3 patches applied to ath-next branch of ath.git, thanks.

3605d751d5dd ath6kl: fix busreqs so they can be reused when sg is cleaned up
db14b18a73a1 ath6kl: after cleanup properly reflect that sg is disabled
fdb6e4839e3a ath6kl: configure SDIO when power is reapplied

-- 
https://patchwork.kernel.org/patch/9360777/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
