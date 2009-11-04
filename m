Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35329 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303AbZKDW3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 17:29:00 -0500
Date: Wed, 4 Nov 2009 15:29:04 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org,
	Stephen Hemminger <shemminger@vyatta.com>,
	Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: pci_set_mwi() and ath5k
Message-ID: <20091104222904.GJ10555@parisc-linux.org>
References: <43e72e890911041204n55b54f8iace79938b40baa32@mail.gmail.com> <40f31dec0911041212p16cfc78eia1ab1817e425e767@mail.gmail.com> <43e72e890911041330j581e7bacp4e7b83a11c1de0e8@mail.gmail.com> <43e72e890911041336n7ffae0d2u135321a588f3e613@mail.gmail.com> <43e72e890911041352i334e170at71a519383d48a08@mail.gmail.com> <43e72e890911041352n3a398b41h8927387c228661c5@mail.gmail.com> <20091104220034.GI10555@parisc-linux.org> <43e72e890911041404q5f491bbbw123d8761037f9c63@mail.gmail.com> <20091104221426.GA2599@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091104221426.GA2599@bombadil.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 04, 2009 at 05:14:26PM -0500, Luis R. Rodriguez wrote:
> On Wed, Nov 04, 2009 at 02:04:11PM -0800, Luis R. Rodriguez wrote:
> > On Wed, Nov 4, 2009 at 2:00 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > > On Wed, Nov 04, 2009 at 01:52:30PM -0800, Luis R. Rodriguez wrote:
> > >> > Even better: I just confirmation from our systems team that our legacy
> > >> > devices and 11n PCI devices don't support MWR so I'll remove all that
> > >> > cruft crap.
> > >>
> > >> I meant MWI of course.
> > >
> > > Yes, but they don't necessarily just use cacheline size for MWI ... some
> > > devices use cacheline size for setting up data structures. ?Might be
> > > worth just checking explicitly that they don't use the cacheline size
> > > register for anything.
> > 
> > Oh right -- so the typical Atheros hack for this is to check the cache
> > line size, and if its 0 set it to L1_CACHE_BYTES. Then eventually read
> > from PCI_CACHE_LINE_SIZE pci config to align the skb data. So what I
> > was doing now is removing all this cruft and replacing it with a
> > generic allocator for atheros drivers that aligns simply to the
> > L1_CACHE_BYTES. Sound kosher?
> 
> Something like this:

Doesn't look kosher to me.  You're not programming the CLS register
now at all, which means you're relying on something else having set
it up for you.  If you could EXPORT_SYMBOL(pci_set_cacheline_size)
and include a call to it somewhere, that would be good.  You can rely
on pci_cache_line_size not changing after the system has booted.

>  	/*
> -	 * Cache line size is used to size and align various
> -	 * structures used to communicate with the hardware.
> -	 */
> -	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &csz);
> -	if (csz == 0) {
> -		/*
> -		 * Linux 2.4.18 (at least) writes the cache line size
> -		 * register as a 16-bit wide register which is wrong.
> -		 * We must have this setup properly for rx buffer
> -		 * DMA to work so force a reasonable value here if it
> -		 * comes up zero.
> -		 */
> -		csz = L1_CACHE_BYTES >> 2;
> -		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
> -	}

These comments are what give me pause.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
