Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54384 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbbAXKYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 05:24:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Hong Xu <hong@topbug.net>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k and ath9k_htc: rename variable "led_blink"
References: <1422094745-12718-1-git-send-email-hong@topbug.net>
Date: Sat, 24 Jan 2015 12:23:56 +0200
In-Reply-To: <1422094745-12718-1-git-send-email-hong@topbug.net> (Hong Xu's
	message of "Sat, 24 Jan 2015 02:19:05 -0800")
Message-ID: <87k30ciiir.fsf@kamboji.qca.qualcomm.com> (sfid-20150124_112406_559286_AEF8C5EB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hong Xu <hong@topbug.net> writes:

> ath9k and ath9k_htc use the variable name "led_blink" to indicate
> whether the module parameter "blink" is on. This name is easy to
> conflict with other variables, thus they are renamed.

Please state clearly that this fixes a compiler error found by kbuild.
Also it's very much recommended to add the actual compiler error to the
commit log:

drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here

-- 
Kalle Valo
