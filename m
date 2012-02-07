Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39487 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab2BGMwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 07:52:12 -0500
Received: by mail-vx0-f174.google.com with SMTP id e1so4592507vcg.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 04:52:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328568313-26267-7-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-2-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-3-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-4-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-5-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-6-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-7-git-send-email-gwingerde@gmail.com>
Date: Tue, 7 Feb 2012 13:52:11 +0100
Message-ID: <CAOZOX0X611UkCWE_q2B3xc35D80snmMGD06-DBkD+7AyEJr-sA@mail.gmail.com> (sfid-20120207_135220_264005_50E6812E)
Subject: Re: [PATCH 6/8] rt2x00: Align RT3572 channel switch RFCSR 1
 programming with Ralink driver.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 11:45 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Align with the v2.5.0.0 Ralink RT3572 driver.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 66af6f4..2afb798 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1806,11 +1806,12 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
>        rt2800_rfcsr_write(rt2x00dev, 13, rfcsr);
>
>        rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
> -       rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
>        rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
>        rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
>        rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 0);
>        rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
> +       rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
> +       rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
>        if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags)) {
>                if (rf->channel <= 14) {
>                        rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
> --
> 1.7.9
>
