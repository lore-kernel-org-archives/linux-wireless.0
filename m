Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34198 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdGGQhJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 12:37:09 -0400
Received: by mail-oi0-f41.google.com with SMTP id l130so32095012oib.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jul 2017 09:37:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1499433473.4790.6.camel@sipsolutions.net>
References: <1499428893-30750-1-git-send-email-arend.vanspriel@broadcom.com> <1499433473.4790.6.camel@sipsolutions.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 7 Jul 2017 09:37:08 -0700
Message-ID: <CA+55aFzV_Gp=q7r+WjNV9epaCaAFqirXfMVD1=+CcfwGV1SGoA@mail.gmail.com> (sfid-20170707_183713_259872_0EE51572)
Subject: Re: [PATCH] brcmfmac: fix possible buffer overflow in brcmf_cfg80211_mgmt_tx()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 7, 2017 at 6:17 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Linus, since you were involved already, will you apply this directly?

I don't think it's _that_ urgent, since it's specific to one
particular driver anyway. I'd suggest just going through the normal
channels, and be cc'd to netdev.

> I guess it should also have a Cc: stable tag, and perhaps a Fixes?

The fixes tag would be

    Fixes: 18e2f61db3b70 ("brcmfmac: P2P action frame tx.")

which is 3.9 in case anybody cares. I assume that didn't get
backported any further.

                Linus
