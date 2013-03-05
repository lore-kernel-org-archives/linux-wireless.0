Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57095 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab3CESb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 13:31:26 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] ath6kl: print firmware capabilities
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20130305163842.32118.84598.stgit@localhost6.localdomain6>
Date: Tue, 5 Mar 2013 10:31:23 -0800
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Message-Id: <D298DB6B-8EF2-4619-90D0-15F662F85627@holtmann.org> (sfid-20130305_193131_857322_48CED732)
References: <20130305163842.32118.84598.stgit@localhost6.localdomain6>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> Printin the  firmware capabilities during the first firmware boot makes it easier to find out what
> features firmware supports.
> 
> Obligatory screenshot:
> 
> [21025.678481] ath6kl: ar6003 hw 2.1.1 sdio fw 3.2.0.144 api 3
> [21025.678667] ath6kl: firmware supports: sched-scan,sta-p2pdev-duplex,rsn-cap-override
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
> drivers/net/wireless/ath/ath6kl/init.c |   68 ++++++++++++++++++++++++++++++++
> 1 file changed, 68 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
> index 072a229..fd06332 100644
> --- a/drivers/net/wireless/ath/ath6kl/init.c
> +++ b/drivers/net/wireless/ath/ath6kl/init.c
> @@ -1549,10 +1549,76 @@ static const char *ath6kl_init_get_hif_name(enum ath6kl_hif_type type)
> 	return NULL;
> }
> 
> +
> +static const struct fw_capa_str_map {
> +	int id;
> +	const char *name;
> +} fw_capa_map[] = {
> +	{ ATH6KL_FW_CAPABILITY_HOST_P2P, "host-p2p" },
> +	{ ATH6KL_FW_CAPABILITY_SCHED_SCAN, "sched-scan" },
> +	{ ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX, "sta-p2pdev-duplex" },
> +	{ ATH6KL_FW_CAPABILITY_INACTIVITY_TIMEOUT, "inactivity-timeout" },
> +	{ ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE, "rsn-cap-override" },
> +	{ ATH6KL_FW_CAPABILITY_WOW_MULTICAST_FILTER, "wow-mc-filter" },
> +	{ ATH6KL_FW_CAPABILITY_BMISS_ENHANCE, "bmiss-enhance" },
> +	{ ATH6KL_FW_CAPABILITY_SCHED_SCAN_MATCH_LIST, "sscan-math-list" },

math ;)

> +	{ ATH6KL_FW_CAPABILITY_RSSI_SCAN_THOLD, "rssi-scan-thold" },
> +	{ ATH6KL_FW_CAPABILITY_CUSTOM_MAC_ADDR, "custom-mac-addr" },
> +	{ ATH6KL_FW_CAPABILITY_TX_ERR_NOTIFY, "tx-err-notify" },
> +	{ ATH6KL_FW_CAPABILITY_REGDOMAIN, "regdomain" },
> +	{ ATH6KL_FW_CAPABILITY_SCHED_SCAN_V2, "sched-scan-v2" },
> +	{ ATH6KL_FW_CAPABILITY_HEART_BEAT_POLL, "hb-poll" },
> +};

Regards

Marcel

