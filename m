Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:55962 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbYHZPkj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 11:40:39 -0400
Date: Tue, 26 Aug 2008 08:39:48 -0700
From: Greg KH <gregkh@suse.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Andrew Bird <ajb@spheresystems.co.uk>,
	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
	Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH 5/5] rfkill: remove transmitter blocking on suspend
Message-ID: <20080826153948.GA18563@suse.de> (sfid-20080826_174043_971831_FBFF5D5A)
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

Normally when you change a kernel-api to operate differently, you also
fix up the relevant parts of the kernel as well.  Have you looked into
these drivers to see if they do have this problem or not?

thanks,

greg k-h
