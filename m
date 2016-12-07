Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33210 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751068AbcLGGTS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 01:19:18 -0500
Message-ID: <1481091554.4092.7.camel@sipsolutions.net> (sfid-20161207_071920_864027_5DB4F31C)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Denis Kenzior <denkenz@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 07 Dec 2016 07:19:14 +0100
In-Reply-To: <CAOq732LOk-GQiSfs9Js-qEgvmbNMD_xf6j_1NR88Z1SDL=J8WA@mail.gmail.com> (sfid-20161207_024034_624798_FE1BD05B)
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
         <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
         <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
         <1480950886.31788.44.camel@sipsolutions.net> <584588A2.9090006@gmail.com>
         <1481008560.6610.3.camel@sipsolutions.net> <584730D7.2020708@gmail.com>
         <CAOq732LOk-GQiSfs9Js-qEgvmbNMD_xf6j_1NR88Z1SDL=J8WA@mail.gmail.com>
         (sfid-20161207_024034_624798_FE1BD05B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Possibly Johanness refers to the fact that if you use
> CMD_AUTHENTICATE, or if you use CMD_CONNECT but the driver implements
> the SME -- doesn't use the cfg80211 software SME -- then
> cfg80211_disconnect won't do anything if we're not associated, only
> authenticated.  Currently cfg80211 doesn't have knowledge of whether
> it is authenticated and where to.

We used to track it, but it was a nightmare and just always buggy :)

> With the software SME current_bss would be set from the moment the
> authentication attempt starts, 

I'm almost certain this isn't true, what makes you think so?

> so there seems to be an inconsistency
> which would affect for example the NL80211_BSS_STATUS_ASSOCIATED
> flags in the result of CMD_GET_SCAN.

Thus this can't be the case.

> Perhaps this can be fixed by always
> setting current_bss on auth attempt start, with flags to indicate
> whether authentication has happened and whether association happened.

No! That would be wrong!

> At the very least with this patch if you set the socket owner during
> CMD_AUTHENTICATE and then separately associate, you'd get the
> expected deauthentication.

That would *NOT* be expected. There's no need to even authenticate
through CMD_AUTHENTICATE at all to connect to (another) AP!

You need to think beyond the 1996 version of 802.11 ;-)

johannes
