Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4A9563288;
	Wed, 14 Oct 2026 16:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791997112; cv=none; b=MyZ8Av1SsuTGS1eRE507Ff6OtnQb8vFu8gqTvFeuZa5UDT7RBdZyL2mWGj+oQZ0tJ3XYP6evpJush+PPcE1GhAYC3uTLjIjHLue/TPsZJ8NDipgVyIlQfkcPbo6VOZuuIqwZ81+1UiwpY/WYO6N37CFIPHJSIzHTPCX2fr6aKk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791997112; c=relaxed/simple;
	bh=SWMfrCIO4YtH5M5e+HBbAjTtGT/8z2eh56CZQAT9lsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=AAKrpP03MAAMtxfwFttEljEVUHmaeX/gqtWE9a5prlnILYqMUVJ7OCieFylOmOXY/U9VDCyanvO/8ihMHxE75r4NYb/U4l7rHDdN1sXhZu71CK0gaEZrsOEuXAa7RQJpL2ystvnNgV0cIPK1byMB8WT18t/9l+oysp30yHulBR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6ri6WzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6ri6WzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5721F000C4;
	Wed, 14 Oct 2026 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791997110;
	bh=pC10JpWaZK5q2nplJQQ/7Ng9MIH1WaCTPiIEoz3L6+4=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=a6ri6WzS7o+KWbVhLNAerubNn8eACMbiby8b3bioPlA4QdWHkcT/EIZTBMeZruyOz
	 uFIDz8t6NrFuh5yk2shxhD7OT1DfrWP19ss8/TBCBNVCaQj+pCvW3494pdTaAvuUdB
	 W4FyN9YXYOlr5UInPQ5d4cf8+sFaXMJlnSYGfHPzNIg7PnGm5FBsZYSxoi0Z2jGpwf
	 z7j2twiYiukHuc5EnkNzB9fsY7g1qECKtF6Fc2CJAOfCm/4xRrXTCmZhBfEGyjG2r7
	 g8FGdd9RuTqcqb8sHYSW3kEXBRv4RLmwxnCpTz3W7ekkgUVuxDHfFHf6P9vsYTuZmn
	 S8oAqGYUm2bEQ==
Date: Wed, 14 Oct 2026 11:58:29 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: bhelgaas@google.com, alex@shazbot.org, jjohnson@kernel.org,
	johannes@sipsolutions.net, mani@kernel.org, jgg@ziepe.ca,
	yishaih@nvidia.com, skolothumtho@nvidia.com, kevin.tian@intel.com,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] ath11k: add PCIe link recovery retry
Message-ID: <20261014165829.GA1636877@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930140833.576941-5-jtornosm@redhat.com>

On Wed, Sep 30, 2026 at 04:08:30PM +0200, Jose Ignacio Tornos Martinez wrote:
> When ath11k devices are passed through to VMs via PCIe passthrough,
> the PCIe link may not stabilize immediately after global reset due to
> virtualization layer timing variations. This causes MHI initialization
> to fail with "BHI offset: 0xffffffff is out of range" errors because
> the device is read before it's ready.
> 
> Currently, ath11k_pci_soc_global_reset() just warns if the link is
> down but continues anyway, leading to inevitable MHI failures.
> 
> This patch adds:
> 1. A retry loop (up to 5000ms) to wait for the PCIe link to recover
>    after global reset (similar to the existing ath12k LTSSM retry logic)
> 2. Proper error propagation to prevent continuing with a dead link
> 
> This is especially important for VM environments where timing can vary
> significantly from bare metal.
> 
> Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
> ---
>  drivers/net/wireless/ath/ath11k/pci.c | 39 ++++++++++++++++++++++-----
>  1 file changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
> index 7114eca8810d..4fc6aaf036c1 100644
> --- a/drivers/net/wireless/ath/ath11k/pci.c
> +++ b/drivers/net/wireless/ath/ath11k/pci.c
> @@ -190,8 +190,10 @@ static void ath11k_pci_restore_window(struct ath11k_base *ab)
>  	spin_unlock_bh(&ab_pci->window_lock);
>  }
>  
> -static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
> +static int ath11k_pci_soc_global_reset(struct ath11k_base *ab)
>  {
> +	unsigned long timeout;
> +	bool link_recovered = false;
>  	u32 val, delay;
>  
>  	val = ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
> @@ -211,14 +213,29 @@ static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
>  
>  	mdelay(delay);
>  
> -	val = ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
> -	if (val == 0xffffffff)
> -		ath11k_warn(ab, "link down error during global reset\n");
> +	/* Wait for PCIe link to recover, especially important in VM environments
> +	 * where timing can vary significantly from bare metal.
> +	 */
> +	timeout = jiffies + msecs_to_jiffies(5000);
> +	while (time_before(jiffies, timeout)) {
> +		val = ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
> +		if (val != 0xffffffff) {
> +			link_recovered = true;
> +			break;
> +		}
> +		mdelay(20);
> +	}
> +	if (!link_recovered) {
> +		ath11k_err(ab, "PCIe link failed to recover - device may need power cycle\n");
> +		return -ETIMEDOUT;
> +	}

Link down is a PCIe reset of the endpoint, which should clear all
PCIe-specific state, e.g., BAR values.  Is that restored somewhere?

>  	/* Restore window register as its content is cleared during
>  	 * hardware global reset, such that it aligns with host cache.
>  	 */
>  	ath11k_pci_restore_window(ab);
> +
> +	return 0;
>  }
>  
>  static void ath11k_pci_clear_dbg_registers(struct ath11k_base *ab)
> @@ -373,8 +390,10 @@ static void ath11k_pci_force_wake(struct ath11k_base *ab)
>  	mdelay(5);
>  }
>  
> -static void ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
> +static int ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
>  {
> +	int ret;
> +
>  	mdelay(100);
>  
>  	if (power_on) {
> @@ -387,8 +406,12 @@ static void ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
>  
>  	ath11k_mhi_clear_vector(ab);
>  	ath11k_pci_clear_dbg_registers(ab);
> -	ath11k_pci_soc_global_reset(ab);
> +	ret = ath11k_pci_soc_global_reset(ab);
> +	if (ret)
> +		return ret;
>  	ath11k_mhi_set_mhictrl_reset(ab);
> +
> +	return 0;
>  }
>  
>  static void ath11k_pci_init_qmi_ce_config(struct ath11k_base *ab)
> @@ -818,7 +841,9 @@ static int ath11k_pci_power_up(struct ath11k_base *ab)
>  
>  	ab_pci->register_window = 0;
>  	clear_bit(ATH11K_FLAG_DEVICE_INIT_DONE, &ab->dev_flags);
> -	ath11k_pci_sw_reset(ab_pci->ab, true);
> +	ret = ath11k_pci_sw_reset(ab_pci->ab, true);
> +	if (ret)
> +		return ret;
>  
>  	/* Disable ASPM during firmware download due to problems switching
>  	 * to AMSS state.
> -- 
> 2.53.0
> 
