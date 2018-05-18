Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38350 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbeERIN3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 04:13:29 -0400
Message-ID: <1526631206.3805.1.camel@sipsolutions.net> (sfid-20180518_101333_544617_1BD90F09)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Kourt <tim.a.kourt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 18 May 2018 10:13:26 +0200
In-Reply-To: <20180511164835.40161-1-tim.a.kourt@linux.intel.com> (sfid-20180511_184957_723913_31CD95FE)
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
         (sfid-20180511_184957_723913_31CD95FE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-05-11 at 09:48 -0700, Tim Kourt wrote:
> __cfg80211_bss_expire function was incorrectly used to flush the BSS
> entries from the previous scan results, causing NL80211_SCAN_FLAG_FLUSH
> flag to have no effect.

Hmm. I guess I'm not convinced - what's the bug?

We flush anything that's older than our start, so that should work just
fine?

johannes
