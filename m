Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50092 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYIMER6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 00:17:58 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Pavel Roskin <proski@gnu.org>
To: jt@hpl.hp.com
Cc: Dan Williams <dcbw@redhat.com>, kilroyd@googlemail.com,
	linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
In-Reply-To: <20080908183203.GA7090@bougret.hpl.hp.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
	 <20080805162238.GA6294@bougret.hpl.hp.com>
	 <20080902230621.GA28885@bougret.hpl.hp.com> <1220878110.2369.3.camel@dv>
	 <20080908183203.GA7090@bougret.hpl.hp.com>
Content-Type: text/plain
Date: Sat, 13 Sep 2008 00:17:55 -0400
Message-Id: <1221279475.14059.29.camel@dv> (sfid-20080913_061818_614674_041DC2AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-08 at 11:32 -0700, Jean Tourrilhes wrote:

> 	Try the attached patch.

It's working on x86_64!  Thank you!

> diff -u -p linux/drivers/net/wireless/orinoco.p1.c linux/drivers/net/wireless/orinoco.c
> --- linux/drivers/net/wireless/orinoco.p1.c	2008-09-08 11:28:01.000000000 -0700
> +++ linux/drivers/net/wireless/orinoco.c	2008-09-08 11:29:59.000000000 -0700
> @@ -3953,7 +3953,7 @@ static int orinoco_ioctl_getrid(struct n
>  /* Trigger a scan (look for other cells in the vicinity */
>  static int orinoco_ioctl_setscan(struct net_device *dev,
>  				 struct iw_request_info *info,
> -				 struct iw_param *srq,
> +				 struct iw_point *srq,
>  				 char *extra)

The same problem exists in airo and atmel, but they don't use that
argument.  Several drivers, including mac80211 use union iwreq_data,
which is fragile.  Fortunately, most drivers don't use that argument or
use the "data" field, which is correct.

The only incorrect use of union iwreq_data is in rndis_wlan.  It would
ignore ESSID on x86_64.

I think the use of union iwreq_data is dangerous and should be avoided.

-- 
Regards,
Pavel Roskin
