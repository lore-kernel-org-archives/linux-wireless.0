Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5783 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaDXIWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 04:22:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP firmware
References: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
Date: Thu, 24 Apr 2014 11:22:39 +0300
In-Reply-To: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Thu, 24 Apr 2014 16:14:10 +0800")
Message-ID: <87d2g7m90w.fsf@kamboji.qca.qualcomm.com> (sfid-20140424_102253_599695_BBBE9AF5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> Firmware 999.999.0.636 does not allow stand alone monitor
> mode. This means that bridging the STA mode and put it into
> promiscuous mode will also cause the firmware to crash. Avoid
> this.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

[...]

> @@ -647,10 +647,15 @@ static int ath10k_monitor_vdev_delete(struct ath10k *ar)
>  
>  static int ath10k_monitor_start(struct ath10k *ar)
>  {
> -	int ret;
> +	int ret = -1;

I prefer to avoid initialising ret variables. And -1 is not a proper
error value.

>  	lockdep_assert_held(&ar->conf_mutex);
>  
> +	if (ar->fw_version_build == 636) {

Checking for firmware version in ath10k is a big no. For a functinality
change like this you should add a new feature flag to enum
ath10k_fw_features (and I need to then recreate the firmware image).

> +		ath10k_warn("stand alone monitor mode is not supported\n");

I would prefer not to print a warning for a situation like this. Can't
we instead return an error value back to the caller?

> +		return ret;

return -EOPNOTSUPP or similar is better approach than initialising ret
to -1.

-- 
Kalle Valo
