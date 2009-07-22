Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21534 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZGVQia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 12:38:30 -0400
Subject: Re: wireless-testing regression: iwl3945 scan fails
From: reinette chatre <reinette.chatre@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1248279871.28545.126.camel@violet>
References: <87k521s2wa.fsf@litku.valot.fi>  <87fxcosron.fsf@litku.valot.fi>
	 <1248278121.17896.2728.camel@rc-desk>  <1248279871.28545.126.camel@violet>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 09:38:30 -0700
Message-Id: <1248280710.17896.2739.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

On Wed, 2009-07-22 at 09:24 -0700, Marcel Holtmann wrote:
> Hi Reinette,
> 
> > > > I just upgraded to rc3-wl (commit 225b6807) and my iwl3945 doesn't work
> > > > anymore, even scan fails. I don't have time to investigate this right
> > > > now, but I'll try to find some time during the evening.
> > > 
> > > I have looked at this now a bit and I don't think this is an iwl3945
> > > problem. Scanning seems to stall in some situations and iwl3945 doesn't
> > > even receive the scan command. 
> > 
> > The patches we sent recently did undergo testing under various scenarios
> > using wpa_supplicant. We have not done this testing after the
> > 2.6.31-rc3-wl merge (yesterday) though. I just did a quick test on my
> > 3945 using iwconfig to associate and it was able to do so on A and G
> > bands. Looks like I need to do some wpa_supplicant testing.
> 
> can also at least get an IP address via DHCP and do some packet
> transfer. I made the experience that DHCP works and then we get
> disconnected seconds later.

I have seen this for a long time now. I am using wpa_supplicant to
connect to a WPA2 network using a 5100 device and get disconnected very
regularly (starts with "CTRL-EVENT-DISCONNECTED - Disconnect event -
remove keys" which is caused by a missing probe response from the AP).
In these cases wpa_supplicant is able to reconnect. This behavior is
also present in 2.6.31-rc3-wl from yesterday.

Do you not get reconnected after you get disconnected?

Reinette

