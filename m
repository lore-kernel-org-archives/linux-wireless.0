Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:26413 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYAZUOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 15:14:34 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1888391wah.23
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2008 12:14:32 -0800 (PST)
Message-ID: <1ba2fa240801261214p42d53602o5be2a2cdbcc0d796@mail.gmail.com> (sfid-20080126_201502_075785_D7B8DF4B)
Date: Sat, 26 Jan 2008 22:14:29 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] wireless: iwlwifi3945/4965 - fix incorrect counting of memory
Cc: "Thomas Tuttle" <linux-kernel@ttuttle.net>,
	LKML <linux-kernel@vger.kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Michael Wu" <flamingice@sourmilk.net>,
	LWML <linux-wireless@vger.kernel.org>
In-Reply-To: <20080126160936.GB6738@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080126160936.GB6738@cvg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 26, 2008 6:09 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> This patch does fix incorrect counting of memory allocated by kmalloc.
> It seems that could lead to allocated memory overrun and corrupt
> nearlaid memory area.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>
> ---
>
>  iwl3945-base.c |    2 +-
>  iwl4965-base.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.git/drivers/net/wireless/iwlwifi/iwl3945-base.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c      2008-01-24 18:26:11.000000000 +0300
> +++ linux-2.6.git/drivers/net/wireless/iwlwifi/iwl3945-base.c   2008-01-26 18:45:03.000000000 +0300
> @@ -6631,7 +6631,7 @@ static void iwl_bg_request_scan(struct w
>          * that based on the direct_mask added to each channel entry */
>         scan->tx_cmd.len = cpu_to_le16(
>                 iwl_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
> -                       IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
> +                       IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
>         scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
>         scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
>         scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
>
> Index: linux-2.6.git/drivers/net/wireless/iwlwifi/iwl4965-base.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c      2008-01-26 18:45:38.000000000 +0300
> +++ linux-2.6.git/drivers/net/wireless/iwlwifi/iwl4965-base.c   2008-01-26 18:46:06.000000000 +0300
> @@ -6992,7 +6992,7 @@ static void iwl_bg_request_scan(struct w
>          * that based on the direct_mask added to each channel entry */
>         scan->tx_cmd.len = cpu_to_le16(
>                 iwl_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
> -                       IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
> +                       IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
>         scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
>         scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
>         scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks.

ACK
