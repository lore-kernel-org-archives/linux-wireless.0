Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59052
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752125AbYFCRhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 13:37:20 -0400
Date: Tue, 03 Jun 2008 10:37:16 -0700 (PDT)
Message-Id: <20080603.103716.193719039.davem@davemloft.net> (sfid-20080603_193737_523598_04EB099E)
To: mokuno@sm.sony.co.jp
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: : Emit event stream compat iw_point objects correctly.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080603.095750.120470495.davem@davemloft.net>
References: <20080110.011602.74511551.davem@davemloft.net>
	<20080111112248.610C.40F06B3A@sm.sony.co.jp>
	<20080603.095750.120470495.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Miller <davem@davemloft.net>
Date: Tue, 03 Jun 2008 09:57:50 -0700 (PDT)

> From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
> Date: Fri, 11 Jan 2008 13:16:29 +0900
> 
> > The source address does not have to be adjusted.  I think it should be
> > 		       ((char *) iwe) + IW_EV_LCP_LEN,
> > or just
> > 		       &iwe->u
> > I think it is more readable what we want to do here.
> > 
> > 
> > > +		       event_len - lcp_len);
> > 
> > The length of the real payload does not need to take account of the
> > destination offset change.  So we can keep the original code like:
> > 
> > 		       org_event_len - IW_EV_LCP_LEN);
> 
> As long as IW_EV_LCP_LEN and IW_EV_COMPAT_LCP_LEN are different, I am
> pretty sure we need to make these adjustments.
> 
> There are so many differences in how struct vs. sub-struct alignment will
> occur in these cases, that we need to be very careful.
> 
> I'll try to look more closely at this and do some testing of my own on
> a compat platform.

I know understand what you were trying to say, indeed the source
address does not and should not need to be adjusted, it is in
non-compat format afterall.
