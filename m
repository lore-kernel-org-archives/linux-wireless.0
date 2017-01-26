Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49778 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752183AbdAZN2C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 08:28:02 -0500
Message-ID: <1485437276.14760.3.camel@sipsolutions.net> (sfid-20170126_142806_922181_12EEB62C)
Subject: IPv6-UDP 0x0000 checksum
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 26 Jan 2017 14:27:56 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

It looks like right now we may have a hardware bug and accept 0x0000 as
valid, when the outcome of the calculation is 0xffff.

What do you think we should do about this?

We could ignore the issue entirely, since 0 wasn't ever supposed to be
sent anyway - but then we don't drop frames that we should drop. I
didn't manage to find the code in the IPv6/UDP stack that even does
that, but I assume it's there somewhere.

Alternatively, we could parse the packet to find the checksum inside,
and if it's 0 then don't report CHECKSUM_UNNECESSARY, but that seems
rather expensive/difficult due to the IPv6 variable header and all
that. If we wanted to go this route, are there any helper functions for
this?

Unfortunately, in the current devices, we neither have a complete
indication that the packet was even UDP-IPv6, nor do we have the raw
csum or anything like that. I think they're adding that to the next
hardware spin, but we probably need to address this issue now.

johannes
