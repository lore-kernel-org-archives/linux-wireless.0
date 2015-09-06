Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54031 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbIFNQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2015 09:16:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] ath9k_htc: introduce support for different fw versions
References: <87oajhvaca.fsf@kamboji.qca.qualcomm.com>
	<1439529178-3011-1-git-send-email-linux@rempel-privat.de>
	<87si6r3jhg.fsf@purkki.adurom.net> <55EC1D0B.6090707@rempel-privat.de>
Date: Sun, 06 Sep 2015 16:16:31 +0300
In-Reply-To: <55EC1D0B.6090707@rempel-privat.de> (Oleksij Rempel's message of
	"Sun, 06 Sep 2015 13:01:31 +0200")
Message-ID: <87bndfhemo.fsf@kamboji.qca.qualcomm.com> (sfid-20150906_151643_269970_391325C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@rempel-privat.de> writes:

>>> At same time this patch will add new module option which should allow
>>> user to play with development fw version without replacing stable one.
>>> If user will set “ath9k_htc use_dev_fw=1” module will try to find
>>> firmware/ath9k_htc/htc_[9271|7010]-1.dev.0.fw first and if it fails,
>>> use stable version: for example...1.4.0.fw.
>> 
>> I'm not really sure if this module parameter makes sense and I haven't
>> noticed any other wifi driver having a similar parameter. If user wants
>> to test a developemnt firmware he can override a stable firmware version
>> with a simple cp operation. So why is the module parameter needed?
>
> Sure, iwl module has CONFIG for this case, so you should recompile it.

Yeah, that's even worse.

> The use case which i was thinking is the ability to provide a package
> for dev FW, which will not conflict with main FW package.
>
> The package just should provide 3 files, /etc/modules/ath9k_htc_params
> and /lib/firmware/bla.fw
> If dev package introduces some regressions i still can ask user to
> reload module with other parameter.

I think this should be doable even without a module parameter, but I
guess the module parameter is ok then.

-- 
Kalle Valo
