Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:60628 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZKPO0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 09:26:54 -0500
Received: by ywh40 with SMTP id 40so3089273ywh.33
        for <linux-wireless@vger.kernel.org>; Mon, 16 Nov 2009 06:26:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091116023317.GA6331@localhost.localdomain>
References: <20091116023317.GA6331@localhost.localdomain>
Date: Mon, 16 Nov 2009 09:21:58 -0500
Message-ID: <1b7401870911160621v4afe9db8j71a817253e6381f3@mail.gmail.com>
Subject: Re: [PATCH] rt2800: do not enable tbtt unless we are in a beacon mode
From: Josef Bacik <josef@toxicpanda.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-wireless@vger.kernel.org, ivdoorn@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 15, 2009 at 9:33 PM, Josef Bacik <josef@redhat.com> wrote:
> Please be gentle, I'm a fs developer and this is my first foray into drivers, as
> I'm tired of building ralinks driver everytime I update my kernel.  Whenever I
> load the rt2800pci driver my box bogs down, and a few printk's later I
> discovered its because I was getting 10's of thousands of TBTT interrupts a
> second.  I discovered this was because we were setting the beacon timer to 0,
> which is apparently what TBTT keys off of.  It seems to me that we should only
> be enabling TBTT when we are in a beacon transmitting mode, which from what I
> can tell is in AD-HOC and other such modes where the mac80211 layer would have
> given us a proper beacon_int to set the beacon timer to instead of 0.  So this
> is my fix, only enable TBTT if our sync mode is for beacon.  This makes it so my
> box doesn't die everytime I load the rt2800pci driver.  Let me know if this is
> acceptable, I just learned all these terms about 15 minutes ago via wikipedia,
> so I really am not familiar with how this stuff is supposed to work.  Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index eb6d129..e90d6fd 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -560,7 +560,8 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
>                rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
>                rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
>                rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, conf->sync);
> -               rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
> +               rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE,
> +                                  (conf->sync == TSF_SYNC_BEACON));
>                rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
>        }
>

Oh btw this is against the wireless-testing git tree, I forgot to
mention that.  Thanks,

Josef
