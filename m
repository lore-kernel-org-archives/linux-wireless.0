Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:43299 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751654Ab0JLFIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 01:08:06 -0400
Date: Tue, 12 Oct 2010 07:07:42 +0200
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [Patch v2 1/1] wext: fix alignment problem in serializing 'struct
	iw_point'
Message-ID: <20101012050742.GA6376@gerrit.erg.abdn.ac.uk>
References: <20100930102508.GB3581@gerrit.erg.abdn.ac.uk> <1285857487.5137.2.camel@jlt3.sipsolutions.net> <42875.148.187.160.35.1285917725.squirrel@148.187.160.35> <1285921839.3739.16.camel@jlt3.sipsolutions.net> <20101011051410.GA3977@gerrit.erg.abdn.ac.uk> <1286790947.3634.9.camel@jlt3.sipsolutions.net> <56374.148.187.160.35.1286798194.squirrel@148.187.160.35> <1286798432.3634.39.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286798432.3634.39.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wext: fix alignment problem in serializing 'struct iw_point'

This fixes a typo in the definition of the serialized length of struct iw_point:
 a) wireless.h is exported to userspace, the typo causes IW_EV_POINT_PK_LEN
    to be 12 on 64-bit, and 8 on 32-bit systems (causing misalignment);
 b) in compat-64 mode iwe_stream_add_point() memcpys overlap (see below).

The second case in  in compat-64 mode looks like (variable names are as in
include/net/iw_handler.h:iwe_stream_add_point()):

 point_len = IW_EV_COMPAT_POINT_LEN = 8
 lcp_len   = IW_EV_COMPAT_LCP_LEN   = 4
 2nd memcpy: IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN = 12 - 4 = 8

 IW_EV_LCP_PK_LEN
 <-------------->                *---> 'extra' data area
 +-------+-------+-------+-------+---------------+------- ...-+
 | len   | cmd   |length | flags |  (empty) -> extra      ... |
 +-------+-------+-------+-------+---------------+------- ...-+
    2       2       2       2          4
 
     lcp_len
 <-------------->                <-!! OVERLAP !!>
 <--1st memcpy--><------- 2nd memcpy ----------->
                                 <---- 3rd memcpy ------- ... >
 <--------- point_len ---------->

This case could cause overrun whenever iw_point.length < 4. 
The other two cases are -
 * 32-bit systems: IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN =  8 - 4 = 4,
   the second memcpy copies exactly the 4 required bytes;
 * 64-bit systems: IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN = 12 - 4 = 8,
   the second memcpy copies a superfluous (but non overlapping) 4 bytes.

The patch changes IW_EV_POINT_PK_LEN to be 8, so that in all 3 cases always only
the requested iw_point.{length,flags} (both __u16) are copied, avoiding overrrun
(compat-64) and superfluous copy (64-bit). In addition, the userspace header is
sanitized (in agreement with version 30 of the wireless tools).

Many thanks to Johannes Berg for help and review with this patch.
    
Signed-off-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
---
 include/linux/wireless.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
	
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -1157,6 +1157,6 @@ struct __compat_iw_event {
 #define IW_EV_PARAM_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_param))
 #define IW_EV_ADDR_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct sockaddr))
 #define IW_EV_QUAL_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_quality))
-#define IW_EV_POINT_PK_LEN	(IW_EV_LCP_LEN + 4)
+#define IW_EV_POINT_PK_LEN	(IW_EV_LCP_PK_LEN + 4)
 
 #endif	/* _LINUX_WIRELESS_H */

