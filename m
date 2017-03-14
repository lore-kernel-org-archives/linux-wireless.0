Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39538 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751313AbdCNNp7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 09:45:59 -0400
Message-ID: <1489499155.10872.1.camel@sipsolutions.net> (sfid-20170314_145112_579606_C91BA798)
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>,
        Jesse Jones <jjones@uniumwifi.com>, agreen@cococorp.com,
        linux-wireless@vger.kernel.org
Cc: Jesse Jones <jjones@cococorp.com>
Date: Tue, 14 Mar 2017 14:45:55 +0100
In-Reply-To: <19214832-030e-2028-49a2-2db087c8c857@neratec.com>
References: <58B09082.7020704@cococorp.com>
         <1488202227.28431.9.camel@sipsolutions.net> <58B487A8.7000602@cococorp.com>
         <1488443814.8390.3.camel@sipsolutions.net>
         <d717a94d5c6632b6665b7ac3b319b726@mail.gmail.com>
         <1488803913.5761.11.camel@sipsolutions.net>
         <19214832-030e-2028-49a2-2db087c8c857@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Isn't CWmin and CWmax only used for retries?

No.

> We recently had the problem that on 5MHz channels probe-responses of
> APs which can't hear each other (hidden node problem) always collide.

I think this is what I neglected - if the APs won't hear each other,
all their own sensing and NAV won't help since it'll never be updated.

CWmin/max are short enough to not actually matter in this case since
they're not long enough to avoid colliding entirely even if one picks
the lowest and the other the largest possible value.

johannes
