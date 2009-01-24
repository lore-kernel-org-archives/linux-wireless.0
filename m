Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58299 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765AbZAXOcN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:32:13 -0500
Subject: Re: p54 + ISL3887 + master mode?
From: Dan Williams <dcbw@redhat.com>
To: Valentin <apo@apo2k4.ath.cx>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090124150103.612d8985@lucien>
References: <20090124150103.612d8985@lucien>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 09:30:52 -0500
Message-Id: <1232807452.2870.27.camel@localhost.localdomain> (sfid-20090124_153216_908067_8FF0063A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-01-24 at 15:01 +0100, Valentin wrote:
> Hi, I recently got a Dell Wireless 1450 USB and am now trying to put it
> into master mode, but to no avail... I've tried this:
> 
> ./iw phy phy6 interface add dell type (master|ap)
> 
> but both just give me the help. Trying to add a device in e.g. monitor
> or managed mode works. If I then try
> 
> iwconfig dell mode master
> 
> I get
> 
> Error for wireless request "Set Mode" (8B06) :
>     SET failed on device dell ; Invalid argument.
> 
> Now I'm pretty much out of ideas. Is it actually possible to get this
> into master mode? :|

One thing to try: make sure the interface is down first, since mac80211
doesn't allow mode switches while the interface is up.

Dan


