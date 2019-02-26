Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EE7C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 444392173C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbfBZNeA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:34:00 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:45324 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfBZNeA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:34:00 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gycr7-0006vC-Nc; Tue, 26 Feb 2019 14:33:09 +0100
Message-ID: <550ff2ac45c891a3fcf3dd8a454f9732d8aa1b70.camel@sipsolutions.net>
Subject: Re: [PATCH RFC] mac80211: Use IFF_ECHO to force delivery of
 tx_status frames
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Julius Niedworok <julius.n@gmx.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-wireless@vger.kernel.org, ga58taw@mytum.de,
        David Hildenbrand <david@redhat.com>, nc@net.in.tum.de,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 26 Feb 2019 14:33:07 +0100
In-Reply-To: <6A213CBE-0B6A-466A-B721-E6A728D4888D@gmx.net> (sfid-20190226_141427_875178_50C975AD)
References: <20190226094104.35192-1-julius.n@gmx.net>
         <c522f2e0-1bef-8679-45f7-707854918820@hartkopp.net>
         <6A213CBE-0B6A-466A-B721-E6A728D4888D@gmx.net>
         (sfid-20190226_141427_875178_50C975AD)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-02-26 at 14:13 +0100, Julius Niedworok wrote:
> 
> Thank you for the explanation - I can adjust the comment, if you like to.
> 
> > So what are you getting back after you enabled IFF_ECHO on your mac80211 device?
> > 
> > Is it just a 'status' about a sent packet, or is it the packet ('full content') itself?
> 
> We are actually getting back the full content of the packet. So it
> matches the behaviour of the 'echo' in CAN.

I don't think it does, really.

In CAN, if I understand correctly, this is used for regular operation
interfaces, where you might want to run 'tcpdump', on wifi the
equivalent would be 'tcpdump -i wlan0'. This *already* implements full
visibility of outgoing and incoming frames.

Not sure how CAN even manages *not to*, but I don't really need to care
:-)

You're proposing to add this to the *monitor* interfaces and you really
should have made the flag conditional on that to make that clear.

However, even on monitor interfaces, you typically *already* see the
frames you transmitted there (as raw frames, which is the only thing you
can do).

What you're proposing is to use IFF_ECHO to show frames transmitted
through *other* interfaces on the monitor interface.

I don't think the IFF_ECHO semantics really match this.


Additionally, drivers are sort of free to ignore the REQ_TX_STATUS, or
we could in the future add ways of using the _noskb to feed back TX
status to the state machines where needed, so I'm not really sure I even
_want_ this to be set in stone in such an API.

Now, I can also see how this can be useful for debugging, but it feels
to me like this should be a driver (debug) option?

johannes

