Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbYEUUF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 16:05:26 -0400
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile
	configuration.
From: Dan Williams <dcbw@redhat.com>
To: Javier Cardona <javier@cozybit.com>
Cc: David Woodhouse <dwmw2@infradead.org>, carrano@laptop.org,
	dilinger@queued.net, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <445f43ac0805211251v12f49c26j540bf3763bc4dd27@mail.gmail.com>
References: <4832422a.20018e0a.6b37.3217@mx.google.com>
	 <1211292718.21380.238.camel@pmac.infradead.org>
	 <445f43ac0805211159u317bf720vd88d29a504445ba6@mail.gmail.com>
	 <1211396780.21380.368.camel@pmac.infradead.org>
	 <445f43ac0805211218v58d33458v41d0d11f98ed4f14@mail.gmail.com>
	 <1211398105.21380.371.camel@pmac.infradead.org>
	 <445f43ac0805211251v12f49c26j540bf3763bc4dd27@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 May 2008 16:05:11 -0400
Message-Id: <1211400311.4232.33.camel@localhost.localdomain> (sfid-20080521_220537_961143_A4940C4A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-21 at 12:51 -0700, Javier Cardona wrote:
> David,
> 
> On Wed, May 21, 2008 at 12:28 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> > On Wed, 2008-05-21 at 12:18 -0700, Javier Cardona wrote:
> >> You need a live endpoint to send a CMD_802_11_RESET, which you won't
> >> have if the device did not respond to USB enumeration because it was
> >> in standalone mode.
> >
> > Hm, did that behaviour change recently? I'm sure this recovery was
> > working before.
> 
> I don't think we've ever been able to communicate over USB with a
> dongle that is in standalone mode.

And they probably don't respond to USB port resets either, do they?  Our
recovery mode was always:

1) CMD_802_11_RESET
2) if that didn't work, do a USB port reset

Dan

