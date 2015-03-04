Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27339 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbbCDMId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 07:08:33 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: workaround corrupted htt rx events
References: <1423490695-24829-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 4 Mar 2015 14:08:26 +0200
In-Reply-To: <1423490695-24829-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 9 Feb 2015 15:04:55 +0100")
Message-ID: <87pp8p6k3p.fsf@kamboji.qca.qualcomm.com> (sfid-20150304_130836_713752_F5A2B59A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> qca6174 WLAN.RM.2.0-00073 firmware uses full rx
> reordering offload and delivers Rx via a new HTT
> event. The event however is incorrectly generated
> in firmware and becomes overly long (with trailing
> garbage). This was hitting defined CE buffer limit
> that was programmed to the device and caused
> device to crash upon busier Rx traffic.
>
> Increasing the CE buffer limit for HTT Rx pipe to
> 2KBytes seems to be enough to workaround this
> problem.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
