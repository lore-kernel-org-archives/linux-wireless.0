Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA1632ED4E;
	Tue,  9 Jun 2026 14:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781015985; cv=none; b=TFP4wvVeFlH78i3r6W2F9KizD/yO77eH914LjMo60JwcoP3ZW3g/ojWBcPpZxmE3VLQaXyc/7PI2qrKgAak5sxxX5h1MJVVr9CXEUsBXZvgbaiKoHR/LHJIYga4e077VNpoHWzecipcUAo1vUlvS2wLLLBK253jvMbv+kSM8V0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781015985; c=relaxed/simple;
	bh=tx+RGX710rlKVricjzG+qqBSm8QEDsNAzbQzxI0kCqI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=XBnYc+u9+krzwUhmrzr8CI56Gmi42T2UCU203uhXSFAohS+s+aq/bZqMVxDq9LoFYWZmVgzumWg8gi33rLfD/0U/uPxo5A0mhMWCs2Lb9bJDwCHm7R6Gemv/asme/mgOPR9k/tbq3TLyigPLDOp89TKEYvPFww8fE4OeGVwjJEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6VR4WMH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6VR4WMH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F23991F00893;
	Tue,  9 Jun 2026 14:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781015984;
	bh=Tv4LQA9WkLY2yp77TSC4KzBd3f1OkTg+7YcTFAVgEC0=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=G6VR4WMHeUELtLF0rDBX6GBtQoodW7EWB72rcgYI5C1En2G4rQ+AdpXVcOJ310dgs
	 6UXXu2+WIQnmYqlF0M/xZbvgw+awFx2uWQE1UVKE++JelYi5ELDM76nXv6Plm50rjR
	 /k4TOcadjAqxLDg0lP9ZIYtzhsH1wRs16k/40V8J80D7qnA+8zDKaaJfamShJzySpm
	 H2mITCCtgTFdh9b+40qWIhb6hfqIfcGGr/YXLLPkxeLaqSEQASOe33d5AVj9c/5ziA
	 BclA+aCcyqe7RstWsb5fWHrPa21QobYV7nBhm73FQBxIyIHtDxuEffCYusJ5a5jDTO
	 KxqKsjKxIKjnw==
Date: Tue, 9 Jun 2026 09:39:42 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: manisadhasivam.linux@gmail.com
Cc: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] PCI: Disable broken FLR on MediaTek MT7925
Message-ID: <20260609143942.GA104064@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGyK6cpa89aHZELLBnc9nBwQdivir7-P9_e+CLQKzbzQzXWjsg@mail.gmail.com>

[cc list trimmed]

On Tue, Jun 09, 2026 at 06:36:38AM -0700, manisadhasivam.linux@gmail.com wrote:
> On Fri, 22 May 2026 09:06:46 +0200, Jose Ignacio Tornos Martinez
> <jtornosm@redhat.com> said:
> > The MediaTek MT7925 WiFi device advertises FLR capability, but it does
> > not work correctly. This manifests in VFIO passthrough scenarios: normal
> > VM operation works fine, including clean shutdown/reboot. However, when
> > the VM terminates uncleanly (crash, force-off), VFIO attempts to reset
> > the device before it can be assigned to another VM. Because FLR is broken,
> > the reset fails preventing reuse.
> >
> > This is similar to its predecessor MT7922 (see commit 81f64e925c29 ("PCI:
> > Avoid FLR for Mediatek MT7922 WiFi")), but with different symptoms.
> > The MT7922 issue manifests as config read failures (returning ~0) after
> > FLR. The MT7925 shows different behavior: config reads work correctly
> > after FLR, but firmware communication fails.
> >
> > First VM start with MT7925 works fine:
> >   mt7925e 0000:08:00.0: ASIC revision: 79250000
> >   mt7925e 0000:08:00.0: WM Firmware Version: ____000000, Build Time:
> >     20260106153120
> >
> > After force reset or VM crash, when VFIO attempts FLR to reset the device
> > for reassignment, firmware initialization fails:
> >   mt7925e 0000:08:00.0: ASIC revision: 79250000
> >   mt7925e 0000:08:00.0: Message 00000010 (seq 1) timeout
> >   mt7925e 0000:08:00.0: Failed to get patch semaphore
> >   [Repeats with increasing sequence numbers 2-10]
> >   mt7925e 0000:08:00.0: hardware init failed
> >
> > The driver cannot acquire the patch semaphore needed for firmware
> > initialization, indicating that FLR does not properly reset the firmware
> > state. The device remains in this broken state until physical power cycle.
> >
> > Disable FLR for MT7925 so the PCI core falls back to Secondary Bus Reset,
> > which successfully resets the device and allows reinitialization for VFIO
> > passthrough reuse.
> >
> > Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Just FYI, b4 complains:

  NOTE: some trailers ignored due to from/email mismatches:
      ! Trailer: Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
       Msg From: manisadhasivam.linux@gmail.com <manisadhasivam.linux@gmail.com>

I applied your R-b manually.
