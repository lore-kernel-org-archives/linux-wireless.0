Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:57068 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3CGWbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 17:31:17 -0500
MIME-Version: 1.0
In-Reply-To: <1362477938.8224.1.camel@jlt4.sipsolutions.net>
References: <1362477938.8224.1.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 7 Mar 2013 14:30:55 -0800
Message-ID: <CAB=NE6UBmPrxp5Pd9cdED4QMQPyxwVi3sn+-RGQVZa=dZzDAPA@mail.gmail.com> (sfid-20130307_233122_287847_4EC10EC1)
Subject: Re: [PATCH] nl80211/compat: netlink_callback min_dump_alloc only
 exists since 3.1
To: Johannes Berg <johannes@sipsolutions.net>
Cc: backports@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 5, 2013 at 2:05 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> On older kernels, we can't do this workaround, so if you use
> an old 64-bit kernel with compat you'd better upgrade.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  patches/0006-disable-dump-adjust-on-old-kernels.patch | 18 ++++++++++++++++++

Same thing here, seems you are using an old branch where all patches
are under patches. The networking patches for backporting are now
under patches/collateral-evolutions/network/. I've massaged it,
applied and pushed, thanks!

Just FYI the patches with 4 digits are patches which have undergone
review and effort to break down as atomically as possible with the
hope that some of these can later be expressed as SmPL grammar to
automatically backport further use cases of the changes expressed. In
this case your patch is already well broken down so I'll leave it with
the 4 digit name.

I've also gone ahead and added some explanation on the top of the
patch as to what it does.

I've added this documentation:

----------------------------------------------

On older kernels, we can't do this workaround, so if you use
an old 64-bit kernel with compat you'd better upgrade.

For more details of this work around refer to this commit
upstream that deals with the code added:

commit 645e77def93f1dd0e211c7244fbe152dac8a7100
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Mar 1 14:03:49 2013 +0100

    nl80211: increase wiphy dump size dynamically

    Given a device with many channels capabilities the wiphy
    information can still overflow even though its size in
    3.9 was reduced to 3.8 levels. For new userspace and
    kernel 3.10 we're going to implement a new "split dump"
    protocol that can use multiple messages per wiphy.

    For now though, add a workaround to be able to send more
    information to userspace. Since generic netlink doesn't
    have a way to set the minimum dump size globally, and we
    wouldn't really want to set it globally anyway, increase
    the size only when needed, as described in the comments.
    As userspace might not be prepared for large buffers, we
    can only use 4k.

    Also increase the size for the get_wiphy command.
----------------------------------------------

Let me know if you want to be more verbose for users.

  Luis
