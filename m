Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47899 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaJ0JxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 05:53:15 -0400
Date: Mon, 27 Oct 2014 12:52:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] ipw2x00: shift wrap bugs setting ->rt_tsf
Message-ID: <20141027095243.GA6890@mwanda> (sfid-20141027_105319_958377_67047D52)
References: <20141024081534.GA11140@mwanda>
 <1414143811.15751.14.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414143811.15751.14.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2014 at 02:43:31AM -0700, Joe Perches wrote:
> On Fri, 2014-10-24 at 11:15 +0300, Dan Carpenter wrote:
> > @@ -8028,10 +8028,10 @@ static void ipw_handle_promiscuous_rx(struct ipw_priv *priv,
> >  
> >  	/* Zero the flags, we'll add to them as we go */
> >  	ipw_rt->rt_flags = 0;
> > -	ipw_rt->rt_tsf = (u64)(frame->parent_tsf[3] << 24 |
> > -			       frame->parent_tsf[2] << 16 |
> > -			       frame->parent_tsf[1] << 8  |
> > -			       frame->parent_tsf[0]);
> > +	ipw_rt->rt_tsf = (u64)frame->parent_tsf[3] << 24 |
> > +			      frame->parent_tsf[2] << 16 |
> > +			      frame->parent_tsf[1] << 8  |
> > +			      frame->parent_tsf[0];
> >  
> >  	/* Convert to DBM */
> >  	ipw_rt->rt_dbmsignal = signal;
> 
> struct ipw_rt_hdr {
> 	struct ieee80211_radiotap_header rt_hdr;
> 	u64 rt_tsf;      /* TSF */	/* XXX */
> 	u8 rt_flags;	/* radiotap packet flags *
> 	u8 rt_rate;	/* rate in 500kb/s */
> 	__le16 rt_channel;	/* channel in mhz */
> 	__le16 rt_chbitmask;	/* channel bitfield */
> 	s8 rt_dbmsignal;	/* signal in dbM, kluged to signed */
> 	s8 rt_dbmnoise;
> 	u8 rt_antenna;	/* antenna number */
> 	u8 payload[0];  /* payload... */
> } __packed;
> 
> Maybe rt_tsf (which is otherwise unused in this code),
> should be __le64 so maybe use (u32) ?
> 
> 	ipw_rt->rt_txf = cpu_to_le64((u32)(frame->parent_tsf[3] << 24 |
> 					   frame->parent_tsf[2] << 16 |
> 					   frame->parent_tsf[1] << 8  |
> 					   frame->parent_tsf[0]));
> 

Hm...  It don't think it makes sense to truncate the top bits away by
truncating to u32.  You may be right though that there is some larger
bugs here than just the truncation.

Both the "frame" and the "ipw_rt" struct seem to hold little endian
values generally so probably ->rt_txf should be an __le64 like you say.

Perhaps the maintainers know what should be done?

regards,
dan carpenter

