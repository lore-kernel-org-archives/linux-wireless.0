Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:47132 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbbAWUMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 15:12:36 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Troy Tan <troy_tan@realsil.com.cn>,
	netdev@vger.kernel.org
Subject: Re: [PATCH 5/6] rtlwifi: btcoexist: Add routines for RTL8812AE - all configs
References: <1422033044-7461-1-git-send-email-Larry.Finger@lwfinger.net>
	<1422033044-7461-6-git-send-email-Larry.Finger@lwfinger.net>
Date: Fri, 23 Jan 2015 22:12:30 +0200
In-Reply-To: <1422033044-7461-6-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Fri, 23 Jan 2015 11:10:43 -0600")
Message-ID: <87mw59jlxt.fsf@kamboji.qca.qualcomm.com> (sfid-20150123_211241_178548_A5C53A90)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Troy Tan <troy_tan@realsil.com.cn>
>
> This patch adds the routines used for all antenna configurations.
>
> Signed-off-by: Troy Tan <troy_tan@realsil.com.cn>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

The commit log is REALLY vague...

> +static u8 rtl_btcoex_create_kernel_socket(struct rtl_priv *rtlpriv,
> +					  u8 is_invite)
> +{
> +	struct bt_coex_info *pcoex_info = &rtlpriv->coex_info;
> +	s8 kernel_socket_err;
> +
> +	BTC_PRINT(BTC_MSG_SOCKET, SOCKET_CRITICAL,
> +		  "%s CONNECT_PORT %d\n", __func__, CONNECT_PORT);
> +
> +	if (!pcoex_info) {
> +		BTC_PRINT(BTC_MSG_SOCKET, SOCKET_CRITICAL, "coex_info: NULL\n");
> +		return _FAIL;
> +	}
> +
> +	kernel_socket_err = sock_create(PF_INET, SOCK_DGRAM, 0,
> +					&pcoex_info->udpsock);
> +	BTC_PRINT(BTC_MSG_SOCKET, SOCKET_CRITICAL,
> +		  "binding socket, err = %d\n", kernel_socket_err);
> +
> +	if (kernel_socket_err < 0) {
> +		BTC_PRINT(BTC_MSG_SOCKET, SOCKET_CRITICAL,
> +			  "Error during creation of socket error:%d\n",
> +			  kernel_socket_err);
> +		return _FAIL;
> +	}
> +	memset(&pcoex_info->sin, 0, sizeof(pcoex_info->sin));
> +	pcoex_info->sin.sin_family = AF_INET;
> +	pcoex_info->sin.sin_port = htons(CONNECT_PORT);
> +	pcoex_info->sin.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

...and then I see stuff like this. What an earth does this do?

-- 
Kalle Valo
