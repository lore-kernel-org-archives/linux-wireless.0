Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f207.google.com ([209.85.218.207]:61159 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbZGDNjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 09:39:25 -0400
Received: by bwz3 with SMTP id 3so871929bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jul 2009 06:39:28 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: [PATCH] p54: two endian fixes
Date: Sat, 4 Jul 2009 17:39:16 +0400
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <200907032101.15855.chunkeey@web.de>
In-Reply-To: <200907032101.15855.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200907041739.18354.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This patch fixes all CHECK_ENDIAN complains:
> 
> 1. p54/fwio.c:296:6: warning: restricted __le32 degrades to integer
>     p54/fwio.c:296:6: warning: restricted __le32 degrades to integer
> 
> 2. p54/p54spi.c:172:32: warning: incorrect type in initializer
>    p54spi.c:172:32:    expected restricted __le32 [usertype] buffer
>    p54/p54spi.c:172:32:    got unsigned int
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> Max,
> 
> drivers/net/wireless/p54/p54spi.c:115: warning: ‘p54spi_read16’ defined but not used
> 
> looks like this function can be nuked, or do you have plans with it?

No, no plans. Also there's unused p54spi_registers_array, which seems to be cx3110x legacy.

>  	for (i = 0; i < 2000; i++) {
> -		__le32 buffer = p54spi_read32(priv, reg);
> +		u32 buffer = p54spi_read32(priv, reg);
>  		if ((buffer & bits) == bits)
>  			return 1;
>  	}

You're right, my fault. There used to be p54spi_spi_read here, which didn't convert endianness.

Thanks.
-- Max
