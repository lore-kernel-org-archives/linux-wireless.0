Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2DWIuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 04:50:17 -0400
Message-ID: <1335171007.3928.9.camel@jlt3.sipsolutions.net> (sfid-20120423_105021_568389_C95A5831)
Subject: Re: [PATCH 3.4 1/2] brcm80211: fmac: fix SDIO function 0 register
 r/w issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Fainelli <florian@openwrt.org>
Cc: Franky Lin <frankyl@broadcom.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Date: Mon, 23 Apr 2012 10:50:07 +0200
In-Reply-To: <4F9516B5.3000509@openwrt.org> (sfid-20120423_104718_390173_B2BFC4D3)
References: <1334957269-27416-1-git-send-email-frankyl@broadcom.com>
	 <1334957269-27416-2-git-send-email-frankyl@broadcom.com>
	 <4F9516B5.3000509@openwrt.org> (sfid-20120423_104718_390173_B2BFC4D3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-23 at 10:45 +0200, Florian Fainelli wrote:

> >   	} else if (regaddr == SDIO_CCCR_ABORT) {
> > +		sdfunc = kzalloc(sizeof(struct sdio_func), GFP_KERNEL);
> 
> You are not catching a kzalloc() possible failure here.
> 
> > +		memcpy(sdfunc, sdiodev->func[0], sizeof(struct sdio_func));

and it should probably be kmemdup anyway?

johannes

