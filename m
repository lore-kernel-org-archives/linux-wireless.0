Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87BD313E36;
	Mon,  5 Oct 2026 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791218504; cv=none; b=lQelC+a5pOt9Q6hBYUZalkjGNoqU7s6erOLmtblwvSOHEWE0aZgY9HUFmCn0gxOvvYadXT5XwG1VeAC7EQ5i3BfznfQxM5QdaluE/8FHd9sRlc4PP25uRySY7gvbG3ZIIYqFfZ8EJoM+BJIo4C+wklMK0g5W4znjs/SqrLYAzIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791218504; c=relaxed/simple;
	bh=+X2OntxrMTq2KSrF/FK1TbUaOawdn0FYEbaeGy3cIa8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=bk/ekS7blznSbsrS59suNtJBpd4B8kuKpDksrDi8BkSViGMmN8xWIAB0w/Sh1QSKv3bCuGa7mPYcm4HI1fYuFD+w2SpkNdVJK8Osah/skvFFRzLAJ2/HKMRhyy2qCapQ58C8UjtJZkyYCQ3wa4oFk+ZTmzOkoyzluuO1YutNy2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmEars6e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmEars6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E841F000FF;
	Mon,  5 Oct 2026 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791218503;
	bh=ACSssUGKie/5eVZn/j7clwXvC4MTmISK/f7AzHTT/3A=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=hmEars6ew5+YbrRD+7XLCHSA9cc1J3iBUUrqtEQ7cEbqkGUIC2ch7qbL8VmiPjUQT
	 XlduUY3JUBTpbVMnZx+7LLH9rETL1YIlR+PwqK2+x1iNA60y3QJ4+sYhvWVFhBKm0i
	 MEkiWKRHfQVXfTW82ZNrJ2R3AfKVdKuHLEdmL7FMpxQVwIkoWT8vPUEOnPLnPCHTjw
	 8Pv+aQmncE1OfyyDaAqYzTbv96s/SCAZh/SviCUvZCmltKHAA0rm0ksnofutqgH2SX
	 cMokhwVuYDjTOFpUKbQSD8k1vKLUskl58yfzGvTyHX+hRbLxdtTqLglJgZEw8KmJZq
	 DwXOhjqIy9FZQ==
Date: Mon, 5 Oct 2026 11:41:41 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: bhelgaas@google.com, alex@shazbot.org, mani@kernel.org,
	jjohnson@kernel.org, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, mhi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 0/2] PCI: Add device-specific reset for Qualcomm
 devices
Message-ID: <20261005164141.GA574887@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005105436.83962-1-jtornosm@redhat.com>

On Mon, Oct 05, 2026 at 12:54:34PM +0200, Jose Ignacio Tornos Martinez wrote:
> Some Qualcomm PCIe devices (WCN6855, WCN7850 WLAN; SDX62/SDX65 modems)
> lack working reset methods for VFIO passthrough scenarios. These devices
> have no FLR capability, advertise NoSoftRst+ (blocking PM reset), and have
> broken bus reset.
> 
> Standard reset methods were already disabled for these devices by commit
> 6a4f64c3a3ad ("PCI: Avoid SBR for Qualcomm WCN6855/WCN7850 WiFi,
> SDX62/SDX65 modems") because they were not working (quirk_no_bus_reset).
> 
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
> 
> Add device-specific reset methods using BAR-space hardware reset registers
> that exist in these devices:
> 
>   Patch 1: SDX62/SDX65 modem reset via MHI SoC reset
>   Patch 2: WCN6855/WCN7850 WLAN reset via SoC global reset
> 
> These are true hardware reset mechanisms (not power management or firmware
> error recovery), providing proper device reset for VFIO scenarios, allowing
> to enforce isolation between successive passthrough users.
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

Applied to pci/reset for v7.4, thanks!

> ---
> v15: Address Bjorn Helgaas feedback:
>   - Explain the relationship with 6a4f64c3a3ad ("PCI: Avoid SBR for Qualcomm
>     WCN6855/WCN7850 WiFi, SDX62/SDX65 modems") and previous status.
>   - No code changes from v14, only commit message clarifications (Mani's
>     Reviewed-by and Alex's Acked-by retained)
> v14: https://lore.kernel.org/all/20260917071651.14174-1-jtornosm@redhat.com/
> 
> --
> 2.54.0
> 
