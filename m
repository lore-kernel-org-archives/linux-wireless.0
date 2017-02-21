Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36260 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752466AbdBUMhi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 07:37:38 -0500
Message-ID: <1487680651.2215.5.camel@sipsolutions.net> (sfid-20170221_133741_489768_148C9B90)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>
Date: Tue, 21 Feb 2017 13:37:31 +0100
In-Reply-To: <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com> (sfid-20170221_123449_168516_EAA590DB)
References: <20170221100957.30965-1-johannes@sipsolutions.net>
         <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com>
         <1487673603.2215.3.camel@sipsolutions.net>
         <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com>
         (sfid-20170221_123449_168516_EAA590DB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> What I am also missing is how to deal with NL80211_CMD_CONNECTED
> event signalling. Should that be given after (un)successful
> completion of the 4-way handshake or should we have a separate event
> for that? 

That's a good point. I don't think a new event really works well, but
perhaps we should extend the NL80211_TIMEOUT_* values with this? It's
not strictly a timeout, I guess, but it's not a direct rejection of the
association either.

Any thoughts?

johannes
