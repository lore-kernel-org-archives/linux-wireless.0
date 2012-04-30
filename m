Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42023 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2D3RRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 13:17:48 -0400
Date: Mon, 30 Apr 2012 13:03:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120430170337.GA2560@tuxdriver.com> (sfid-20120430_191751_861148_4B63B7EF)
References: <20120422182928.GA2854@ritirata.org>
 <20120430145803.GE2630@ritirata.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120430145803.GE2630@ritirata.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 30, 2012 at 04:58:04PM +0200, Antonio Quartulli wrote:
> On Sun, Apr 22, 2012 at 08:29:29PM +0200, Antonio Quartulli wrote:
> > Hello,
> > 
> > since linux-3.0 (I don't remember if it was the case even before), I'm getting
> > this output in dmesg:
> > 
> > [   53.662990] ------------[ cut here ]------------
> > [   53.663016] WARNING: at drivers/iommu/intel-iommu.c:2911
> > intel_unmap_page+0x14b/0x180()
> > [   53.663047] Hardware name: Latitude E5420
> > [   53.663066] Driver unmaps unmatched page at PFN ffd1a000
> 
> 
> I see that I always get the same addr passed to the unmap function:
> 
> [   23.950535] Driver unmaps unmatched page at PFN ffd1a000
> 
> is it a coincidence?
> I'm running linux-3.3.3 right now. I can try wireless-testing if it would help.

Just for the record, we are seeing a similar problem on RHEL 6.3
(which has an iwlwifi driver derived from linux-3.2).

	https://bugzilla.redhat.com/show_bug.cgi?id=815998

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
