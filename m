Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49608 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdISOjH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 10:39:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Subject: Re: [PATCH] rsi: add driver and firmware version info
References: <1504094535-6680-1-git-send-email-amitkarwar@gmail.com>
Date: Tue, 19 Sep 2017 17:39:01 +0300
In-Reply-To: <1504094535-6680-1-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Wed, 30 Aug 2017 17:32:15 +0530")
Message-ID: <87mv5qah2y.fsf@kamboji.qca.qualcomm.com> (sfid-20170919_163911_567876_FAC6355B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
>
> We will dump information about driver and firmware versions,
> firmware file name and operating mode during initialization.
>
> Signed-off-by: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> +void rsi_print_version(struct rsi_common *common)
> +{
> +	memcpy(common->driver_ver, DRV_VER, ARRAY_SIZE(DRV_VER));
> +	common->driver_ver[ARRAY_SIZE(DRV_VER)] = '\0';
> +
> +	rsi_dbg(ERR_ZONE, "================================================\n");
> +	rsi_dbg(ERR_ZONE, "================ RSI Version Info ==============\n");
> +	rsi_dbg(ERR_ZONE, "================================================\n");
> +	rsi_dbg(ERR_ZONE, "FW Version\t: %d.%d.%d\n",
> +		common->lmac_ver.major, common->lmac_ver.minor,
> +		common->lmac_ver.release_num);
> +	rsi_dbg(ERR_ZONE, "Driver Version\t: %s", common->driver_ver);
> +	rsi_dbg(ERR_ZONE, "Operating mode\t: %d [%s]",
> +		common->oper_mode, opmode_str(common->oper_mode));
> +	rsi_dbg(ERR_ZONE, "Firmware file\t: %s", common->priv->fw_file_name);
> +	rsi_dbg(ERR_ZONE, "================================================\n");
> +}
> +

[...]

> +#define DRV_VER				"RS911X.NB0.NL.GNU.LNX.1.0"

The concept of a driver version does not really work with upstream
drivers. The history has shown multiple times that the driver version
won't be updated for years and thus it won't have any meaning. So better
remove driver_ver from the driver entirely.

-- 
Kalle Valo
