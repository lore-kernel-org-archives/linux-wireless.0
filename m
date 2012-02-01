Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56583 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2BAKaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 05:30:35 -0500
Received: by dadp15 with SMTP id p15so755616dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 02:30:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327936679-12576-3-git-send-email-sgruszka@redhat.com>
References: <1327936679-12576-1-git-send-email-sgruszka@redhat.com>
	<1327936679-12576-3-git-send-email-sgruszka@redhat.com>
Date: Wed, 1 Feb 2012 11:30:35 +0100
Message-ID: <CAGXE3d_Yp3FRbeYHvLYTdtMc+OVJp2gW70yB-L1Diug7yAp9uw@mail.gmail.com> (sfid-20120201_113039_227393_AA64EC10)
Subject: Re: [PATCH 3/4] rt2800: radio 3xxx: add channel switch calibration routines
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 30, 2012 at 4:17 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Synchronize code with Ralink driver:
> 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
> Based on functions:
> RT33xx_ChipSwitchChannel
> RT30xx_ChipSwitchChannel
>
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index a841918..b5dcc48 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1700,6 +1700,13 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
>        }
>        rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
>
> +       rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> +       rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> +       rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> +       msleep(1);
> +       rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
> +       rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> +
>        rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
>        rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
>        rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
> @@ -1710,6 +1717,13 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
>        rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
>        rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
>        rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
> +
> +       rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> +       rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> +       rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> +       msleep(1);
> +       rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
> +       rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
>  }

This was also introduced for later chipsets only but since Ralink left the
code in for all chipsets I guess this is ok ...

Helmut
