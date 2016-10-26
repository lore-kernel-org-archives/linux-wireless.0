Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53902 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932667AbcJZQKP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 12:10:15 -0400
Message-ID: <1477498212.5563.2.camel@sipsolutions.net> (sfid-20161026_181018_644403_1335061A)
Subject: Re: [PATCH 2/8] mac80211: Allow AUTH_DATA to be used for FILS
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 26 Oct 2016 18:10:12 +0200
In-Reply-To: <20161026153559.GA13254@jouni.qca.qualcomm.com>
References: <1477435357-8495-1-git-send-email-jouni@qca.qualcomm.com>
         <1477435357-8495-3-git-send-email-jouni@qca.qualcomm.com>
         <1477459800.4059.1.camel@sipsolutions.net>
         <20161026153559.GA13254@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This is admittedly a bit strange design with that special case needed
> for SAE. If we were to design the SAE case now in combination with
> FILS, I guess this would be quite different (e.g., separate
> attributes for Authentication transaction sequence number and Status
> code). Unlike the mesh use case with SAE, FILS is only between an AP
> and a station and as such, there would not really be a case where the
> station would send an Authentication frame with non-zero Status code.
> 
> A future amendment might define a new authentication algorithm that
> ends up using more than a single Authentication frame exchange. In
> such a case, we would actually have need for Authentication
> transaction sequence number even though FILS doesn't need it.
> 
> I think I'd rather maintain a consistent attribute design for all
> authentication algorithms and leave this as-is now. Another option
> would be to not apply the rename SAE attributes patch and define
> something new as a more generic solution, but I'm not sure there is
> sufficient justification for the added complexity since we cannot
> really get rid of the current SAE design any time soon.

Yes, fair point.

Maybe you can clarify the nl80211 attribute documentation wrt. this? It
just states that it starts with the Authentication transaction sequence
field, but afaict that's not true, it also has the status code field,
which is also ignored here.

johannes
