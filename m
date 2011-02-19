Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45837 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1BSKAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 05:00:47 -0500
Received: by bwz15 with SMTP id 15so1453215bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 02:00:46 -0800 (PST)
Date: Sat, 19 Feb 2011 13:00:27 +0300
From: Dan Carpenter <error27@gmail.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: greg@kroah.com, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/15] staging: ath6kl: Add configuration for excessive
 TX retry threshold
Message-ID: <20110219100027.GD4384@bicker>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
 <1298063596-2096-10-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298063596-2096-10-git-send-email-vmehta@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are style issues with almost all the patches in this series.
Please read Documentation/CodingStyle and run checkpatch.pl on 
your patches before sending.

On Fri, Feb 18, 2011 at 01:13:11PM -0800, Vipin Mehta wrote:
> +static int
> +ar6000_xioctl_set_excess_tx_retry_thres_cmd(struct net_device * dev, char * userdata)
> +{
> +    AR_SOFTC_T     *ar     = (AR_SOFTC_T *)ar6k_priv(dev);
                  ^^^^
White space not needed here.
Better to declare this as:
	struct ar6_softc *ar = (struct ar6_softc *)ar6k_priv(dev);

> +    WMI_SET_EXCESS_TX_RETRY_THRES_CMD cmd;
> +    int ret = 0;
> +
> +    if (ar->arWmiReady == false) {
> +        return -EIO;
> +    }

No curly braces needed.

> +
> +    if (copy_from_user(&cmd, userdata, sizeof(cmd))) {
> +        return -EFAULT;
> +    }

No curly braces needed.

> +
> +    if (wmi_set_excess_tx_retry_thres_cmd(ar->arWmi, &cmd) != 0)
                                                             ^^^^^
Not needed.

> +    {

Curly braces on the wrong line.
Curly braces were not needed.

> +        ret = -EINVAL;

Just return -EINVAL directly.

> +    }
> +    return(ret);
             ^   ^

Parentheses not needed.
Just return 0 directly.

> +}

Please you tabs to indent on new functions.  If the code is inside an
existing function then be consistent, but if it's a new function then
use tabs.

regards,
dan carpenter
