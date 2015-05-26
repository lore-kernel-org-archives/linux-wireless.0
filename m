Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59677 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbbEZOCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 10:02:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [4.1] rtlwifi: Remove the clear interrupt routine from all drivers
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1431743367-10059-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Vincent Fann <vincent_fann@realtek.com>,
	Shao Fu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Message-Id: <20150526105918.C651D14174E@smtp.codeaurora.org> (sfid-20150526_160259_948891_01217CC7)
Date: Tue, 26 May 2015 10:59:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


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

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
