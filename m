Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:65125 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZKPRoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 12:44:23 -0500
Received: by qyk4 with SMTP id 4so2759257qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 16 Nov 2009 09:44:28 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] rt2800: do not enable tbtt unless we are in a beacon mode
Date: Mon, 16 Nov 2009 18:44:24 +0100
Cc: linux-wireless@vger.kernel.org, users@host1.serialmonkey.com,
	John Linville <linville@tuxdriver.com>
References: <20091116023317.GA6331@localhost.localdomain>
In-Reply-To: <20091116023317.GA6331@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911161844.25162.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ Added john to CC list ]

On Monday 16 November 2009, Josef Bacik wrote:
> Please be gentle, I'm a fs developer and this is my first foray into drivers, as
> I'm tired of building ralinks driver everytime I update my kernel.  Whenever I
> load the rt2800pci driver my box bogs down, and a few printk's later I
> discovered its because I was getting 10's of thousands of TBTT interrupts a
> second.  I discovered this was because we were setting the beacon timer to 0,
> which is apparently what TBTT keys off of.  It seems to me that we should only
> be enabling TBTT when we are in a beacon transmitting mode, which from what I
> can tell is in AD-HOC and other such modes where the mac80211 layer would have
> given us a proper beacon_int to set the beacon timer to instead of 0.  So this
> is my fix, only enable TBTT if our sync mode is for beacon.  This makes it so my
> box doesn't die everytime I load the rt2800pci driver.  Let me know if this is
> acceptable, I just learned all these terms about 15 minutes ago via wikipedia,
> so I really am not familiar with how this stuff is supposed to work.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Good catch.

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index eb6d129..e90d6fd 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -560,7 +560,8 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
>  		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
>  		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
>  		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, conf->sync);
> -		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
> +		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE,
> +				   (conf->sync == TSF_SYNC_BEACON));
>  		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
>  	}
>  


