Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43410 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751697AbcLEOxX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:53:23 -0500
Message-ID: <1480949600.31788.29.camel@sipsolutions.net> (sfid-20161205_155332_133729_A6E4CF6D)
Subject: Re: [PATCH] mac80211:  Return avg sig, rx, tx values in ethtool
 stats.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 05 Dec 2016 15:53:20 +0100
In-Reply-To: <58457D63.2010605@candelatech.com>
References: <1480442872-7358-1-git-send-email-greearb@candelatech.com>
                 (sfid-20161129_190824_045626_457405E8) <1480946891.31788.10.camel@sipsolutions.net>
         <58457D63.2010605@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Unless I screwed up, this patch also returns an average.

Oops, sorry. I missed the whole mac_div() indirection thing.

I'm not super convinced anyway though - all of this data already is
available in a much more reliable fashion, even trackable when stations
are removed (all data gets sent in the DEL_STATION notification), so
adding a crippled way to get the same data seems a bit strange?

In any case I'd want you to resend with the /* pr_..*/ stuff removed.

johannes
