Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538BA22E3F0;
	Tue, 23 Jun 2026 13:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222026; cv=none; b=MfrTMGSV6HxDk0Im+18NM6kiy5c1EUcpfa9gfXpRZF5+diy8rJGut661ETi75O7O9T34Kx3clT7vVHGjXW0z8s22qjzX+hdi/W6oiH5v2T+8DuyhjY2pqnFaUkD6og+z0e0njm84pLfzWzp1nese5MG/l6jOZCPGCk+5MvXuaKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222026; c=relaxed/simple;
	bh=VtyrWGAhbxvjX0SgyCmodbPbzQLVna+hNRYjk9HXCx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y5j2Ro2us3iGbv6Z+d3boyT1t7Jf0qNZ/+CUcFjzPnBUI4M4tyyWMoKEv4WTVswJbsYIlD3Faaoi9curYxG0CnHPYMo1hf0bonMTeKgG+zbfF7+CLIodGeUraFoe9VIQnHe1in4ZmEP4uIV8IxyeycSG2fSOc8eKwADfF97CJFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eog6lePD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eog6lePD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F241F000E9;
	Tue, 23 Jun 2026 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782222025;
	bh=pmgv52n41p5z4OQmO+J47C3uc5k3v6DiUGJnWHiFcd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eog6lePDuynqkdv62ua2ud0QrAX6PAZNziY/Ubl02jOpmGet7dGmXm/9VdWmzkZcq
	 NKCxBBURFICGgk3em8aj5s1RxE4HWiY7js93DyMVxxDpDfIbQSLgGRZy7r2uBlYLZ+
	 9FRlL4OTwbnrRmvZgkeG3f32xe+XREvoNrIx2oQfy1wvrda0u+uko8TQcSYEFHOcmq
	 pft7hlp8BpLL7Xq4Q8BwqPKcnPkDW+E0SdUF8/E2Ii3uEgQNa58B6xxMzcag796MB7
	 zk7Sq1Agg/SBwR/xTodgV2YIhOZkuRXaxdFRhpL78KowH71QiczKZI9ySCa9QUGAkq
	 H+GfdPbltNLjQ==
Date: Tue, 23 Jun 2026 15:40:16 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: alex@shazbot.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, bhelgaas@google.com, jjohnson@kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org, 
	mhi@lists.linux.dev
Subject: Re: [PATCH v9] PCI: Add device-specific reset for Qualcomm devices
Message-ID: <frqpqy5nbx7wb7ds2osotuntnbsehp2gfbhpmhlilu4mzhljpa@sart22k7tjme>
References: <r4jeqtx247iosfjdps6g4fqwtsdzine5qlgh33sdt4p6ktmaln@o725aolrpj4l>
 <20260623125637.1188867-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260623125637.1188867-1-jtornosm@redhat.com>

On Tue, Jun 23, 2026 at 02:56:35PM +0200, Jose Ignacio Tornos Martinez wrote:
> Hi Mani and Alex,
> 
> Thank you both for the guidance. 
> 
> 
> I think your insight about the BAR-space reset mechanisms is a much better
> approach to have a "real" reset. With that, I've implemented device-specific
> reset functions based on the driver code Mani referenced:
> 
> WCN6855/WCN7850 WiFi (reset_qualcomm_wifi):
> - Uses SoC global reset via BAR0 offset 0x3008
> - Follows the sequence from ath11k_pci_soc_global_reset() /
>   ath12k_pci_soc_global_reset() / ath11k_pci_sw_reset()
> - Set reset bit → 10ms delay → clear reset bit → 10ms delay → verify link
>   recovery (up to 5s)
> - Includes MHI controller reset cleanup (offset 0x38) to clear SYSERR after SoC
>   reset
> - Both WCN6855 and WCN7850 share identical register offsets and reset sequence
> 
> SDX62/SDX65 modems (reset_qualcomm_modem):
> - Uses MHI SoC reset via BAR0 offset 0xb0
> - Follows the sequence from mhi_soc_reset() / mhi_pci_reset_prepare()
> - Write reset request → 2s delay for reset completion
> 
> All implementations follow Alex's pattern: save command register ->
> enable memory decode -> ioremap BAR -> perform reset sequence ->
> iounmap -> restore command.
> Testing results: The implementation shows successful reset behavior for both
> WiFi and modem devices in VFIO passthrough scenarios.
> 

Cool!

> 
> Regarding the approach (quirks.c vs dedicated VFIO driver):
> 
> Mani, I understand your concern about potential conflicts with the native
> drivers. I want to make sure I implement this correctly. Could you clarify
> when you envision the conflict occurring? 
> From what I can see, the native drivers call their reset functions directly
> without using pci_try_reset_function(), so the device-specific reset in
> quirks.c could be enough, but I may be missing some error recovery paths or
> other scenarios.
> 

MHI driver is calling pci_try_reset_function():

$ git grep -r pci_try_reset_function drivers/bus/mhi
drivers/bus/mhi/host/pci_generic.c:     err = pci_try_reset_function(pdev);

So I was worried that it could create conflict. But looking more, I
understood that it won't create any conflict, but just an additional SoC reset:

  pci_try_reset_function()
    -> pci_dev_save_and_disable()
      -> mhi_pci_reset_prepare()
         -> mhi_soc_reset()         <- First reset 
    -> __pci_reset_function_locked()
      -> pci_dev_specific_reset()   <- Second reset

But this additional SoC reset wouldn't cause any issue to the device due to the
2s delay, but the total recovery delay would compound to 4s now.

And that also should be fine as this path gets triggered only when the device
dies during the recovery work (very rare).

So you can implement the reset in quirks.c with device_specific reset.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
