Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56145 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1FDS4C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 14:56:02 -0400
Received: by qyg14 with SMTP id 14so1396031qyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jun 2011 11:56:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110604144854.GA4865@localhost.localdomain>
References: <20110604144854.GA4865@localhost.localdomain>
Date: Sat, 4 Jun 2011 20:56:02 +0200
Message-ID: <BANLkTi=g-j95ZVgCavo3pucutTLhcZ5E2A@mail.gmail.com> (sfid-20110604_205711_116897_CDE3A195)
Subject: Re: [PATCH wireless-2.6 v2] rt2x00: fix rmmod crash
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 4, 2011 at 4:48 PM, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> Avoid queue and run autowakeup_work when device is not present anymore.
> That prevent rmmod and device remove crash introduced by:
>
> commit 1c0bcf89d85cc97a0d9ce4cd909351a81fa4fdde
> Author: Ivo van Doorn <ivdoorn@gmail.com>
> Date:   Sat Apr 30 17:18:18 2011 +0200
>
>    rt2x00: Add autowake support for USB hardware
>
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

John, can you push this to 3.0-rc (I think the above mentioned
patch also went into that tree).

Thanks.

Ivo

> ---
>  drivers/net/wireless/rt2x00/rt2x00config.c |    3 ++-
>  drivers/net/wireless/rt2x00/rt2x00dev.c    |    4 ++++
>  2 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
> index 555180d..b704e5b 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00config.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00config.c
> @@ -250,7 +250,8 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
>        if (ieee80211_flags & IEEE80211_CONF_CHANGE_CHANNEL)
>                rt2x00link_reset_tuner(rt2x00dev, false);
>
> -       if (test_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags) &&
> +       if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
> +           test_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags) &&
>            (ieee80211_flags & IEEE80211_CONF_CHANGE_PS) &&
>            (conf->flags & IEEE80211_CONF_PS)) {
>                beacon_diff = (long)jiffies - (long)rt2x00dev->last_beacon;
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index c018d67..939821b 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -146,6 +146,9 @@ static void rt2x00lib_autowakeup(struct work_struct *work)
>        struct rt2x00_dev *rt2x00dev =
>            container_of(work, struct rt2x00_dev, autowakeup_work.work);
>
> +       if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
> +               return;
> +
>        if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
>                ERROR(rt2x00dev, "Device failed to wakeup.\n");
>        clear_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
> @@ -1160,6 +1163,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>         * Stop all work.
>         */
>        cancel_work_sync(&rt2x00dev->intf_work);
> +       cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
>        if (rt2x00_is_usb(rt2x00dev)) {
>                del_timer_sync(&rt2x00dev->txstatus_timer);
>                cancel_work_sync(&rt2x00dev->rxdone_work);
> --
> 1.7.4
>
>
