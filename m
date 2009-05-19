Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4321 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZESEC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 00:02:57 -0400
Date: Tue, 19 May 2009 00:02:39 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@iki.fi
Subject: Re: [WIP PATCH] sdio support for wl12xx
Message-ID: <20090519040239.GA12911@hash.localnet>
References: <20090518180957.GD2580@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090518180957.GD2580@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2009 at 02:09:57PM -0400, Bob Copeland wrote:
> yet for applying.  However, it does load (with the proper setup code)
> on my Android dev phone, chip probe works, and probably the rest too,
> though I didn't get that far.  

So much for hubris!

> +void wl12xx_sdio_read(struct wl12xx *wl, int addr, void *buf, size_t len)
> +{
> +	int ret, i;

sdio_claim_host(wl->func);
  
> +	for (i=0; i < 5; i++) {
> +		if (i < 2)
> +			ret = read_direct(wl->func, buf, addr, len);
> +		else
> +			ret = sdio_memcpy_fromio(wl->func, buf, addr, len);
> +
> +		if (!ret)
> +			break;
> +	}

sdio_release_host(wl->func);

> +}

And so on with write() (and dropping around wl12xx_init_ieee80211 to avoid
the recursive lock).  That kills some warnings.

iwconfig shows:

wlan0     IEEE 802.11bg  ESSID:""  
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated   
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

So at least mac80211 is up and running.

I'm missing the NVS tables so 'ifconfig wlan0 up' bails on fw load.

-- 
Bob Copeland %% www.bobcopeland.com

