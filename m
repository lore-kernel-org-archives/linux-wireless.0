Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169A651CF56;
	Tue, 13 Oct 2026 17:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791913382; cv=none; b=UuIcf96UocKAY+lx3YGjn7ge+TzDDFTNiGY8nbtNMYXmizhMRjv9e1pei1bgSqa0DK2MiMZlO4TYessuyMpfNB1ykhX+0be6KV1/MoUuc1c2C3NdEs7TJB3XhPBNlyI2WvFUTDNRaLgF4OThIWm94LzpBG3/GYzI5hMUq3S4Nj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791913382; c=relaxed/simple;
	bh=OFAfkLArIISQMtIBXs88GvQjJ68ib8glSTZMngiiQEQ=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=FEtKSeCYeZQFr2UnJ9KAwWoDEwg3akinq/G9QYNUd1Vz4TgtDKIhrV0RZu6lAstExRl1Lv2q5wLWyCSLhKx7uwPncxAAacK3XVvXrfs9WvyelqFbNKEntQZs3W1bQjWNkFhGZWGfp4Y1Rf/nZ6cSA79t2vXAORRY85yizcBfrs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dcRHtIlk; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dcRHtIlk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791913380; x=1823449380;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=OFAfkLArIISQMtIBXs88GvQjJ68ib8glSTZMngiiQEQ=;
  b=dcRHtIlkyLFTYXUpFOTuI+9QUKm6UkI9CWe3DHEsg1456Z8zaaryiqZu
   fRupBKafJzCff+z+8/J1VxU4NWfice/ko4s2G1fraujEQNe9IDiKfPPWb
   QGiruk/YMX2auRbStvPaTPKdUw7tpn4anHLPxho0OnZoDcNwa5MmpagK9
   z3DdnBXYSovzgxgSO6KIfHTJIzShsdwJJScjldLRjtAe11D0vFWlOLK69
   c52dTsGHrC2oI5K9QrN1zH/Ilh/rjDf/wXY5Q6SP1X6XZnr52uUPJAoDf
   jWqZ/HtjzFHiSJWtIfF9G5cUWlVcANAcqRKCH3xaLqB+MNVRjS9QB7gn+
   A==;
X-CSE-ConnectionGUID: PZgINpXmTRqYooepVux1YQ==
X-CSE-MsgGUID: qhoh2UouRJCWwW5rZoLf5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="743342"
X-IronPort-AV: E=Sophos;i="6.27,156,1787036400"; 
   d="scan'208";a="743342"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 10:42:59 -0700
X-CSE-ConnectionGUID: mJakSm3RTfqxHKqqjVFQSA==
X-CSE-MsgGUID: yytLjkP+Ssuq5WYE6NXFSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,156,1787036400"; 
   d="scan'208";a="1581795"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.106])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 10:42:54 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 13 Oct 2026 20:42:51 +0300 (EEST)
To: Bjorn Helgaas <helgaas@kernel.org>
cc: Manivannan Sadhasivam <mani@kernel.org>, 
    Bjorn Helgaas <bhelgaas@google.com>, 
    Lorenzo Pieralisi <lpieralisi@kernel.org>, 
    =?ISO-8859-2?Q?Krzysztof_Wilczy=F1ski?= <kwilczynski@kernel.org>, 
    Rob Herring <robh@kernel.org>, Nirmal Patel <nirmal.patel@linux.intel.com>, 
    Jonathan Derrick <jonathan.derrick@linux.dev>, 
    Jeff Johnson <jjohnson@kernel.org>, linux-pci@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org, 
    linux-wireless@vger.kernel.org, ath12k@lists.infradead.org, 
    ath11k@lists.infradead.org, ath10k@lists.infradead.org, 
    Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>, 
    Qiang Yu <qiang.yu@oss.qualcomm.com>, 
    Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: Re: [PATCH v3 2/8] PCI/ASPM: Add pci_force_enable_link_state() API
In-Reply-To: <20261013163107.GA1522779@bhelgaas>
Message-ID: <2517d322-9e5d-5b81-aa67-56705879be74@linux.intel.com>
References: <20261013163107.GA1522779@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-2133506109-1791910896=:21507"
Content-ID: <26a95089-31f0-9c7c-e696-b88359198360@linux.intel.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2133506109-1791910896=:21507
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <c9ae739a-d76a-a4da-d400-ab79af0b37d5@linux.intel.com>

On Tue, 13 Oct 2026, Bjorn Helgaas wrote:
> On Tue, Oct 13, 2026 at 02:41:32PM +0300, Ilpo J=E4rvinen wrote:
> > On Mon, 12 Oct 2026, Bjorn Helgaas wrote:
> > > On Wed, Jul 08, 2026 at 04:30:16PM +0200, Manivannan Sadhasivam wrote=
:
> > > > From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com=
>
> > > >=20
> > > > pci_enable_link_state() and pci_enable_link_state_locked() APIs onl=
y enable
> > > > the ASPM states that were not previously disabled via
> > > > pci_disable_link_state*() API or blacklisted during init (e.g. the =
pre-1.1
> > > > device blacklist, which is only meant to be overridden with
> > > > 'pcie_aspm=3Dforce'). This is an intentional behavior as these APIs=
 must not
> > > > silently re-enable states that were deliberately disabled, since do=
ing so
> > > > could enable ASPM on a link where it is known to be unsafe.
> > >=20
> > > I think this is saying that many uses of pci_disable_link_state() are
> > > to avoid hardware errata, i.e., these are basically quirks, and we
> > > should *never* enable those ASPM states.
> > >=20
> > > > However, some drivers (e.g. the atheros WLAN drivers) save the curr=
ently
> > > > enabled ASPM states, disable all ASPM states before firmware downlo=
ad, and
> > > > then try to restore exactly the states that were enabled before. Re=
storing
> > > > those states requires re-enabling states that were just disabled vi=
a
> > > > pci_disable_link_state() API. But, this cannot be achieved using th=
e
> > > > existing APIs.
> > >=20
> > > This sounds like it's also for hardware errata: if ASPM works
> > > correctly, there's no need to disable it during firmware download.  I
> > > think this is *only* the atheros drivers, isn't it?  I didn't see any
> > > others.
> >=20
> > There are more that should use disable/enable API. In addition ath*, I =
had=20
> > also these in my unfinished series:
> >=20
> >   brcmfmac
> >   ib-hfi1
> >   rtlwifi
> >   rtsx
> >   r8169
>=20
> Thanks for those pointers!
>=20
> > > > Hence, add pci_force_enable_link_state() API for such callers. Unli=
ke
> > > > pci_enable_link_state(), it re-enables the requested states even if=
 they
> > > > were previously disabled via pci_disable_link_state() or disabled d=
uring
> > > > init. The caller is therefore responsible for only enabling states =
the
> > > > device actually supports, typically the ones previously reported by
> > > > pcie_aspm_enabled().
> > >=20
> > > The problem is that pci_enable_link_state() cannot enable things that
> > > were disabled by pci_disable_link_state().  They're not symmetric,
> > > which violates the caller's expectation.
> >=20
> > Yes.
> >=20
> > This patch seems to come with my Suggested-by but what I suggested (and=
=20
> > had a patch for) was to make disable/enable proper symmetric pairs beca=
use=20
> > it is very trappy otherwise. If something else is needed in addition, t=
hat=20
> > should be named differently like Bjorn also seems to suggest (however s=
ee=20
> > my alternative suggestion below).
> >=20
> > I renamed the current pci_enable_link_state() to=20
> > pci_set_default_link_state() in my own attempt to get room for adding t=
he=20
> > symmetric pair.
>=20
> We might need new names for pci_enable_link_state(),
> pci_disable_link_state(), and the quirk thing.  If we keep the same
> names, I think it will be pretty complicated to manage the changing
> semantics when backporting driver changes that use them.

I'm not good at picking names, but yes, reusing a name in the same=20
kernel cycle using the same signature is asking for trouble.

> > > Instead of adding pci_force_enable_link_state(), I think we should ad=
d
> > > a new interface for the *quirk* behavior that permanently disables
> > > states.  Then pci_enable_link_state() and pci_disable_link_state()
> > > could be made symmetric.
> >=20
> > My suggestion is to make the disables/enables counted per state which=
=20
> > would allow parallel sources of disables to function without clashing.
>=20
> By parallel sources, are you thinking of sysfs and driver calls?  If
> locking would be sufficient I think that would end up being simpler.
>
> But maybe the issue is these devices where we think ASPM breakage only
> happens in certain circumstances, e.g., firmware download, so we want
> to keep states disabled for that period.  Then I guess locking inside
> the enable/disable doesn't prevent sysfs from enabling those states
> during that period.

There are (at least) these sources:

- quirks (disable only)
- hw has ASPM related problem at certain phase of operation
- sysfs
- lane margining (the proposed patch)

I don't think locks can really solve this well as the sources seem largely=
=20
independent from each other and are not necessarily short-lived periods=20
(one could perhaps say some cases occur early enough the other sources don'=
t=20
matter but there are still enough sources even with that considered so=20
that disable/enable pair could overlap, potentially leading to unwanted=20
enable of a state).

IIRC, L0p was also incompatible with ASPM states. But it could be HW is=20
fine with both being configure at the same point of time (I've not checked=
=20
the spec with that in mind).

> > Disable quirks could simply not have the pairing enable, no special=20
> > interface needed.
>=20
> I'm not sure what this looks like to the caller.  A parameter that
> says whether to count the disable?

A quirk would just makes pci_disable_link_state(pdev, PCIE_LINK_STATE_L1)=
=20
call (or whatever that ends up being called if a new name is selected),=20
which increases disabled counter for L1 state. As there's no pairing=20
enable, L1 cannot be enabled anymore by anything.

Only if the particular state disable counter is 0, the ASPM driver allows=
=20
enabling that state or the other states depending on that state.


Sysfs accessors need to keep an additional bit per state to not request=20
multiple disables/enables for a single state. The rest of the sources have=
=20
it naturally from their operation and pairing disable/enable calls.

> I think having a different function name would be helpfully
> descriptive because permanently removing an advertised capability is
> different from temporarily disabling a feature.

--=20
 i.
--8323328-2133506109-1791910896=:21507--
