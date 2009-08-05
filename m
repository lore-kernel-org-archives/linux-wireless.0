Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51784 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934703AbZHERPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 13:15:23 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 10:15:25 -0700
Date: Wed, 5 Aug 2009 10:15:23 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Andrea Rossato <mailing_list@istitutocolli.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] a possible regression in managed mode ?
Message-ID: <20090805171523.GE4727@mosca>
References: <43e72e890908050810h29c28945o4732f8606caab9fb@mail.gmail.com>
 <20090805155330.GC4727@mosca>
 <20090805165227.GA18394@eeepc.nowhere.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090805165227.GA18394@eeepc.nowhere.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please include linux-wireless, addint it back again.

On Wed, Aug 05, 2009 at 09:52:27AM -0700, Andrea Rossato wrote:
> On Wed, Aug 05, 2009 at 05:10:18PM +0200, Luis R. Rodriguez wrote:
> > Can you try with -D nl80211 and see if that fixes your issue?
> 
> I'll be able to try that in a couple of days... I'm now in the
> situation when I run my eee pc in Master mode.
> 
> >
> > Also from your description of the issue below it is unclear to me if
> > you do not see these issues with an older kernel or if this is only
> > happening with newer kernels or wireless-testing. Can you please
> > clarify.
> 
> When I use 2.6.29.4 everything works smoothly and association and
> authentication always happen at the first try. The "authentication
> timeout" issue only happens with the wireless-testing kernel from git.

This is when using wpa_supplicant 0.6.9? Or when using both 0.6.9
and git version of the supplicant?

> Since my scripts always call "wpa_cli reassociate" I was not aware of
> the fact that the first time wpa_supplicant was succeeding in
> associating the first time (hence the Access Point log that show the
> first successful association and nothing more).

You know you can just have wpa_supplicant try to reassoc for you
upon disconnection automatically, right? I use something like this:

ctrl_interface=/var/run/wpa_supplicant
ap_scan=1
network={
        ssid="mosca"
        scan_ssid=1
        key_mgmt=NONE
}

> On Wed, Aug 05, 2009 at 05:53:31PM +0200, Luis R. Rodriguez wrote:
> >
> > Also please install iw, and provide 'iw event -t' log.
> 
> Already installed here. I'll provide the output as soon as I'll be
> able to test the nl80211 driver.

May want to update from git, iw has been updated recently so you could
decode more messages specially if using wireless-testing.

  Luis
