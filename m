Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56563 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0K3Ogm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 09:36:42 -0500
Subject: Re: [PATCH w-t] iwlagn: fix microcode error on 4965
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101130143339.GC3074@redhat.com>
References: <20101130130148.GA3074@redhat.com>
	 <1291123016.3624.17.camel@jlt3.sipsolutions.net>
	 <20101130134903.GB3074@redhat.com>
	 <1291126178.3624.19.camel@jlt3.sipsolutions.net>
	 <20101130143339.GC3074@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 15:36:37 +0100
Message-ID: <1291127797.3624.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-30 at 15:33 +0100, Stanislaw Gruszka wrote:
> Commit dbbf1755b09eef8ff6dd21c8dafe1606f051ce12 "iwlwifi: use
> antenna information in EEPROM" caused 4965 device breakage with
> "Microcode SW error detected.  Restarting 0x82000000." message.
> This patch reverts 4965 part of that commit.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

> ---
>  drivers/net/wireless/iwlwifi/iwl-4965.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index 9f1d8d8..6788ceb 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -2624,6 +2624,8 @@ struct iwl_cfg iwl4965_agn_cfg = {
>  	.fw_name_pre = IWL4965_FW_PRE,
>  	.ucode_api_max = IWL4965_UCODE_API_MAX,
>  	.ucode_api_min = IWL4965_UCODE_API_MIN,
> +	.valid_tx_ant = ANT_AB,
> +	.valid_rx_ant = ANT_ABC,
>  	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
>  	.eeprom_calib_ver = EEPROM_4965_TX_POWER_VERSION,
>  	.ops = &iwl4965_ops,


