Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7206 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbbKZMj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:39:58 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mark Brown <broonie@kernel.org>
CC: <kernel-build-reports@lists.linaro.org>,
	<linaro-kernel@lists.linaro.org>, <linux-next@vger.kernel.org>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: Re: next-20151126 build: 3 failures 15 warnings (next-20151126)
References: <E1a1sVV-00079q-My@optimist> <20151126121551.GE1929@sirena.org.uk>
Date: Thu, 26 Nov 2015 14:39:40 +0200
In-Reply-To: <20151126121551.GE1929@sirena.org.uk> (Mark Brown's message of
	"Thu, 26 Nov 2015 12:15:51 +0000")
Message-ID: <87y4dllysz.fsf@kamboji.qca.qualcomm.com> (sfid-20151126_134007_712760_D4BBD07F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mark Brown <broonie@kernel.org> writes:

> On Thu, Nov 26, 2015 at 09:06:25AM +0000, Build bot for Mark Brown wrote:
>
> Today's -next fails to build an arm64 allmodconfig due to:
>
>> 	arm64-allmodconfig
>> ../drivers/net/wireless/ath/ath10k/thermal.c:119:6: error: redefinition of 'ath10k_thermal_event_temperature'
>> ../drivers/net/wireless/ath/ath10k/thermal.c:136:6: error: redefinition of 'ath10k_thermal_set_throttling'
>> ../drivers/net/wireless/ath/ath10k/thermal.c:162:5: error: redefinition of 'ath10k_thermal_register'
>> ../drivers/net/wireless/ath/ath10k/thermal.c:216:6: error: redefinition of 'ath10k_thermal_unregister'
>
> This is happening because there are stub functions provided in the
> driver's thermal.h for !THERMAL cases but these are guarded by an #ifdef
> not an #if and so fails to do the right thing if the thermal code is
> built as a module.

Thanks, I'll apply the fix soon. Just wait for comments from others
first.

> It looks like this was somehow triggered as part of the reorganisation
> of the WiFi directory structure.

This is surprising and also worrying, any ideas why? It would be good to
understand the root cause in case there's a bug in wireless drivers
directory reorganisation.

-- 
Kalle Valo
