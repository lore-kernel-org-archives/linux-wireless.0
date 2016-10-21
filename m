Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60514 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754247AbcJULzV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 07:55:21 -0400
Message-ID: <1477050915.4068.36.camel@sipsolutions.net> (sfid-20161021_135525_321040_FA11DEE6)
Subject: brcmfmac interface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 21 Oct 2016 13:55:15 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

I'm looking into the interface combinations stuff, mostly due to the
patches from QCA to add the support for differing beacon intervals.

One thing that I was considering, was to change the API
for cfg80211_check_combinations() to not require the driver to fill in
the # of interfaces of each given type, but just have it pass the new
one, if present, or so.


However, there's a major difference between brcmfmac and mac80211 (the
only "drivers" using this), namely this: mac80211 allows *adding* any
kind of interface, as long as you don't actually try to operate it.
brcmfmac, on the other hand, prevents even adding an interface if it
doesn't fit the combinations.

I'm wondering if this is intentional?

I suspect that we can't change mac80211 at this point, and the brcmfmac
behaviour might be unexpected to some people who are used to working
with mac80211, but I'm not sure you'd want to change it either?

johannes
