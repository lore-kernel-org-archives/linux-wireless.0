Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35644 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbdF0MDL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 08:03:11 -0400
Received: by mail-wm0-f49.google.com with SMTP id w126so22504926wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jun 2017 05:03:10 -0700 (PDT)
Subject: Re: [PATCH v2] nl80211: Don't verify owner_nlportid on NAN commands
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
References: <20170626165230.13971-1-luca@coelho.fi>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <90201931-33b5-cf49-9734-a42856af3a36@broadcom.com> (sfid-20170627_140314_946154_89EF99AA)
Date: Tue, 27 Jun 2017 14:03:07 +0200
MIME-Version: 1.0
In-Reply-To: <20170626165230.13971-1-luca@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-06-17 18:52, Luca Coelho wrote:
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
> ---
> 
> In v2:
>    * Andrei fixed the documentation.

Almost there :-p Is the reference in NL80211_CMD_ADD_NAN_FUNCTION doc to
NL80211_ATTR_SOCKET_OWNER still warranted?

Regards,
Arend
