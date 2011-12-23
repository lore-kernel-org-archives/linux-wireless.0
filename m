Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17319 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab1LWNLS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 08:11:18 -0500
Message-ID: <4EF47DEC.10703@qca.qualcomm.com> (sfid-20111223_141122_897641_6C9DFBF5)
Date: Fri, 23 Dec 2011 15:11:08 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: TCMD responds through testmode events
References: <1324335768-8495-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1324335768-8495-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2011 01:02 AM, Thomas Pedersen wrote:
> ath6kl now no longer knows what is is sending and / or receiving through
> cfg80211_testmode, and simply passes opaque buffers between userspace
> and the firmware.

Patch title could be a bit more descriptive, like: "send TCMD events
through testmode events"

> @@ -30,7 +31,6 @@ enum ath6kl_tm_attr {
>  
>  enum ath6kl_tm_cmd {
>  	ATH6KL_TM_CMD_TCMD		= 0,
> -	ATH6KL_TM_CMD_RX_REPORT		= 1,
>  };

Please leave the enum but add a comment saying that it's not used anymore.

> +	skb = cfg80211_testmode_alloc_event_skb(ar->wiphy, buf_len, GFP_ATOMIC);

Why atomic?

> +	if (!skb) {
> +		ath6kl_dbg(ATH6KL_DBG_WMI,
> +			   "failed to allocate testmode rx skb!\n");

Please use ath6kl_warn()

> +	NLA_PUT_U32(skb, ATH6KL_TM_ATTR_CMD, ATH6KL_TM_CMD_TCMD);
> +	NLA_PUT(skb, ATH6KL_TM_ATTR_DATA, buf_len, buf);
> +	cfg80211_testmode_event(skb, GFP_ATOMIC);

Why atomic?

>  nla_put_failure:
> -	ret = -ENOBUFS;
> -	goto out;
> +	kfree_skb(skb);
> +	ath6kl_dbg(ATH6KL_DBG_WMI, "nla_put failed on testmode rx skb!\n");

ath6kl_warn()

Kalle
