Received: from mx1.white.stw.pengutronix.de (mx1.white.stw.pengutronix.de [185.203.200.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E886D3D953D;
	Tue, 28 Jul 2026 07:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.200.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785222516; cv=none; b=Ea7HlQPvf/v8Lx/EXi2Q2aNt5D6qplkqU+hYnj1ctuKFtDO1qlcG6CZnluvWMuuTe0U4TrdCSDS/Tziofx41/r1LBM01RIhSZcHhI0KJEHX8zQf9S3PGXNhrnmjhZ8kowOpnHf0pGkKtJlzU4GkiyhjWlDvPcxgKuhWOYU2w2kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785222516; c=relaxed/simple;
	bh=enItIOkR8QUL0XzFFYgjjcYLoiaHw/mGSpalR5j5Dz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gxWpBnb2huy/xfVqOUZu8XDHD7U6RFSRktyeh22HANtaOt5NHo+sDgxfLv9UsIvNr0LqclJOKDd4d8wozoKNDIZMOsv5rzpxBXNZYiu4oOi0sKVPN6mtZ/wC5GrZ7qp/qLX0K/6+w9p8XcqXoDbqUqyGvatu8SQeA455glaDiCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.200.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de (drehscheibe.grey.stw.pengutronix.de [IPv6:2a0a:edc0:0:c01:1d::a2])
	(Authenticated sender: relay-from-drehscheibe.grey.stw.pengutronix.de)
	by mx1.white.stw.pengutronix.de (Postfix) with ESMTPSA id 904342028FD;
	Tue, 28 Jul 2026 09:08:28 +0200 (CEST)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[IPV6:::1])
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.96)
	(envelope-from <s.kerkmann@pengutronix.de>)
	id 1wobvQ-001gLd-1W;
	Tue, 28 Jul 2026 09:08:28 +0200
Message-ID: <ae47a0de-e53e-4d61-849c-dbf8c646eff7@pengutronix.de>
Date: Tue, 28 Jul 2026 09:08:28 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: mwifiex: fix freeze for 60 seconds caused by
 request_firmware
To: Georgi Valkov <gvalkov@gmail.com>, briannorris@chromium.org
Cc: francesco@dolcini.it, johannes.berg@intel.com, kees@kernel.org,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260712221709.7099-1-gvalkov@gmail.com>
From: Stefan Kerkmann <s.kerkmann@pengutronix.de>
Content-Language: en-US, de-DE
In-Reply-To: <20260712221709.7099-1-gvalkov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Georgi,

thank you for the fix!

On 7/13/26 00:17, Georgi Valkov wrote:
> Fix regression in rgpower table loading, caused by using
> request_firmware(): when the requested firmware does not exist, e.g.
> nxp/rgpower_WW.bin does not exist on OpenWRT builds for WRT3200ACM,
> request_firmware() falls back to firmware_fallback_sysfs(), which expects
> the firmware to be provided by user space using SYSFS. No such utility is
> provided in this configuration, so the entire system locks up for 60
> seconds, until the request times out. During this time, no other log
> messages are observed, and the device does not respond to commands over
> UART.
> 
> The request_firmware() call is performed in the following context:
> current->comm kworker/1:2  in_task 1  irqs_disabled 0  in_atomic 0
> 
> Fixed by using request_firmware_direct(). This prevents fallback to SYSFS,
> and avoids delay. The rgpower table is optional. The driver falls back
> to the device tree power table if the firmware is not present.
> 
> The error code is printed for debugging and returned to the caller,
> which only cares for success or failure, so there are no side effects.
> 
> Fixes: 7b6f16a25806 ("wifi: mwifiex: add rgpower table loading support")
> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>

Reviewed-by: Stefan Kerkmann <s.kerkmann@pengutronix.de>

> ---
>  drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> index a6550548d3b4..9460d5352b23 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> @@ -196,6 +196,7 @@ static int mwifiex_request_rgpower_table(struct mwifiex_private *priv)
>  	struct mwifiex_adapter *adapter = priv->adapter;
>  	char rgpower_table_name[30];
>  	char country_code[3];
> +	int ret;
>  
>  	strscpy(country_code, domain_info->country_code, sizeof(country_code));
>  
> @@ -214,16 +215,17 @@ static int mwifiex_request_rgpower_table(struct mwifiex_private *priv)
>  		adapter->rgpower_data = NULL;
>  	}
>  
> -	if ((request_firmware(&adapter->rgpower_data, rgpower_table_name,
> -			      adapter->dev))) {
> +	ret = request_firmware_direct(&adapter->rgpower_data, rgpower_table_name,
> +				      adapter->dev);
> +
> +	if (ret) {
>  		mwifiex_dbg(
>  			adapter, INFO,
> -			"info: %s: failed to request regulatory power table\n",
> -			__func__);
> -		return -EIO;
> +			"info: %s: failed to request regulatory power table: %d\n",
> +			__func__, ret);
>  	}
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static int mwifiex_dnld_rgpower_table(struct mwifiex_private *priv)

-- 
Pengutronix e.K.                       | Stefan Kerkmann             |
Steuerwalder Str. 21                   | https://www.pengutronix.de/ |
31137 Hildesheim, Germany              | Phone: +49-5121-206917-128  |
Amtsgericht Hildesheim, HRA 2686       | Fax:   +49-5121-206917-9    |

