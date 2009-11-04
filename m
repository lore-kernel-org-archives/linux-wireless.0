Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42953 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796AbZKDWAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 17:00:30 -0500
Date: Wed, 4 Nov 2009 15:00:34 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org,
	Stephen Hemminger <shemminger@vyatta.com>,
	Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: pci_set_mwi() and ath5k
Message-ID: <20091104220034.GI10555@parisc-linux.org>
References: <43e72e890911041204n55b54f8iace79938b40baa32@mail.gmail.com> <40f31dec0911041212p16cfc78eia1ab1817e425e767@mail.gmail.com> <43e72e890911041330j581e7bacp4e7b83a11c1de0e8@mail.gmail.com> <43e72e890911041336n7ffae0d2u135321a588f3e613@mail.gmail.com> <43e72e890911041352i334e170at71a519383d48a08@mail.gmail.com> <43e72e890911041352n3a398b41h8927387c228661c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890911041352n3a398b41h8927387c228661c5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 04, 2009 at 01:52:30PM -0800, Luis R. Rodriguez wrote:
> > Even better: I just confirmation from our systems team that our legacy
> > devices and 11n PCI devices don't support MWR so I'll remove all that
> > cruft crap.
> 
> I meant MWI of course.

Yes, but they don't necessarily just use cacheline size for MWI ... some
devices use cacheline size for setting up data structures.  Might be
worth just checking explicitly that they don't use the cacheline size
register for anything.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
