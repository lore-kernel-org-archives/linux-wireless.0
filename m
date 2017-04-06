Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43656 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdDFECY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 00:02:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>, <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mwifiex: MAC randomization should not be persistent
References: <20170405222640.4494-1-briannorris@chromium.org>
Date: Thu, 06 Apr 2017 07:02:15 +0300
In-Reply-To: <20170405222640.4494-1-briannorris@chromium.org> (Brian Norris's
        message of "Wed, 5 Apr 2017 15:26:40 -0700")
Message-ID: <87inmifak8.fsf@kamboji.qca.qualcomm.com> (sfid-20170406_060318_108500_D3430017)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> nl80211 provides the NL80211_SCAN_FLAG_RANDOM_ADDR for every scan
> request that should be randomized; the absence of such a flag means we
> should not randomize. However, mwifiex was stashing the latest
> randomization request and *always* using it for future scans, even those
> that didn't set the flag.
>
> Let's zero out the randomization info whenever we get a scan request
> without NL80211_SCAN_FLAG_RANDOM_ADDR. I'd prefer to remove
> priv->random_mac entirely (and plumb the randomization MAC properly
> through the call sequence), but the spaghetti is a little difficult to
> unravel here for me.
>
> Fixes: c2a8f0ff9c6c ("mwifiex: support random MAC address for scanning")

So the first release with this was v4.9.

> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> Should this be tagged for -stable?

IMHO yes.

-- 
Kalle Valo
