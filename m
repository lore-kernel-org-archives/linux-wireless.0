Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47877 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754060AbcJEJiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 05:38:19 -0400
Message-ID: <1475660290.4994.21.camel@sipsolutions.net> (sfid-20161005_113823_313994_179963F6)
Subject: Re: [PATCH] mac80211: discard multicast and 4-addr A-MSDUs
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc: "M . Braun" <michael-dev@fami-braun.de>
Date: Wed, 05 Oct 2016 11:38:10 +0200
In-Reply-To: <90c1bacf-3ea3-0486-96f4-be878a4a759e@nbd.name>
References: <1475655551-13504-1-git-send-email-johannes@sipsolutions.net>
         <90c1bacf-3ea3-0486-96f4-be878a4a759e@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Won't this break the use of A-MSDU in existing 4-addr AP/STA setups?

I didn't think it did, but looking closer, that does seem indeed to be
the case.

Do you remember why you explicitly added code to *not* accept 4-addr
frames in non-4addr AP_VLAN, but no other cases? This seems oddly
specific.

I can change it to accept 4-addr frames in 4-addr cases, but I'll note
that it's completely pointless to carry A4 since it will not be used
for decapsulation.

johannes
