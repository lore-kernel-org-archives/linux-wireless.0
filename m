Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW4.Sony.CO.JP ([137.153.0.46]:63235 "EHLO mgw4.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbXL0JWl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2007 04:22:41 -0500
Date: Thu, 27 Dec 2007 18:24:40 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: David Miller <davem@davemloft.net>
Subject: Re: : Emit event stream compat iw_point objects correctly.
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20071227.005725.144782426.davem@davemloft.net>
References: <20071227173802.6F56.40F06B3A@sm.sony.co.jp> <20071227.005725.144782426.davem@davemloft.net>
Message-Id: <20071227181439.6F59.40F06B3A@sm.sony.co.jp> (sfid-20071227_092248_539531_5FAF1DCF)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 27 Dec 2007 00:57:25 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
> Date: Thu, 27 Dec 2007 17:51:49 +0900
> 
> > 	Hi
> > 
> > On Fri, 21 Dec 2007 20:58:08 -0800 (PST)
> > David Miller <davem@davemloft.net> wrote:
> > 
> > > @@ -520,7 +530,7 @@ iwe_stream_add_point(char *	stream,		/* Stream of events */
> > >  		memcpy(stream + IW_EV_LCP_LEN,
> > >  		       ((char *) iwe) + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
> > >  		       IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
> > 
> > As the alignment of 64bit platforms may be defferent from 32bit one,
> > should it be like the following?
> 
> IW_EV_LCP_LEN is the same on both 32-bit and 64-bit platforms, it is
> just the size of the "len" and "cmd" portions of struct iw_event.
> 

IW_EV_LCP_PK_LEN ?

#define IW_EV_LCP_PK_LEN        (4)

> Those are both __u16, so IW_EV_LCP_LEN always evaluates to "4",
> try it if you do not believe me. :-)

Although I believed you, I tried :)

On ppc64 (PS3), IW_EV_LCP_LEN is 8, not 4.

include/linux/wireless.h:

#define IW_EV_LCP_LEN   (sizeof(struct iw_event) - sizeof(union iwreq_data))

where sizeof(struct iw_event) == 24, sizeof(union iwreq_data) == 16 on
PS3.

-- 
Masakazu MOKUNO

