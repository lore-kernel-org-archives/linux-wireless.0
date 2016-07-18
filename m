Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43501 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbcGRInO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 04:43:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Maxim Altshul <maxim.altshul@ti.com>
Cc: <linux-kernel@vger.kernel.org>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>, Yaniv Machani <yanivma@ti.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2 v4] wlcore: Add support for get_expected_throughput opcode
References: <20160711142251.30443-1-maxim.altshul@ti.com>
	<20160711142251.30443-2-maxim.altshul@ti.com>
Date: Mon, 18 Jul 2016 11:43:10 +0300
In-Reply-To: <20160711142251.30443-2-maxim.altshul@ti.com> (Maxim Altshul's
	message of "Mon, 11 Jul 2016 17:22:33 +0300")
Message-ID: <87inw39w0x.fsf@purkki.adurom.net> (sfid-20160718_104333_917330_0C2EA02B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Altshul <maxim.altshul@ti.com> writes:

> Adding this opcode, allows the TI wireless driver,
> to report throughput directly from FW to mac80211.
>
> This is used mainly for mesh metric calculation.
>
> Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>

[...]

> +static u32 wlcore_op_get_expected_throughput(struct ieee80211_sta *sta)
> +{
> +	struct wl1271_station *wl_sta = (struct wl1271_station *)sta->drv_priv;
> +	struct wl1271 *wl = wl_sta->wl;
> +	u8 hlid = wl_sta->hlid;
> +
> +	/* return in units of Kbps */
> +		return (wl->links[hlid].fw_rate_mbps * 1000);

The indentation looks wrong, but I can fix it before I apply the patch.

-- 
Kalle Valo
