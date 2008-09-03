Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46852 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbYICTPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 15:15:42 -0400
Date: Wed, 3 Sep 2008 15:05:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Andrew Bird <ajb@spheresystems.co.uk>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
	Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH 5/5] rfkill: remove transmitter blocking on suspend
Message-ID: <20080903190559.GO3050@tuxdriver.com> (sfid-20080903_211546_983410_BEBBFF86)
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br> <1219762681-26911-6-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1219762681-26911-6-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 26, 2008 at 11:58:01AM -0300, Henrique de Moraes Holschuh wrote:
> Currently, rfkill would stand in the way of properly supporting wireless
> devices that are capable of waking the system up from sleep or hibernation
> when they receive a special wireless message.  It would also get in the way
> of mesh devices that need to remain operational even during platform
> suspend.
> 
> To avoid that, stop trying to block the transmitters on the rfkill class
> suspend handler.
> 
> Drivers that need rfkill's older behaviour will have to implement it by
> themselves in their own suspend handling.
> 
> Do note that rfkill *will* attempt to restore the transmitter state on
> resume in any situation.  This happens after the driver's resume method is
> called by the suspend core (class devices resume after the devices they are
> attached to have been resumed).
> 
> The following drivers need to check if they need to explicitly block
> their transmitters in their own suspend handlers (maintainers Cc'd):
> 	arch/arm/mach-pxa/tosa-bt.c
> 	drivers/net/usb/hso.c
> 	drivers/net/wireless/rt2x00/* (USB might need it?)
> 	drivers/net/wireless/b43/ (SSB over USB might need it?)
> 	drivers/misc/hp-wmi.c
> 	eeepc-laptop w/rfkill support (not in mainline yet)
> 	Compal laptop w/rfkill support (not in mainline yet)
> 	toshiba-acpi w/rfkill support (not in mainline yet)

Are we now satisfied that the in-kernel drivers above are all prepared
for this patch?

John
-- 
John W. Linville
linville@tuxdriver.com
