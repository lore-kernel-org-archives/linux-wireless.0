Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbYCDRQJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 12:16:09 -0500
Subject: Re: [PATCH] libertas: add LED control TLV to types.h
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803031216.42283.hs4233@mail.mn-solutions.de>
References: <200803031216.42283.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 12:12:04 -0500
Message-Id: <1204650724.30024.2.camel@localhost.localdomain> (sfid-20080304_171612_499906_D0824F7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-03 at 12:16 +0100, Holger Schurig wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> diff --git a/drivers/net/wireless/libertas/types.h b/drivers/net/wireless/libertas/types.h
> index f0d5795..4031be4 100644
> --- a/drivers/net/wireless/libertas/types.h
> +++ b/drivers/net/wireless/libertas/types.h
> @@ -239,4 +239,17 @@ struct mrvlietypes_ledgpio {
>  	struct led_pin ledpin[1];
>  } __attribute__ ((packed));
>  
> +struct led_bhv {
> +	uint8_t	firmwarestate;
> +	uint8_t	led;
> +	uint8_t	ledstate;
> +	uint8_t	ledarg;
> +} __attribute__ ((packed));
> +
> +
> +struct mrvlietypes_ledbhv {
> +	struct mrvlietypesheader header;
> +	struct led_bhv ledbhv[1];
> +} __attribute__ ((packed));
> +
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

