Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34558 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbcLGJMP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 04:12:15 -0500
Message-ID: <1481101658.4092.26.camel@sipsolutions.net> (sfid-20161207_101248_433742_8232BC13)
Subject: Re: [PATCH] mac80211:  fix rx-rate report when rate is invalid.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
In-Reply-To: <1480975935-12760-1-git-send-email-greearb@candelatech.com>
References: <1480975935-12760-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2016 10:07:38 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-12-05 at 14:12 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This fixes obtaining the rate info via sta_set_sinfo
> when the rx rate is invalid (for instance, on IBSS
> interface that has received no frames from one of its
> peers).

Please fix this completely while at it, i.e.
make sta_set_rate_info_rx() have a return value and don't set
the BIT(NL80211_STA_INFO_RX_BITRATE) when there's no known rate.

johannes
