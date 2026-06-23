Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD652EA732;
	Tue, 23 Jun 2026 05:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782192781; cv=none; b=uWVV5K3XqthTwwWV/HxsJjza2Q/Zrfk9W4cxswj0bXyXpgUZnrncFJvNiUwzdUljUBFmAb0vPd3IHl/JTmsDJtVrw4eS0WqedOfg+Vc8jQsFBSGLxP1O1jfFcxSKIwDBqn7Cfs/fMe68JcV8bK2HPGQu7cOqHN97uaUBGGiJHko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782192781; c=relaxed/simple;
	bh=ZQYFqy0/qZv9LhGvXbnZXFxN26fQvgAs/9zVX5lTC8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nxfr713P3jjbYhX5qA8nm609zcGNeJ/6+cnI82yi6dodqiAfTZJJAOz9h9ICD9D4ZNR5tMZ5TAB7XL3HZhnL4muWJUqp616xylNV2Px3RbqUFyW3FhzooN99PNKbGBv8ie+yQDdUpJJOMwNY8Y4vyzP7o7fzjk2wx+4mfvx5z/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnWsGh+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnWsGh+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E221F000E9;
	Tue, 23 Jun 2026 05:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782192780;
	bh=nRnmTVyRRl3BaJUm5m0mOjDwYXi6X6Hva20TicMSD7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LnWsGh+LQLMkEYbRWqmGgoksSDc9dxW/P0i9OHvZYcqK8YcswGQ9dXWFeiNObRysZ
	 1qoIaXagDUt5t//btSUei78KbHRdz3iowwGxkcZYEyDnGa/lKvLPi/1unx6aBtH74r
	 OhWasxJGT52fJve/Pkf7Chz476UeozkCBz+tvx2VQzZGlRkiSke4c3JPScoDmMNtK3
	 8sC9WvAhKxr990uqmF7sX7MqMs/m1mgAXkXrnFtpbnW/e9a1MnjBTF+R5zdYaugf0A
	 6Xkr4xlGh7Tr4PQ4W08j61Gew3N7DSCs97eGJt7FFS2WbTjhMBr+eNAQCGG5RE4HFb
	 ZSLj0WBRZAaug==
Date: Tue, 23 Jun 2026 07:32:50 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Alex Williamson <alex@shazbot.org>
Cc: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, 
	ath11k@lists.infradead.org, ath12k@lists.infradead.org, bhelgaas@google.com, 
	jjohnson@kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-wireless@vger.kernel.org, mhi@lists.linux.dev
Subject: Re: [PATCH v9] PCI: Add device-specific reset for Qualcomm devices
Message-ID: <r4jeqtx247iosfjdps6g4fqwtsdzine5qlgh33sdt4p6ktmaln@o725aolrpj4l>
References: <n3maiuu5cctivlal4fozysz37ir6ecdfws5u2xxw2neclsfdfj@nsvwvlh7b4j5>
 <20260618063309.9536-1-jtornosm@redhat.com>
 <4wmbans3ae5ayxqvs3wwn4hg3r3dcjuugmw2akoihvry35bq6k@k5lm6zjrp44l>
 <20260622160822.09350246@shazbot.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260622160822.09350246@shazbot.org>

On Mon, Jun 22, 2026 at 04:08:22PM -0600, Alex Williamson wrote:
> On Mon, 22 Jun 2026 18:22:39 +0200
> Manivannan Sadhasivam <mani@kernel.org> wrote:
> 
> > On Thu, Jun 18, 2026 at 08:33:08AM +0200, Jose Ignacio Tornos Martinez wrote:
> > > Hi Mani,
> > > 
> > > Let me clarify the exact scenario and where the reset is necessary:
> > > 
> > > * For the commented WiFi devices (WCN6855/WCN7850):
> > > 
> > > Standard VFIO passthrough flow (this works fine):
> > >   1. Unbind native driver (ath11k/ath12k/MHI)
> > >   2. Bind vfio-pci driver
> > >   3. Assign device to VM
> > >   4. VM boots, loads its own driver → device works perfectly
> > >   5. VM shuts down cleanly → device can be reassigned → works fine
> > > 
> > > The problem occurs with unclean VM termination:
> > >   1. VM crashes or is force-terminated
> > >   2. VFIO tries to reset the device before reassignment
> > >   3. Without a working PCI reset method, reset fails
> > >   4. Device stuck in undefined state → cannot be reassigned to another VM
> > >   
> > >      Unbinding the driver again doesn't help because the device hardware
> > >      itself is in a bad state. From hypervisor:
> > >      $ lspci -vvv -s 0000:03:00.0
> > >         03:00.0 Network controller: Qualcomm Technologies, Inc (rev ff) (prog-if ff)
> > >             !!! Unknown header type 7f
> > >      And a full host power-cycle is necessary to recover.
> > >        
> > 
> > Can you try the global reset available in the WLAN device BAR space?
> > 
> > WCN6855: https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git/tree/drivers/net/wireless/ath/ath11k/pci.c#n193
> > WCN7850: https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git/tree/drivers/net/wireless/ath/ath12k/pci.c#n182
> > 
> > > * For the commented modem devices (SDX62/SDX65): 
> > > 
> > > Even worse because it fails during the first VM boot without proper reset
> > > capability, standard VFIO passthrough flow:
> > >   1. Unbind native driver (MHI)
> > >   2. Bind vfio-pci driver
> > >   3. Assign device to VM
> > >   4. VM boots, loads its own driver and crashes:
> > >      [   24.024165] mhi mhi0: Device failed to enter MHI Ready
> > >      [   24.024168] mhi mhi0: MHI did not enter READY state
> > >      
> > >      Unbind/rebind attempts fail:
> > >      [  352.643601] mhi mhi0: Requested to power ON
> > >      [  352.643611] mhi mhi0: Power on setup success
> > >      [  373.442954] mhi mhi0: Device failed to clear MHI Reset
> > >      [  373.442970] mhi mhi0: MHI did not enter READY state
> > >      And requires a full host power cycle to recover,
> > >      even outside of VFIO scenarios.
> > > 
> > > * MHI Host driver's remove callback may handle clean software state
> > > teardown, but it doesn't provide a PCI reset capability that VFIO can
> > > invoke. VFIO needs a reset method registered in the PCI reset hierarchy
> > > (device_specific, pm, flr, bus, etc.). VFIO invokes this reset both during
> > > initial device binding (before the VM starts) and when reassigning the
> > > device between VMs - without a working reset method, the device cannot
> > > reach a clean state for initialization.
> > >   
> > 
> > Likewise, there is a SoC reset available in the modem BAR space. You can try it:
> > https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git/tree/drivers/bus/mhi/host/main.c#n178
> > 
> > If these works, then you can hook these in the device_specific reset callback.
> 
> 
> These look promising as simple flows to implement in a device specific
> reset: save command register, set memory enable, ioremap BAR space,
> match read/write/delay sequences of reset function and caller, iounmap,
> restore command.
> 
> Note the delay in this latter reset is in the caller.  It's also
> surprising that none of these implement a read to flush the posted
> write that initiates the reset.  I wonder if that contributes to the 2s
> delay in the latter example.
> 
> Also it appears these reset the internal state, but not the PCI state,
> which is fine for our purposes, and certainly more confidence inspiring
> than the D3hot heuristics.  Thanks,
> 

Yeah. But I think this should be handled inside a dedicated VFIO pci driver.
Otherwise, if we implement this logic in device_specific reset callback, then
the callback will get triggered even when the client drivers like ath11k are
bound to the device and create conflict.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
