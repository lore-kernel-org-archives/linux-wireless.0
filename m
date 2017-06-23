Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:34695 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdFWVDh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 17:03:37 -0400
Received: by mail-wr0-f172.google.com with SMTP id 77so80983357wrb.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 14:03:37 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Don't verify owner_nlportid on NAN commands
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
References: <20170623092633.23026-1-luca@coelho.fi>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5680f862-2025-0ff0-59a2-ae50e32cee76@broadcom.com> (sfid-20170623_230341_576173_2D14A2DA)
Date: Fri, 23 Jun 2017 23:03:34 +0200
MIME-Version: 1.0
In-Reply-To: <20170623092633.23026-1-luca@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23-06-17 11:26, Luca Coelho wrote:
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

Sounds like this patch is missing significant changes in the
documentation of nl80211 API:

 * @NL80211_CMD_ADD_NAN_FUNCTION: Add a NAN function. The function is
defined
 *      with %NL80211_ATTR_NAN_FUNC nested attribute. When called, this
 *      operation returns the strictly positive and unique instance id
 *      (%NL80211_ATTR_NAN_FUNC_INST_ID) and a cookie (%NL80211_ATTR_COOKIE)
 *      of the function upon success.
 *      Since instance ID's can be re-used, this cookie is the right
 *      way to identify the function. This will avoid races when a
termination
 *      event is handled by the user space after it has already added a new
 *      function that got the same instance id from the kernel as the one
 *      which just terminated.
 *      This cookie may be used in NAN events even before the command
 *      returns, so userspace shouldn't process NAN events until it
processes
 *      the response to this command.
 *      Look at %NL80211_ATTR_SOCKET_OWNER as well.

/and/

 * @NL80211_ATTR_SOCKET_OWNER: Flag attribute, if set during interface

[...]

 *      If set during NAN interface creation, the interface will be
destroyed
 *      if the socket is closed just like any other interface. Moreover,
only
 *      the netlink socket that created the interface will be allowed to add
 *      and remove functions. NAN notifications will be sent in unicast
to that
 *      socket. Without this attribute, any socket can add functions and the
 *      notifications will be sent to the %NL80211_MCGRP_NAN multicast
group.

Also is this not a more fundamental flaw in netlink socket behavior.
Should there be some priority imposed on command responses over event
messages. Just seems like this patch is a workaround.

Regards,
Arend
