Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51822 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab2B0MHZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 07:07:25 -0500
Message-ID: <4F4B71F2.1020709@openwrt.org> (sfid-20120227_130729_182747_BE98FF6D)
Date: Mon, 27 Feb 2012 13:07:14 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: David Fries <david@fries.net>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: ath5k phy0: gain calibration timeout
References: <20120227031232.GA1190@spacedout.fries.net>
In-Reply-To: <20120227031232.GA1190@spacedout.fries.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-27 4:12 AM, David Fries wrote:
> Wireless network stopped working after 22 hours with ath5k, I have the
> following message repeating, suspending to ram and back was enough to
> get it talking again.
> ath5k phy0: gain calibration timeout (2462MHz)
> 
> I previously was running 3.2-rc5 for a month and a half straight
> without any wireless issues, I just upgraded to 3.3-rc1, the message
> started 22 hours after booting the newer kernel.  This ath5k is
> running hostapd 1:0.7.3-4 with WPA-EAP and had no clients for the 12
> hours before the calibration message started, and had no clients for
> hours after until I tried to connect and found I couldn't.
> While I was unable to connect, I flipped
> the laptop rfkill switch and the gain calibration timeouts continued,
> disabling rfkill and they still continued.  That's when I did a
> suspend to memory and resume and found it recovered.  While it was
> working I tried rfkill and it no longer was talking after disabling
> rfkill, I thought it was resuming previously, but I don't use that
> very often.
> 
> I revered the following two comments and will see if I run into any
> more problems.  I can test patches.
> ath5k: We always do full calibration on AR5210
> dafae6af0336958e9e2eb67cc5e4e31d6d13b308
> ath5k: Calibration re-work
> ce169aca0d823d38465127023e3d571816e6666c
Please try applying the following two patches:
http://nbd.name/gitweb.cgi?p=openwrt.git;a=blob_plain;f=package/mac80211/patches/440-ath5k_calibrate_no_queue_stop.patch;hb=HEAD
http://nbd.name/gitweb.cgi?p=openwrt.git;a=blob_plain;f=package/mac80211/patches/441-ath5k_no_agc_recalibration.patch;hb=HEAD

- Felix
