Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54339 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbbAOLo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 06:44:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Troy Tan <troy_tan@realsil.com.cn>,
	netdev@vger.kernel.org
Subject: Re: [PATCH for 3.19 2/3] rtlwifi: Fix handling of new style descriptors
References: <1421257036-5382-1-git-send-email-Larry.Finger@lwfinger.net>
	<1421257036-5382-3-git-send-email-Larry.Finger@lwfinger.net>
Date: Thu, 15 Jan 2015 13:44:51 +0200
In-Reply-To: <1421257036-5382-3-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Wed, 14 Jan 2015 11:37:15 -0600")
Message-ID: <877fwoxo7g.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_124502_222793_000B22EC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Troy Tan <troy_tan@realsil.com.cn>
>
> The hardware and firmware for the RTL8192EE utilize a FIFO list of
> descriptors. There were some problems with the initial implementation.
> The worst of these failed to detect that the FIFO was becoming full,
> which led to the device needing to be power cycled. As this condition
> is not relevant to most of the devices supported by rtlwifi, a callback
> routine was added to detect this situation. This patch implements the
> necessary changes in the pci handler.
>
> Signed-off-by: Troy Tan <troy_tan@realsil.com.cn>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

[...]

> --- a/drivers/net/wireless/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/rtlwifi/wifi.h
> @@ -2172,6 +2172,7 @@ struct rtl_hal_ops {
>  	void (*add_wowlan_pattern)(struct ieee80211_hw *hw,
>  				   struct rtl_wow_pattern *rtl_pattern,
>  				   u8 index);
> +	u16 (*get_available_desc)(struct ieee80211_hw *hw, u8 q_idx);

I don't see this op set anywhere within the patch. Is that correct or
did I miss something?

-- 
Kalle Valo
