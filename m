Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60824 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab1JYHAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 03:00:38 -0400
Message-ID: <4EA65E8E.5080909@qca.qualcomm.com> (sfid-20111025_090042_541908_323453CA)
Date: Tue, 25 Oct 2011 10:00:30 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath6kl: Implement support for background scan control
 from userspace
References: <1318983606-8959-1-git-send-email-rpanjwan@qca.qualcomm.com> <1318983606-8959-2-git-send-email-rpanjwan@qca.qualcomm.com>
In-Reply-To: <1318983606-8959-2-git-send-email-rpanjwan@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/19/2011 03:20 AM, Rishi Panjwani wrote:
> In order to allow user space based control of background scan interval,
> we use available debugfs infrastructure. The feature has been added for
> testing purposes. The user has to write the bgscan interval (in secs) to
> the bgscan_interval file in ath6kl debug directory. To disable bgscan,
> a '0' is to be written to the bgscan_interval file.
> 
> Example:
> 
> echo "2" > bgscan_interval
> 
> This will make the background scan interval as 2 seconds

Thanks, applied. But I did one change:

> +	if (bgscan_int)
> +		ath6kl_wmi_scanparams_cmd(ar->wmi, 0, 0, bgscan_int, 0, 0, 0, 3,
> +			0, 0, 0);
> +	else
> +		ath6kl_wmi_scanparams_cmd(ar->wmi, 0, 0, 0xffff, 0, 0, 0, 3, 0,
> +			0, 0);

I changed that to more simple form:

	if (bgscan_int == 0)
		bgscan_int = 0xffff;

	ath6kl_wmi_scanparams_cmd(ar->wmi, 0, 0, bgscan_int, 0, 0, 0, 3,
				  0, 0, 0);

Please check that I didn't break anything.

Kalle
