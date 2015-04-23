Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbbDWIPp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2015 04:15:45 -0400
Date: Thu, 23 Apr 2015 10:15:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi getting stuck with current Linus' tree (646da63172)
In-Reply-To: <1429764440.4084.5.camel@intel.com>
Message-ID: <alpine.LNX.2.00.1504231011500.3695@pobox.suse.cz> (sfid-20150423_101607_123444_0032FB61)
References: <alpine.LNX.2.00.1504222235340.3695@pobox.suse.cz> <1429764440.4084.5.camel@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 23 Apr 2015, Grumbach, Emmanuel wrote:

> > I've been running current Linus' tree and have been getting system lockups 
> > frequently. After a few "silent" lockups, I was able to obtain a dmesg 
> > before the machine turned dead again (wifi stopped working shortly before 
> > that).
> > 
> > Before starting to debug / bisect (last known good on this machine is 
> > 4.0-rc6), I am attaching the dmesg in case someone already knows what the 
> > issue is.
> > 
> 
> I briefly went over the iwlwifi commits between 4.0-rc6 and linux/master
> and couldn't find anything obvious.
> Note that for the device you have, the commits that touch
> drivers/net/wireless/iwlwifi/mvm are not relevant.
> 
> What you are seeing is that the PCI host is disconnecting the WiFi NIC
> for some weird reason. It is not the first time I see that, but
> unfortunately, I have never been able to debug this. I am personally not
> a HW PCI expert and I couldn't reproduce either...
> 
> I am afraid I won't save you the time of the bisection, but I am not
> entirely sure that bisecting the iwlwifi driver is enough to find the
> commit that broke it. You may want to bisect the pci bus driver as well.

The problem is that I can't really reliably reproduce it; it happens 
rather often, but not so often that I could be certainly sure that my 
distinction of good and bad kernels would be accurate.

I will try it, but I expect the result to be bogus because of this, 
unfortunately.

> First question is: Are you sure that 4.0-rc6 was good?

Pretty much, yes. I've been running it for quite some time on this 
machine without any issues. But after updating to current HEAD two days 
ago, the issue triggered like 6 or 7 times already.

Thanks,

-- 
Jiri Kosina
SUSE Labs
