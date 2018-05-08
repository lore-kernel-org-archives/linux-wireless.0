Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:56240 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752474AbeEHNBZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 09:01:25 -0400
Message-ID: <1525784480.14830.12.camel@sipsolutions.net> (sfid-20180508_150144_293364_E52D5E09)
Subject: Re: [PATCH] mac80211: ethtool: avoid 32 bit multiplication overflow
From: Johannes Berg <johannes@sipsolutions.net>
To: Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 08 May 2018 15:01:20 +0200
In-Reply-To: <20180508125732.5153-1-colin.king@canonical.com>
References: <20180508125732.5153-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-08 at 13:57 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The multiplication of 100000 * cfg80211_calculate_bitrate() is a 32 bit
> operation and can overflow if cfg80211_calculate_bitrate is greater
> than 42949. Although I don't believe this is occurring at present, it
> would be safer to avoid the potential overflow by making the constant
> 100000 an ULL to ensure a 64 multiplication occurs.

Yeah it can't happen since mac80211 doesn't support 60 GHz devices, and
all others are limited to less than than.

Still, applied.

johannes
