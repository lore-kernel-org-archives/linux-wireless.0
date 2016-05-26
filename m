Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0250.hostedemail.com ([216.40.44.250]:48064 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754008AbcEZQCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2016 12:02:07 -0400
Message-ID: <1464278521.16344.35.camel@perches.com> (sfid-20160526_180215_721754_27547A33)
Subject: Re: [PATCH v1 1/1] rtl8xxxu: tuse %*ph to dump buffers
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 26 May 2016 09:02:01 -0700
In-Reply-To: <1464274339-103386-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1464274339-103386-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-05-26 at 17:52 +0300, Andy Shevchenko wrote:
> Use %*ph specifier to dump small buffers in hex format instead of doing this
> byte-by-byte.
[]
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
[]
> @@ -413,13 +413,8 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
>  		dev_info(&priv->udev->dev,
>  			 "%s: dumping efuse (0x%02zx bytes):\n",
>  			 __func__, sizeof(struct rtl8192cu_efuse));
> -		for (i = 0; i < sizeof(struct rtl8192cu_efuse); i += 8) {
> -			dev_info(&priv->udev->dev, "%02x: "
> -				 "%02x %02x %02x %02x %02x %02x %02x %02x\n", i,
> -				 raw[i], raw[i + 1], raw[i + 2],
> -				 raw[i + 3], raw[i + 4], raw[i + 5],
> -				 raw[i + 6], raw[i + 7]);
> -		}
> +		for (i = 0; i < sizeof(struct rtl8192cu_efuse); i += 8)
> +			dev_info(&priv->udev->dev, "%02x: %8ph\n", i, &raw[i]);

print_hex_dump_bytes?

or maybe add a dev_print_hex_dump variant?

