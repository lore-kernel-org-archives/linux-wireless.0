Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32151 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaEVQk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 12:40:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: make core registering async
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	<1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
Date: Thu, 22 May 2014 19:40:50 +0300
In-Reply-To: <1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 22 May 2014 16:12:35 +0200")
Message-ID: <87tx8hwyul.fsf@kamboji.qca.qualcomm.com> (sfid-20140522_184100_170418_E80A81DE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If ath10k was built into the kernel it could stall
> booting for 120 seconds by default (60 seconds for
> each firmware API variant) waiting for firmware
> files before userspace was ready or filesystems
> mounted.
>
> Fix this by making the core registering
> asynchronous.
>
> This also shoves off about 1 second from boot time
> on most systems since the driver is now mostly
> initialized in a worker and modprobe takes very
> little time to complete.
>
> As a side effect there's no way to propagate
> registering errors to the pci subsystem but this
> probably isn't really necessary.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I see a new sparse warning with this patch:

drivers/net/wireless/ath/ath10k/core.c:956:6: warning: symbol 'ath10k_core_register_work' was not declared. Should it be static?

-- 
Kalle Valo
