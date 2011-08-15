Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:48260 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729Ab1HOJeO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 05:34:14 -0400
Received: by mail-yx0-f175.google.com with SMTP id 19so3150306yxi.20
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 02:34:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312881233-9366-24-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	<1312881233-9366-24-git-send-email-eliad@wizery.com>
Date: Mon, 15 Aug 2011 12:34:13 +0300
Message-ID: <CAHiDVw=0TyB6v7DxOwqCKT54=Q9-gzZ-atXaeoB46RoXZRoJiA@mail.gmail.com> (sfid-20110815_113417_712471_6E6DD819)
Subject: Re: [PATCH 23/40] wl12xx: re-enable block ack session support
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 9, 2011 at 12:13 PM, Eliad Peller <eliad@wizery.com> wrote:
> From: Arik Nemtsov <arik@wizery.com>
- linux-wireless
+ mcs list

>
> Incorporate interface changes for HT support.
>
> Add ba_bitmap field to the wl1271_link struct, to indicate
> activate RX BA sessions (for AP mode).
>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
...

> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 994a26d..e523f0b 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -283,14 +283,15 @@ static struct conf_drv_settings default_conf = {
>                        0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>                        0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>                        0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>                },
>        },
>        .ht = {
> -               .tx_ba_win_size = 64,
> +               .tx_ba_win_size = 8,
Is the FW stop supporting TX BA win of 64?

All the best,
Shahar
