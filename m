Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2846 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaFBQm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 12:42:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix vdev map size for 10.x firmware
References: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com>
Date: Mon, 2 Jun 2014 19:42:51 +0300
In-Reply-To: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Thu, 29 May 2014 15:36:07 +0200")
Message-ID: <87ppirz2ic.fsf@kamboji.qca.qualcomm.com> (sfid-20140602_184301_387539_D3588AA6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Firmware 10.x supports up to 8 virtual AP interfaces
> (comparing to 7 for main firmware). Previous vdev map
> initialization was missing enough space for 8 + 1 vdevs
> (we may spent one for mac monitor), due to wrong define used.
>
> Use correct one - TARGET_10X_NUM_VDEVS - for 10.x firmware.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

So what is the actual bug you are fixing? Previously with 10.x it was
possible to get only 7 VIFs, even though we advertised 8 to user space,
and with your fix we get the full 8 VIFs?

It would be good to clear have that in the commit log so that anyone can
understand what bug is fixed.

-- 
Kalle Valo
