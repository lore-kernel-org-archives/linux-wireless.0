Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:36476 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbYABUN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 15:13:57 -0500
Subject: Re: [PATCH 6/8] [PATCH] Split up rndis_host.c
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: David Brownell <david-b@pacbell.net>
Cc: bjd@jooz.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071223011707.1798C2360C6@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <11983602942818-git-send-email-bjd@jooz.net>
	 <11983602953056-git-send-email-bjd@jooz.net>
	 <20071223011707.1798C2360C6@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 22:13:47 +0200
Message-Id: <1199304827.8532.31.camel@localhost> (sfid-20080102_201402_157561_BA0001EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Bjorge was not comfortable with double probing rndis_wext requires,
wireless RNDIS devices have same device id as the rest of RNDIS. Our
module version checks OID_GEN_PHYSICAL_MEDIUM in generic_rndis_bind,
with rndis_host bind fails if OID is supported and wireless media type
is returned, with rndis_wext if OID isn't supported or type isn't
wireless. Should this be ok?

Should separate rndis_wext be located in drivers/net/wireless instead of
drivers/net/usb?

 - Jussi Kivilinna

On Sat, 2007-12-22 at 17:17 -0800, David Brownell wrote:
> > From: Bjorge Dijkstra <bjd@jooz.net>
> > Subject: [PATCH 6/8] [PATCH] Split up rndis_host.c
> > Date: Sat, 22 Dec 2007 22:51:32 +0100
> >
> > Split up rndis_host.c into rndis_host.h and rndis_base.c and
> > change Makefile accordingly. This is done so we can add extra
> > source files to the rndis_host module later on.
> 
> I'm fine with splitting out a header file and the EXPORT_SYMBOL_GPL.
> But why not just have a separate "rndis_wext" module?
> 
> 
> > ---
> >  drivers/net/usb/Makefile     |    1 +
> >  drivers/net/usb/rndis_base.c |  548 ++++++++++++++++++++++++++++++
> >  drivers/net/usb/rndis_host.c |  763 ------------------------------------------
> >  drivers/net/usb/rndis_host.h |  256 ++++++++++++++
> >  4 files changed, 805 insertions(+), 763 deletions(-)
> >  create mode 100644 drivers/net/usb/rndis_base.c
> >  delete mode 100644 drivers/net/usb/rndis_host.c
> >  create mode 100644 drivers/net/usb/rndis_host.h
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

