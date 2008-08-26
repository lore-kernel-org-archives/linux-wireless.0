Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from usul.saidi.cx ([204.11.33.34]:42442 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751837AbYHZWzd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 18:55:33 -0400
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 5/5] rfkill: remove transmitter blocking on suspend
MIME-Version: 1.0
Date: Tue, 26 Aug 2008 18:56:27 -0400
From: Philip Langdale <philipl@overt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Andrew Bird <ajb@spheresystems.co.uk>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
In-Reply-To: <1219762681-26911-6-git-send-email-hmh@hmh.eng.br>
References: <1219762681-26911-6-git-send-email-hmh@hmh.eng.br>
Message-ID: <0039aef27a50f39669ac0b03c80d2071@localhost> (sfid-20080827_005538_319503_AFEB4665)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 26 Aug 2008 11:58:01 -0300, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> Currently, rfkill would stand in the way of properly supporting wireless
> devices that are capable of waking the system up from sleep or
hibernation
> when they receive a special wireless message.  It would also get in the
> way
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
> resume in any situation.  This happens after the driver's resume method
is
> called by the suspend core (class devices resume after the devices they
> are
> attached to have been resumed).
> 
> The following drivers need to check if they need to explicitly block
> their transmitters in their own suspend handlers (maintainers Cc'd):

> 	toshiba-acpi w/rfkill support (not in mainline yet)

The toshiba bluetooth device is automatically disconnected and powered down
at suspend - and I'm glad to know that rfkill will still attempt to restore
the state - because the hardware definitely won't. :-)

So, no new work here.

--phil

