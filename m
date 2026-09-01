Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04FA3B6370;
	Tue,  1 Sep 2026 07:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788248583; cv=none; b=LoGFCm559XQv4Dql6EQgtzg6bisBfjwyJP6ZnSO0hQJ7gPEjxo4PILaYqojqAClKVRdgwBelKGQiO6qouYV44fX1p6bgHGCH3mup4ntrFuE4lsO41kuz9myCDM7eoKH5GPVRlw3bN4aO+pdN1AT5HWP5XK3Q1Dy/tUsaVDnhhSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788248583; c=relaxed/simple;
	bh=k0qhAN1k0pG/OfgzAZMQmUAwZp4NG01KmPUtyNCuT7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mlo7Y2f9xHAtWimNSImhvBlXoTODfu8/7Z7mOSSbzQfSi+8IwR/eNDWJsHsWmbAX8/vFLWCGmXfzX1lYtEb1bzi777zn3MmFJQtVKVlzdsppQeX/ju/niytWCkD7M5XzSgUAZ8Y2k0Ir+iqO2K+FFEqx7NH9dJiQQPjO9dhNmpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNMDG2qs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNMDG2qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB251F000E9;
	Tue,  1 Sep 2026 07:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788248582;
	bh=8MysSjN5BiHyKVnu9WLokfhYFbub8w6aLjsPVpWNVEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UNMDG2qs+RipyyPPrYH4e8EY5MOSWjrbQRFLh5cmMcRnZiSqoIVvXjKt9ymlzr0Vw
	 +4lWJ8kKsslWNLgt/foNbIii9s3D6RyYJXaGIzYPxePOmbH5SwEi0nnvq63XaWvwpc
	 37l3qpwmE5V0GdYEr8plIh3eLLoSdJq5XAkzyVM6Zvr8lRKTYzdK2A4RfzfQM2nExM
	 i3o9qd2PfdFdLbd5tVml1JRxKQmLyHa4kHq8RFIJ50K8sAXlOkmHjdHJlaIrQxWTXR
	 SveyLPqdVlc+/tR3NTfIGcKlL9//cM+mW0evRWYf0KSqnU4QoNPGgFuPExQ8zyXXIe
	 j6YfMSJxQSphQ==
Date: Tue, 1 Sep 2026 09:42:43 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, 
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, Jingoo Han <jingoohan1@gmail.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Rob Herring <robh@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@bgdev.pl>, 
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, mhi@lists.linux.dev, linux-wireless@vger.kernel.org, 
	ath11k@lists.infradead.org, qiang.yu@oss.qualcomm.com
Subject: Re: [PATCH v5 1/6] PCI/bwctrl: Set host bridge OPP and optionally
 disable ASPM around link retraining
Message-ID: <atba2336nxz566wvbfrvclbx7yyma5elhnojb7ozz4ku6dk3q3@c2wa24laiqyd>
References: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
 <20260819-bwscale-v5-1-6dea79786b37@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260819-bwscale-v5-1-6dea79786b37@oss.qualcomm.com>

On Wed, Aug 19, 2026 at 06:55:52PM +0530, Krishna Chaitanya Chundru wrote:
> PCIe host bridge controllers may need their operating point raised before

Use either "Host Bridge devices" or "PCIe controllers".

> retraining to a higher link speed so that hardware resources (e.g., RPMh
> votes on Qualcomm platforms) are available at the requested data rate.
> After retraining, the operating point must be updated to reflect the
> actual negotiated speed.
> 
> Add pcie_set_opp() to look up an OPP on the host bridge parent device
> using a key of (per-lane frequency in kHz, LNKCTL2 Target Link Speed
> level).  Keying by generation rather than total bandwidth lets OPP tables
> remain width-independent.
> 
> In pcie_set_target_speed(), call pcie_set_opp() before retraining only
> when upscaling (speed_req > cur_bus_speed), since only raising the
> operating point requires pre-staging hardware.  After retraining, call
> pcie_set_opp() unconditionally with the actual cur_bus_speed to settle
> the votes.  Both calls are skipped for downstream ports of PCIe switches,
> as those are outside the host controller's scope.
> 
> Some controllers also require ASPM to be disabled around link retraining.
> Add a disable_aspm_for_retrain flag to pci_host_bridge; when set,
> pcie_set_target_speed() saves the child device's ASPM state, disables all
> ASPM link states before retraining, and restores them afterward.
> 
> Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
> ---
>  drivers/pci/pcie/bwctrl.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/pci.h       |  1 +
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pcie/bwctrl.c b/drivers/pci/pcie/bwctrl.c
> index c4c8d260bf96..6fa1522c47db 100644
> --- a/drivers/pci/pcie/bwctrl.c
> +++ b/drivers/pci/pcie/bwctrl.c
> @@ -28,9 +28,11 @@
>  #include <linux/mutex.h>
>  #include <linux/pci.h>
>  #include <linux/pci-bwctrl.h>
> +#include <linux/pm_opp.h>
>  #include <linux/rwsem.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
> +#include <linux/units.h>
>  
>  #include "../pci.h"
>  #include "portdrv.h"
> @@ -120,6 +122,38 @@ static int pcie_bwctrl_change_speed(struct pci_dev *port, u16 target_speed, bool
>  	return pcie_retrain_link(port, use_lt);
>  }
>  
> +static int pcie_set_opp(struct pci_dev *pdev, struct pci_host_bridge *host,
> +			enum pci_bus_speed speed)
> +{
> +	struct device *dev = host->dev.parent;
> +	struct dev_pm_opp_key key = {};
> +	int ret, freq_mbps, width;
> +	unsigned long freq_kbps;
> +	struct dev_pm_opp *opp;
> +	u16 lnksta;
> +
> +	pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
> +	width = FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
> +
> +	freq_mbps = pcie_dev_speed_mbps(speed);
> +	if (freq_mbps < 0)
> +		return -EINVAL;
> +
> +	freq_kbps = freq_mbps * KILO;
> +	key.freq = freq_kbps;
> +	key.level = pci_bus_speed2lnkctl2(speed);
> +	key.bw = 0;

'key' is already 0 initialized above.

> +	opp = dev_pm_opp_find_key_exact(dev, &key, true);
> +	if (!IS_ERR(opp)) {
> +		ret = dev_pm_opp_set_opp(dev, opp);
> +		if (ret)
> +			dev_err(dev, "Failed to set OPP for freq (%lu): %d\n",
> +				freq_kbps * width, ret);
> +		dev_pm_opp_put(opp);
> +	}
> +	return 0;
> +}
> +
>  /**
>   * pcie_set_target_speed - Set downstream Link Speed for PCIe Port
>   * @port:	PCIe Port
> @@ -140,9 +174,12 @@ static int pcie_bwctrl_change_speed(struct pci_dev *port, u16 target_speed, bool
>  int pcie_set_target_speed(struct pci_dev *port, enum pci_bus_speed speed_req,
>  			  bool use_lt)
>  {
> +	struct pci_host_bridge *host = pci_find_host_bridge(port->bus);
> +	bool is_rootbus = pci_is_root_bus(port->bus);
>  	struct pci_bus *bus = port->subordinate;
> +	struct pci_dev *child = NULL;
> +	int aspm_state = 0, ret;
>  	u16 target_speed;
> -	int ret;
>  
>  	if (WARN_ON_ONCE(!pcie_valid_speed(speed_req)))
>  		return -EINVAL;
> @@ -152,6 +189,24 @@ int pcie_set_target_speed(struct pci_dev *port, enum pci_bus_speed speed_req,
>  
>  	target_speed = pcie_bwctrl_select_speed(port, speed_req);
>  
> +	/*
> +	 * The host bridge driver may need to be scaled for targeted speed

"Host Bridge resources may need to be..."

> +	 * otherwise link might not come up at requested speed.
> +	 */
> +	if (is_rootbus && host && bus) {
> +		/* Get function 0 of downstream device */
> +		list_for_each_entry(child, &bus->devices, bus_list)
> +			if (PCI_FUNC(child->devfn) == 0)
> +				break;
> +
> +		if (child && host->disable_aspm_for_retrain) {
> +			aspm_state = pcie_aspm_enabled(child);
> +			pci_disable_link_state_locked(child, PCIE_LINK_STATE_ALL);
> +		}

You mentioned that the Host Bridge requires disabling ASPM during retraining,
but here you are disabling ASPM of the downstream device. So the issue is device
specific or Host Bridge (RP?) specific?

> +		if (speed_req > bus->cur_bus_speed)
> +			pcie_set_opp(port, host, speed_req);
> +	}
> +
>  	scoped_guard(rwsem_read, &pcie_bwctrl_setspeed_rwsem) {
>  		struct pcie_bwctrl_data *data = port->link_bwctrl;
>  
> @@ -176,6 +231,12 @@ int pcie_set_target_speed(struct pci_dev *port, enum pci_bus_speed speed_req,
>  	    !list_empty(&bus->devices))
>  		ret = -EAGAIN;
>  
> +	if (bus && is_rootbus && host) {

Maintain an order for this check. I think this order makes sense than the above
one.


- Mani

-- 
மணிவண்ணன் சதாசிவம்
