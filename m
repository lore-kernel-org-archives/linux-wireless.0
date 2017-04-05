Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754897AbdDERYt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 13:24:49 -0400
Message-ID: <1491413087.14498.2.camel@redhat.com> (sfid-20170405_192546_031423_9E66F7B5)
Subject: Re: How to use netlink to determine wifi protection WEP
From: Dan Williams <dcbw@redhat.com>
To: Thomas Thielemann <thomas@th-thielemann.de>,
        linux-wireless@vger.kernel.org
Date: Wed, 05 Apr 2017 12:24:47 -0500
In-Reply-To: <163FFAFB-1BA3-42A1-9F84-0EAEDFEBE5AE@th-thielemann.de>
References: <163FFAFB-1BA3-42A1-9F84-0EAEDFEBE5AE@th-thielemann.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-05 at 09:27 +0200, Thomas Thielemann wrote:
> Hello!
> 
> I need a solution to determine whether a WiFi is using WEP. I know
> there is a protection flag within MAC frame but do not know how to
> access.
> 
> To detect whether a WiFi i protected by WPA2 I found the following
> solution: 
> 
> Scan with
> 
> nl_sock* socket = nl_socket_alloc();
> genl_connect(socket);
> struct nl_msg* msg = nlmsg_alloc();
> int driverId = genl_ctrl_resolve(socket, "nl80211"); 
> genlmsg_put(msg, 0, 0, driverId, 0, 0, NL80211_CMD_TRIGGER_SCAN, 0);
> 
> and fetch with
> 
> genlmsg_put(msg, 0, 0, driverId, 0, NLM_F_DUMP, NL80211_CMD_GET_SCAN,
> 0);
> 
> Read the received structure using nl80211_bss::
> NL80211_BSS_INFORMATION_ELEMENTS from nl80211.h and
> 
> examine the field RSN(id=48) (see IEEE802.11-2012.pdf, chapter 8.4.2
> Information elements)
> 
> Which netlink command gives me the related data? Is it
> NL80211_CMD_GET_BEACON?

You want both the beacon (for the Privacy bit) and the information
elements.

If the privacy bit is set in beacon and there are no WPA/WPA2/RSN-
related information elements, then the AP is using WEP.  Unfortunately
you don't know whether it's WEP-40 or WEP-104, but that's another
topic.

If the privacy bit is set, and there are WPA/WPA2/RSN information
elements, then the AP *might* be using WEP in compatibility mode.  This
isn't very common though, so you can probably just ignore this case.

Dan
