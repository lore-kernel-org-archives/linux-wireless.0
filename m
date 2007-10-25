Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57050 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757191AbXJYOPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 10:15:51 -0400
Message-ID: <4720A509.2070708@sgi.com> (sfid-20071025_151554_198567_BF3BC89D)
Date: Thu, 25 Oct 2007 16:15:37 +0200
From: Jes Sorensen <jes@sgi.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: iwl4965 detection problem
References: <47209C0C.5010505@sgi.com> <1193319925.5542.8.camel@localhost.localdomain>
In-Reply-To: <1193319925.5542.8.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> You'll need to update more than just the kernel.  There were issues with
> Test 3 for udev and network init scripts that didn't distinguish between
> the wmasterX and wlanX interfaces, and since both have the same MAC
> address things got confused.
> 
> Try updating to the latest Rawhide bits rather than using Test 3.  The
> make sure you remove the following files:
> 
> rm -f /etc/sysconfig/network-scripts/ifcfg-wlan0*
> rm -f /etc/udev/rules.d/70-persistent-net.rules
> 
> The initscripts don't care what's after the ifcfg- (because you could
> name it ifcfg-Home or ifcfg-Some-Other-Place, it doesn't have to be the
> device name) and therefore even a ifcfg-wlan0.bak will cause the problem
> too.

Hi Dan,

I think I have the latest updates, provided fedora/core/development is
rawhide? I got udev-116-3.fc8 and initscripts-8.60-1.

That said, I am pretty sure this is a driver issue - even right after
the install, when Fedora hadn't figured out the device and didn't try
to load the module, it didn't find the device either unless I loaded it,
unloaded it and loaded it again.

Cheers,
Jes
