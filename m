Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab0GUR5U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:57:20 -0400
Subject: Re: [PATCH] libertas: convert new uses of __attribute__ ((packed))
 to __packed
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Holger Schurig <holgerschurig@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1279118223-10219-1-git-send-email-linville@tuxdriver.com>
References: <1279118223-10219-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 12:58:26 -0700
Message-ID: <1279742306.7267.4.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-14 at 10:37 -0400, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Looks fine to me.

> ---
>  drivers/net/wireless/libertas/cfg.c  |    6 +++---
>  drivers/net/wireless/libertas/host.h |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index f36cc97..7e07416 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -891,7 +891,7 @@ struct cmd_key_material {
>  
>  	__le16 action;
>  	struct MrvlIEtype_keyParamSet param;
> -} __attribute__ ((packed));
> +} __packed;
>  
>  static int lbs_set_key_material(struct lbs_private *priv,
>  				int key_type,
> @@ -1395,7 +1395,7 @@ struct cmd_monitor_mode {
>  
>  	__le16 action;
>  	__le16 mode;
> -} __attribute__ ((packed));
> +} __packed;
>  
>  static int lbs_enable_monitor_mode(struct lbs_private *priv, int mode)
>  {
> @@ -1450,7 +1450,7 @@ struct cmd_rssi {
>  	__le16 nf;
>  	__le16 avg_snr;
>  	__le16 avg_nf;
> -} __attribute__ ((packed));
> +} __packed;
>  
>  static int lbs_get_signal(struct lbs_private *priv, s8 *signal, s8 *noise)
>  {
> diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
> index db8e209..43d020c 100644
> --- a/drivers/net/wireless/libertas/host.h
> +++ b/drivers/net/wireless/libertas/host.h
> @@ -398,12 +398,12 @@ struct mrvl_ie_domain_param_set {
>  
>  	u8 countrycode[COUNTRY_CODE_LEN];
>  	struct ieee80211_country_ie_triplet triplet[1];
> -} __attribute__ ((packed));
> +} __packed;
>  
>  struct cmd_ds_802_11d_domain_info {
>  	__le16 action;
>  	struct mrvl_ie_domain_param_set domain;
> -} __attribute__ ((packed));
> +} __packed;
>  
>  struct lbs_802_11d_domain_reg {
>  	/** Country code*/
> @@ -411,7 +411,7 @@ struct lbs_802_11d_domain_reg {
>  	/** No. of triplet*/
>  	u8 no_triplet;
>  	struct ieee80211_country_ie_triplet triplet[MRVDRV_MAX_TRIPLET_802_11D];
> -} __attribute__ ((packed));
> +} __packed;
>  
>  /*
>   * Define data structure for CMD_GET_HW_SPEC


