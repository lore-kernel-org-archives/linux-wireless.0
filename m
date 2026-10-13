Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621C047F3B1;
	Tue, 13 Oct 2026 16:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791909070; cv=none; b=a4Ek9UQ2Go2Hz9HZCqlsypyBAWfZtm4E8mlj3GJHwTuSYobzdKN8qGlMfr/sh/DVKXhlq4apBZJAw80ZedKozJN54zhaUAYZeYttSp1OoUDvBcFgDxIMGbvykp+fq1A4GYlGBBX9b8sP/XLvWLyRw4XXpZhmxMzlFqrKryZcfSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791909070; c=relaxed/simple;
	bh=3PWdcDHBhbPWpZh4tpl2UNxQ8ZhM6kxojcRsoH1f5fI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=I58HqvLBJcUHpgNUVIDr+MSJT2cFyelyBgXMg9+uAL5OpqgvMNL0qt5vLqNHXbUkpM6CBw/DR2ObC7J104DAzkNZUMWYho96Uy4NtJn7z506liTtGIrr2A5ivtvSR08xCGyKpVzYEJj8EW2oP1XW7OFt3LJKSirQcDLoHdGyhs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngPdDnNj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngPdDnNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B351F00893;
	Tue, 13 Oct 2026 16:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791909068;
	bh=OKaeHoDMxbcRdhaEWBqicGHaLuwHpHXnx6ahTNQjleE=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=ngPdDnNjKhLyQT2N6RhyXzNbBJDw86DCky0DDkFZybGOWOVKgXN/ad/0sBCVkayei
	 HNYj9hrjWpWtBFX/UYrVuXDu9Nm7T92X1bPsmBFtk4Y//+tnDFq0hvpgYtRGyFnd2P
	 c30Gm7kdg0sOrDiIM+eseypQum5fGKkqjPdbpcWGVdosSz8LpVBEl5UHRwM88GzhMF
	 LxJV4rIAovtRgv9XNXWPgotqgnhY5XjoeljLa9b9heAjpcpggcX2vRtxecvBr3LGzE
	 e4URZupBZVLhzqUcLPkBuj4YCM0EBklpXxFGlAABFL+uXuGY4FJty1HMPPxJ406n+g
	 bQsk8Di+vLpcw==
Date: Tue, 13 Oct 2026 11:31:07 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	Jonathan Derrick <jonathan.derrick@linux.dev>,
	Jeff Johnson <jjohnson@kernel.org>, linux-pci@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
	ath11k@lists.infradead.org, ath10k@lists.infradead.org,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: Re: [PATCH v3 2/8] PCI/ASPM: Add pci_force_enable_link_state() API
Message-ID: <20261013163107.GA1522779@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1390db8-2369-9ab7-49a9-b7f09ef7b1ea@linux.intel.com>

On Tue, Oct 13, 2026 at 02:41:32PM +0300, Ilpo Järvinen wrote:
> On Mon, 12 Oct 2026, Bjorn Helgaas wrote:
> > On Wed, Jul 08, 2026 at 04:30:16PM +0200, Manivannan Sadhasivam wrote:
> > > From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> > > 
> > > pci_enable_link_state() and pci_enable_link_state_locked() APIs only enable
> > > the ASPM states that were not previously disabled via
> > > pci_disable_link_state*() API or blacklisted during init (e.g. the pre-1.1
> > > device blacklist, which is only meant to be overridden with
> > > 'pcie_aspm=force'). This is an intentional behavior as these APIs must not
> > > silently re-enable states that were deliberately disabled, since doing so
> > > could enable ASPM on a link where it is known to be unsafe.
> > 
> > I think this is saying that many uses of pci_disable_link_state() are
> > to avoid hardware errata, i.e., these are basically quirks, and we
> > should *never* enable those ASPM states.
> > 
> > > However, some drivers (e.g. the atheros WLAN drivers) save the currently
> > > enabled ASPM states, disable all ASPM states before firmware download, and
> > > then try to restore exactly the states that were enabled before. Restoring
> > > those states requires re-enabling states that were just disabled via
> > > pci_disable_link_state() API. But, this cannot be achieved using the
> > > existing APIs.
> > 
> > This sounds like it's also for hardware errata: if ASPM works
> > correctly, there's no need to disable it during firmware download.  I
> > think this is *only* the atheros drivers, isn't it?  I didn't see any
> > others.
> 
> There are more that should use disable/enable API. In addition ath*, I had 
> also these in my unfinished series:
> 
>   brcmfmac
>   ib-hfi1
>   rtlwifi
>   rtsx
>   r8169

Thanks for those pointers!

> > > Hence, add pci_force_enable_link_state() API for such callers. Unlike
> > > pci_enable_link_state(), it re-enables the requested states even if they
> > > were previously disabled via pci_disable_link_state() or disabled during
> > > init. The caller is therefore responsible for only enabling states the
> > > device actually supports, typically the ones previously reported by
> > > pcie_aspm_enabled().
> > 
> > The problem is that pci_enable_link_state() cannot enable things that
> > were disabled by pci_disable_link_state().  They're not symmetric,
> > which violates the caller's expectation.
> 
> Yes.
> 
> This patch seems to come with my Suggested-by but what I suggested (and 
> had a patch for) was to make disable/enable proper symmetric pairs because 
> it is very trappy otherwise. If something else is needed in addition, that 
> should be named differently like Bjorn also seems to suggest (however see 
> my alternative suggestion below).
> 
> I renamed the current pci_enable_link_state() to 
> pci_set_default_link_state() in my own attempt to get room for adding the 
> symmetric pair.

We might need new names for pci_enable_link_state(),
pci_disable_link_state(), and the quirk thing.  If we keep the same
names, I think it will be pretty complicated to manage the changing
semantics when backporting driver changes that use them.

> > Instead of adding pci_force_enable_link_state(), I think we should add
> > a new interface for the *quirk* behavior that permanently disables
> > states.  Then pci_enable_link_state() and pci_disable_link_state()
> > could be made symmetric.
> 
> My suggestion is to make the disables/enables counted per state which 
> would allow parallel sources of disables to function without clashing.

By parallel sources, are you thinking of sysfs and driver calls?  If
locking would be sufficient I think that would end up being simpler.

But maybe the issue is these devices where we think ASPM breakage only
happens in certain circumstances, e.g., firmware download, so we want
to keep states disabled for that period.  Then I guess locking inside
the enable/disable doesn't prevent sysfs from enabling those states
during that period.

> Disable quirks could simply not have the pairing enable, no special 
> interface needed.

I'm not sure what this looks like to the caller.  A parameter that
says whether to count the disable?

I think having a different function name would be helpfully
descriptive because permanently removing an advertised capability is
different from temporarily disabling a feature.

Bjorn
