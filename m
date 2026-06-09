Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A1A43635E;
	Tue,  9 Jun 2026 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781016335; cv=none; b=Iabpq2ROSMxnLVfBu9Acse3PmeMQ7+Znmyuk3lknnJ+wzXHz87D/kcMAgbKt7aYkg84A2fuOSTSOUUWEsPSJ68spJ41lVhLzrqgg9ev3yaodi39Mk+6FtyGwSk88vZ3hDYBvkvrl+LfG3u4IHQEZWkqhjiam5Zbr/ND1i6uGxGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781016335; c=relaxed/simple;
	bh=j6tC4XvNLCSrmGlsdlptyNckumJ7AQ6LxOk2sA6mJn8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=mUoK54aybOp1WrMNnrC/jiU1Y2ZgUAxpHPrgoViMYh9U3LcdJ2PafV+CYuJ/ZEZgvQqL5O17gaYWpTFKFtATANXY4ZNlGE63xzbl8O7fHID7z6MWYLlrpDT7pHRVJhL9KC0AKiQWsBHzJtnCh6/OccYgyEdkoUtgAtgTxFAnUo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ihlrrl6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ihlrrl6Q"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3E2571F00893;
	Tue,  9 Jun 2026 14:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781016333;
	bh=DT+xz6ypM6hLHzaMyiMzGKHLZEoQ1yT2AY12QYD03q4=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=ihlrrl6QKkW/FD9GEoNkCG0RChf9wGHv7Jq6WCnwXPrLxInhHx1obFW1ja84FlIXK
	 dOqCw3KTLzFF12vb3aFIf7zPxxv1/uTTdTnnXXW/9DzuWJgvLC0vOdzVnXfIFlR3Wi
	 37xUSVXBJe1zwk44SEFm4jX8WcPsa3ldmj55tuZQQArYCK1Zx1A+iW2rV4/f/icj6L
	 2fLjlwvS9KOVLpMIZhCX1tVorLU6NmHi7tLrVJ/zOkEgTk3QAnNSkstODffwLJBMug
	 FSpo9sHE+s0o9xENr17R/XBUd6b5gw4HS0lkwWMkUvwiuWNCezFGJ+ZrpdtkeWz99V
	 uESCTXxlKBhtw==
Date: Tue, 9 Jun 2026 09:45:32 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Alex Williamson <alex@shazbot.org>
Cc: bhelgaas@google.com, nbd@nbd.name, lorenzo@kernel.org,
	shayne.chen@mediatek.com, sean.wang@mediatek.com,
	linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] PCI: Disable broken FLR on MediaTek MT7925
Message-ID: <20260609144532.GA104629@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522070646.203115-1-jtornosm@redhat.com>

[cc->to: Alex]

On Fri, May 22, 2026 at 09:06:46AM +0200, Jose Ignacio Tornos Martinez wrote:
> The MediaTek MT7925 WiFi device advertises FLR capability, but it does
> not work correctly. This manifests in VFIO passthrough scenarios: normal
> VM operation works fine, including clean shutdown/reboot. However, when
> the VM terminates uncleanly (crash, force-off), VFIO attempts to reset
> the device before it can be assigned to another VM. Because FLR is broken,
> the reset fails preventing reuse.
> 
> This is similar to its predecessor MT7922 (see commit 81f64e925c29 ("PCI:
> Avoid FLR for Mediatek MT7922 WiFi")), but with different symptoms.
> The MT7922 issue manifests as config read failures (returning ~0) after
> FLR. The MT7925 shows different behavior: config reads work correctly
> after FLR, but firmware communication fails.
> 
> First VM start with MT7925 works fine:
>   mt7925e 0000:08:00.0: ASIC revision: 79250000
>   mt7925e 0000:08:00.0: WM Firmware Version: ____000000, Build Time:
>     20260106153120
> 
> After force reset or VM crash, when VFIO attempts FLR to reset the device
> for reassignment, firmware initialization fails:
>   mt7925e 0000:08:00.0: ASIC revision: 79250000
>   mt7925e 0000:08:00.0: Message 00000010 (seq 1) timeout
>   mt7925e 0000:08:00.0: Failed to get patch semaphore
>   [Repeats with increasing sequence numbers 2-10]
>   mt7925e 0000:08:00.0: hardware init failed
> 
> The driver cannot acquire the patch semaphore needed for firmware
> initialization, indicating that FLR does not properly reset the firmware
> state. The device remains in this broken state until physical power cycle.
> 
> Disable FLR for MT7925 so the PCI core falls back to Secondary Bus Reset,
> which successfully resets the device and allows reinitialization for VFIO
> passthrough reuse.
> 
> Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

Applied to pci/virtualization for v7.2, thanks!

Alex, are you OK with this?  The v2 conversation talks about SBR also
being broken, but maybe that turned out to be a red herring?

  https://lore.kernel.org/linux-pci/20260508145153.717641-1-jtornosm@redhat.com/t/#u

> ---
> v4: Improved commit message with specific dmesg evidence showing firmware
>   initialization failure after FLR (Bjorn Helgaas feedback)
> v2: https://lore.kernel.org/all/20260521061205.12727-1-jtornosm@redhat.com/
> 
>  drivers/pci/quirks.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 000000000000..111111111111 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -5607,6 +5607,7 @@
>   * Intel 82579LM Gigabit Ethernet Controller 0x1502
>   * Intel 82579V Gigabit Ethernet Controller 0x1503
>   * Mediatek MT7922 802.11ax PCI Express Wireless Network Adapter
> + * Mediatek MT7925 802.11be PCI Express Wireless Network Adapter
>   */
>  static void quirk_no_flr(struct pci_dev *dev)
>  {
> @@ -5617,6 +5618,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_MEDIATEK, 0x0616, quirk_no_flr);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_MEDIATEK, 0x7925, quirk_no_flr);
> 
>  /* FLR may cause the SolidRun SNET DPU (rev 0x1) to hang */
>  static void quirk_no_flr_snet(struct pci_dev *dev)
> --
> 2.53.0
> 
