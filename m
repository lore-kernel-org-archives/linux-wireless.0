Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48840 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbcJEN5W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 09:57:22 -0400
Message-ID: <1475675837.5257.1.camel@sipsolutions.net> (sfid-20161005_155725_714356_85BC4816)
Subject: Re: [PATCH] cfg80211: let ieee80211_amsdu_to_8023s() take only
 802.3 header
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Braun <michael-dev@fami-braun.de>
Date: Wed, 05 Oct 2016 15:57:17 +0200
In-Reply-To: <1475674414-23086-1-git-send-email-johannes@sipsolutions.net> (sfid-20161005_153344_222282_258F288B)
References: <1475674414-23086-1-git-send-email-johannes@sipsolutions.net>
         (sfid-20161005_153344_222282_258F288B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-05 at 15:33 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's only a single case where has_80211_header is passed as true,
> which is in mac80211. Given that it's only a very simple check that
> needs to be done before calling it (calling
> __ieee80211_data_to_8023()
> and checking its return value), simple move that into the caller in
> order to simplify this function. The only additional cost this adds
> is the extra skb_push(), so reduce that by using __skb_push() as we
> know there's enough space, having pulled just before.

Obviously this is broken ... we need to have a frame without the outer
802.3 header, not with it, passed into the function.

johannes
