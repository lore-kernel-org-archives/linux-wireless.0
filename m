Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbXLGKa0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 05:30:26 -0500
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: Dan Williams <dcbw@redhat.com>
To: jt@hpl.hp.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071206191150.GC5237@bougret.hpl.hp.com>
References: <1196940519.3980.51.camel@localhost.localdomain>
	 <20071206191150.GC5237@bougret.hpl.hp.com>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 05:20:18 -0500
Message-Id: <1197022818.2603.20.camel@localhost.localdomain> (sfid-20071207_103030_815629_6C074530)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-12-06 at 11:11 -0800, Jean Tourrilhes wrote:
> On Thu, Dec 06, 2007 at 06:28:39AM -0500, Dan Williams wrote:
> > See the previous thread about fixing the ap_scan mess.  I think Jean's
> > correct in asserting that we need more bits for scan capability.
> > 
> > This patch introduces scan capability bits for WEXT; hopefully cfg80211
> > can also pick up equivalent functionality.  Capability bits are provided
> > for all the current options that may be passed to drivers in the
> > iw_scan_req structure.  It can be assumed that if the driver reports the
> > scan capability, that the driver respects the options specified in the
> > iw_scan_req structure when performing the scan.
> > 
> > Clients can use logic like (cribbed from wpa_supplicant's driver_wext.c)
> > this to figure out whether or not the capability bits are supported:
> > 
> > struct iwreq iwr;
> > struct iw_range *range;
> > 
> > <set up iwr/range for request>
> > 
> > if (ioctl(drv->ioctl_sock, SIOCGIWRANGE, &iwr) == 0) {
> > 	u8 minlen = ((char *) &range->scan_capa) - (char *) range + sizeof(range->scan_capa);
> > 
> > 	if (iwr.u.data.length >= minlen) {
> > 		/* SCAN_CAPA is supported */
> > 	}
> > }
> > 
> > Jean; what do you think?
> 
> 	Actually, I like your new proposal. I told you there was a
> gotcha, you need to add some padding to not screw up userspace. Note
> that we have already some padding in that structure (look at 'old_*'),
> so it's not the first time we do that.
> 	Basically, it should look like the patch below...
> 
> 	Regards,
> 
> 	Jean
> 
> Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
> 
> --- linux/include/linux/wireless.d1.h   2007-12-06 11:04:16.000000000 -0800
> +++ linux/include/linux/wireless.h      2007-12-06 11:06:26.000000000 -0800
> @@ -1040,6 +1040,16 @@ struct   iw_range
>          * because each entry contain its channel index */
>  
>         __u32           enc_capa;       /* IW_ENC_CAPA_* bit field */
> +
> +       /* Do *NOT* use those fields, they are just used as padding to get
> +        * proper alignement with user space */
> +       __s32           min_pms;
> +       __s32           max_pms;
> +       __u16           pms_flags;
> +       __s32           modul_capa;
> +       __u32           bitrate_capa;
> +
> +       __u32           scan_capa;      /* IW_SCAN_CAPA_* bit field */
>  };

Can you explain a bit more about this patch?  Also, if nobody is
supposed to use these fields, shouldn't their names be 'reserved' or
something like that?

Thanks,
Dan


