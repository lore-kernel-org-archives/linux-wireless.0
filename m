Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2811 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965780AbXCPRn7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2007 13:43:59 -0400
Date: Fri, 16 Mar 2007 13:14:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx: Add firmware version to ethtool output
Message-ID: <20070316171427.GC3426@tuxdriver.com>
References: <45eb1612.l8xsd6TwZVsRseAH%Larry.Finger@lwfinger.net> <200703042002.39581.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200703042002.39581.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 04, 2007 at 08:02:39PM +0100, Michael Buesch wrote:
> On Sunday 04 March 2007 19:55, Larry Finger wrote:

> > @@ -42,6 +43,8 @@ static void bcm43xx_get_drvinfo(struct n
> >  	strncpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> >  	strncpy(info->version, utsname()->release, sizeof(info->version));
> >  	strncpy(info->bus_info, pci_name(bcm->pci_dev), ETHTOOL_BUSINFO_LEN);
> > +	snprintf(info->fw_version, sizeof(info->fw_version), "0x%x",
> > +		 bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED, BCM43xx_UCODE_REVISION));
> 
> This will crash when the device is not up.

Larry, will you be doing a new version of this patch that accounts
for this comment?

John
-- 
John W. Linville
linville@tuxdriver.com
