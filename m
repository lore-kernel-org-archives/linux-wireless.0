Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from SpacedOut.fries.net ([67.64.210.234]:39942 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab2B0OnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 09:43:22 -0500
Date: Mon, 27 Feb 2012 08:42:55 -0600
From: David Fries <david@fries.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: ath5k phy0: gain calibration timeout
Message-ID: <20120227144255.GB1190@spacedout.fries.net> (sfid-20120227_154326_165987_29F044E7)
References: <20120227031232.GA1190@spacedout.fries.net>
 <4F4B71F2.1020709@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F4B71F2.1020709@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 01:07:14PM +0100, Felix Fietkau wrote:
> On 2012-02-27 4:12 AM, David Fries wrote:
> > Wireless network stopped working after 22 hours with ath5k, I have the
> > following message repeating, suspending to ram and back was enough to
> > get it talking again.
> > ath5k phy0: gain calibration timeout (2462MHz)
> > 
> > I previously was running 3.2-rc5 for a month and a half straight
> > without any wireless issues, I just upgraded to 3.3-rc1, the message
> > started 22 hours after booting the newer kernel.  This ath5k is
> > running hostapd 1:0.7.3-4 with WPA-EAP and had no clients for the 12
> > hours before the calibration message started, and had no clients for
> > hours after until I tried to connect and found I couldn't.
> > While I was unable to connect, I flipped
> > the laptop rfkill switch and the gain calibration timeouts continued,
> > disabling rfkill and they still continued.  That's when I did a
> > suspend to memory and resume and found it recovered.  While it was
> > working I tried rfkill and it no longer was talking after disabling
> > rfkill, I thought it was resuming previously, but I don't use that
> > very often.
> > 
> > I revered the following two comments and will see if I run into any
> > more problems.  I can test patches.
> > ath5k: We always do full calibration on AR5210
> > dafae6af0336958e9e2eb67cc5e4e31d6d13b308
> > ath5k: Calibration re-work
> > ce169aca0d823d38465127023e3d571816e6666c
> Please try applying the following two patches:
> http://nbd.name/gitweb.cgi?p=openwrt.git;a=blob_plain;f=package/mac80211/patches/440-ath5k_calibrate_no_queue_stop.patch;hb=HEAD
> http://nbd.name/gitweb.cgi?p=openwrt.git;a=blob_plain;f=package/mac80211/patches/441-ath5k_no_agc_recalibration.patch;hb=HEAD

Thanks, I'm running with those two patches.  I'll give it a few days
before reporting to see if it goes down again.

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
