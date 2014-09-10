Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:35512 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaIJLOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 07:14:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: move fw_crash_dump allocation
References: <1409814788-1661-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 10 Sep 2014 14:14:23 +0300
In-Reply-To: <1409814788-1661-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 4 Sep 2014 09:13:08 +0200")
Message-ID: <878ulr9180.fsf@kamboji.qca.qualcomm.com> (sfid-20140910_131456_871932_7A7F4A41)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The fw_crash_data was allocated too late. Upon
> early firmware crash, before registering to
> mac80211, it was possible to crash the whole
> system:
>
>  ath10k_pci 0000:00:05.0: device has crashed during init
>  BUG: unable to handle kernel NULL pointer dereference at           (null)

[...]

>  ---[ end Kernel panic - not syncing: Fatal exception in interrupt
>
> To prevent that split debug functions and allocate
> fw_crash_data earlier.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
