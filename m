Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58899 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755269AbcJNNKn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 09:10:43 -0400
Message-ID: <1476450635.31114.42.camel@sipsolutions.net> (sfid-20161014_151049_007103_7C55AE25)
Subject: Re: [PATCH] mac80211: aes_ccm: move struct aead_req off the stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, luto@amacapital.net,
        sergey.senozhatsky.work@gmail.com, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        j@w1.fi
Date: Fri, 14 Oct 2016 15:10:35 +0200
In-Reply-To: <1476450540-1760-1-git-send-email-ard.biesheuvel@linaro.org> (sfid-20161014_150908_308224_F47D6BD7)
References: <1476450540-1760-1-git-send-email-ard.biesheuvel@linaro.org>
         (sfid-20161014_150908_308224_F47D6BD7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> So use kzalloc

Do we really need kzalloc()? We have things on the stack right now, and
don't initialize, so surely we don't really need to zero things?

> This only addresses one half of the problem. The other problem, i.e.,
> the fact that the aad[] array lives on the stack of the caller, is
> handled adequately imo by the change proposed by Johannes.

But if we allocate things anyway, is it worth expending per-CPU buffers
on these?

johannes
