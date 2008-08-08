Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYHHOui (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 10:50:38 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Dan Williams <dcbw@redhat.com>
To: Dave <kilroyd@googlemail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net
In-Reply-To: <489B6458.8050206@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
	 <1217970944.2908.11.camel@dv>
	 <1217973349.30531.1.camel@localhost.localdomain>
	 <1217976491.2908.36.camel@dv>
	 <1218028414.16977.5.camel@localhost.localdomain>
	 <4899FB91.8070501@gmail.com>
	 <1218056165.12240.0.camel@localhost.localdomain>
	 <489A12E2.8060909@gmail.com>
	 <1218077300.30724.10.camel@localhost.localdomain>
	 <489B425F.5060704@gmail.com>
	 <1218138129.32083.14.camel@localhost.localdomain>
	 <489B6458.8050206@gmail.com>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 10:51:58 -0400
Message-Id: <1218207118.32033.12.camel@localhost.localdomain> (sfid-20080808_165042_996630_775FC028)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-08-07 at 22:08 +0100, Dave wrote:
> Dan Williams wrote:
> > On Thu, 2008-08-07 at 19:43 +0100, Dave wrote:
> >> That said, what's wrong with the ap_scan=2 mode? You've stated it's not
> >> great (and I'm prepared to believe it), but what is the actual problem?
> 
> > But the problem with ap_scan=2 is really about the failure window.
> > ap_scan=2 basically dumps a load of options on the driver, and unless
> > the options _exactly_ match the configuration of the AP, you won't
> > connect.  The supplicant isn't able to make intelligent choices about
> > which networks in its config file match the scan result, thus there's a
> > lot more potential for failure unless you know exactly what your network
> > is set up to do, and these capabilities aren't always exposed through
> > beacons.  So ap_scan=2 just opens up a huge window of failure and stuff
> > can't ever Just Work because no intelligence can be applied.
> 
> Wouldn't a different mode of operation in wpa_supplicant solve this (see below)? Then get rid of the mode selection via wpa_supplicant.conf by selecting mode based on drivers error responses (and/or reported capabilities).

Maybe; as long as the modes are not actually exposed or configurable in
any way.  However, since drivers are so horribly inconsistent and since
WEXT doesn't promote consistency, I tend to think having automatically
chosen modes like this would cause more problems than we have now...

> ap_scan=3:
>     * wpa_supplicant requests scan with SIOCSIWSCAN
>     * driver reports scan complete with wireless event SIOCGIWSCAN
>     * wpa_supplicant reads scan results with SIOCGIWSCAN (multiple call if a larget buffer is needed)
>     * wpa_supplicant decides which SSID to use based on scan results
>     * wpa_supplicant configures driver to associate with an SSID (SIOCSIWMODE, SIOCSIWGENIE, SIOCSIWAUTH, SIOCSIWESSID)
> 
> SIOCSIWSCAN not supported? => ap_scan=2

If a driver doesn't support SIOCSIWSCAN it'll get a big fat NAK for
kernel inclusion.  Any driver that doesn't support scan shouldn't be
used.

I assume you mean "specific SSID scanning" though, right?  That's
basically what NM does right now; if the driver doesn't support SSID
scan capabilities, NM requests that the supplicant use ap_scan=2.

Basically, I don't think any of this is really a problem any more.  The
supplicant should probably ignore a result of EOPNOTSUPP when calling
SIOCSIWAP during the association run.  ap_scan certainly shouldn't be
overloaded more than it is now.  I don't think the supplicant locking in
the BSSID and controlling roaming in the supplicant based on BSSID is
all that useful since the firmware or stack usually does what it wants
anyway.  Besides, it's sort of insane to specify 10 different network
blocks with a common SSID but different everything else.  That's an
indication of a horribly broken network for starters, and secondly you
simply shouldn't need to lock multiple network blocks with a common SSID
down to different BSSIDs in the first place really.

If we really want to handle roaming in the supplicant, we shouldn't be
overloading ap_scan any more.  We should be thinking about this from the
ground up and not trying to shove a round peg into a square hole.
ap_scan just isn't suitable for actually handling roaming.

Dan

