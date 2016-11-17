Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45352 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940708AbcKQGsU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 01:48:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] cw1200: fix bogus maybe-uninitialized warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161025202121.1070879-1-arnd@arndb.de>
References: <20161025202121.1070879-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Solomon Peachy <pizza@shaftnet.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20161117064819.96A68615B1@smtp.codeaurora.org> (sfid-20161117_074847_739610_9F3E352C)
Date: Thu, 17 Nov 2016 06:48:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:
> On x86, the cw1200 driver produces a rather silly warning about the
> possible use of the 'ret' variable without an initialization
> presumably after being confused by the architecture specific definition
> of WARN_ON:
> 
> drivers/net/wireless/st/cw1200/wsm.c: In function ‘wsm_handle_rx’:
> drivers/net/wireless/st/cw1200/wsm.c:1457:9: error: ‘ret’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> We have already checked that 'count' is larger than 0 here, so
> we know that 'ret' is initialized. Changing the 'for' loop
> into do/while also makes this clear to the compiler.
> 
> Suggested-by: David Laight <David.Laight@ACULAB.COM>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

7fc1503c906f cw1200: fix bogus maybe-uninitialized warning

-- 
https://patchwork.kernel.org/patch/9395413/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
