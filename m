Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24354 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1HMSDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:03:53 -0400
Date: Sat, 13 Aug 2011 23:34:14 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 02/11] ath9k: Fix rx overrun interrupt storm
Message-ID: <20110813180413.GA16149@vmraj-lnx.users.atheros.com> (sfid-20110813_200357_118586_62C5A5F1)
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1313211498-14442-2-git-send-email-rmanohar@qca.qualcomm.com>
 <CAJ-VmokWVzcYPwgNkMn+CcH8mEzsCAyzM3wEEMBFmUc6dg7KmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAJ-VmokWVzcYPwgNkMn+CcH8mEzsCAyzM3wEEMBFmUc6dg7KmQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 13, 2011 at 06:51:28PM +0800, Adrian Chadd wrote:
> I did this in FreeBSD to fix RXEOL storms, but I was receiving them
> because I had phyerr's enabled (for radar) and the PCU list end had
> actually been hit.
> So I added code which kicks off a PCU stop/start in the RX handler
> (once whatever packets were in the RX queue) so that the PCU receive
> would then begin again.
>
Nice. But why are you doing PCU stop/start for every RXEOL?
> Were you seeing it occur because you hit the end of the RX descriptor
> list? Or some other reason?
>
Yes. The RXORN/RXEOL intr issue was observed with AR9280 chip, while
running stress test.
> I ask because I'm seeing issues with an AR9280 (SR71-E) on FreeBSD,
> where the PCU stops RX for some reason, and constantly fires off
> RXEOLs. Warm resets don't fix it, I have to do a cold reset to fix it.
> :(
Are you still facing the issue after restarting pcu recv?
> 
> 
> Adrian
> 
> On 13 August 2011 12:58, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> > Whenever RXEOL is received, both RXORN and RXEOL got cleared
> > to avoid rx overrun interrupt storm. This was handled only for
> > edma chips. The same scenario was also observered with AR9280,
> > doing frequent channel type switch b/w HT20/40 with bidi traffic
> > that is causing failure to stop rx dma. This patch clears
> > the RXEOL & RXORN interrupts for all chips.
> >
> > ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
> > DMADBG_7=0x000062c0
> > ath: Could not stop RX, we could be confusing the DMA engine when we
> > start RX up
> > ------------[ cut here ]------------
> > WARNING: at drivers/net/wireless/ath/ath9k/recv.c:532
> > ath_stoprecv+0x110/0x120 [ath9k]()
> > Call Trace:
> >  [<ffffffff8104a55a>] warn_slowpath_common+0x7a/0xb0
> >  [<ffffffff8104a5a5>] warn_slowpath_null+0x15/0x20
> >  [<ffffffffa0560380>] ath_stoprecv+0x110/0x120 [ath9k]
> >  [<ffffffffa055e6fa>] ath_reset+0x6a/0x200 [ath9k]
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/main.c |    8 +++-----
> >  1 files changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> > index 1e7fe8c..097c1eb 100644
> > --- a/drivers/net/wireless/ath/ath9k/main.c
> > +++ b/drivers/net/wireless/ath/ath9k/main.c
> > @@ -826,11 +826,9 @@ irqreturn_t ath_isr(int irq, void *dev)
> >        if (status & ATH9K_INT_TXURN)
> >                ath9k_hw_updatetxtriglevel(ah, true);
> >
> > -       if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
> > -               if (status & ATH9K_INT_RXEOL) {
> > -                       ah->imask &= ~(ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
> > -                       ath9k_hw_set_interrupts(ah, ah->imask);
> > -               }
> > +       if (status & ATH9K_INT_RXEOL) {
> > +               ah->imask &= ~(ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
> > +               ath9k_hw_set_interrupts(ah, ah->imask);
> >        }
> >
> >        if (status & ATH9K_INT_MIB) {
> > --
> > 1.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
