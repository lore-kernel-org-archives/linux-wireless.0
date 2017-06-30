Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59940 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751652AbdF3GrO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 02:47:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] nl80211: Don't verify owner_nlportid on NAN commands
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170626165230.13971-1-luca@coelho.fi>
References: <20170626165230.13971-1-luca@coelho.fi>
To: Luciano Coelho <luca@coelho.fi>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        arend.vanspriel@broadcom.com,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Message-Id: <20170630064713.5F0EE607EA@smtp.codeaurora.org> (sfid-20170630_084717_533445_5B269D10)
Date: Fri, 30 Jun 2017 06:47:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luca@coelho.fi> wrote:

> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> If NAN interface is created with NL80211_ATTR_SOCKET_OWNER, the socket
> that is used to create the interface is used for all NAN operations and
> reporting NAN events.
> However, it turns out that sending commands and receiving events on
> the same socket is not possible in a completely race-free way:
> If the socket buffer is overflowed by the events, the command response
> will not be sent. In that case the caller will block forever on recv.
> Using non-blocking socket for commands is more complicated and still
> the command response or ack may not be received.
> So, keep unicasting NAN events to the interface creator, but allow
> using a different socket for commands.
> 
> Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Patch applied to wireless-drivers-next.git, thanks.

36a554cec119 nl80211: Don't verify owner_nlportid on NAN commands

-- 
https://patchwork.kernel.org/patch/9810107/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
