Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40349 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab0JKJzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 05:55:51 -0400
Subject: Re: [Patch 1/1] wext: fix 32/64 bit alignment issue for 'point'
 type
From: Johannes Berg <johannes@sipsolutions.net>
To: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101011051410.GA3977@gerrit.erg.abdn.ac.uk>
References: <20100930102508.GB3581@gerrit.erg.abdn.ac.uk>
	 <1285857487.5137.2.camel@jlt3.sipsolutions.net>
	 <42875.148.187.160.35.1285917725.squirrel@148.187.160.35>
	 <1285921839.3739.16.camel@jlt3.sipsolutions.net>
	 <20101011051410.GA3977@gerrit.erg.abdn.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 11:55:47 +0200
Message-ID: <1286790947.3634.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 07:14 +0200, Gerrit Renker wrote:

> In the drawings below I have traced with an asterisk where in userspace the data is
> read out - as far as I can see this is correct. The only worrying case is number (3).

> 3) 64-bit compat
> ~~~~~~~~~~~~~~~~
>  point_len = IW_EV_COMPAT_POINT_LEN = 8
>  iwe->len  = event_len = point_len + u.data.length = 8 + u.data.length
>  lcp_len   = IW_EV_COMPAT_LCP_LEN   = 4
>  2nd memcpy: IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN = 12 - 4 = 8
> 
>  IW_EV_LCP_PK_LEN
>  <-------------->                *
>  +-------+-------+-------+-------+---------------+------- ...-+
>  | len   | cmd   |length | flags |  (empty) -> extra      ... |
>  +-------+-------+-------+-------+---------------+------- ...-+
>     2       2       2       2          4
>  
>      lcp_len
>  <-------------->                <-!! OVERLAP !!>
>  <--1st memcpy--><------- 2nd memcpy ----------->
>                                  <---- 3rd memcpy ------- ... >
>  <--------- point_len ---------->
> 
> Here it is as you point out: the second and third memcpy()'s overlap by 4 bytes,
> which would be a problem if the length == 0 and no extra data were to be copied.

This, and the other two cases as well, looks correct.


> --- a/include/net/iw_handler.h
> +++ b/include/net/iw_handler.h
> @@ -548,9 +548,9 @@ iwe_stream_add_point(struct iw_request_info *info, char *stream, char *ends,
>         if(likely((stream + event_len) < ends)) {
>                 iwe->len = event_len;
>                 memcpy(stream, (char *) iwe, IW_EV_LCP_PK_LEN);
> +               /* copy length and flags of iw_point */
>                 memcpy(stream + lcp_len,
> -                      ((char *) &iwe->u) + IW_EV_POINT_OFF,
> -                      IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
> +                      ((char *) &iwe->u) + IW_EV_POINT_OFF, 4);
>                 memcpy(stream + point_len, extra, iwe->u.data.length);
>                 stream += event_len;
>         }

However, I don't understand this patch. Your original patch would have
fixed this just as well, since after it

IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN

would be

(IW_EV_LCP_PK_LEN + 4) - IW_EV_LCP_PK_LEN == 4

and at the same time fixes the userspace problem, if anyone really wants
to use wext in new applications that don't use iwlib still...

johannes

