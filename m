Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25F44FD78F;
	Thu, 17 Sep 2026 17:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664805; cv=none; b=RvM2yKxo7NcHb/A/YRx1M258SNzf+vMpyIHrSK5M0Fj5ijJorUaCZWTBPhw3wzM+/2jCwKUxnQ6iY6sdwwGsQwl9gMchf9jtt2AzEAL85p1qsZ3bshgiZEsbfMR8tyNpsJVDshOSZoWRybZ+vWDh30twFCC6XQF2j3WxyiU1lNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664805; c=relaxed/simple;
	bh=uwuIT3omK02sZdec7a0FXVuDK2O3xZEMksDRkfSnzaA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=CU0K10WOJwO/19vT6HhrjY2KGjfW28Mjw9NdSPy8FrOQVq9c9Y48rv1ZspyO3EO/m2PyFGBZY018AC2sR2+VB3aao4W9NMrOUCPGU5UeQepxPqHMNEM5+nnmZjOYPFJo1oMGzwgM7MAaRif21IqsbF7iKE5gdxURvtf56QFldZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gHGHTvtJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gHGHTvtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0DF1F00893;
	Thu, 17 Sep 2026 17:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789664803;
	bh=thptWvz4OVCspoERVZ766KnGJOYRQWL/l9e0wco26zk=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=gHGHTvtJa8ZqJi+mpWrczyhU8V7irl79da3wZEEQ6mBacP/g+M0kfS2fcL7yoNgmW
	 wNbOs/ErLHpxxyG/ePxupieQ8pcFwj+9LCqG1SSeymQERPmWKLpt6j76+Vb5QeJf27
	 EHi+hhIFnIHHgxTb0d25dU9hYPQzKhumhLBNtBMH0xxhpX5izYp+6IT/+CB7mLy0KC
	 z9G1HMag6QDCmRNw6fsMzhju2O/5PR08BA2F9tBmVDWn5TjqITo4/5A204EBIPZ5/n
	 9UU90blkT6hDsIw34wj5yJ0NPKIIjsjDoYTPyqzxhKmdom91s6/7B7jw48MpPqGeNh
	 SmQGtSb+a/rDA==
Date: Thu, 17 Sep 2026 12:06:42 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: alex@shazbot.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, bhelgaas@google.com,
	jjohnson@kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	mani@kernel.org, mhi@lists.linux.dev
Subject: Re: [PATCH v13] PCI: Add device-specific reset for Qualcomm devices
Message-ID: <20260917170642.GA1026691@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917065918.13357-1-jtornosm@redhat.com>

On Thu, Sep 17, 2026 at 08:59:18AM +0200, Jose Ignacio Tornos Martinez wrote:
> Hi Bjorn,
> 
> Thanks for the review.
> 
> > I guess you are saying that some kind of reset *does* work
> > fine in normal, clean VM termination?  If reset works fine
> > for normal VM termination but not for VM crash, do we have
> > any idea why they are different?
>
> It depends on the device:
> 
> - For the modems (SDX62/SDX65), without a proper reset
>   capability, these devices never successfully initialize
>   even on first VM assignment.
> 
> - For the WLAN devices (WCN6855/WCN7850), the reset fails
>   in both cases, but on clean VM shutdown the guest driver's
>   .shutdown/.remove callbacks properly deinitialize the device
>   (stop DMA, disable interrupts, etc.), so it ends up in a
>   known-good state even without a successful reset. On unclean
>   termination (crash, force-off), the guest driver callbacks
>   never run, the device stays in an undefined state, and
>   without a working reset it cannot be reused.

Ah, so this depends on the previous VM tenant to clean up after itself
instead of the host kernel enforcing the isolation?

That seems important to mention and potentially unacceptable to
tenants if an issue in the tenant's kernel may cause their data to be
leaked to the next user of the device.

> I will try to clarify this better in the commit messages for v14.
> 
> > Since these basically copy code from other drivers, is there
> > an opportunity to remove it from those drivers and use this
> > instead?
>
> Yes, that could be a follow-up after this lands.

Sounds good.
