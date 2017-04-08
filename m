Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38116 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751166AbdDHRtH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 13:49:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>, jiri@resnulli.us
Subject: [PATCH 0/5] extended netlink ACK reporting
Date: Sat,  8 Apr 2017 19:48:55 +0200
Message-Id: <20170408174900.12820-1-johannes@sipsolutions.net> (sfid-20170408_194912_839224_E91C2962)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

After testing and fixing the ack message length calculation,
this now works.

The UAPI changes are like before - the ACK message format becomes
 [nlmsg header]
 [ack header]
 [request nlmsg header]
 [request nlmsg body (already optional) - length aligned]
 [extended ACK TLVs - this is NEW]

The extended ACK TLVs currently are:
For the error case:
 * MSG - string message
 * OFFS - offset of problem (e.g. malformed attribute)
          in the request message
 * ATTR - missing attribute ID
For the success case:
 * COOKIE - arbitrary per-subsystem cookie to identify
            the newly created object or similar

The whole behaviour can be enabled/disabled/queried using
a new socket option NETLINK_EXT_ACK.

johannes
