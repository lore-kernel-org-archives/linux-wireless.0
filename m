Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50170 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbeCWN1b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 09:27:31 -0400
Message-ID: <1521811648.11491.8.camel@sipsolutions.net> (sfid-20180323_142734_468698_A120C039)
Subject: Re: [PATCHv4 1/3] cfg80211: enable setting cqm rssi config for AP
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Mar 2018 14:27:28 +0100
In-Reply-To: <1519544998-2621-2-git-send-email-tamizhr@codeaurora.org> (sfid-20180225_085010_994165_1F9FF330)
References: <1519544998-2621-1-git-send-email-tamizhr@codeaurora.org>
         <1519544998-2621-2-git-send-email-tamizhr@codeaurora.org>
         (sfid-20180225_085010_994165_1F9FF330)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-02-25 at 13:19 +0530, Tamizh chelvam wrote:
> From: Tamizh chelvam <tamizhr@codeaurora.org>
> 
> This patch extend cqm rssi config and notifier feature to AP mode
> by introducing NL80211_EXT_FEATURE_AP_STA_CQM_RSSI_CONFIG ext
> feature bit. And this patch introduces NL80211_MCGRP_AP_STA_CQM
> for notifying station's low/high rssi event to userspace application.

So, I guess I can sort of see how this could be useful.

However, is it really best in this current form?

For example, it seems trivial to imagine that one might want to have
different thresholds for different stations, and nothing in the current
implementation would prevent that, just the CQM API isn't very suited
to that.

There was also an extension to CQM to support different levels - not
sure where that ended up, but we should take that into account I guess.


Overall, I'm still not really convinced CQM is the right approach here.

One thing I could even imagine would be to just not have this
capability at all, but build it into a little BPF program you install.
I had - and still want to revive - the code to insert a "programming
point" into the wireless stack, and one could then easily build a hash
table of TAs vs. signal strength in BPF code.

We may not want to go that far, but I think the current approach is too
short-sighted. This might solve a specific problem today, but I don't
think it'll serve us well into the future if we don't make it more
flexible.

johannes
