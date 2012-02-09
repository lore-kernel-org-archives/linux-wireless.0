Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38326 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab2BIKko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 05:40:44 -0500
Received: by yhoo21 with SMTP id o21so729261yho.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 02:40:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328783095-8330-1-git-send-email-florian@openwrt.org>
References: <20120208180102.18346jfdlm9wakw8@www.81.fi> <1328783095-8330-1-git-send-email-florian@openwrt.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 Feb 2012 21:40:23 +1100
Message-ID: <CAGRGNgX-_s_EsbBLxs6UNJd7=3Yk0HECfxb-HSB_-r6cDyyuuA@mail.gmail.com> (sfid-20120209_114047_738473_CB442F20)
Subject: Re: [PATCH] zd1211rw: wait between setting hash table and powering
 radio on
To: Florian Fainelli <florian@openwrt.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	dsd@gentoo.org, kune@deine-taler.de, jussi.kivilinna@mbnet.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Florian,

A couple of minor points:

On Thu, Feb 9, 2012 at 21:24, Florian Fainelli <florian@openwrt.org> wrote:
> I am running Debian testing kernel 3.1.0-1-amd64, using a 079b:0062 Sagem
> XG-76NA 802.11bg stick.
>
> Upon zd1211rw interface
> bringup (ifconfig wlan0 up) I get the following timeout:
>
> [  950.330573] zd1211rw 1-3:1.0: phy2
> [  955.108510] zd1211rw 1-3:1.0: firmware version 4725
> [  955.148532] zd1211rw 1-3:1.0: zd1211b chip 079b:0062 v4810 high 00-19-70
> AL2230_RF pa0 g--NS
> [snip]
> [  955.204072] zd1211rw 1-3:1.0: error ioread32(CR_REG1): -110
>
> A second ifconfig wlan0 up brings the interface up without problems.
>
> After a bit more debugging, the call trace is the following:
>
> [10241.028130] zd1211rw 1-3:1.0: zd_chip_lock_phy_regs: error
> ioread32(CR_REG1): -110
> [10241.028140] zd1211rw 1-3:1.0: zd_switch_radio_on: failed to lock PHY regs
> [10241.028148] zd1211rw 1-3:1.0: zd_op_start: failed to set radio on
>
> Adding a 10 milliseconds delay between the call to set_mc_hash() and
> zd_chip_switch_radio_on() allows successful interface bringups in all
> cases and matches what the vendor driver did.
>
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
>  drivers/net/wireless/zd1211rw/zd_mac.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
> index 98a574a..bed634c 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -306,9 +306,14 @@ int zd_op_start(struct ieee80211_hw *hw)
>        r = set_mc_hash(mac);
>        if (r)
>                goto disable_int;
> +       msleep(10);

You might want to stick a comment in here to tell future developers
why we're doing this.

> +
>        r = zd_chip_switch_radio_on(chip);
> -       if (r < 0)
> +       if (r < 0) {
> +               dev_err(zd_chip_dev(chip),
> +                       "%s: failed to set radio on\n", __func__);
>                goto disable_int;
> +       }

It might also be an idea to have it re-try powering on the radio
after, say 100 msecs, just in case 10 msecs isn't enough for whatever
is causing this issue.

>        r = zd_chip_enable_rxtx(chip);
>        if (r < 0)
>                goto disable_radio;

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
