Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:61420 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbXLFTMf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 14:12:35 -0500
Date: Thu, 6 Dec 2007 11:11:50 -0800
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
Message-ID: <20071206191150.GC5237@bougret.hpl.hp.com> (sfid-20071206_191238_825340_E46E0180)
Reply-To: jt@hpl.hp.com
References: <1196940519.3980.51.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196940519.3980.51.camel@localhost.localdomain>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 06, 2007 at 06:28:39AM -0500, Dan Williams wrote:
> See the previous thread about fixing the ap_scan mess.  I think Jean's
> correct in asserting that we need more bits for scan capability.
> 
> This patch introduces scan capability bits for WEXT; hopefully cfg80211
> can also pick up equivalent functionality.  Capability bits are provided
> for all the current options that may be passed to drivers in the
> iw_scan_req structure.  It can be assumed that if the driver reports the
> scan capability, that the driver respects the options specified in the
> iw_scan_req structure when performing the scan.
> 
> Clients can use logic like (cribbed from wpa_supplicant's driver_wext.c)
> this to figure out whether or not the capability bits are supported:
> 
> struct iwreq iwr;
> struct iw_range *range;
> 
> <set up iwr/range for request>
> 
> if (ioctl(drv->ioctl_sock, SIOCGIWRANGE, &iwr) == 0) {
> 	u8 minlen = ((char *) &range->scan_capa) - (char *) range + sizeof(range->scan_capa);
> 
> 	if (iwr.u.data.length >= minlen) {
> 		/* SCAN_CAPA is supported */
> 	}
> }
> 
> Jean; what do you think?

	Actually, I like your new proposal. I told you there was a
gotcha, you need to add some padding to not screw up userspace. Note
that we have already some padding in that structure (look at 'old_*'),
so it's not the first time we do that.
	Basically, it should look like the patch below...

	Regards,

	Jean

Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>

--- linux/include/linux/wireless.d1.h   2007-12-06 11:04:16.000000000 -0800
+++ linux/include/linux/wireless.h      2007-12-06 11:06:26.000000000 -0800
@@ -1040,6 +1040,16 @@ struct   iw_range
         * because each entry contain its channel index */
 
        __u32           enc_capa;       /* IW_ENC_CAPA_* bit field */
+
+       /* Do *NOT* use those fields, they are just used as padding to get
+        * proper alignement with user space */
+       __s32           min_pms;
+       __s32           max_pms;
+       __u16           pms_flags;
+       __s32           modul_capa;
+       __u32           bitrate_capa;
+
+       __u32           scan_capa;      /* IW_SCAN_CAPA_* bit field */
 };
 
 /*
