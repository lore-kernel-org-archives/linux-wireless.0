Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49712 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750761AbdD1JTI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 05:19:08 -0400
Message-ID: <1493371140.2431.6.camel@sipsolutions.net> (sfid-20170428_111924_839852_24BECDFB)
Subject: Re: [PATCH] mac80211: Fix possible sband related NULL pointer
 de-reference
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org
Cc: mohammed@codeaurora.org, Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 28 Apr 2017 11:19:00 +0200
In-Reply-To: <1493277338-25726-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1493277338-25726-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-27 at 12:45 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Existing API 'ieee80211_get_sdata_band' returns default 2 GHz band
> even
> if the channel context configuration is NULL. This crashes for
> chipsets
> which support 5 Ghz alone when it tries to access members of 'sband'.
> Channel context configuration can be NULL in multivif case and when
> channel switch is in progress (or) when it fails. Fix this by
> replacing
> the API 'ieee80211_get_sdata_band' with  'ieee80211_get_sband' which
> returns a NULL pointer for sband when the channel configuration is
> NULL.

Makes sense.

Applied, but could you point to the one that actually crashed?


johannes
