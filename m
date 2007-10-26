Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4736 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbXJZMbI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 08:31:08 -0400
Date: Fri, 26 Oct 2007 08:30:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jes Sorensen <jes@sgi.com>
Cc: Dan Williams <dcbw@redhat.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: iwl4965 detection problem
Message-ID: <20071026123044.GB23415@tuxdriver.com> (sfid-20071026_133120_235674_EEABE585)
References: <47209C0C.5010505@sgi.com> <1193319925.5542.8.camel@localhost.localdomain> <4720A509.2070708@sgi.com> <1193333545.2111.8.camel@localhost.localdomain> <47219FE6.70900@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47219FE6.70900@sgi.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 26, 2007 at 10:05:58AM +0200, Jes Sorensen wrote:
> Dan Williams wrote:
> >I've had this same problem with one machine and there were problems with
> >those two files.  I fixed it on that machine (and was fixed on a few
> >others using this procedure) by removing those two files and rebooting.
> >
> >The symptom is that the driver loads and recognizes the card, but no
> >wireless devices show up to userspace (via iwconfig, ifconfig, or
> >in /sys/class/net) because device renames by udev and/or init scripts
> >stomped over them (like trying to rename wmaster0 -> eth1 and then
> >renaming wlan0 -> eth1 but failing because it was already taken).
> >
> >Try killing those two files, making sure you're up to date, then
> >restarting.

> I tried that, but no go :-( Even before the card was detected by Fedora,
> when I manually loaded the iwl4965 module, nothing showed up in
> ifconfig -a, I had to unload/reload for anything to happen.

I've been seeing this behaviour _sometimes_ as well.  (/me hates _sometimes_)

Fresh off the presses, an F8-based build w/ the latest round of
iwl4965 updates from Zhu Yi and friends:

	http://koji.fedoraproject.org/koji/taskinfo?taskID=215212

I haven't had a chance to test it yet myself (built it overnight),
so YMMV.  Still, there is a lot of iwl4965 churn in there so it is
probably worth some testing.  (Newer than wireless-2.6!)

For any non-iwl4965 F8 users it may still be worthwhiles to give
those kernels a spin -- the stuff in the current F8 kernels is a
little old now.(*)

Let me know...

John

(*) I had to stop shoving stuff into F8 a couple of weeks back after
a big wireless update broke a bunch of people's wireless while F8
was trying to freeze... :-(
-- 
John W. Linville
linville@tuxdriver.com
