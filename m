Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:43368 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752624AbdIXRWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Sep 2017 13:22:13 -0400
MIME-Version: 1.0
In-Reply-To: <1506265531.2909.5.camel@sipsolutions.net>
References: <20170924054015.8958-1-qasdfgtyuiop@gmail.com> <1506265531.2909.5.camel@sipsolutions.net>
From: Xiang Gao <qasdfgtyuiop@gmail.com>
Date: Sun, 24 Sep 2017 13:21:52 -0400
Message-ID: <CAMtaSwR4YTgh9N9x8a12R4dEZNuarjwvfOmnO6vnaDffVV-j3w@mail.gmail.com> (sfid-20170924_193027_450530_BFEEC825)
Subject: Re: [PATCH] mac80211: aead api to reduce redundancy
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2017-09-24 11:05 GMT-04:00 Johannes Berg <johannes@sipsolutions.net>:
> On Sun, 2017-09-24 at 01:40 -0400, Xiang Gao wrote:
>> Currently, the aes_ccm.c and aes_gcm.c are almost line by line
>> copy of each other. This patch reduce code redundancy by moving
>> the code in these two files to crypto/aead_api.c to make it a
>> higher level aead api. The aes_ccm.c and aes_gcm.c are removed
>> and all the functions are now implemented in their headers using
>> the newly added aead api.
>>
> No objection from me, though I'd ask you to respin with the indentation
> fixed up a bit.

Hi Johannes,

Thank you for you time for the suggestion. I'm not sure if I correctly
understand you point.
Do you mean to put more characters each line in the description? Something like:

> Currently, the aes_ccm.c and aes_gcm.c are almost line by line copy of
> each other. This patch reduce code redundancy by moving the code in these
> two files to crypto/aead_api.c to make it a higher level aead api. The
> file aes_ccm.c and aes_gcm.c are removed and all the functions there are
> now implemented in their headers using the newly added aead api.

instead of

> Currently, the aes_ccm.c and aes_gcm.c are almost line by line
> copy of each other. This patch reduce code redundancy by moving
> the code in these two files to crypto/aead_api.c to make it a
> higher level aead api. The aes_ccm.c and aes_gcm.c are removed
> and all the functions are now implemented in their headers using
> the newly added aead api.

Xiang Gao

>
> johannes
