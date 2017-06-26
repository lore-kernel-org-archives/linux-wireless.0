Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35210 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751407AbdFZLWo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 07:22:44 -0400
Message-ID: <1498476159.22048.34.camel@coelho.fi> (sfid-20170626_132248_302034_92C93007)
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Mon, 26 Jun 2017 14:22:39 +0300
In-Reply-To: <5680f862-2025-0ff0-59a2-ae50e32cee76@broadcom.com>
References: <20170623092633.23026-1-luca@coelho.fi>
         <5680f862-2025-0ff0-59a2-ae50e32cee76@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] nl80211: Don't verify owner_nlportid on NAN commands
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-23 at 23:03 +0200, Arend van Spriel wrote:
> On 23-06-17 11:26, Luca Coelho wrote:
> > From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> > 
> > If NAN interface is created with NL80211_ATTR_SOCKET_OWNER, the socket
> > that is used to create the interface is used for all NAN operations and
> > reporting NAN events.
> > However, it turns out that sending commands and receiving events on
> > the same socket is not possible in a completely race-free way:
> > If the socket buffer is overflowed by the events, the command response
> > will not be sent. In that case the caller will block forever on recv.
> > Using non-blocking socket for commands is more complicated and still
> > the command response or ack may not be received.
> > So, keep unicasting NAN events to the interface creator, but allow
> > using a different socket for commands.
> 
> Sounds like this patch is missing significant changes in the
> documentation of nl80211 API:

Thanks Arend!

Andrei is going to fix the documentation and I'll send v2.


--
Luca.
