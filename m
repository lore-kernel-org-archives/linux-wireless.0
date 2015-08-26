Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46109 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543AbbHZIKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 04:10:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Add spectral scan support for 10.4 fw
References: <1440046745-428-1-git-send-email-rmani@qti.qualcomm.com>
Date: Wed, 26 Aug 2015 11:09:46 +0300
In-Reply-To: <1440046745-428-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Thu, 20 Aug 2015 10:29:05 +0530")
Message-ID: <87k2si31yt.fsf@kamboji.qca.qualcomm.com> (sfid-20150826_101023_595758_6050F829)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> To enable/configure spectral scan parameters in 10.4 firmware, existing
> wmi spectral related functions can be reused. Link those functions in
> 10.4 wmi ops table.
>
> In addition, adjust bin size (only when size is 68 bytes) before reporting
> bin samples to user space. The background for this adjustment is that
> qca99x0 reports bin size as 68 bytes (64 bytes + 4 bytes) in report
> mode 2. First 64 bytes carries in-band tones (-32 to +31) and last 4 byte
> carries band edge detection data (+32) mainly used in radar detection
> purpose. Additional last 4 bytes are stripped to make bin size valid one.
>
> This bin size adjustment will happen only for qca99x0, all other chipsets
> will report proper bin sizes (64/128) without extra 4 bytes being added
> at the end. The changes are validated in qca99x0 using 10.4 firmware.
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
