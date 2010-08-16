Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53082 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab0HPTGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 15:06:31 -0400
Received: by vws3 with SMTP id 3so3678407vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 12:06:30 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 16 Aug 2010 15:06:29 -0400
Message-ID: <AANLkTi=ZGn0Rt7zYxBJB0jJ-EY=gPpxtBN2bA9svkq99@mail.gmail.com>
Subject: nl80211 scanning from userspace
From: Christopher Piggott <cpiggott@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to figure out how to use nl80211 to scan.  The "iw" example
has been somewhat helpful, though the userspace header file nl80211
and /usr/include/netlink/*.h have been helpful.  I'm on an ubuntu
system, and I'm sorry to say that the libnl1-doc package has some
doxygen files in it that don't agree with the actual headers (function
prototypes differ, etc.) but it's enough to get at least some picture
of what's going on.

Here's what I have put together so far, in snippets:

Register callbacks for all messages:
    callbacks = nl_cb_alloc(NL_CB_DEFAULT);
    nl_cb_set_all(callbacks,  NL_CB_CUSTOM, rx, NULL);

Create a socket, allocate a cache.  I do error checking on each of
these calls to make sure they succeed, but I'm eliminating that here
for brevity:
    genl_connect(sock);
    cache = genl_ctrl_alloc_cache(sock);
    nl80211 = genl_ctrl_search_by_name(cache, cacheName);   /*
cacheName is "nl80211" */

Start building the message.  First build an SSID list with one entry
in it (empty string)
    struct nl_msg *ssids = nlmsg_alloc();
    nla_put_string(ssids, 0, "");

Next build the scan request message:
    struct nl_msg *msg = nlmsg_alloc();
    int flags = 0;
    int cmd = NL80211_CMD_TRIGGER_SCAN;
    genlmsg_put(msg, 0, 0, genl_family_get_id(nl80211), 0, flags, cmd, 0);
    /* append our ssid list to this message as a nested message */
    nla_put_nested(msg, NL80211_ATTR_SCAN_SSIDS, ssids)

Finally I send the request:
    int rc = nl_send_auto_complete(sock, msg);

>From this I found out that 32 bytes were sent (seems reasonable).
Unfortunately, what I get back is this:
  [HEADER] 16 octets
    .nlmsg_len = 52
    .nlmsg_type = 2 <ERROR>
    .nlmsg_flags = 0 <>
    .nlmsg_seq = 1282012377
    .nlmsg_pid = 30415
  [ERRORMSG] 20 octets
    .error = -22 "Invalid argument"
  [ORIGINAL MESSAGE] 16 octets
    .nlmsg_len = 16
    .nlmsg_type = 23 <0x17>
    .nlmsg_flags = 5 <REQUEST,ACK>
    .nlmsg_seq = 1282012377
    .nlmsg_pid = 30415

so, even following what iw's "scan.c" does I have somehow pieced the
request together incorrectly.

Questions:
1. Am I doing something obviously wrong?
2. Is this even the interface I should be using to do this?  (I need
to scan for all access points on a specific "hidden" SSID to retrieve
some information about their SNR.  It's a type of "site survey"
application for building contour maps of coverage).

I'm not sure what I'm doing next makes sense, either.  After I send
the scan request I wait 3 seconds then start reading like this:
    while(nl_recvmsgs(sock, callbacks) != 0)
    {
        printf("processed a result\n");
    }

I have registered my callback earlier; this seems to work because I
get the message (above) plus later an "Operation Not Supported"
message.  The operation is indeed supported, as it works with the
iwlist and iw command line tools.

--Chris
