Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:44089 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751297Ab0LVBnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 20:43:00 -0500
Date: Tue, 21 Dec 2010 20:42:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ohad Ben-Cohen <ohad@wizery.com>,
	<linux-pm@lists.linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
In-Reply-To: <201012212231.57420.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1012212032590.11252-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 21 Dec 2010, Rafael J. Wysocki wrote:

> It basically goes like this.  There's device A that is only resumed when it's
> needed to carry out an operation and is suspended immediately after that.
> There's another device B that needs A to do something during its suspend.
> So, when the suspend of B is started, A is woken up, does its work and is
> suspended again (using pm_runtime_suspend()).  Then B is suspended.
> 
> We currently require that ->suspend() and ->resume() callbacks be defined
> for A (presumably pointing to the same code as its runtime callbacks) so that
> things work correctly, but perhaps we can just relax this requirement a bit?
> I'm not 100% sure that's a good idea, just considering it.

I still don't know.  It would require a lot of special conditions: no
child devices, not runtime-PM-disabled, not runtime-PM-forbidden...  
Also, A's parent would have to be coded carefully; otherwise A's
runtime resume would prevent the parent from suspending.

This just doesn't fit very well with the runtime PM model, or at least, 
not in the form you described.

Consider this instead:  Since A is required to be functional before B
can be used, A must be registered before B and hence B gets suspended
before A.  Therefore during the prepare phase we can runtime-resume A
and leave it powered up; when B needs to suspend, it won't matter that
the runtime-PM calls are ineffective.  Then when A's dpm_suspend
occurs, it can safely go to a low-power state and stay there.

Alan Stern

