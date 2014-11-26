Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14713 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaKZHVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 02:21:46 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: embed supported chip ids in hw_params
References: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Nov 2014 09:21:16 +0200
In-Reply-To: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 24 Nov 2014 15:17:24 +0100")
Message-ID: <87vbm2whoz.fsf@kamboji.qca.qualcomm.com> (sfid-20141126_082149_682152_02A49D0F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This will make it easier to extend and maintain
> list of supported hardware.
>
> As a requirement this moves chip_id checking a
> little later because target_version isn't known
> until BMI can be queried.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

The reason why I originally added the chip_id check was that QCA988X hw
1.0 failed badly (ath10k might have even crashed, don't remember
anymore) and I added this chip_id as an ugly workaround to detect hw1.0
early. Most likely with this patch the problem comes back again.

I don't know what's a good solution, need to think more. Any ideas?

-- 
Kalle Valo
