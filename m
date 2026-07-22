Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED291E9B37;
	Wed, 22 Jul 2026 12:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784722635; cv=none; b=D5szYyyCf0jOp8GBW/gqa66HGbez9l3LMBWvpyDmiJePkKWCBUyelGsK7nsWuAXUR2ut/Sthcmx4nyza4eUGKM8TZDBVS7fdh2tw/f7wLo6+SMVjOSCBc98hhuuFowE/jh3KpoU0uusxu9AojXYi2YAcjFM5fIk2tjwMAUiMYRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784722635; c=relaxed/simple;
	bh=pCML7xd5rfy/phlXgpCrqUwKFRBHYn0XXUULzy5c6ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4uEYc1t6rDwn0jX9wnV9WXnUPOf5hgPHAv9efOpxPIaYph9UiJZ8eAiJNsw6C5JX2dKpLtS7IK/LdOxc4y9aZtc7eg5WhbiDEQem1BagqiPGfOXwpTvEJeusKnPbJY4kAEqTRO4Bxm4AKwIVL2G4kZn8pwru/w81GZgn83STsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IcsfQpRJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcsfQpRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA1B1F000E9;
	Wed, 22 Jul 2026 12:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784722634;
	bh=T9beRhF2jjJvFTZCtXWpywAw5rE3wHDEFmzE5t7fnUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IcsfQpRJs3YyBJzWUl/mvMT93RQ+AQOaw5S7BCqTxuIzAca8N+vOiQ/LeUOWs0haJ
	 6KYGyMBWt7MLsUJ9kEvvdXPCsoYFWAH/9YekTepHuPEcfse7rKv0Oe0lmY+NIw6guW
	 OfkCxTlNFKfuoJsjsQTqD757G6G3wNRD2sXMKaYcNJcZUrMxFYw0VqftePis0GmZDJ
	 H1su9VHuHVfhyrIVQa4Z3CQtZkfR59j18cbSdVgaKFN3qm1JH3s2zzjiVsUu3YPJKp
	 RmMgKeb0DB4BCmsP+zGknbmheuwekrcgAWiGP6qfXzexK3CfOc6uoBWy2z9D+9hiTs
	 8vgfgNkPiaCww==
Date: Wed, 22 Jul 2026 14:17:06 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: bhelgaas@google.com, alex@shazbot.org, sashiko-bot@kernel.org, 
	sashiko-reviews@lists.linux.dev, jjohnson@kernel.org, linux-pci@vger.kernel.org, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
	mhi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13] PCI: Add device-specific reset for Qualcomm devices
Message-ID: <d35ftvppjovbyb3va5ok3yy2l5ng2jliqidqa4szp7hrgalrf4@rbhj2ehrff3l>
References: <20260721082933.7B5A41F000E9@smtp.kernel.org>
 <20260722112813.33153-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260722112813.33153-1-jtornosm@redhat.com>

On Wed, Jul 22, 2026 at 01:28:13PM +0200, Jose Ignacio Tornos Martinez wrote:
> > [Severity: High]
> > Will this sequence of ioread32 flush reads and
> > read_poll_timeout trigger Master Aborts on architectures
> > with strict error handling?
> >
> > The SoC global reset explicitly drops the device PCIe link.
> > Performing ioread32 flush reads immediately after asserting
> > the reset, and then actively polling the disconnected MMIO
> > space with read_poll_timeout while the link recovers, can
> > result in Unsupported Request errors.
> >
> > On strict platforms like ARM64 or x86 servers with APEI/GHES
> > Firmware First error handling, these can escalate to fatal
> > Uncorrectable Errors and cause a host kernel panic when a
> > guest VM exits.
> >
> > Should this avoid MMIO flush reads during these reset
> > sequences and instead use fixed delays to safely bridge the
> > link-down period?
> 
> The SoC global reset at 0x3008 does not immediately drop the
> PCIe link. The flush reads execute while the device is still
> responsive - the actual reset takes effect during the
> subsequent msleep. The ath11k/ath12k drivers perform the same
> register accesses during this reset sequence, including on
> ARM64 Qualcomm platforms, without issues.
> 

Yes, Qcom devices supporting SoC reset have a mechanism to keep the PCIe link
alive (in L0/L1) when the reset gets triggered in the device. So the register
access is available throughout the reset cycle.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
