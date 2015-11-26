Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18230 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbbKZRCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 12:02:00 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Marek <mmarek@suse.com>
CC: <linux-kbuild@vger.kernel.org>, <fengguang.wu@intel.com>,
	<kbuild-all@01.org>, <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10: Fix build with CONFIG_THERMAL=m
References: <201511260039.iQbaOe1h%fengguang.wu@intel.com>
	<1448552198-26911-1-git-send-email-mmarek@suse.com>
Date: Thu, 26 Nov 2015 19:01:42 +0200
In-Reply-To: <1448552198-26911-1-git-send-email-mmarek@suse.com> (Michal
	Marek's message of "Thu, 26 Nov 2015 16:36:38 +0100")
Message-ID: <87h9k8n18p.fsf@kamboji.qca.qualcomm.com> (sfid-20151126_180205_316054_AD7A6D89)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

Michal Marek <mmarek@suse.com> writes:

> After commit cf4f21938e13 ("kbuild: Allow to specify composite modules
> with modname-m"), thermal.c gets included in the driver and the build
> fails with
>
> drivers/net/wireless/ath/ath10k/thermal.c:119:6: error: redefinition of ‘ath10k_thermal_event_temperature’
> drivers/net/wireless/ath/ath10k/thermal.h:54:20: note: previous definition of ‘ath10k_thermal_event_temperature’ was here
> drivers/net/wireless/ath/ath10k/thermal.c:136:6: error: redefinition of ‘ath10k_thermal_set_throttling’
> drivers/net/wireless/ath/ath10k/thermal.h:59:20: note: previous definition of ‘ath10k_thermal_set_throttling’ was here
> drivers/net/wireless/ath/ath10k/thermal.c:162:5: error: redefinition of ‘ath10k_thermal_register’
> drivers/net/wireless/ath/ath10k/thermal.h:45:19: note: previous definition of ‘ath10k_thermal_register’ was here
> drivers/net/wireless/ath/ath10k/thermal.c:216:6: error: redefinition of ‘ath10k_thermal_unregister’
> drivers/net/wireless/ath/ath10k/thermal.h:50:20: note: previous definition of ‘ath10k_thermal_unregister’ was here
>
> Change the #ifdef to reflect the new kbuild behavior.
>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Michal Marek <mmarek@suse.com>

Please fix the subject prefix to "ath10k: ", otherwise looks good. Feel
free to apply this to the kbuild tree.

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
