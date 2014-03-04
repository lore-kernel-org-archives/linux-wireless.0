Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44728 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbaCDSpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 13:45:16 -0500
Date: Tue, 4 Mar 2014 13:33:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	"pali.rohar@gmail.com" <pali.rohar@gmail.com>,
	"pavel@ucw.cz" <pavel@ucw.cz>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wl1251: use skb_trim to make skb shorter
Message-ID: <20140304183348.GB7317@tuxdriver.com> (sfid-20140304_194524_466325_472DA1BB)
References: <20140225105756.GB22279@mudshark.cambridge.arm.com>
 <1393678326-23535-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20140304142658.GK8766@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140304142658.GK8766@mudshark.cambridge.arm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, I'll queue it as a fix...

On Tue, Mar 04, 2014 at 02:26:58PM +0000, Will Deacon wrote:
> Hi Jonn,
> 
> On Sat, Mar 01, 2014 at 12:52:06PM +0000, Ivaylo Dimitrov wrote:
> > the current code is directly setting skb->len, which is not correct and
> > brings problems with HAVE_EFFICIENT_UNALIGNED_ACCESS enabled in config
> > 
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > ---
> 
> Can you pick this patch up please? It addresses a regression introduced in
> the merge window (ARM started selecting HAVE_EFFICIENT_UNALIGNED_ACCESS).
> 
> Cheers,
> 
> Will
> 
> >  drivers/net/wireless/ti/wl1251/rx.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/ti/wl1251/rx.c b/drivers/net/wireless/ti/wl1251/rx.c
> > index 123c4bb..cde0eaf 100644
> > --- a/drivers/net/wireless/ti/wl1251/rx.c
> > +++ b/drivers/net/wireless/ti/wl1251/rx.c
> > @@ -180,7 +180,7 @@ static void wl1251_rx_body(struct wl1251 *wl,
> >  	wl1251_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
> >  
> >  	/* The actual length doesn't include the target's alignment */
> > -	skb->len = desc->length  - PLCP_HEADER_LENGTH;
> > +	skb_trim(skb, desc->length - PLCP_HEADER_LENGTH);
> >  
> >  	fc = (u16 *)skb->data;
> >  
> > -- 
> > 1.7.9.5
> > 
> > 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
