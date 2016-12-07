Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34970 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751792AbcLGJhL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 04:37:11 -0500
Message-ID: <1481103371.4092.36.camel@sipsolutions.net> (sfid-20161207_103744_583047_BB70B9F8)
Subject: Re: [PATCH v2 2/2] mac80211:  Show pending txqlen in debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Wed, 07 Dec 2016 10:36:11 +0100
In-Reply-To: <1480964310-16698-2-git-send-email-greearb@candelatech.com>
References: <1480964310-16698-1-git-send-email-greearb@candelatech.com>
         <1480964310-16698-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-12-05 at 10:58 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Could be useful for debugging memory consumption issues,
> and perhaps power-save as well.

Applied this one, but I tend to agree with Felix about the ethtool
stuff, so I've dropped that.

FWIW, we have cfg80211_get_station() now (maybe we could extend that
and provide an iterator as well), so instead of carrying patches you
could also have a small additional module that uses the existing APIs
to get the data, since nl80211 seems to somehow be so problematic for
you.

johannes
