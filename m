Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:3725 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbYJ3Uoo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:44:44 -0400
Subject: Re: Guidelines regarding separate directory
From: Pavel Roskin <proski@gnu.org>
To: Dave <kilroyd@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <490A17F3.5050802@gmail.com>
References: <4909EA78.3060700@lwfinger.net>
	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>
	 <490A17F3.5050802@gmail.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:44:41 -0400
Message-Id: <1225399481.7931.5.camel@dv> (sfid-20081030_214448_835859_AFA0998F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-10-30 at 20:24 +0000, Dave wrote:
> Johannes Berg wrote:

> On a similar note, would anyone object to collecting the orinoco files
> in a subdirectory?

Fine with me.

> I'm looking at doing some refactoring of orinoco.c
> which I think can be split into at least 3 files.

Maybe it's too late at this point, but it would be nice to support
Orinoco USB eventually.  It uses modified orinoco.c.  Please keep it in
mind when splitting.  It may be possible to reuse some of the new parts
in the USB driver.

> PS the existing files that would move:
> airport.c
> hermes.c
> hermes.h
> hermes_dld.c
> hermes_dld.h
> hermes_rid.h
> orinoco.c
> orinoco.h
> orinoco_cs.c
> orinoco_pci.c

orinoco_pci.c is a good candidate for removal.  It only supports the
hardware that is already supported by hostap_pci.

-- 
Regards,
Pavel Roskin
