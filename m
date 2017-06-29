Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43168 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752614AbdF2NYh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 09:24:37 -0400
Message-ID: <1498742675.3141.4.camel@sipsolutions.net> (sfid-20170629_152501_116846_CCEFEEBD)
Subject: Re: [PATCH v2] nl80211: Don't verify owner_nlportid on NAN commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 15:24:35 +0200
In-Reply-To: <20170626165230.13971-1-luca@coelho.fi>
References: <20170626165230.13971-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-06-26 at 19:52 +0300, Luca Coelho wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> If NAN interface is created with NL80211_ATTR_SOCKET_OWNER, the
> socket
> that is used to create the interface is used for all NAN operations
> and
> reporting NAN events.
> However, it turns out that sending commands and receiving events on
> the same socket is not possible in a completely race-free way:
> If the socket buffer is overflowed by the events, the command
> response
> will not be sent. In that case the caller will block forever on recv.
> Using non-blocking socket for commands is more complicated and still
> the command response or ack may not be received.
> So, keep unicasting NAN events to the interface creator, but allow
> using a different socket for commands.
> 
> Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com
> >
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 

Agree with Andrei regarding the documentation.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes
