Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59464 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbcBAOcT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 09:32:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 04/31] iwlwifi: pcie: add initial RTPM support for PCI
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
	<1454238386-27032-4-git-send-email-emmanuel.grumbach@intel.com>
Date: Mon, 01 Feb 2016 16:32:15 +0200
In-Reply-To: <1454238386-27032-4-git-send-email-emmanuel.grumbach@intel.com>
	(Emmanuel Grumbach's message of "Sun, 31 Jan 2016 13:05:59 +0200")
Message-ID: <87y4b4sdqo.fsf@purkki.adurom.net> (sfid-20160201_153222_774227_E26C4252)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> From: Luca Coelho <luciano.coelho@intel.com>
>
> Add an initial implementation of runtime power management (RTPM) for
> PCI devices.  With this patch, RTPM is only used when wifi is off
> (i.e. the wifi interface is down).  This implementation is behind a
> new Kconfig flag, IWLWIFI_PCIE_RTPM.
>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[...]

> --- a/drivers/net/wireless/intel/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
> @@ -99,6 +99,18 @@ config IWLWIFI_UAPSD
>  
>  	  If unsure, say N.
>  
> +config IWLWIFI_PCIE_RTPM
> +       bool "Enable runtime power management mode for PCIe devices"
> +       depends on IWLMVM && IWLWIFI_PCIE && PM
> +       default false
> +       help
> +         Say Y here to enable runtime power management for PCIe
> +         devices.  If enabled, the device will go into low power mode
> +         when idle for a short period of time, allowing for improved
> +         power saving during runtime.
> +
> +	 If unsure, say N.

I didn't see the new option in menuconfig and then noticed that I can't
find IWLWIFI_PCIE anywhere. Is that correct?

-- 
Kalle Valo
