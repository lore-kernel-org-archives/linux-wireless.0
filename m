Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41766 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932065AbdBHJLH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 04:11:07 -0500
Message-ID: <1486545047.4603.14.camel@sipsolutions.net> (sfid-20170208_101426_871554_81802AF5)
Subject: Re: [PATCH 1/5] nl80211: fix validation of scheduled scan info for
 wowlan netdetect
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 08 Feb 2017 10:10:47 +0100
In-Reply-To: <1485518971-28183-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1485518971-28183-1-git-send-email-arend.vanspriel@broadcom.com>
         <1485518971-28183-2-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-27 at 12:09 +0000, Arend van Spriel wrote:
> For wowlan netdetect a separate limit is defined for the number of
> matchsets. Currently, this limit is ignored and the regular limit
> for scheduled scan matchsets, ie. struct wiphy::max_match_sets, is
> used for the net-detect case as well.

Applied.

This means that brmcfmac is now broken in mac80211-next for a bit, but
once it hits net-next and I merge back everything will be fine again,
so just a few days (and I assume nobody us using brcmfmac from
mac80211-next anyway ... wireless-testing will be fine)

johannes
