Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55918 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935364AbcJ1SQj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Oct 2016 14:16:39 -0400
Message-ID: <1477678593.4220.2.camel@sipsolutions.net> (sfid-20161028_202107_452942_002BCF46)
Subject: Re: [PATCH] mac80211: fix incorrect error return path on tmp
 allocation failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2016 20:16:33 +0200
In-Reply-To: <20161028180824.7110-1-colin.king@canonical.com>
References: <20161028180824.7110-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-28 at 19:08 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The current exit path when tmp fails to be allocated is via the
> fail label which frees tfm2 which has not yet been allocated,
> which is problematic since tfm2 is not initialized and is a garbage
> pointer. Fix this by exiting directly to the return at the end
> of the function and hence avoiding the freeing of tfm2.

Yeah, thanks. Arnd beat you to the fix by about 8 hours, so I've
already applied his patch and sent an updated pull request :)

johannes
