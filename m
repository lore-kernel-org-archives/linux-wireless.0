Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:37579 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3FKSZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 14:25:30 -0400
Received: by mail-ea0-f181.google.com with SMTP id a15so4041498eae.12
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 11:25:29 -0700 (PDT)
References: <1370969333-4649-1-git-send-email-sgruszka@redhat.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1370969333-4649-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <DD2B8C0B-3AFD-447C-8562-DA74792F2EC5@gmail.com> (sfid-20130611_202533_954486_ACFA2EFB)
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 3.10] rt2800: fix RT5390 & RT3290 TX power settings regression
Date: Tue, 11 Jun 2013 20:25:26 +0200
To: Stanislaw Gruszka <sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 11 jun. 2013, at 18:48, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> My change:
> 
> commit cee2c7315f60beeff6137ee59e99acc77d636eeb
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Fri Oct 5 13:44:09 2012 +0200
> 
>    rt2800: use BBP_R1 for setting tx power
> 
> unfortunately does not work well with RT5390 and RT3290 chips as they
> require different temperature compensation TX power settings (TSSI
> tuning). Since that commit make wireless connection very unstable on
> those chips, restore previous behavior to fix regression. Once we
> implement proper TSSI tuning on 5390/3290 we can restore back setting
> TX power by BBP_R1 register for those chips.
> 
> Reported-and-tested-by: Mike Romberg <mike-romberg@comcast.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2800lib.c | 29 ++++++++++++++++++-----------
> 1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 92849e5..8b679df 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2634,19 +2634,26 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
>     * TODO: we do not use +6 dBm option to do not increase power beyond
>     * regulatory limit, however this could be utilized for devices with
>     * CAPABILITY_POWER_LIMIT.
> +     *
> +     * TODO: add different temperature compensation code for RT3290 & RT5390
> +     * to allow to use BBP_R1 for those chips.
>     */
> -    rt2800_bbp_read(rt2x00dev, 1, &r1);
> -    if (delta <= -12) {
> -        power_ctrl = 2;
> -        delta += 12;
> -    } else if (delta <= -6) {
> -        power_ctrl = 1;
> -        delta += 6;
> -    } else {
> -        power_ctrl = 0;
> +    if (!rt2x00_rt(rt2x00dev, RT3290) &&
> +        !rt2x00_rt(rt2x00dev, RT5390)) {
> +        rt2800_bbp_read(rt2x00dev, 1, &r1);
> +        if (delta <= -12) {
> +            power_ctrl = 2;
> +            delta += 12;
> +        } else if (delta <= -6) {
> +            power_ctrl = 1;
> +            delta += 6;
> +        } else {
> +            power_ctrl = 0;
> +        }
> +        rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, power_ctrl);
> +        rt2800_bbp_write(rt2x00dev, 1, r1);
>    }
> -    rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, power_ctrl);
> -    rt2800_bbp_write(rt2x00dev, 1, r1);
> +
>    offset = TX_PWR_CFG_0;
> 
>    for (i = 0; i < EEPROM_TXPOWER_BYRATE_SIZE; i += 2) {
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
