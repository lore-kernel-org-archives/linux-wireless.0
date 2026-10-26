Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793040495;
	b=pAqJiWcsArqjkdr8vutcgNFB8ILqVEy/MNuQn1mB8lWnifpXeWm8+0DssUmEADP4QGR7
	 kczMFM+rpk54c3OM2K2WYDDDW3erhYCxNh+QXJ7iBWEJOx2ZvB3pKOScFhGIk0BucUf5N
	 FfbymMfgygwwZ/z+jm8nbufC54t06AZy+dOvNBfwL6LEDznhnEJWTLWbiMGFF2ZxgguUd
	 MjTdkTZzu+dN5Hzrx+K/LU4CiMvb0I75eZgN1WPsn27gNUpMvI2GKIBSHZjjNyxsDz4zq
	 3LO/P4pKgrPwimQGGqmB9vY2hRbert9IwKIKQUejP1+UM+HML1UFY/YS5+YMXe2NV2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793040495;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OFgOBq7srdyS3DTXSaBZpYgi1nhuYA9dhuW6lCLNCpc=;
	b=Ap/HMGxpn8F0zOEejMNVJxnKTozzkSSX+15EtvG5ZMPVsqUIgwxLlR/+xwfLRNScpTjM
	 +4bi3o5+hErqo+VJtRGIX3Uw8kvDFtOkxbet2VNfDsjcQ8AcFT2IgBztG08OfihmS02lM
	 WPNQ06Ylg7YhuZmllp2guiCxNODho4jEK/DQAlwDv5hObcv5xIAuNzILI3iPlCe6iDa/z
	 m+YmrDLJjL9gFq2uuAzOnN1rOFswFw/28XnqdTiaX33X9fFGsXq6cAySOVJyxuCxS0pTV
	 Qd2q/T4kCNAbm4fhaSrN9kiB7QunBOmxTZ1vTrejxNVWLyreHUX5FIV/KeXd4zz/wIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g270PxXR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B31606A31A;
	Mon, 26 Oct 2026 18:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g270PxXR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0161F01825;
	Mon, 26 Oct 2026 18:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793040494;
	bh=OFgOBq7srdyS3DTXSaBZpYgi1nhuYA9dhuW6lCLNCpc=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=g270PxXRHl932rwmRbdsArXuijZoXYbPzhaWRbr82mx/eqVUDHtXq8LBw4WrfiA0v
	 ekffoLuJy31YZYtOZsxlaXE/XFQFr9oUTA0Z71G+d9DJd4zl6Qbqt0ScOmLbP6NfwU
	 DP89865RLciWDTbAJ0dk+/F8QrRbBPwGMDDH0VWwm95FYM83hZvRfhhylKX2b5333/
	 FidG0jTcEdwMRF5po75YgODIAUl9nXgKyo+k8xib4oBGK3sa8swkypFmr7gbfz1Uec
	 T8YyZwPC63lbZ8T0NjjJgz/m8r8h1c9i3RcvsWwOWG+E/UNqRW28djXtn/jRThgZYL
	 VGXCWSILYyBmw==
Date: Mon, 26 Oct 2026 13:48:13 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Denis Benato <denis.benato@linux.dev>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com,
	linux-wireless@vger.kernel.org, miriam.rachel.korenblit@intel.com,
	emmanuel.grumbach@intel.com, linux-kernel@vger.kernel.org,
	kernel@lists.opengamingcollective.org
Subject: Re: [PATCH 1/1] PCI: Disable D3cold for Killer BE200-family WiFi on
 MSI Claw A1M
Message-ID: <20261026184813.GA342157@bhelgaas>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025231813.128649-2-denis.benato@linux.dev>

On Sun, Oct 25, 2026 at 11:18:13PM +0000, Denis Benato wrote:
> During s2idle the platform removes power from the WiFi slot (D3cold).
> The Killer BE1750 (Intel BE200, 8086:272b) installed in the MSI Claw A1M
> fails to resume from that state: the PCIe link does not retrain
> ("pcieport 0000:00:1c.0: Data Link Layer Link Active not set in
> 100 msec") and every device register reads back as 0xffffffff, so the
> card disappears from the bus and the machine must be power-cycled.
> 
> Keeping the device in D3hot with the link in L1.2 during system sleep
> makes suspend and resume work reliably: the package still reaches >99%
> S0ix residency and the card survives every cycle (verified over multiple
> suspend/resume tests with an RTC-timed wake).
> 
> Disable D3cold for the BE200-family device on this board. This mirrors
> the udev-level workaround distributions already ship for the AX200/AX210
> (8086:2725), which suffers from the same class of problem, and moves it
> into the kernel where it belongs.

If 2725 has the same problem, should we make the quirk apply to it
also?

I suppose this is a firmware problem with whatever is supposed to turn
the power back on?  Are there any firmware updates available?

> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220223
> Signed-off-by: Denis Benato <denis.benato@linux.dev>
> ---
>  drivers/pci/quirks.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 7572b358b50f..60156e6c3e49 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -6593,3 +6593,24 @@ static void pci_mask_replay_timer_timeout(struct pci_dev *pdev)
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_GLI, 0x9750, pci_mask_replay_timer_timeout);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_GLI, 0x9755, pci_mask_replay_timer_timeout);
>  #endif
> +
> +/*
> + * MSI Claw A1M: during s2idle the platform removes power from the WiFi slot
> + * (D3cold). The Killer BE1750 (Intel BE200, 8086:272b) fails to resume from
> + * that state: the PCIe link does not retrain ("Data Link Layer Link Active
> + * not set in 100 msec") and every device register reads back as 0xffffffff,
> + * so the card disappears from the bus and the machine must be power-cycled.
> + *
> + * Keeping the device in D3hot with the link in L1.2 during system sleep makes
> + * suspend and resume work reliably: the package still reaches >99% S0ix
> + * residency and the card survives.

From just this patch, I don't think we can assert the L1.2 link state,
can we?  AFAICS, this patch just prevents the use of D3cold.

> + */
> +static void quirk_msi_claw_be200_d3cold(struct pci_dev *pdev)
> +{
> +	if (!dmi_match(DMI_BOARD_NAME, "MS-1T41"))
> +		return;
> +
> +	pci_d3cold_disable(pdev);
> +	pci_info(pdev, "disabling D3cold: slot power removal during s2idle prevents resume on this system");
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x272b, quirk_msi_claw_be200_d3cold);
> -- 
> 2.55.0
> 
