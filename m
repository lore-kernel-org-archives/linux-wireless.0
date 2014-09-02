Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32747 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBHQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 03:16:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: re-enable interrupts properly in hw recovery
References: <1409144989-17934-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 2 Sep 2014 10:15:57 +0300
In-Reply-To: <1409144989-17934-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 27 Aug 2014 15:09:49 +0200")
Message-ID: <871trupk5u.fsf@kamboji.qca.qualcomm.com> (sfid-20140902_091640_509556_056DE1F1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Recent changes done to start/restart sequences
> broke hw recovery in some hw configurations. The
> pci transport was stopped twice however due to a
> workaround in the pci disabling code the
> disable/enable for first msi interrupt was not
> balanced. This ended up with irqs not being
> properly re-enabled and the following print out
> during recovery:
>
>  ath10k: failed to receive control response completion, polling..
>  ath10k: Service connect timeout: -110
>  ath10k: Could not init core: -110
>
> Legacy interrupt mode was unaffected while msi
> ranged mode would be partially crippled (it would
> miss fw indication interrupts but otherwise it
> worked fine).
>
> This fixes completely broken fw recovery for a
> single msi interrupt mode and fixes subsequent fw
> crash reports for msi range interrupt mode.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
