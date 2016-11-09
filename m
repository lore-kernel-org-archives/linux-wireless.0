Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60244 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbcKIBhB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 20:37:01 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] cw1200: Don't leak memory if krealloc failes
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1475239157-16448-1-git-send-email-jthumshirn@suse.de>
References: <1475239157-16448-1-git-send-email-jthumshirn@suse.de>
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Solomon Peachy <pizza@shaftnet.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Johannes Berg <johannes@sipsolutions.net>
Message-Id: <20161109013700.B3FEE61258@smtp.codeaurora.org> (sfid-20161109_023704_871988_F4B3ED17)
Date: Wed,  9 Nov 2016 01:37:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Thumshirn <jthumshirn@suse.de> wrote:
> The call to krealloc() in wsm_buf_reserve() directly assigns the newly
> returned memory to buf->begin. This is all fine except when krealloc()
> failes we loose the ability to free the old memory pointed to by
> buf->begin. If we just create a temporary variable to assign memory to
> and assign the memory to it we can mitigate the memory leak.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Johannes Berg <johannes@sipsolutions.net>

Patch applied to wireless-drivers-next.git, thanks.

9afdd6128c39 cw1200: Don't leak memory if krealloc failes

-- 
https://patchwork.kernel.org/patch/9358185/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
