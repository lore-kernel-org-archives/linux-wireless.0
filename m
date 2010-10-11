Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:47403 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340Ab0JKFOg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 01:14:36 -0400
Date: Mon, 11 Oct 2010 07:14:10 +0200
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [Patch 1/1] wext: fix 32/64 bit alignment issue for 'point'
	type
Message-ID: <20101011051410.GA3977@gerrit.erg.abdn.ac.uk>
References: <20100930102508.GB3581@gerrit.erg.abdn.ac.uk> <1285857487.5137.2.camel@jlt3.sipsolutions.net> <42875.148.187.160.35.1285917725.squirrel@148.187.160.35> <1285921839.3739.16.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
In-Reply-To: <1285921839.3739.16.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

| Ah, so userspace reading this was the issue -- yes, I can see that, and
| I checked the "canonical userspace" (wireless-tools), and it essentially
| contains this patch.
| 
The change should really be confined only to userspace, please see below.

There are three different alignments for three different cases, which are
caught by iwlib in userspace. Users of wireless.h can be encouraged to use the
latest iwlib, which catches the alignment issues transparently (I have been
given this advice myself).

In the drawings below I have traced with an asterisk where in userspace the data is
read out - as far as I can see this is correct. The only worrying case is number (3).

The cases are:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1) 32 bit kernel
~~~~~~~~~~~~~~~~
 point_len = IW_EV_POINT_LEN = 8
 iwe->len  = event_len = point_len + u.data.length = 8 + u.data.length
 lcp_len   = IW_EV_LCP_LEN   = 4
 2nd memcpy: IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN = 8 - 4 = 4


 IW_EV_LCP_PK_LEN
 <-------------->                *
 +-------+-------+-------+-------+------------ ...-+
 | len   | cmd   |length | flags | extra       ... |
 +-------+-------+-------+-------+------------ ...-+
    2       2       2       2
 
     lcp_len
 <-------------->
 <--1st memcpy--><- 2nd memcpy -><- 3rd memcpy ... >
 
 <--------- point_len ---------->


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2) 64-bit kernel
~~~~~~~~~~~~~~~~
 point_len = IW_EV_POINT_LEN = 16
 iwe->len  = event_len = point_len + u.data.length = 16 + u.data.length
 lcp_len   = IW_EV_LCP_LEN   = 8
 2nd memcpy: IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN = 12 - 4 = 8

 IW_EV_LCP_PK_LEN
 <-------------->                *                               *
 +-------+-------+---------------+-------+-------+---------------+------------ ...-+
 | len   | cmd   |   (empty)     |length | flags |  (empty)      | extra       ... |
 +-------+-------+---------------+-------+-------+---------------+------------ ...-+
    2       2           4             2      2          4 
 
      lcp_len
 <------------------------------>
 <------- 1st memcpy -----------><--------- 2nd memcpy ---------><- 3rd memcpy ... >
 
 <--------- point_len ------------------------------------------>


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
3) 64-bit compat
~~~~~~~~~~~~~~~~
 point_len = IW_EV_COMPAT_POINT_LEN = 8
 iwe->len  = event_len = point_len + u.data.length = 8 + u.data.length
 lcp_len   = IW_EV_COMPAT_LCP_LEN   = 4
 2nd memcpy: IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN = 12 - 4 = 8

 IW_EV_LCP_PK_LEN
 <-------------->                *
 +-------+-------+-------+-------+---------------+------- ...-+
 | len   | cmd   |length | flags |  (empty) -> extra      ... |
 +-------+-------+-------+-------+---------------+------- ...-+
    2       2       2       2          4
 
     lcp_len
 <-------------->                <-!! OVERLAP !!>
 <--1st memcpy--><------- 2nd memcpy ----------->
                                 <---- 3rd memcpy ------- ... >
 <--------- point_len ---------->

Here it is as you point out: the second and third memcpy()'s overlap by 4 bytes,
which would be a problem if the length == 0 and no extra data were to be copied.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I attach a patch to fix the last case -- could you please have a look.

--UlVJffcvxoiEqYs2
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="wext.diff"

wext: avoid overlapping memcpy in compat-64 mode

The second memcpy in iwe_stream_add_point() copies:
 * 4 bytes in 32-bit mode (sufficient for length/flags);
 * 8 bytes in 64-bit mode (only first 4 bytes used);
 * 8 bytes in 64-bit compat (overlaps with the third mempcy).

To avoid problems with the third memcpy, this patch reduces the copy length
to always 4 bytes = sizeof(iw_point.length) + sizeof(iw_point.flags)/

Signed-off-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
---
 include/net/iw_handler.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -548,9 +548,9 @@ iwe_stream_add_point(struct iw_request_info *info, char *stream, char *ends,
 	if(likely((stream + event_len) < ends)) {
 		iwe->len = event_len;
 		memcpy(stream, (char *) iwe, IW_EV_LCP_PK_LEN);
+		/* copy length and flags of iw_point */
 		memcpy(stream + lcp_len,
-		       ((char *) &iwe->u) + IW_EV_POINT_OFF,
-		       IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
+		       ((char *) &iwe->u) + IW_EV_POINT_OFF, 4);
 		memcpy(stream + point_len, extra, iwe->u.data.length);
 		stream += event_len;
 	}

--UlVJffcvxoiEqYs2--
