Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39915 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0HTXm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 19:42:56 -0400
Received: by gxk23 with SMTP id 23so1474079gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Aug 2010 16:42:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikzWs65zQYbCJQuvLv0e_010Rgy-C6J4ucpzBfa@mail.gmail.com>
References: <AANLkTi=ZGn0Rt7zYxBJB0jJ-EY=gPpxtBN2bA9svkq99@mail.gmail.com>
	<1281986025.3683.31.camel@jlt3.sipsolutions.net>
	<AANLkTiniqFJzrWFzNJTxsF31EZfSTei89dbS2Ak4YDjH@mail.gmail.com>
	<1281987696.3683.32.camel@jlt3.sipsolutions.net>
	<AANLkTi=ALaGb=UcWAuB_N8E9j95f0Hgxtw0Dhh7xaPh2@mail.gmail.com>
	<1281995025.3683.34.camel@jlt3.sipsolutions.net>
	<AANLkTi=sb0PT4FHsjbuAOQjnDq79GHEj8LbCLTtO8MeS@mail.gmail.com>
	<AANLkTin90i08fbYeyrc17a7=smhshxR69=ushqUSkA0Z@mail.gmail.com>
	<1282035102.3747.0.camel@jlt3.sipsolutions.net>
	<AANLkTikzWs65zQYbCJQuvLv0e_010Rgy-C6J4ucpzBfa@mail.gmail.com>
Date: Fri, 20 Aug 2010 19:42:56 -0400
Message-ID: <AANLkTi=ioQFQ=0_Z5EWRNVrEYp2o40UU4TROOMaouZX1@mail.gmail.com>
Subject: Fwd: nl80211 scanning from userspace
From: Christopher Piggott <cpiggott@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm sorry ... I hit REPLY again to Johannes personally rather than to
the list.  I don't know what it is about this list server that makes
me do it ... maybe there's no Reply-To.

Here was my followup question:


---------- Forwarded message ----------



I have another question about netlink scanning.  Here is what I am
doing.  First, trigger a request to starts canning:

   type = genl_family_get_id(nl80211);
   cmd = NL80211_CMD_TRIGGER_SCAN;
   flags = 0;
   pid = 0;
   (void) genlmsg_put(msg, pid, seqSent, type, 0, flags, cmd, 0);
   int dev = if_nametoindex("wlan0");
   nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev);
   rc = nl_send_auto_complete(sock, msg);


Wait a little while, and I get back a valid message that indicates the
scan is complete.  I handle that here:

bool try_parse_scan_status(struct nl_msg *msg) {
   struct genlmsghdr *genMsgHeader = (struct genlmsghdr *) nlmsg_data(header);

   /* check to make sure it's the right interface.  That works so
I'll leave that code out */
   switch (genMsgHeader->cmd) {
       case NL80211_CMD_NEW_SCAN_RESULTS:
           if (debug) {
               cerr << "New scan results available" << endl;
           }
           nl_msg_dump(msg, stdout);
           trigger_fetch_scan_results();
           break;
       /* other stuff deleted */
}

OK so here's what happens.  I get the message back indicating the scan
is complete, yay!  Then I try to call my trigger_fetch_scan_results().
 What that method does is sends command NL80211_CMD_GET_SCAN on that
interface, with the flag NLM_F_DUMP.  Great!

The problem is, I get a message back whose genMsgHeader->cmd STILL
says "NL80211_CMD_NEW_SCAN_RESULTS."  The resulting packet has good
stuff in it (the ssid, etc. info I am looking for).  UNFORTUNATELY,
because of the way I wrote my code it triggers another scan, which
causes it to say "Device or resource busy" and it just loops.


So here's the question: in my NL_CB_VALID listener, how do I
distinguish the response to the NL80211_CMD_TRIGGER_SCAN (the one that
indicates scan complete) from the response to the CMD_GET_SCAN (fetch
the results) message?

--Chris
