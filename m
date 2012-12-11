Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42494 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab2LKVqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 16:46:15 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so2708325wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 13:46:13 -0800 (PST)
References: <20121211100404.GA7817@earthship.arig>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20121211100404.GA7817@earthship.arig>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <5533C657-B24F-4835-9728-E77D65CA9348@gmail.com> (sfid-20121211_224618_486165_A023B801)
Cc: "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	"<users@rt2x00.serialmonkey.com>" <users@rt2x00.serialmonkey.com>,
	"<juhosg@openwrt.org>" <juhosg@openwrt.org>,
	"<sgruszka@redhat.com>" <sgruszka@redhat.com>,
	"<helmut.schaa@googlemail.com>" <helmut.schaa@googlemail.com>,
	"<john@phrozen.org>" <john@phrozen.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 2/3] rt2x00: allow disabling bands through platform_data
Date: Tue, 11 Dec 2012 22:46:12 +0100
To: Daniel Golle <dgolle@allnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On 11 dec. 2012, at 11:04, Daniel Golle <dgolle@allnet.de> wrote:

> 
> Signed-off-by: Daniel Golle <dgolle@allnet.de>

Again we need a proper patch description here.

Also, can you explain why the enabling / disabling of individual bands needs to be done via platform data, as opposed to letting user space handle this?

> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 355cff5..c67e769 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -426,6 +426,7 @@ struct hw_mode_spec {
>    unsigned int supported_bands;
> #define SUPPORT_BAND_2GHZ    0x00000001
> #define SUPPORT_BAND_5GHZ    0x00000002
> +#define SUPPORT_BAND_BOTH    (SUPPORT_BAND_2GHZ | SUPPORT_BAND_5GHZ)
> 
>    unsigned int supported_rates;
> #define SUPPORT_RATE_CCK    0x00000001
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index d454488..b7856bf 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -835,6 +835,22 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
>    unsigned int num_rates;
>    unsigned int i;
> 
> +    if (rt2x00dev->dev->platform_data) {
> +        struct rt2x00_platform_data *pdata;
> +
> +        pdata = rt2x00dev->dev->platform_data;
> +        if (pdata->disable_2ghz)
> +            spec->supported_bands &= ~SUPPORT_BAND_2GHZ;
> +        if (pdata->disable_5ghz)
> +            spec->supported_bands &= ~SUPPORT_BAND_5GHZ;
> +    }
> +
> +    if ((spec->supported_bands & SUPPORT_BAND_BOTH) == 0) {
> +        ERROR(rt2x00dev, "No supported bands\n");
> +        return -EINVAL;
> +    }
> +
> +
>    num_rates = 0;
>    if (spec->supported_rates & SUPPORT_RATE_CCK)
>        num_rates += 4;
> diff --git a/include/linux/rt2x00_platform.h b/include/linux/rt2x00_platform.h
> index 80effa7..b4c7768 100644
> --- a/include/linux/rt2x00_platform.h
> +++ b/include/linux/rt2x00_platform.h
> @@ -14,6 +14,9 @@
> 
> struct rt2x00_platform_data {
>    char *eeprom_file_name;
> +
> +    int disable_2ghz;
> +    int disable_5ghz;
> };
> 
> #endif /* _RT2X00_PLATFORM_H */
> -- 
> 1.8.0.1
> 
