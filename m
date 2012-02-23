Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33178 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2BWMXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 07:23:39 -0500
Subject: Re: [PATCH 4/6] iwlwifi: use writeb,writel,readl directly
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1329992168-19990-4-git-send-email-sgruszka@redhat.com> (sfid-20120223_111624_443292_569282C6)
References: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
	 <1329992168-19990-4-git-send-email-sgruszka@redhat.com>
	 (sfid-20120223_111624_443292_569282C6)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Feb 2012 13:23:35 +0100
Message-ID: <1329999815.3448.3.camel@jlt3.sipsolutions.net> (sfid-20120223_132342_031278_C5CDA19D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-23 at 11:16 +0100, Stanislaw Gruszka wrote:
> That change will save us some CPU cycles at run time. Having port-based
> I/O seems to be not possible for PCIe devices.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/Kconfig          |    1 +
>  drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   13 ++++++-------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
> index ae08498..404ac69 100644
> --- a/drivers/net/wireless/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> @@ -6,6 +6,7 @@ config IWLWIFI
>  	select LEDS_CLASS
>  	select LEDS_TRIGGERS
>  	select MAC80211_LEDS
> +	select HAS_IOMEM

According to every other user of HAS_IOMEM, this should be
	depends on HAS_IOMEM

I've made the change.

johannes

