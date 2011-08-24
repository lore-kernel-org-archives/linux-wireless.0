Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57474 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1HXOkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 10:40:17 -0400
Message-ID: <4E550D34.7020008@qca.qualcomm.com> (sfid-20110824_164021_275875_DB9BE01C)
Date: Wed, 24 Aug 2011 17:39:48 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Add initial debugfs changes
References: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2011 05:25 PM, Vasanthakumar Thiagarajan wrote:
> +#ifdef CONFIG_ATH6KL_DEBUGFS
> +int ath6kl_init_debugfs(struct ath6kl *ar);
> +#else
> +static inline int ath6kl_init_debugfs(struct ath6kl *ar)
> +{
> +	return 0;
> +}
> +#endif

I would prefer to call this ath6kl_debug_init(). That way we can put all
debug initialisation into that, not just debugfs code. And then the
ifdef should check for CONFIG_ATH6KL_DEBUG.

Kalle
