Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab2GSOyo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 10:54:44 -0400
Date: Thu, 19 Jul 2012 16:54:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Chen, Chien-Chia" <machen@suse.com>
Cc: users@rt2x00.serialmonkey.com, kevin.chou@mediatek.com,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users]  [PATCH] rt2x00 : fix rt3290 resuming failed.
Message-ID: <20120719145430.GA4231@redhat.com> (sfid-20120719_165448_314160_0DDB625C)
References: <1342667903-27314-1-git-send-email-machen@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1342667903-27314-1-git-send-email-machen@suse.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 19, 2012 at 11:18:23AM +0800, Chen, Chien-Chia wrote:
> +	if (rt2x00_rt(rt2x00dev,RT3290)){
Please add space after a comma.

> +		retval = rt2800_enable_wlan_rt3290(rt2x00dev);
> +		if (retval)
> +			return -EBUSY;
> +	}
Since we enabling device here, it's probably not needed to do this on
rt2800pci_probe_hw, or I'm wrong?

> +			if ((rt2x00_get_field32(reg, PLL_LD) == 1) &&
> +				(rt2x00_get_field32(reg, XTAL_RDY) == 1))
> +					break;
Use proper coding style here (see below). Seems you did not copy this
function from rt2800pci.c, but take it form other source, so it could
miss some other changes as well.

> +
> +			rt2800_register_write(rt2x00dev, 0x58, 0x018);
> +			udelay(REGISTER_BUSY_DELAY);
> +			rt2800_register_write(rt2x00dev, 0x58, 0x418);
> +			udelay(REGISTER_BUSY_DELAY);
> +			rt2800_register_write(rt2x00dev, 0x58, 0x618);
We really like to know what those black magic numbers mean.

> -			if (rt2x00_get_field32(reg, PLL_LD) &&
> -			    rt2x00_get_field32(reg, XTAL_RDY))
> -				break;
Here is how above part should look like.

Stanislaw
