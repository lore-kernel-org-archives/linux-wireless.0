Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33427 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbYICVcQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 17:32:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 5/5] rfkill: remove transmitter blocking on suspend
Date: Wed, 3 Sep 2008 23:31:38 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Andrew Bird <ajb@spheresystems.co.uk>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
	Philip Langdale <philipl@overt.org>
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br> <20080903190559.GO3050@tuxdriver.com> <20080903212020.GA14620@khazad-dum.debian.net>
In-Reply-To: <20080903212020.GA14620@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809032331.38963.mb@bu3sch.de> (sfid-20080903_233219_953210_08331081)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 03 September 2008 23:20:21 Henrique de Moraes Holschuh wrote:
> On Wed, 03 Sep 2008, John W. Linville wrote:
> > > The following drivers need to check if they need to explicitly block
> > > their transmitters in their own suspend handlers (maintainers Cc'd):
> > > 	arch/arm/mach-pxa/tosa-bt.c
> > > 	drivers/net/usb/hso.c
> > > 	drivers/net/wireless/rt2x00/* (USB might need it?)
> > > 	drivers/net/wireless/b43/ (SSB over USB might need it?)
> > > 	drivers/misc/hp-wmi.c
> > > 	eeepc-laptop w/rfkill support (not in mainline yet)
> > > 	Compal laptop w/rfkill support (not in mainline yet)
> > > 	toshiba-acpi w/rfkill support (not in mainline yet)
> > 
> > Are we now satisfied that the in-kernel drivers above are all prepared
> > for this patch?

The b43/b43legacy chips are completely shutdown on suspend and all
clocks are disabled (Including PHY/radio). We don't support WoL.

-- 
Greetings Michael.
