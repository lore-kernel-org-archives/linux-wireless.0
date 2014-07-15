Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42717 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaGOIcr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 04:32:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: pci fixes 2014-06-05
References: <1401954520-3365-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 15 Jul 2014 11:22:41 +0300
In-Reply-To: <1401954520-3365-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 5 Jun 2014 09:48:38 +0200")
Message-ID: <87d2d7ghf2.fsf@kamboji.qca.qualcomm.com> (sfid-20140715_103251_893069_09A5E254)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> I've found a few issues while I was testing ath10k
> in QEMU/KVM with PCI passthrough. The second patch
> is something that I've found while analysing the
> bmi race and I don't think anyone experienced
> problems associated with it.
>
> There's still a weird synchronization issue with
> (what I think is) iomap write propagation. The
> initial fw bootup interrupt doesn't come in and
> it seems CE interrupts are unmasked with a lag
> because explicit polling after ctl_resp timeout
> seems to be sufficient to work around it. I
> suspect this might be a virtualization problem
> rather than ath10k. Ideas, anyone?

No ideas, but it would be great to get ath10k working in KVM. If we
cannot find a better solution, could we add the explicit polling anyway?
(With an approriate comment why such a hack is needed, of course)

> Michal Kazior (2):
>   ath10k: fix bmi exchange tx/rx race
>   ath10k: sanitize tx ring index access properly

Thanks, both patches applied.

-- 
Kalle Valo
