Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:49873 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0DFO4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 10:56:10 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1073551fgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 07:56:08 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/2] rt2x00: Fix typo in RF register programming of rt2800.
Date: Tue, 6 Apr 2010 16:55:59 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1269463357-32563-1-git-send-email-gwingerde@gmail.com> <1269463357-32563-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1269463357-32563-2-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004061655.59700.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Gertjan. I just stumbled over the same issue. This allows
scanning on all channel on the SoC platform.

Helmut

Am Mittwoch 24 März 2010 schrieb Gertjan van Wingerde:
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 18d4d8e..326fce7 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -812,9 +812,9 @@ static void rt2800_config_channel_rt3x(struct rt2x00_dev *rt2x00dev,
>  	rt2800_rfcsr_write(rt2x00dev, 24,
>  			      rt2x00dev->calibration[conf_is_ht40(conf)]);
>  
> -	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
> +	rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
>  	rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
> -	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
> +	rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
>  }
>  
>  static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
> 

