Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F5346AA9C;
	Fri,  2 Oct 2026 21:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790977262; cv=none; b=sMSzZd2lnYenoyYF395BDHROvKTcfHZ4QWBEQpiMhPsqcir6w/Wt7lY7qNMidDH+adGQnrNV39j/ZxgIc/d8ayVS3axGrKKet+5tdhQdMf3k7griFLq1cDZpNkyfkLKXU/sCo38xf+iZqHw+oQt5QmqAcH/v9xHVfRjWczxmd9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790977262; c=relaxed/simple;
	bh=Jo/5dugZh4Ny+wdhiWvf9iwKHvuRL9KA6JlWJlTgqFY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ecZXFHxmtbRLw4UoP7ez82RYnOypFabyv9WObiitZZqD5ZZd3wHobrCKff79BGQw2B0hOYhckQq5XJbevj6NtizE7GQs8eCzAbGtOxxcJv+jSBgoaCpgH2E29jFXlMbEym5uKGn4EgUdSmezSus7/PODs6mouqSaXIi9912/90o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QLeXmgTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QLeXmgTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093F71F000FF;
	Fri,  2 Oct 2026 21:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790977260;
	bh=61/R3wV1NWOE7HoqVebj9mBBmgNaHG+WOnm/3sC4cmQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=QLeXmgTDJEE8p5eWTzIXSvYXsfvtao+l8O8886gPdU1izn35ejFHcWBvDWnftjgDw
	 ZxiJvtS1vONSgMAEkyW0mOlyURTGbgSjHJmpKwbfQ5NsVblwokR3GXK5u7ff//bVL6
	 mp9IiYPz+CmRPKkF4c754VWqF5xLjibG8VtpoQVu8Sf/BzmHHfTUukmPdmfFStm5iz
	 4TSRk9l1CBq54U+4nwwnqkKrmG2Vef2V1GChyQjuWaJ7JxLi7JgQVxU1TI2dntf3Li
	 tPQhO8cho59LNs5j6EegyuBt3w9L4GjFadc1h2kcML6BaiShNUh58so/5IER2kHC8N
	 j7LQiwQDB//hg==
Date: Fri, 2 Oct 2026 16:40:58 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Alex Williamson <alex@shazbot.org>
Cc: bhelgaas@google.com, mani@kernel.org, jjohnson@kernel.org,
	linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org, ath12k@lists.infradead.org,
	mhi@lists.linux.dev, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v14 0/2] PCI: Add device-specific reset for Qualcomm
 devices
Message-ID: <20261002214058.GA284603@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917071651.14174-1-jtornosm@redhat.com>

[cc->to: Alex, +cc Jason]

On Thu, Sep 17, 2026 at 09:16:49AM +0200, Jose Ignacio Tornos Martinez wrote:
> Some Qualcomm PCIe devices (WCN6855, WCN7850 WLAN; SDX62/SDX65 modems)
> lack working reset methods for VFIO passthrough scenarios. These devices
> have no FLR capability, advertise NoSoftRst+ (blocking PM reset), and have
> broken bus reset (addressed by quirk_no_bus_reset, merged for v7.2).

Specifically, 6a4f64c3a3ad ("PCI: Avoid SBR for Qualcomm
WCN6855/WCN7850 WiFi, SDX62/SDX65 modems").  I don't know what the
behavior was prior to that commit.  I suppose it was something
obvious?

> VFIO attempts to reset devices on every reassignment:
> - For the listed modems, without a proper reset capability, these devices
> never successfully initialize even on first VM assignment.
> - For the listed WLAN devices, without a working reset method, the attempt
> fails. On clean VM shutdown, the guest driver properly deinitializes the
> device via .shutdown/.remove callbacks, leaving it in a usable state despite
> the failed reset. However, on unclean VM termination (crash, force-off), the
> guest driver callbacks are not triggered, the device remains in an undefined
> state (DMA active, interrupts enabled, etc.), and without a working reset it
> cannot be reused.

So IIUC, prior to these patches, these devices were functional when
passed through to several successive guests as long as the guests shut
down cleanly, but the resets done by VFIO didn't work, so the host
couldn't enforce isolation between those guests.

If true, I propose updating the commit logs to emphasize the lack of
isolation and de-emphasize the VM clean shutdown vs crash behavior,
e.g.:

  Resets of this device always failed prior to this commit, so VFIO on
  the host could not enforce isolation between successive passthrough
  users.

  If a guest driver deinitialized the device, it may have been
  functional if passed through to a subsequent guest, despite the lack
  of isolation.  Otherwise the device may have been left in an
  undefined state (e.g., DMA and interrupts active) and unusable.

It would also be great to have Alex's ack here.

> Add device-specific reset methods using BAR-space hardware reset registers
> that exist in these devices:
> 
>   Patch 1: SDX62/SDX65 modem reset via MHI SoC reset
>   Patch 2: WCN6855/WCN7850 WLAN reset via SoC global reset
> 
> These are true hardware reset mechanisms (not power management or firmware
> error recovery), providing proper device reset for VFIO scenarios.
> 
> Testing shows stable operation over 100+ VM crash/reset cycles. Device-
> specific reset is position #1 in the reset hierarchy, so these devices
> will use hardware reset as their primary reset method.
> 
> Jose Ignacio Tornos Martinez (2):
>   PCI: Add device-specific reset for Qualcomm SDX62/SDX65 modems
>   PCI: Add device-specific reset for Qualcomm WCN6855/WCN7850 WLAN
> 
>  drivers/pci/quirks.c | 116 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 116 insertions(+)
> 
> ---
> v14: Address Bjorn Helgaas feedback:
>   - Split WLAN and modem resets into two separate patches
>   - Clarify commit message for WLAN devices: VFIO resets on every
>     reassignment, clean shutdown leaves device in usable state via
>     driver callbacks, but unclean termination is where the lack of reset
>     is critical
>   - No code changes from v13, only patch split and commit message
>     clarification (Mani's Reviewed-by retained)
> v13: https://lore.kernel.org/all/20260915223634.GA878346@bhelgaas/
> 
> --
> 2.54.0
> 
