Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab2BGIL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 03:11:27 -0500
Date: Tue, 7 Feb 2012 09:11:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/4] iwlwifi: cleanup/fix memory barriers
Message-ID: <20120207081115.GC2246@redhat.com> (sfid-20120207_091130_688893_6A2F8A1F)
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
 <1328544564-8696-3-git-send-email-sgruszka@redhat.com>
 <4F2FFC25.8000705@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F2FFC25.8000705@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 06, 2012 at 05:13:25PM +0100, Johannes Berg wrote:
> On 2/6/2012 5:09 PM, Stanislaw Gruszka wrote:
> >wmb(), rmb() are not needed when writel(), readl() are used as
> >accessors for MMIO. We use them indirectly via iowrite32(),
> >ioread32().
> >
> >What is needed mmiowb(), for synchronizing writes coming from
> >different CPUs on PCIe bridge (see in patch comments). This
> >fortunately is not needed on x86, where mmiowb() is just
> >defined as compiler barrier. As iwlwifi devices are most likely
> >not used on anything other than x86, this is not so important
> >fix.
> 
> Technically, PCIe bridges can reorder writes as well, so we really
> need to do a dummy read somewhere -- we were discussing this
> internally recently as well.

PCIe can reorder writes only if they come from different CPUs,
good examples are in "LOCKS VS I/O ACCESSES" in
Documentation/memory-barriers.txt

Stanislaw
