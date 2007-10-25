Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbXJYReJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 13:34:09 -0400
Subject: Re: iwl4965 detection problem
From: Dan Williams <dcbw@redhat.com>
To: Jes Sorensen <jes@sgi.com>
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4720A509.2070708@sgi.com>
References: <47209C0C.5010505@sgi.com>
	 <1193319925.5542.8.camel@localhost.localdomain>  <4720A509.2070708@sgi.com>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 13:32:25 -0400
Message-Id: <1193333545.2111.8.camel@localhost.localdomain> (sfid-20071025_183414_941084_A9954257)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-10-25 at 16:15 +0200, Jes Sorensen wrote:
> Dan Williams wrote:
> > You'll need to update more than just the kernel.  There were issues with
> > Test 3 for udev and network init scripts that didn't distinguish between
> > the wmasterX and wlanX interfaces, and since both have the same MAC
> > address things got confused.
> > 
> > Try updating to the latest Rawhide bits rather than using Test 3.  The
> > make sure you remove the following files:
> > 
> > rm -f /etc/sysconfig/network-scripts/ifcfg-wlan0*
> > rm -f /etc/udev/rules.d/70-persistent-net.rules
> > 
> > The initscripts don't care what's after the ifcfg- (because you could
> > name it ifcfg-Home or ifcfg-Some-Other-Place, it doesn't have to be the
> > device name) and therefore even a ifcfg-wlan0.bak will cause the problem
> > too.
> 
> Hi Dan,
> 
> I think I have the latest updates, provided fedora/core/development is
> rawhide? I got udev-116-3.fc8 and initscripts-8.60-1.
> 
> That said, I am pretty sure this is a driver issue - even right after
> the install, when Fedora hadn't figured out the device and didn't try
> to load the module, it didn't find the device either unless I loaded it,
> unloaded it and loaded it again.

I've had this same problem with one machine and there were problems with
those two files.  I fixed it on that machine (and was fixed on a few
others using this procedure) by removing those two files and rebooting.

The symptom is that the driver loads and recognizes the card, but no
wireless devices show up to userspace (via iwconfig, ifconfig, or
in /sys/class/net) because device renames by udev and/or init scripts
stomped over them (like trying to rename wmaster0 -> eth1 and then
renaming wlan0 -> eth1 but failing because it was already taken).

Try killing those two files, making sure you're up to date, then
restarting.

Dan


