Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39976 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbZAHQ6C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 11:58:02 -0500
Subject: Re: [PATCH v2 2/3] libertas: Update libertas core with GSPI
	constants
From: Dan Williams <dcbw@redhat.com>
To: Colin McCabe <colin@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Andrey Yurovsky <andrey@cozybit.com>
In-Reply-To: <1230951623-26998-3-git-send-email-colin@cozybit.com>
References: <1230951623-26998-1-git-send-email-colin@cozybit.com>
	 <1230951623-26998-2-git-send-email-colin@cozybit.com>
	 <1230951623-26998-3-git-send-email-colin@cozybit.com>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 11:56:41 -0500
Message-Id: <1231433801.21643.44.camel@localhost.localdomain> (sfid-20090108_175809_154299_145CC496)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-02 at 19:00 -0800, Colin McCabe wrote:
> Add GSPI constants to libertas core.
> 
> Fix misleading comment in lbs_setup_firmware.
> 
> Signed-off-by: Colin McCabe <colin@cozybit.com>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/host.h    |    1 +
>  drivers/net/wireless/libertas/hostcmd.h |    8 ++++++++
>  drivers/net/wireless/libertas/main.c    |    5 ++---
>  3 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
> index 277ff19..d4457ef 100644
> --- a/drivers/net/wireless/libertas/host.h
> +++ b/drivers/net/wireless/libertas/host.h
> @@ -66,6 +66,7 @@
>  #define CMD_802_11_LED_GPIO_CTRL		0x004e
>  #define CMD_802_11_EEPROM_ACCESS		0x0059
>  #define CMD_802_11_BAND_CONFIG			0x0058
> +#define CMD_GSPI_BUS_CONFIG			0x005a
>  #define CMD_802_11D_DOMAIN_INFO			0x005b
>  #define CMD_802_11_KEY_MATERIAL			0x005e
>  #define CMD_802_11_SLEEP_PARAMS			0x0066
> diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
> index c6d5771..3c15611 100644
> --- a/drivers/net/wireless/libertas/hostcmd.h
> +++ b/drivers/net/wireless/libertas/hostcmd.h
> @@ -221,6 +221,14 @@ struct cmd_ds_mac_multicast_adr {
>  	u8 maclist[ETH_ALEN * MRVDRV_MAX_MULTICAST_LIST_SIZE];
>  } __attribute__ ((packed));
>  
> +struct cmd_ds_gspi_bus_config {
> +	struct cmd_header hdr;
> +	__le16 action;
> +	__le16 bus_delay_mode;
> +	__le16 host_time_delay_to_read_port;
> +	__le16 host_time_delay_to_read_register;
> +} __attribute__ ((packed));
> +
>  struct cmd_ds_802_11_authenticate {
>  	u8 macaddr[ETH_ALEN];
>  	u8 authtype;
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index 3b8cb29..69f7479 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -1011,9 +1011,8 @@ void lbs_resume(struct lbs_private *priv)
>  EXPORT_SYMBOL_GPL(lbs_resume);
>  
>  /**
> - *  @brief This function downloads firmware image, gets
> - *  HW spec from firmware and set basic parameters to
> - *  firmware.
> + * @brief This function gets the HW spec from the firmware and sets
> + *        some basic parameters.
>   *
>   *  @param priv    A pointer to struct lbs_private structure
>   *  @return 	   0 or -1

