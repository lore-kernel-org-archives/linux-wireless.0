Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab2G3Lpz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 07:45:55 -0400
Date: Mon, 30 Jul 2012 13:45:16 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Chen, Chien-Chia" <machen@suse.com>
Cc: users@rt2x00.serialmonkey.com, kevin.chou@mediatek.com,
	woody.hung@mediatek.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users]  [PATCH v2] rt2x00 : fix rt3290 resuming failed.
Message-ID: <20120730114515.GA3722@redhat.com> (sfid-20120730_134618_011032_4FA9891D)
References: <1343645143-10602-1-git-send-email-machen@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1343645143-10602-1-git-send-email-machen@suse.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -400,6 +400,14 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
>  {
>  	unsigned int i;
>  	u32 reg;
> +
> +	int retval;
> +
> +	if (rt2x00_rt(rt2x00dev, RT3290)) {
> +		retval = rt2800_enable_wlan_rt3290(rt2x00dev);
> +		if (retval)
> +			return -EBUSY;
> +	}

Since we call that here, why we need this also in rt2800pci_probe_hw() ?

Stanislaw
