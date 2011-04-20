Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49768 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab1DTIja (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 04:39:30 -0400
Received: from public by plane.gmane.org with local (Exim 4.69)
	(envelope-from <public@plane.gmane.org>)
	id 1QCSel-0000MT-Ol
	for linux-wireless@vger.kernel.org; Wed, 20 Apr 2011 10:21:03 +0200
Message-ID: <4DAE9759.9020005@gmail.com>
Date: Wed, 20 Apr 2011 11:20:41 +0300
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
MIME-Version: 1.0
To: Sujith <public-m.sujith-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>
CC: public-linville-2XuSBdqkA4R54TAoqtyWWQ@plane.gmane.org,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
	public-ath9k-devel-xDcbHBWguxHbcTqmT+pZeQ@plane.gmane.org
Subject: Re: [PATCH 2/5] ath9k_htc: Fix AMPDU subframe handling
References: <19886.28554.581823.283614@gargle.gargle.HOWL>
In-Reply-To: <19886.28554.581823.283614@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/20/2011 08:30 AM, Sujith wrote:
> From: Sujith Manoharan<Sujith.Manoharan-DlyHzToyqoxBDgjK7y7TUQ@public.gmane.org>
>
> * Register the driver's maximum ampdu subframe limit to mac80211.
> * Cleanup the target capabilities structure and fix an endian issue.
> * Fix BTCOEX by sending a command to the target when the BT priority
>    changes.
> * Bump the required firmware version to 1.1
>
> Signed-off-by: Sujith Manoharan<Sujith.Manoharan-DlyHzToyqoxBDgjK7y7TUQ@public.gmane.org>

[...]

> +	/*
> +	 * Check if the available FW matches the driver's
> +	 * required version.
> +	 */
> +	if (priv->fw_version_major<  MAJOR_VERSION_REQ ||
> +	    priv->fw_version_minor<  MINOR_VERSION_REQ) {

Wrong version check logic. Version 2.0 will fail this 1.1 check, because 
of minor version number.
Should be something like:
if (priv->fw_version_major < MAJOR_VERSION_REQ ||
     (priv->fw_version_major == MAJOR_VERSION_REQ &&
      priv->fw_version_minor < MINOR_VERSION_REQ))

> +		dev_err(priv->dev, "ath9k_htc: Please upgrade to FW version %d.%d\n",
> +			MAJOR_VERSION_REQ, MINOR_VERSION_REQ);
> +		return -EINVAL;
> +	}
> +
>   	return 0;
>   }

