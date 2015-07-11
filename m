Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53878 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbGKQTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2015 12:19:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix QCA61X4 boot up
References: <1435930429-3970-1-git-send-email-bartosz.markowski@tieto.com>
Date: Sat, 11 Jul 2015 19:19:50 +0300
In-Reply-To: <1435930429-3970-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Fri, 3 Jul 2015 15:33:49 +0200")
Message-ID: <87615qwtsp.fsf@kamboji.qca.qualcomm.com> (sfid-20150711_181959_214870_EB9D6B2A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> commit "a521ee983d312db7 ath10k: Add new reg_address/mask to hw register
> table" commit has broken the QCA61x4 support, by providing wrong
> fw_indicator_address, which shall be 0x0003a028 instead of 0x00009028.
>
> User experience was a failing boot up sequence (crashing device during
> initialization)
>
> [  181.663874] ath10k_pci 0000:02:00.0: enabling device (0000 -> 0002)
> [  181.664787] ath10k_pci 0000:02:00.0: pci irq msi-x interrupts 8 irq_mode 0 reset_mode 0
> [  181.688886] ath10k_pci 0000:02:00.0: device has crashed during init
> [  181.688897] ath10k_pci 0000:02:00.0: failed to wait for target after cold reset: -70
> [  181.688902] ath10k_pci 0000:02:00.0: failed to reset chip: -70
> [  181.689774] ath10k_pci: probe of 0000:02:00.0 failed with error -70
>
> Fix it by updating the address with correct value.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
