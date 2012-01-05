Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.solarflare.com ([216.237.3.220]:10033 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755393Ab2AERDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 12:03:32 -0500
Message-ID: <1325783007.3764.19.camel@bwh-desktop> (sfid-20120105_180337_638947_B874EC2C)
Subject: Re: [PATCH v2] drivers: net: Fix dependency for EEPROM_93CX6
From: Ben Hutchings <bhutchings@solarflare.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Fabio Estevam <festevam@gmail.com>, <netdev@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <gwingerde@gmail.com>,
	<linville@tuxdriver.com>, <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>
Date: Thu, 5 Jan 2012 17:03:27 +0000
In-Reply-To: <4F05CBA9.1070602@lwfinger.net>
References: <1325770673-17309-1-git-send-email-festevam@gmail.com>
	 <4F05CBA9.1070602@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-05 at 10:11 -0600, Larry Finger wrote:
> On 01/05/2012 07:37 AM, Fabio Estevam wrote:
> > Fix the following build warning:
> >
> > warning: (KS8851&&  AX88796_93CX6&&  RTL8180&&  RTL8187&&  ADM8211&&  RT2400PCI&&  RT2500PCI&&  RT61PCI&&  RT2800PCI&&  R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES)
> >
> > Signed-off-by: Fabio Estevam<fabio.estevam@freescale.com>
> > ---
> > Changes since v1:
> > - Place MISC_DEVICES dependency into the 'depends on' line
> 
> Is this the right way to fix this? Whenever I get this kind of build warning, I 
> usually attribute it to a problem with my local configuration and fix my copy of 
> .config, not modify the build system. With this change, it seems to me that a 
> lot of devices will suddenly disappear from the build with little explanation.

I entirely agree.

> I don't feel confident enough to NACK the patch, but I would like an expert to 
> comment.

I'm not an expert but am prepared to be opinionated!

> I have noticed that the defconfigs for various architectures are split between 
> turning MISC_DEVICES on or off.

That seems like a bug, since MISC_DEVICES doesn't by itself select any
code.  (It's also not a meaningful category and maybe ought not to be an
option at all.)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

