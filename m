Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0057.outbound.protection.outlook.com ([104.47.37.57]:42432
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726733AbeHHNkS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 09:40:18 -0400
Date: Wed, 8 Aug 2018 14:20:42 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: scan: fix crash when driver doesn't report frame type
Message-ID: <20180808112042.h7n3v2wxejo7ab7s@bars> (sfid-20180808_132137_602337_01D5CA13)
References: <20180804203111.31768-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180804203111.31768-1-sergey.matyukevich.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If driver does not know what kind of frame has been received from BSS,
> then it is possible to specify CFG80211_BSS_FTYPE_UNKNOWN
> in cfg80211_inform_bss[_width].
> 
> In this case neither NL80211_BSS_BEACON_IES nor NL80211_BSS_PRESP_DATA
> will be reported to userspace.

The fix is for iw tool, so the patch title is a bit confusing.
It should have been something like this:
[PATCH] iw: scan: fix crash when driver doesn't report frame type

Regards,
Sergey
