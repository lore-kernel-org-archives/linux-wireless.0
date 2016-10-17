Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50630 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754520AbcJQORN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 10:17:13 -0400
Message-ID: <1476713828.315.5.camel@sipsolutions.net> (sfid-20161017_161716_676121_31FE6A00)
Subject: Re: [PATCH v4] mac80211: move struct aead_req off the stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: herbert@gondor.apana.org.au, sergey.senozhatsky.work@gmail.com
Date: Mon, 17 Oct 2016 16:17:08 +0200
In-Reply-To: <1476713133-18355-1-git-send-email-ard.biesheuvel@linaro.org> (sfid-20161017_160545_826866_8595CA02)
References: <1476713133-18355-1-git-send-email-ard.biesheuvel@linaro.org>
         (sfid-20161017_160545_826866_8595CA02)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-17 at 15:05 +0100, Ard Biesheuvel wrote:
> From: Johannes Berg <johannes.berg@intel.com>

That really ought to have been you - I think I may have lost that by
accident. I'll change it.

> In addition, take care not to put any of our own stack allocations
> into
> scatterlists. This involves reserving some extra room when allocating
> the
> aead_request structures, and referring to those allocations in the
> scatter-
> lists (while copying the data from/to the stack before/after the
> crypto
> operation, as appropriate)

I removed the "to the stack after" language, since that doesn't
actually occur :)


> --- a/net/mac80211/aes_cmac.h
> +++ b/net/mac80211/aes_cmac.h
> @@ -11,6 +11,8 @@
>  
>  #include <linux/crypto.h>
>  
> +#define CMAC_AAD_LEN	20

This part (and aes_cmac.c changes) shouldn't have been there, but that
was my mistake - removed.

With that, I've applied this. Will send it to davem tomorrow.

johannes
