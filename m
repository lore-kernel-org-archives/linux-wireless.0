Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46698 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbbIRHmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 03:42:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] ath9k_htc: introduce support for different fw versions
References: <1441537741-11846-1-git-send-email-linux@rempel-privat.de>
Date: Fri, 18 Sep 2015 10:42:41 +0300
In-Reply-To: <1441537741-11846-1-git-send-email-linux@rempel-privat.de>
	(Oleksij Rempel's message of "Sun, 6 Sep 2015 13:09:01 +0200")
Message-ID: <87fv2crx5a.fsf@kamboji.qca.qualcomm.com> (sfid-20150918_094255_459862_5EB418F0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@rempel-privat.de> writes:

> Current kernel support only one fw name with theoretically only one
> fw version located in “firmware/htc_[9271|7010].fw”. Which is ok so far we
> have only one fw version (1.3). After we realised new fw 1.4, we faced
> compatibility problem which was decided to solve by firmware name and
> location:
> - new firmware is located now in
> 	firmware/ath9k_htc/htc_[9271|7010]-1.4.0.fw
> - old version 1.3 should be on old place, so old kernel have no issues
> 	with it.
> - new kernels including this patch should be able to try different
> 	supported (min..max) fw version.
> - new kernel should be able to support old fw location too. At least for
> 	now.
>
> At same time this patch will add new module option which should allow user
> to play with development  fw version without replacing stable one. If user
> will set “ath9k_htc use_dev_fw=1” module will try to find
> firmware/ath9k_htc/htc_[9271|7010]-1.dev.0.fw first and if it fails, use
> stable version: for example...1.4.0.fw.
>
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>

Thanks, applied manually. You forgot to CC linux-wireless and hence
patchwork didn't see this.

In the future please add a changelog when sending new versions of a
patch.

-- 
Kalle Valo
