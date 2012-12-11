Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58460 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab2LKKwH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 05:52:07 -0500
Message-ID: <1355223079.3738.128.camel@cumari.coelho.fi> (sfid-20121211_115211_429975_B00E71C9)
Subject: Re: wl12xx over spi with no scan results
From: Luciano Coelho <coelho@ti.com>
To: Alberto Garau <Alberto.Garau@inpeco.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>, Arik Nemtsov <arik@wizery.com>
Date: Tue, 11 Dec 2012 12:51:19 +0200
In-Reply-To: <0294E4ABF3EF28409B75AAF7EAC3D41A0C36067E@DB3PRD0510MB381.eurprd05.prod.outlook.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-21-git-send-email-arik@wizery.com>
	 <1355159205.3738.63.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C360305@DB3PRD0510MB381.eurprd05.prod.outlook.com>
	 <1355161791.3738.67.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C360609@DB3PRD0510MB381.eurprd05.prod.outlook.com>
	 <1355218436.3738.122.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C36067E@DB3PRD0510MB381.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-11 at 10:35 +0000, Alberto Garau wrote:
> That's an *ancient* kernel. :( Any chance you can try it with a newer kernel?
> 
> Unortunately not, that's our production kernel. 

Even if you can't use it in real life, it could be worth trying a newer
kernel if you keep getting problems with that old one.  You could also
try compat-wireless to get a newer wireless subsystem, at least.


> > Any other idea about why the scan command it's not properly working ?
> 
> Another common problem is the clock settings.  Are you sure the correct value for board_ref_clock in your board file?
> 
> Are you talking about "wl->ref_clock = pdata->board_ref_clock;" in the probe ? Which value should I put for 38.4MHz due to the fact that it is an integer parameter ?

Yes, that's the value I'm talking about.  You should put it in your
boardfile, something like this (from panda):

static struct wl12xx_platform_data omap_panda_wlan_data  __initdata = {
	.board_ref_clock = WL12XX_REFCLOCK_38, /* 38.4 MHz */
};

You can find these values in the include/linux/wl12xx.h file.

--
Luca.

