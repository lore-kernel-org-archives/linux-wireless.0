Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33848 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab3HEQXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 12:23:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix device teardown
References: <1374129572-6079-1-git-send-email-michal.kazior@tieto.com>
	<1375427747-9539-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 5 Aug 2013 19:23:07 +0300
In-Reply-To: <1375427747-9539-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 2 Aug 2013 09:15:47 +0200")
Message-ID: <87pptsf6ok.fsf@kamboji.qca.qualcomm.com> (sfid-20130805_182407_544829_A054C574)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This fixes interrupt-related issue when no
> interfaces were running thus the device was
> considered powered down.
>
> The power_down() function isn't really powering
> down the device. It simply assumed it won't
> interrupt. This wasn't true in some cases and
> could lead to paging failures upon FW indication
> interrupt (i.e. FW crash) because some structures
> aren't allocated in that device state.
>
> One reason for that was that ar_pci->started
> wasn't reset. The other is interrupts should've
> been masked when teardown starts.
>
> The patch reorganized interrupt setup and makes
> sure ar_pci->started is reset accordingly.
>
> Reported-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
