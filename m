Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59798 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751353AbdFZK6r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 06:58:47 -0400
Message-ID: <1498474722.3318.2.camel@sipsolutions.net> (sfid-20170626_125850_908362_45986049)
Subject: Re: [PATCH] nl80211: Don't verify owner_nlportid on NAN commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 26 Jun 2017 12:58:42 +0200
In-Reply-To: <5680f862-2025-0ff0-59a2-ae50e32cee76@broadcom.com> (sfid-20170623_230337_027084_2D56F2D7)
References: <20170623092633.23026-1-luca@coelho.fi>
         <5680f862-2025-0ff0-59a2-ae50e32cee76@broadcom.com>
         (sfid-20170623_230337_027084_2D56F2D7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-23 at 23:03 +0200, Arend van Spriel wrote:
> 
> Also is this not a more fundamental flaw in netlink socket behavior.
> Should there be some priority imposed on command responses over event
> messages. Just seems like this patch is a workaround.

In a way, but it's not that easy. ACK messages are really just that,
messages, and having them bypass the queue might not be reasonable for
the use case, having them be queued unconditionally would open an
avenue for memory consumption attacks (send lots of dummy commands and
let the ACKs accumulate), and deleting already "delivered" message
could, I think, break semantics because I think delivery can be checked
by the sender?

Either way, I don't really see a good way to solve this problem in
netlink.

johannes
