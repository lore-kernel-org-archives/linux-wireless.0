Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44494 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753985AbdHWOtU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 10:49:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] at76c50x-usb: check memory allocation failure
References: <1503498556-13835-1-git-send-email-himanshujha199640@gmail.com>
Date: Wed, 23 Aug 2017 17:49:15 +0300
In-Reply-To: <1503498556-13835-1-git-send-email-himanshujha199640@gmail.com>
        (Himanshu Jha's message of "Wed, 23 Aug 2017 19:59:16 +0530")
Message-ID: <87tw0ywd90.fsf@kamboji.qca.qualcomm.com> (sfid-20170823_164923_915359_DA146469)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himanshu Jha <himanshujha199640@gmail.com> writes:

> Check memory allocation failure and return -ENOMEM rather than just
> retuning void.
>
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>

[...]

> -static void at76_dump_mib_mac_addr(struct at76_priv *priv)
> +static int at76_dump_mib_mac_addr(struct at76_priv *priv)
>  {
>  	int i;
>  	int ret;
> @@ -940,7 +940,7 @@ static void at76_dump_mib_mac_addr(struct at76_priv *priv)
>  					 GFP_KERNEL);
>  
>  	if (!m)
> -		return;
> +		return -ENOMEM;

This feels rather pointless. You are changing these functions to return
an error code but the callers it anyway. And besides, did you check
where these are actually used?

	if (at76_debug & DBG_MIB) {
		at76_dump_mib_mac(priv);
		at76_dump_mib_mac_addr(priv);
		at76_dump_mib_mac_mgmt(priv);
		at76_dump_mib_mac_wep(priv);
		at76_dump_mib_mdomain(priv);
		at76_dump_mib_phy(priv);
		at76_dump_mib_local(priv);
	}

So it's just for debug messages and the current error handling looks the
correct approach. There is not much anything else we can do than just
skip the message printout.

-- 
Kalle Valo
