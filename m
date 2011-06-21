Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50785 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab1FUN7K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 09:59:10 -0400
Subject: Re: [3.0 regression] DMAR faults in iwlagn
From: wwguy <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Lutomirski <luto@mit.edu>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1308663526.4276.2.camel@jlt3.sipsolutions.net>
References: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com>
	 (sfid-20110620_204449_827132_DD43A304)  <1308663526.4276.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 06:55:05 -0700
Message-ID: <1308664505.21011.12.camel@wwguy-ubuntu> (sfid-20110621_155914_894639_636600C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-21 at 06:38 -0700, Johannes Berg wrote:
> On Mon, 2011-06-20 at 14:44 -0400, Andrew Lutomirski wrote:
> > On 3.0-git today, I get:
> > 
> > [   40.142872] DRHD: handling fault status reg 2
> > [   40.142892] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe38000
> > [   40.142896] DMAR:[fault reason 05] PTE Write access is not set
> > 
> > lspci says:
> > 
> > 03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)
> > 
> > This seems to be triggered by interface state changes.  The driver
> > still works.  I don't see this on 2.6.39.1.
> 
> Thanks Andy. Do you happen to know if there's any way to figure out what
> ffe38000 was? Clearly the device is attempting to write something that
> we haven't mapped properly, but I'm not sure _what_?

Andy, did you have chance try wireless-testing tree, I could not see the
issue, but maybe we can bisect the problem if you also do't see the
problem there.

Thanks
Wey

