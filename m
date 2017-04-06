Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751694AbdDFPlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 11:41:49 -0400
Message-ID: <1491493306.9316.1.camel@redhat.com> (sfid-20170406_174158_521841_B5531744)
Subject: Re: How to use netlink to determine wifi protection WEP
From: Dan Williams <dcbw@redhat.com>
To: Thomas Thielemann <thomas@th-thielemann.de>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 06 Apr 2017 10:41:46 -0500
In-Reply-To: <C7BDEED9-DCEC-4BED-AC69-800EEFE4FF49@th-thielemann.de>
References: <163FFAFB-1BA3-42A1-9F84-0EAEDFEBE5AE@th-thielemann.de>
         <1491413087.14498.2.camel@redhat.com>
         <C7BDEED9-DCEC-4BED-AC69-800EEFE4FF49@th-thielemann.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-06 at 16:27 +0200, Thomas Thielemann wrote:
> Thanks!
> 
> If the sequence is the following:
> 
>  1. Prepare and execute NL80211_CMD_TRIGGER_SCAN
>  2. Prepare and execute NL80211_CMD_GET_SCAN
>  Together with NL80211_CMD_GET_SCAN a callback is registered. 
>  In the callback the raw data are parsed as BSS. The IE's are parsed
> to.
> 
> When do I have to fetch the beacon to get the right beacon but
> without lost of the scan result?
> After I fetched all scan results or immediately after the receive of
> every scan result?

The scan results are essentially the beacons, so you just need to read
the GET_SCAN.  Then when parsing the "bss info" you get from the scan
results handler that you registered, you look for:

NL80211_BSS_CAPABILITY: the Privacy bit is in here
NL80211_BSS_INFORMATION_ELEMENTS: the IEs are obviously in here

Dan

> Regards,
> Thomas
> 
> 
> > Am 05.04.2017 um 19:24 schrieb Dan Williams <dcbw@redhat.com>:
> > 
> > On Wed, 2017-04-05 at 09:27 +0200, Thomas Thielemann wrote:
> > > Hello!
> > > 
> > > I need a solution to determine whether a WiFi is using WEP. I
> > > know
> > > there is a protection flag within MAC frame but do not know how
> > > to
> > > access.
> > > 
> > > To detect whether a WiFi i protected by WPA2 I found the
> > > following
> > > solution: 
> > > 
> > > Scan with
> > > 
> > > nl_sock* socket = nl_socket_alloc();
> > > genl_connect(socket);
> > > struct nl_msg* msg = nlmsg_alloc();
> > > int driverId = genl_ctrl_resolve(socket, "nl80211"); 
> > > genlmsg_put(msg, 0, 0, driverId, 0, 0, NL80211_CMD_TRIGGER_SCAN,
> > > 0);
> > > 
> > > and fetch with
> > > 
> > > genlmsg_put(msg, 0, 0, driverId, 0, NLM_F_DUMP,
> > > NL80211_CMD_GET_SCAN,
> > > 0);
> > > 
> > > Read the received structure using nl80211_bss::
> > > NL80211_BSS_INFORMATION_ELEMENTS from nl80211.h and
> > > 
> > > examine the field RSN(id=48) (see IEEE802.11-2012.pdf, chapter
> > > 8.4.2
> > > Information elements)
> > > 
> > > Which netlink command gives me the related data? Is it
> > > NL80211_CMD_GET_BEACON?
> > 
> > You want both the beacon (for the Privacy bit) and the information
> > elements.
> > 
> > If the privacy bit is set in beacon and there are no WPA/WPA2/RSN-
> > related information elements, then the AP is using
> > WEP.  Unfortunately
> > you don't know whether it's WEP-40 or WEP-104, but that's another
> > topic.
> > 
> > If the privacy bit is set, and there are WPA/WPA2/RSN information
> > elements, then the AP *might* be using WEP in compatibility
> > mode.  This
> > isn't very common though, so you can probably just ignore this
> > case.
> > 
> > Dan
> > 
> 
> 
