Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:58431 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0ENInh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 04:43:37 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Sascha Silbe' <sascha-ml-reply-to-2010-2@silbe.org>,
	Kiran Divekar <dkiran@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
Date: Fri, 14 May 2010 01:43:35 -0700
Subject: RE: [PATCH v2] Libertas: Added callback functions to support SDIO
	suspend/resume.
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF595056D1B6FCB@SC-VEXCH1.marvell.com>
In-Reply-To: <20100513092013.GA22652@twin.sascha.silbe.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Sascha,

> -----Original Message-----
> From: libertas-dev-bounces@lists.infradead.org [mailto:libertas-dev- 
> bounces@lists.infradead.org] On Behalf Of Sascha Silbe
> 
> On Wed, May 12, 2010 at 10:07:55PM -0700, Kiran Divekar wrote:
> [if_usb_suspend()]
> > +	if (priv->wol_criteria == 0xffffffff) {
> Again, s/0xffffffff/EHS_REMOVE_WAKEUP/.
> 
> > +		lbs_pr_info("Suspend attempt without "
> > +						"configuring wake params!\n");
> > +		return -ENOSYS;
> > +	}
> AFAICT this would cause a USB-connected libertas chip with WOL 
> disabled ("ethtool eth0 d") to prevent suspend, instead of just 
> powering down like an SDIO-connected chip. So instead of failing 
> during
> lbs_host_sleep_cfg() because the 8388 doesn't support 
> EHS_REMOVE_WAKEUP, you just bail out earlier, still breaking suspend.
> 

Earlier also this check was there in lbs_suspend() (in main.c). I just moved it to if_usb_suspend (in if_usb.c). In both the cases It's going to bail out earlier. So I don't see any side affects on USB suspend due to this patch.

Your other comments looks fine to me. I will modify the patch accordingly.

> 
> > diff --git a/drivers/net/wireless/libertas/main.c
> > b/drivers/net/wireless/libertas/main.c

Thanks,
Amit
