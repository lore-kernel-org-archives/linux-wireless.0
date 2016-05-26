Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:24158 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbcEZQz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2016 12:55:58 -0400
Message-ID: <1464281830.27624.27.camel@linux.intel.com> (sfid-20160526_185601_827902_D7361D8F)
Subject: Re: [PATCH v1 1/1] rtl8xxxu: tuse %*ph to dump buffers
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 26 May 2016 19:57:10 +0300
In-Reply-To: <1464278521.16344.35.camel@perches.com>
References: <1464274339-103386-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1464278521.16344.35.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-05-26 at 09:02 -0700, Joe Perches wrote:
> On Thu, 2016-05-26 at 17:52 +0300, Andy Shevchenko wrote:
> > Use %*ph specifier to dump small buffers in hex format instead of
> > doing this
> > byte-by-byte.
> []
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
> > b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
> []
> > @@ -413,13 +413,8 @@ static int rtl8192cu_parse_efuse(struct
> > rtl8xxxu_priv *priv)
> >  		dev_info(&priv->udev->dev,
> >  			 "%s: dumping efuse (0x%02zx bytes):\n",
> >  			 __func__, sizeof(struct rtl8192cu_efuse));
> > -		for (i = 0; i < sizeof(struct rtl8192cu_efuse); i
> > += 8) {
> > -			dev_info(&priv->udev->dev, "%02x: "
> > -				 "%02x %02x %02x %02x %02x %02x
> > %02x %02x\n", i,
> > -				 raw[i], raw[i + 1], raw[i + 2],
> > -				 raw[i + 3], raw[i + 4], raw[i +
> > 5],
> > -				 raw[i + 6], raw[i + 7]);
> > -		}
> > +		for (i = 0; i < sizeof(struct rtl8192cu_efuse); i
> > += 8)
> > +			dev_info(&priv->udev->dev, "%02x: %8ph\n",
> > i, &raw[i]);
> 
> print_hex_dump_bytes?

I know, perhaps I had to mention that it is not too beneficial here. 

> or maybe add a dev_print_hex_dump variant?

I don't know how much users we have to introduce a such. This is
actually a main reason I avoid to use print_hex_dump() above. Btw, the
above might be collapsed into one function instead of 3 times of copy-n-
paste.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
