Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37757 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbbETNx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:53:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Vincent Fann <vincent_fann@realtek.com>,
	Shao Fu <shaofu@realtek.com>, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.1] rtlwifi: Remove the clear interrupt routine from all drivers
References: <1431743367-10059-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Wed, 20 May 2015 16:53:51 +0300
In-Reply-To: <1431743367-10059-1-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Fri, 15 May 2015 21:29:27 -0500")
Message-ID: <877fs39wy8.fsf@kamboji.qca.qualcomm.com> (sfid-20150520_155400_827418_A764CA92)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Vincent Fann <vincent_fann@realtek.com>
>
> Several of these drivers have there TX randomly blocked for 3~5 seconds while
> measuring tx throughput (iperf). The root couse happens in rtl_pci_flush().
> The function uses a while-loop to wait for TX queue length to decrease to 0.
> The TX queue length counts the number of packets that are queued in the driver.
> The driver relys on the TX OK interrupt to return skb and reduce TX queue length.
>
> The interrupt subroutine disables interupts, reads the interrupt registers, and
> then clears the registers in the beginning of _rtl_pci_interrupt(). After all
> interupts process are finished, the driver invokes enable_interrupt() to enable
> interupts. This behavior is normal for an interrupt subroutine.
>
> But enable_interrupt() invokes clear_interrupt() again. This unexpected interrupt
> clearing may cleari me fresh TX OK interrupts. These missing interrupts cause TX
> queue length to never reduce to 0i, which causes rtl_pci_flush() to be stuck in
> unterminated while-loop.
>
> This patch removes clear_interrupt() in enable_interrupt() to avoid this behavior.
>
> Signed-off-by: Vincent Fann <vincent_fann@realtek.com>
> Signed-off-by: Shao Fu <shaofu@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> [3.18+]
> ---
>
> Kalle,
>
> This patch is a little large for the current kernel and stable; however, it only
> deletes code that is clearly wrong. I hope it will be OK.

This isn't a recent regression nor a crasher (or similar) so I can't
really justify to send this to 4.1 this late. The way I see it this
could easily wait for 4.2, right?

-- 
Kalle Valo
