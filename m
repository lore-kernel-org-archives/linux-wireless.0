Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50858 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752419AbcJ1K7A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Oct 2016 06:59:00 -0400
Message-ID: <1477652334.4220.0.camel@sipsolutions.net> (sfid-20161028_125922_500432_5ACBBA9A)
Subject: Re: [PATCH] mac80211: fils_aead: fix encrypt error handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2016 12:58:54 +0200
In-Reply-To: <20161028102621.1881878-1-arnd@arndb.de>
References: <20161028102621.1881878-1-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-28 at 12:25 +0200, Arnd Bergmann wrote:
> gcc -Wmaybe-uninitialized reports a bug in aes_siv_encryp:
> 
> net/mac80211/fils_aead.c: In function ‘aes_siv_encrypt.constprop’:
> net/mac80211/fils_aead.c:84:26: error: ‘tfm2’ may be used
> uninitialized in this function [-Werror=maybe-uninitialized]
> 
> At the time that the memory allocation fails, 'tfm2' has not been
> allocated, so we should not attempt to free it later, and we can
> simply return an error.
> 
> Fixes: 39404feee691 ("mac80211: FILS AEAD protection for station mode
> association frames")

Ahrg, how did I miss that.

Dave, I'll apply this, and send a new pull request.

johannes
