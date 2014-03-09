Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:46783 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751914AbaCIVPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 17:15:37 -0400
Message-ID: <1394399733.6972.47.camel@joe-AO722> (sfid-20140309_221540_883727_2EF637CA)
Subject: Re: [PATCH 4/6] ath6kl: remove unnecessary line continuations
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Sun, 09 Mar 2014 14:15:33 -0700
In-Reply-To: <20140309065729.10793.45052.stgit@x230>
References: <20140309065606.10793.67068.stgit@x230>
	 <20140309065729.10793.45052.stgit@x230>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-09 at 08:57 +0200, Kalle Valo wrote:
> Fixes checkpatch warning:
> WARNING: Avoid unnecessary line continuations
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
[]
> diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
[]
> @@ -45,8 +45,9 @@ module_param(testmode, uint, 0644);
>  module_param(recovery_enable, uint, 0644);
>  module_param(heart_beat_poll, uint, 0644);
>  MODULE_PARM_DESC(recovery_enable, "Enable recovery from firmware error");
> -MODULE_PARM_DESC(heart_beat_poll, "Enable fw error detection periodic"   \
> -		 "polling. This also specifies the polling interval in"  \
> +MODULE_PARM_DESC(heart_beat_poll,
> +		 "Enable fw error detection periodic"
> +		 "polling. This also specifies the polling interval in"
>  		 "msecs. Set reocvery_enable for this to be effective");

Couple things:

o There's a missing space between periodic and polling
o There's a typo of recovery

My suggestion would be to use:

MODULE_PARM_DESC(heart_beat_poll,
		 "Enable fw error detection periodic polling in msecs - Also set recovery_enable for this to be effective");


