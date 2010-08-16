Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab0HPTNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 15:13:49 -0400
Subject: Re: nl80211 scanning from userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Christopher Piggott <cpiggott@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=ZGn0Rt7zYxBJB0jJ-EY=gPpxtBN2bA9svkq99@mail.gmail.com>
References: <AANLkTi=ZGn0Rt7zYxBJB0jJ-EY=gPpxtBN2bA9svkq99@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 21:13:45 +0200
Message-ID: <1281986025.3683.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-16 at 15:06 -0400, Christopher Piggott wrote:

> Start building the message.  First build an SSID list with one entry
> in it (empty string)
>     struct nl_msg *ssids = nlmsg_alloc();
>     nla_put_string(ssids, 0, "");

I think that has to be a 1 instead of 0, but I'm not entirely sure.

> Next build the scan request message:
>     struct nl_msg *msg = nlmsg_alloc();
>     int flags = 0;
>     int cmd = NL80211_CMD_TRIGGER_SCAN;
>     genlmsg_put(msg, 0, 0, genl_family_get_id(nl80211), 0, flags, cmd, 0);
>     /* append our ssid list to this message as a nested message */
>     nla_put_nested(msg, NL80211_ATTR_SCAN_SSIDS, ssids)

You're not telling it which interface should scan, this is handled
generically in iw.c, look for
	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, devidx);

> Finally I send the request:
>     int rc = nl_send_auto_complete(sock, msg);
> 
> From this I found out that 32 bytes were sent (seems reasonable).
> Unfortunately, what I get back is this:
>   [HEADER] 16 octets
>     .nlmsg_len = 52
>     .nlmsg_type = 2 <ERROR>
>     .nlmsg_flags = 0 <>
>     .nlmsg_seq = 1282012377
>     .nlmsg_pid = 30415
>   [ERRORMSG] 20 octets
>     .error = -22 "Invalid argument"
>   [ORIGINAL MESSAGE] 16 octets
>     .nlmsg_len = 16
>     .nlmsg_type = 23 <0x17>
>     .nlmsg_flags = 5 <REQUEST,ACK>
>     .nlmsg_seq = 1282012377
>     .nlmsg_pid = 30415
> 
> so, even following what iw's "scan.c" does I have somehow pieced the
> request together incorrectly.
> 
> Questions:
> 1. Am I doing something obviously wrong?

You're also missing the interface as above.

> 2. Is this even the interface I should be using to do this?  (I need
> to scan for all access points on a specific "hidden" SSID to retrieve
> some information about their SNR.  It's a type of "site survey"
> application for building contour maps of coverage).

Yes, it does make sense.

> I'm not sure what I'm doing next makes sense, either.  After I send
> the scan request I wait 3 seconds then start reading like this:
>     while(nl_recvmsgs(sock, callbacks) != 0)
>     {
>         printf("processed a result\n");
>     }
> 
> I have registered my callback earlier; this seems to work because I
> get the message (above) plus later an "Operation Not Supported"
> message.  The operation is indeed supported, as it works with the
> iwlist and iw command line tools.

Maybe you should look at wpa_supplicant either for doing your thing, or
for the driver_nl80211.c code in it, which is more explicit than iw.

johannes

