Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38110 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbZK3Sai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 13:30:38 -0500
Date: Mon, 30 Nov 2009 13:24:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Keng-Yu Lin <keng-yu.lin@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	Carlos Corbacho <carlos@strangeworlds.co.uk>,
	aceracpi@googlegroups.com
Subject: Re: [PATCH] acer-wmi: Add DMI quirk to blacklist Acer Aspire One
	BA01-DV/JM11-ML.
Message-ID: <20091130182445.GC21401@tuxdriver.com>
References: <1259214413-21956-1-git-send-email-keng-yu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1259214413-21956-1-git-send-email-keng-yu.lin@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think this needs to go through someone else's tree...

John

On Thu, Nov 26, 2009 at 01:46:53PM +0800, Keng-Yu Lin wrote:
> The two Acer Aspire One models should be blacklisted to prevent from
> reporting rfkill is enabled since it's hardware controlled.
> 
> Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
> ---
>  drivers/platform/x86/acer-wmi.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index 454970d..b39766c 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -241,6 +241,20 @@ static struct dmi_system_id __devinitdata acer_blacklist[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
>  		},
>  	},
> +	{
> +		.ident = "Acer Aspire One (BA01-DV)",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "AO531h"),
> +		},
> +	},
> +	{
> +		.ident = "Acer Aspire One (JM11-ML)",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "AO751h"),
> +		},
> +	},
>  	{}
>  };
>  
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
