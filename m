Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60872 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754426AbdA0Mwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 07:52:33 -0500
Message-ID: <1485520288.5851.8.camel@sipsolutions.net> (sfid-20170127_135448_782332_5E72604A)
Subject: Re: [PATCH 1/5] nl80211: fix validation of scheduled scan info for
 wowlan netdetect
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 27 Jan 2017 13:31:28 +0100
In-Reply-To: <1485518971-28183-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170127_132234_218655_59FDFD26)
References: <1485518971-28183-1-git-send-email-arend.vanspriel@broadcom.com>
         <1485518971-28183-2-git-send-email-arend.vanspriel@broadcom.com>
         (sfid-20170127_132234_218655_59FDFD26)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-27 at 12:09 +0000, Arend van Spriel wrote:
> For wowlan netdetect a separate limit is defined for the number of
> matchsets. Currently, this limit is ignored and the regular limit
> for scheduled scan matchsets, ie. struct wiphy::max_match_sets, is
> used for the net-detect case as well.
> 

But .. this patch shouldn't be first in the series, should it? That
leaves brcmfmac broken inbetween.

Also, since you fix the brcmfmac value in patch 2, and it's the same in
both cases, I don't really see a dependency of anything *on* the
nl80211 patch? The brcmfmac changes can go in without it entirely, and
have no effect whatsoever, no?

IOW, I think Kalle can merge 2-5, and I can then pick up this one when
they hit net-next and I've synchronized, no?

johannes
