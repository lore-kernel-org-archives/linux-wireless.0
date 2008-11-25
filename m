Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34850 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYKYWLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 17:11:20 -0500
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
CC: "ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Tue, 25 Nov 2008 14:06:31 -0800
Subject: RE: [Ipw2100-devel] [PATCH] ipw2200: increase scan timeout
Message-ID: <02B3067C068D0549A8CCFCB17D4D318B1CAAB2EF@orsmsx502.amr.corp.intel.com> (sfid-20081125_231125_262971_9D84C2D7)
References: <200811251809.55461.helmut.schaa@gmail.com>
 <1227637971.13619.262.camel@rc-desk>
In-Reply-To: <1227637971.13619.262.camel@rc-desk>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 

> -----Original Message-----
> From: reinette chatre [mailto:reinette.chatre@intel.com] 
> Sent: Tuesday, November 25, 2008 1:33 PM
> To: Helmut Schaa
> Cc: ipw2100-devel@lists.sourceforge.net; Zhu, Yi; 
> linux-wireless@vger.kernel.org; linville@tuxdriver.com
> Subject: Re: [Ipw2100-devel] [PATCH] ipw2200: increase scan timeout
> 
> On Tue, 2008-11-25 at 09:09 -0800, Helmut Schaa wrote:
> > The current scan timeout is set to 5 seconds. If the timeout is hit 
> > because the firmware did not respond yet, the adapter gets 
> restarted, 
> > which results in a disassociation.
> >
> > However, in an environment with lots of access points the scan 
> > sometimes takes longer than 5 seconds. This patch simply 
> increases the timeout to 10 seconds.
> >
> > Signed-off-by: helmut.schaa@googlemail.com
> > ---
> >
> > I was able to reproduce the issue fairly reliable with a 
> 2915 adapter 
> > by periodically triggering scans while associated.
> >
> > I have no idea in which situations the scan takes longer than 5 
> > seconds to complete but maybe it might even take longer than 10 
> > seconds. Has anybody from Intel insight into the firmware scan code?
> >
> > diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c 
> > b/drivers/net/wireless/ipw2x00/ipw2200.c
> > index c73173a..a776da3 100644
> > --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> > +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> > @@ -2304,7 +2304,7 @@ static void 
> ipw_bg_adapter_restart(struct work_struct *work)
> >       mutex_unlock(&priv->mutex);
> >  }
> >
> > -#define IPW_SCAN_CHECK_WATCHDOG (5 * HZ)
> > +#define IPW_SCAN_CHECK_WATCHDOG (10 * HZ)
> >
> >  static void ipw_scan_check(void *data)  {
> 
> I do not have insight into the scan code ... but I can try to 
> find out if there is something specific you need to know.
> 
> This change seems harmless and if it helps you it may help 
> somebody else too.

It seems harmless to me also, and if anyone is getting burned by it timing out before a scan is complete, then it seems like a good idea.  It's just a "safety net", and should not affect the *actual* time spent scanning.

-- Ben --


> 
> Acked-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> Thank you
> 
> Reinette
> 
> 
> --------------------------------------------------------------
> -----------
> This SF.Net email is sponsored by the Moblin Your Move 
> Developer's challenge Build the coolest Linux based 
> applications with Moblin SDK & win great prizes Grand prize 
> is a trip for two to an Open Source event anywhere in the 
> world http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> ipw2100-devel mailing list
> ipw2100-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw2100-devel
> 