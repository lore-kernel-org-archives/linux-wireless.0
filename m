Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34801 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbcAGNCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 08:02:54 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Pawel Kulakowski <pawel.kulakowski@tieto.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Enable support for cloned SKBS
References: <1450432137-30668-1-git-send-email-pawel.kulakowski@tieto.com>
Date: Thu, 07 Jan 2016 15:02:43 +0200
In-Reply-To: <1450432137-30668-1-git-send-email-pawel.kulakowski@tieto.com>
	(Pawel Kulakowski's message of "Fri, 18 Dec 2015 10:48:57 +0100")
Message-ID: <871t9tlez0.fsf@kamboji.qca.qualcomm.com> (sfid-20160107_140256_997422_F6769AB0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pawel Kulakowski <pawel.kulakowski@tieto.com> writes:

> Ath9k driver does not modify tx skbs, so SUPPORTS_CLONED_SKBS
> flag can be set. Enabling this flag significant reduce number
> of copy operation during TCP Tx. This is especially noticeable
> on platforms with slower CPU (lower CPU usage brings
> profits in better TCP Tx troughput results).
>
> Tested on MIPS with 560 MHz clock
> Without CLONED_SKBS flag:
> TCP Tx 145 Mb/s (iperf result)
> __copy_user_common consumes 12.9% of CPU (result from perf tool)
> 0% CPU Idle
>
> With CLONED_SKBS flag:
> TCP Tx 170 Mb/s (iperf result)
> __copy_user_common consumes 1.8% of CPU (result from perf tool)
> 12% CPU Idle
>
> Signed-off-by: Pawel Kulakowski <pawel.kulakowski@tieto.com>

Applied to ath.git, thanks.

-- 
Kalle Valo
