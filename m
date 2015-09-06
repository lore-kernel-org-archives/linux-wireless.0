Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:59367 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbbIFLLZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2015 07:11:25 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] ath9k_htc: introduce support for different fw versions
References: <87oajhvaca.fsf@kamboji.qca.qualcomm.com>
	<1439529178-3011-1-git-send-email-linux@rempel-privat.de>
Date: Sun, 06 Sep 2015 13:55:23 +0300
In-Reply-To: <1439529178-3011-1-git-send-email-linux@rempel-privat.de>
	(Oleksij Rempel's message of "Fri, 14 Aug 2015 07:12:58 +0200")
Message-ID: <87si6r3jhg.fsf@purkki.adurom.net> (sfid-20150906_131144_490811_AC10F35B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@rempel-privat.de> writes:

> Current kernel support only one fw name with theoretically only one
> fw version located in “firmware/htc_[9271|7010].fw”. Which is ok so
> far we have only one fw version (1.3). After we realised new fw 1.4,
> we faced compatibility problem which was decided to solve by firmware
> name and location:
>
> - new firmware is located now in firmware/ath9k_htc/htc_[9271|7010]-1.4.0.fw
> - old version 1.3 should be on old place, so old kernel have no issues with it.
> - new kernels including this patch should be able to try different supported (min..max) fw version.
> - new kernel should be able to support old fw location too. At least for now.

Please word wrap the commit log.

> At same time this patch will add new module option which should allow
> user to play with development fw version without replacing stable one.
> If user will set “ath9k_htc use_dev_fw=1” module will try to find
> firmware/ath9k_htc/htc_[9271|7010]-1.dev.0.fw first and if it fails,
> use stable version: for example...1.4.0.fw.

I'm not really sure if this module parameter makes sense and I haven't
noticed any other wifi driver having a similar parameter. If user wants
to test a developemnt firmware he can override a stable firmware version
with a simple cp operation. So why is the module parameter needed?

-- 
Kalle Valo
