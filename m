Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5889D395AD1;
	Fri, 16 Oct 2026 05:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792129124; cv=none; b=Uv3G7rUfzfuWH1woy0GdFS8ucYoC35ltE7yii9B/mgCa/eiIDN1gc6pJAYfKcgZu51UtfsVo+nBIOrOv6eynZgJHWB/wZOReVVmqeCqB5VetPl4w5cI+B/21IiQK9lci1nbDOIIW87dM+qSXMXFWZNtUyxsw1FceTRs9sK2XVLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792129124; c=relaxed/simple;
	bh=yRN3IHAhSLlcnOHRWDVjO0jp4mGUUNVEuWi+SGMy2w4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOk2wM8d92q9NM6lHIYsVD4n9K0vcMmsFooUvS4fwLdbUt7PqaFDXURET/jrb9kcjIii7hHv8fi23ZWIJ1HVI2LRyqaB9TgF0/Dq4BlCmkqKteNDLYpORp798fwbU23ZUKj4GYEl2eGtNYcnhE1cFeD+VazAxvz4egKkl2c+hFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGISrgXL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGISrgXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45551F000C4;
	Fri, 16 Oct 2026 05:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792129122;
	bh=ktqFSsAx52niNcMbY6VRLuj3WY+yJAl8EZhfxOg24+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TGISrgXLsZT/CTjeLsAIaY1W0qIJ+pKBQSG0YeThNt4I/0JCvBaoFTZAPXWGmHCad
	 FsWo1l2SSLWIKzSvLrhQpv5RbEyMiS+3pLkdKeUqdI9Uk4YLk/L/vJ2HvpJaGqnDDO
	 +xukVVIwCLfi9Vf2MFtSwhWzIhF20wpuJ+19jo3+tYu6fOGJZ1jb3P3d7137vUmDcE
	 VXwdaCVqJW2wbuIlM5oNG8z7Xoa2OlFQ1P8YDaXGTBofxnC5/nd93f02C2zlRsXGwa
	 Es0sLy0Tre9LPf3lT0Es5b2CEG0RwsvGfI7IcwB7oqKiYzEIxG7NnvW+SDXs2+7s7s
	 tytdwblQwdoDA==
Date: Fri, 16 Oct 2026 11:08:29 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Rob Herring <robh@kernel.org>, Nirmal Patel <nirmal.patel@linux.intel.com>, 
	Jonathan Derrick <jonathan.derrick@linux.dev>, Jeff Johnson <jjohnson@kernel.org>, linux-pci@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath12k@lists.infradead.org, ath11k@lists.infradead.org, ath10k@lists.infradead.org, 
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>, Qiang Yu <qiang.yu@oss.qualcomm.com>, 
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH v3 1/8] PCI/ASPM: Always disable ASPM when driver
 requests it
Message-ID: <atG4Gaq7GLiq2H7t@debian>
References: <20260708-pci-aspm-fix-v3-1-6bd72451746e@kernel.org>
 <20261015230714.GA1802070@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261015230714.GA1802070@bhelgaas>

On Thu, Oct 15, 2026 at 06:07:14PM -0500, Bjorn Helgaas wrote:
> On Wed, Jul 08, 2026 at 04:30:15PM +0200, Manivannan Sadhasivam wrote:
> > From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > 
> > PCI core/ASPM service driver allows controlling ASPM state through
> > pci_disable_link_state() API. It was decided earlier (see the Link
> > below), to not allow ASPM changes when OS does not have control over it
> > but only log a warning about the problem 'commit 2add0ec14c25 ("PCI/ASPM:
> > Warn when driver asks to disable ASPM, but we can't do it")'.
> > 
> > A number of drivers have added workarounds to force ASPM off with own
> > writes into the Link Control Register (some even with comments
> > explaining why PCI core does not disable it under some circumstances).
> > According to the comments, some drivers require ASPM to be off for
> > reliable operation.
> > 
> > Having custom ASPM handling in drivers is problematic because the state
> > kept in the ASPM service driver is not updated by the changes made
> > outside the link state management API.
> > 
> > As the first step to address this issue, make pci_disable_link_state()
> > to unconditionally disable ASPM so the motivation for drivers to come
> > up with custom ASPM handling code is eliminated.
> > 
> > To fully take advantage of the ASPM handling core provides, the drivers
> > that need to quirk ASPM have to be altered depend on PCIEASPM and the
> > custom ASPM code is removed. This is to be done separately. As PCIEASPM
> > is already behind EXPERT, it should be no problem to limit disabling it
> > for configurations that do not require touching ASPM.
> > 
> > Make pci_disable_link_state() function comment to comply kerneldoc
> > formatting while changing the description.
> > 
> > Link: https://lore.kernel.org/all/CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com/
> > Link: https://lore.kernel.org/all/20230511131441.45704-1-ilpo.jarvinen@linux.intel.com/
> > Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > [mani: commit message fixup]
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> I was a little confused about the provenance of this patch.  It
> *looks* like it should have been posted somewhere by Ilpo and
> something tweaked by Mani when applying, but none of the links above
> are a posting of this patch.  I dug around and found
> https://lore.kernel.org/linux-pci/20230918131103.24119-4-ilpo.jarvinen@linux.intel.com/,
> and this patch looks like basically the aspm.c part of it, so I assume
> that should probably be the https://patch.msgid.link/?
> 

Ilpo shared this patch during the review of v1 of this series:
https://lore.kernel.org/linux-pci/52baf40b-41ed-2588-7817-4d8cd859e0d1@linux.intel.com/

> To fix the provenance and the "Drivers can controlling" typo mentioned
> by Ilpo, I replaced this with just the aspm.c changes from
> https://lore.kernel.org/linux-pci/20230918131103.24119-4-ilpo.jarvinen@linux.intel.com/
> and added the CONFIG_PCIEASPM dependency to the commit log.  The code
> change is the same.
> 

This looks good to me.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
