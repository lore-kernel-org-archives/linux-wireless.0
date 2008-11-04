Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:65508 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYKDAfK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 19:35:10 -0500
Subject: Re: [PATCH] p54: don't report known but unhandled EEPROM codes as
	unknown
From: Pavel Roskin <proski@gnu.org>
To: Chr <chunkeey@web.de>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200810301810.45647.chunkeey@web.de>
References: <20081029213143.4497.77258.stgit@dv.roinet.com>
	 <200810301810.45647.chunkeey@web.de>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 19:35:07 -0500
Message-Id: <1225758907.13275.14.camel@dv> (sfid-20081104_013523_363879_6ED43BDA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-10-30 at 18:10 +0100, Chr wrote:
> On Wednesday 29 October 2008 22:31:43 Pavel Roskin wrote:
> > [...]
> > +		case PDR_RADIATED_TRANSMISSION_CORRECTION:
> > +		case PDR_PRISM_TX_IQ_CALIBRATION:
> > +		case PDR_BASEBAND_REGISTERS:
> > +		case PDR_PER_CHANNEL_BASEBAND_REGISTERS:
> > +			break;
> >  		default:
> >  			printk(KERN_INFO "p54: unknown eeprom code : 0x%x\n",
> >  				le16_to_cpu(entry->code));
> 
> what about removing the printk?
> since intersil reserved 0x8000-0xffff for it's customers...
> so there could be lots of unknown pdr magics.

I don't see any extra messages.  From my experience, OEMs don't change
anything except the required settings (IDs, OEM name, country code) and
don't add anything non-trivial.

But I'm fine either way, with or without that printk.

-- 
Regards,
Pavel Roskin
