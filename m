Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50619 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbLKNc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 08:32:29 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: miaoqing@codeaurora.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [PATCH v3] ath9k: feeding entropy in kernel from ADC capture
References: <1444381605-11065-1-git-send-email-miaoqing@codeaurora.org>
Date: Fri, 11 Dec 2015 15:32:19 +0200
In-Reply-To: <1444381605-11065-1-git-send-email-miaoqing@codeaurora.org>
	(miaoqing@codeaurora.org's message of "Fri, 9 Oct 2015 17:06:45
	+0800")
Message-ID: <87si393ycc.fsf@kamboji.qca.qualcomm.com> (sfid-20151211_143232_927170_3D3F0E3B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@codeaurora.org writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> This patch is derived from
> commit 6301566e0b2d ("ath9k: export HW random number generator"),
>
> We evaluated the entropy of the ADC data on QCA9531, QCA9561, QCA955x,
> and AR9340, and it has sufficient quality random data (at least 10 bits
> and up to 22 bits of min-entropy for a 32-bit value). We conservatively
> assume the min-entropy is 10 bits out of 32 bits. Thus, ATH9K_RNG_BUF_SIZE
> is set to 320 (u32) i.e., 1.25 kilobytes of data is inserted to fill up
> the pool as soon as the entropy counter becomes 896/4096 (set by random.c).
> Since ADC was not designed to be a dedicated HW RNG, we do not want to bind
> it to /dev/hwrng framework directly. This patch feeds the entropy directly
> from the WiFi driver to the input pool. The ADC register output is only
> used as a seed for the Linux entropy pool. No conditioning is needed,
> since all the conditioning is performed by the pool itself.
>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Applied to ath.git, thanks.

-- 
Kalle Valo
