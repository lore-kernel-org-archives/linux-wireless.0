Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:58159 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab0KDPuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 11:50:40 -0400
Date: Thu, 4 Nov 2010 13:50:37 -0200
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	seno <senada@t-online.de>
Subject: Re: [PATCH 9/9] rtl8187: restore anaparam registers after reset
 with 8187B
Message-ID: <20101104135037.4a465ea8@gotham.conectiva>
In-Reply-To: <20101104153057.GA4610@barata.holoscopio.com>
References: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
	<1288659579-4986-10-git-send-email-herton@mandriva.com.br>
	<20101104153057.GA4610@barata.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 4 Nov 2010 13:30:57 -0200
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:

> On Mon, Nov 01, 2010 at 10:59:39PM -0200, Herton Ronaldo Krzesinski wrote:
> > Current 8187B initialization misses anaparam registers restore after
> > 8187 reset. This causes ANAPARAM register to stay zeroed out (ANAPARAM2
> > kept its value on my tests). To avoid this, call rtl8187_set_anaparam
> > right after chip reset (to be on the safe side, as it makes sure we
> > restore all ANAPARAM registers).
> > 
> 
> Hello, Herton.
> 
> Thank you very much for these patches. I am in the process of testing
> them right now. The first thing I've noticed is a drop in the signal
> level by 10dBm when using this last patch. Is this something we should
> be concerned with?

I think not, may be the signal is a bit weaker with the anaparam now being
what Realtek uses/recomends (unfortunately it's a magic number and not
disclosed what each bit/parameter is doing..., probably the buggy previous
behaviour of the setting being zero after reset was making the signal too
high when not needed), but as with it we can get higher rate and bandwidth
on same distance, it shouldn't be a concern (my iperf test results showed
improvements too with the last two changes).

> 
> I will do some tests with the distance to the Access Point and send my
> results later.
> 
> Regards,
> Cascardo.
> 
> > Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: seno <senada@t-online.de>
> > ---
> >  drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > index 4448647..eeee244 100644
> > --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > @@ -771,6 +771,8 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
> >  	if (res)
> >  		return res;
> >  
> > +	rtl8187_set_anaparam(priv, true);
> > +
> >  	/* BRSR (Basic Rate Set Register) on 8187B looks to be the same as
> >  	 * RESP_RATE on 8187L in Realtek sources: each bit should be each
> >  	 * one of the 12 rates, all are enabled */
> > -- 
> > 1.7.3.2
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
[]'s
Herton
