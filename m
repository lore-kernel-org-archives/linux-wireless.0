Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:27377 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYKZQ3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 11:29:11 -0500
Received: by rn-out-0910.google.com with SMTP id k40so524545rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 08:29:09 -0800 (PST)
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] ipw2200: increase scan timeout
Date: Wed, 26 Nov 2008 17:28:43 +0100
Cc: reinette chatre <reinette.chatre@intel.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>
References: <200811251809.55461.helmut.schaa@gmail.com> <1227637971.13619.262.camel@rc-desk>
In-Reply-To: <1227637971.13619.262.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811261728.44428.helmut.schaa@gmail.com> (sfid-20081126_172918_015990_3C3E643C)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 25. November 2008 schrieb reinette chatre:
> On Tue, 2008-11-25 at 09:09 -0800, Helmut Schaa wrote:
> > The current scan timeout is set to 5 seconds. If the timeout is hit because
> > the firmware did not respond yet, the adapter gets restarted, which results
> > in a disassociation.
> > 
> > However, in an environment with lots of access points the scan sometimes takes
> > longer than 5 seconds. This patch simply increases the timeout to 10 seconds.
> > 
> > Signed-off-by: helmut.schaa@googlemail.com
> > ---
> > 
> > I was able to reproduce the issue fairly reliable with a 2915 adapter by 
> > periodically triggering scans while associated.
> > 
> > I have no idea in which situations the scan takes longer than 5 seconds to
> > complete but maybe it might even take longer than 10 seconds. Has anybody from
> > Intel insight into the firmware scan code?
> > 
> > diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> > index c73173a..a776da3 100644
> > --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> > +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> > @@ -2304,7 +2304,7 @@ static void ipw_bg_adapter_restart(struct work_struct *work)
> >  	mutex_unlock(&priv->mutex);
> >  }
> >  
> > -#define IPW_SCAN_CHECK_WATCHDOG (5 * HZ)
> > +#define IPW_SCAN_CHECK_WATCHDOG (10 * HZ)
> >  
> >  static void ipw_scan_check(void *data)
> >  {
> 
> I do not have insight into the scan code ... but I can try to find out
> if there is something specific you need to know.
> 
> This change seems harmless and if it helps you it may help somebody else
> too.
> 
> Acked-by: Reinette Chatre <reinette.chatre@intel.com>

John, please do _not_ merge this patch. It only hides the real problem.
I'll send another patch (including explanations) in a few minutes.

Helmut
