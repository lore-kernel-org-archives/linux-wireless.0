Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54122 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753709AbcHSBAV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Aug 2016 21:00:21 -0400
Message-ID: <1471555383.28620.5.camel@sipsolutions.net> (sfid-20160819_031515_602892_D123D791)
Subject: Re: [PATCH 2/3] wlcore: Pass win_size taken from ieee80211_sta to FW
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Altshul <maxim.altshul@ti.com>,
        linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Date: Thu, 18 Aug 2016 23:23:03 +0200
In-Reply-To: <20160818073627.30972-3-maxim.altshul@ti.com>
References: <20160818073627.30972-1-maxim.altshul@ti.com>
         <20160818073627.30972-2-maxim.altshul@ti.com>
         <20160818073627.30972-3-maxim.altshul@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-08-18 at 10:36 +0300, Maxim Altshul wrote:
> When starting a new BA session, we must pass the win_size to the FW.
> 
> To do this we take max_rx_aggregation_subframes (BA RX win size)
> which is stored in ieee80211_sta structure (e.g per link and not per
> HW)

I believe this is wrong, and you should use the struct
ieee80211_ampdu_params::buf_size value that's passed to ampdu_action
when the action is IEEE80211_AMPDU_RX_START.

johannes
