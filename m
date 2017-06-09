Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53858 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751536AbdFII7R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 04:59:17 -0400
Message-ID: <1496998749.2424.3.camel@sipsolutions.net> (sfid-20170609_105929_175674_B0BD75B9)
Subject: Re: [linux-wireless] [mac80211] Does IEEE80211_IBSS_MAX_STA_ENTRIES
 (in net/mac80211/ibss.c) work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Xuebing Wang <xbing6@gmail.com>, linux-wireless@vger.kernel.org
Date: Fri, 09 Jun 2017 10:59:09 +0200
In-Reply-To: <0d40c0dc-4476-0567-6cb9-149a3fcc83e4@gmail.com> (sfid-20170608_065026_486259_DBDF5F58)
References: <0d40c0dc-4476-0567-6cb9-149a3fcc83e4@gmail.com>
         (sfid-20170608_065026_486259_DBDF5F58)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-06-08 at 12:50 +0800, Xuebing Wang wrote:
> Hi community,
> 
> Does IEEE80211_IBSS_MAX_STA_ENTRIES (in net/mac80211/ibss.c) work?

Yes, as far as it's supposed to :)

> I hard-code it to be 2 (from original 128), and update kernel for
> one node, and start IBSS network with 5 nodes. In the node with hard-
> coded IBSS_MAX_STA_ENTRIES = 2, I still can see and ping all other 4
> nodes. I am using kernel v3.18.29, does IBSS_MAX_STA_ENTRIES work
> with latest kernel source code?
> 
> My purpose is to limit the max number of peers (for all nodes in
> IBSS network) to be 12 or 20.

This isn't really the point of this setting, and that's why it's also
not configurable.

This setting is really just intended to catch the case of a rogue
network/transmitter or similar overflowing the amount of memory we
keep.

This setting has no impact on who we can *communicate* with - although
we can only communicate with peers that we don't have a station entry
for on very few low rates, so you won't get good performance beyond
that point.

If you wanted to actually limit the IBSS network to a certain number of
peers, you'd have to

 * make that setting configurable (with a sane upper bound)
 * write some additional code to restrict IBSS communication to when a
   station entry exists

You could also do some higher layer filtering (iptables) I guess.

johannes
