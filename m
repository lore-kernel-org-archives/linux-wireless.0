Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:40127 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1HMKvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 06:51:31 -0400
Received: by yie30 with SMTP id 30so2474398yie.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 03:51:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313211498-14442-2-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1313211498-14442-2-git-send-email-rmanohar@qca.qualcomm.com>
Date: Sat, 13 Aug 2011 18:51:28 +0800
Message-ID: <CAJ-VmokWVzcYPwgNkMn+CcH8mEzsCAyzM3wEEMBFmUc6dg7KmQ@mail.gmail.com> (sfid-20110813_125134_936354_EBC7058E)
Subject: Re: [PATCH 02/11] ath9k: Fix rx overrun interrupt storm
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I did this in FreeBSD to fix RXEOL storms, but I was receiving them
because I had phyerr's enabled (for radar) and the PCU list end had
actually been hit.
So I added code which kicks off a PCU stop/start in the RX handler
(once whatever packets were in the RX queue) so that the PCU receive
would then begin again.

Were you seeing it occur because you hit the end of the RX descriptor
list? Or some other reason?

I ask because I'm seeing issues with an AR9280 (SR71-E) on FreeBSD,
where the PCU stops RX for some reason, and constantly fires off
RXEOLs. Warm resets don't fix it, I have to do a cold reset to fix it.
:(


Adrian

On 13 August 2011 12:58, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> Whenever RXEOL is received, both RXORN and RXEOL got cleared
> to avoid rx overrun interrupt storm. This was handled only for
> edma chips. The same scenario was also observered with AR9280,
> doing frequent channel type switch b/w HT20/40 with bidi traffic
> that is causing failure to stop rx dma. This patch clears
> the RXEOL & RXORN interrupts for all chips.
>
> ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
> DMADBG_7=0x000062c0
> ath: Could not stop RX, we could be confusing the DMA engine when we
> start RX up
> ------------[ cut here ]------------
> WARNING: at drivers/net/wireless/ath/ath9k/recv.c:532
> ath_stoprecv+0x110/0x120 [ath9k]()
> Call Trace:
>  [<ffffffff8104a55a>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff8104a5a5>] warn_slowpath_null+0x15/0x20
>  [<ffffffffa0560380>] ath_stoprecv+0x110/0x120 [ath9k]
>  [<ffffffffa055e6fa>] ath_reset+0x6a/0x200 [ath9k]
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 1e7fe8c..097c1eb 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -826,11 +826,9 @@ irqreturn_t ath_isr(int irq, void *dev)
>        if (status & ATH9K_INT_TXURN)
>                ath9k_hw_updatetxtriglevel(ah, true);
>
> -       if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
> -               if (status & ATH9K_INT_RXEOL) {
> -                       ah->imask &= ~(ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
> -                       ath9k_hw_set_interrupts(ah, ah->imask);
> -               }
> +       if (status & ATH9K_INT_RXEOL) {
> +               ah->imask &= ~(ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
> +               ath9k_hw_set_interrupts(ah, ah->imask);
>        }
>
>        if (status & ATH9K_INT_MIB) {
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
