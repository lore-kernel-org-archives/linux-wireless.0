Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41082 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751648AbcJDJZu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 05:25:50 -0400
Message-ID: <1475573142.5324.41.camel@sipsolutions.net> (sfid-20161004_112556_661202_D33416FC)
Subject: Re: nl80211 fine timing measurement support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Lior David <liord@codeaurora.org>, Luca Coelho <luca@coelho.fi>
Cc: Maya Erez <merez@codeaurora.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 04 Oct 2016 11:25:42 +0200
In-Reply-To: <6b1f015b-2796-9821-25c6-d4d5070939c9@broadcom.com> (sfid-20161001_115652_871760_B91DD921)
References: <e7096bbb-ba66-e639-b86e-a483dc198b85@codeaurora.org>
         <45d2980c-aeb4-4faa-e73f-75747124e9eb@broadcom.com>
         <1474353599.5664.125.camel@coelho.fi>
         <b7022d3c-51ff-96eb-f6f0-319eb5ea66b0@codeaurora.org>
         <6b1f015b-2796-9821-25c6-d4d5070939c9@broadcom.com>
         (sfid-20161001_115652_871760_B91DD921)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> If raw results are mainly used for analysis algorithms how about
> providing raw measurement data through debugfs. May even consider
> adding rtt calculation in cfg80211/mac80211 for drivers that choose
> to provide raw measurement data and still only report final RTT in
> nl80211 api.
> 

I think the "analysis algorithms" in this case are what actually gives
you the distance value.

However, I don't think we should accept that everybody wants to run
their proprietary algorithms on top and expose only the values needed
for those. That makes the drivers only usable with additional
proprietary software, which may even be incompatible with the GPL.

If the algorithms are in the device, then we can expose the final
results, and that's most useful for applications in the API.

If they're not, then we need to expose something that can be used
without additional proprietary and device-specific algorithms.

If those algorithms cannot be run in the device, then we should put
them into the driver instead.

johannes
