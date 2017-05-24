Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49378 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966462AbdEXHCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 03:02:00 -0400
Message-ID: <1495609318.2665.3.camel@sipsolutions.net> (sfid-20170524_090213_797520_B0862CCB)
Subject: Re: [PATCH v2 0/2] extend mac80211 mesh DFS and CSA functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 24 May 2017 09:01:58 +0200
In-Reply-To: <20170523150043.22093-1-sw@simonwunderlich.de>
References: <20170523150043.22093-1-sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-05-23 at 17:00 +0200, Simon Wunderlich wrote:
> This patchset includes the remaining two patches for the CSA
> handling, with Johannes change suggestions integrated.

Applied, thanks for respinning.

I made a small change and removed the return from
ieee80211_ie_build_wide_bw_cs() since it wasn't used, and I would like
to use the safer skb way of doing this more.

(But it doesn't work yet because IBSS uses this to fill a non-SKB
buffer, and changing that is a bit complex)

johannes
