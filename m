Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34386 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755160AbcK3IWa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 03:22:30 -0500
Message-ID: <1480494148.9990.33.camel@sipsolutions.net> (sfid-20161130_092246_385667_3068EF50)
Subject: Re: [RFC V2 1/5] nl80211: allow reporting RTT information in scan
 results
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 30 Nov 2016 09:22:28 +0100
In-Reply-To: <6f75b940-d0b1-1e9c-f286-3923089d202d@broadcom.com> (sfid-20161128_210801_345602_4774A658)
References: <1479388726-3288-1-git-send-email-arend.vanspriel@broadcom.com>
         <1479388726-3288-2-git-send-email-arend.vanspriel@broadcom.com>
         <1480343530.8107.51.camel@sipsolutions.net>
         <6f75b940-d0b1-1e9c-f286-3923089d202d@broadcom.com>
         (sfid-20161128_210801_345602_4774A658)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-11-28 at 21:07 +0100, Arend Van Spriel wrote:
> 
> I was wondering about the meaning of the term "parent_bssid". Given
> your remark it means something else than my guess. I actually meant
> the distance to the AP indicated by this BSS. Our gscan code obtains
> the gscan results from firmware and in that API it has RTT info. 

Oh, ok. Right, that's unrelated to the parent_bssid.

I do wonder how it'd even be possible to *determine* this though?
Perhaps by the ACK timing, assuming it's precise on the AP?

> However, recent testing revealed those fields are always coming up
> with zero values :-(

Heh :-)

> So right now I am not sure if we need this extension.

FWIW, we don't seem to have it.

johannes
