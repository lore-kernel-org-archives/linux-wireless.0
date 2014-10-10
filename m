Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24873 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaJJJes (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 05:34:48 -0400
Date: Fri, 10 Oct 2014 15:06:31 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix kernel panic while shutting down AP
Message-ID: <20141010093629.GA31275@qca.qualcomm.com> (sfid-20141010_113451_917091_F7A94D37)
References: <1412759786-10567-1-git-send-email-rmanohar@qti.qualcomm.com>
 <CA+BoTQ=K=F5TodrmuaEaJfErFx1=BL-bmPDrAaeMLjjb8c3fJQ@mail.gmail.com>
 <20141008103312.GA25666@qca.qualcomm.com>
 <CA+BoTQmVsyuxjvc_s-BC6ZwRWk3ACG0CvDYHJRnZ7OqY6W1Upw@mail.gmail.com>
 <20141008110842.GC25666@qca.qualcomm.com>
 <CA+BoTQ=BuSrkBxkbsShZM=Zh8uqye5u0HydpfM9roubgi0-4tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CA+BoTQ=BuSrkBxkbsShZM=Zh8uqye5u0HydpfM9roubgi0-4tQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2014 at 02:16:18PM +0200, Michal Kazior wrote:
> On 8 October 2014 13:08, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> > On Wed, Oct 08, 2014 at 12:50:28PM +0200, Michal Kazior wrote:
> >> On 8 October 2014 12:33, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> >> > On Wed, Oct 08, 2014 at 11:45:38AM +0200, Michal Kazior wrote:
> >> >> On 8 October 2014 11:16, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> >> >> > The commit "ath10k: workaround fw beaconing bug" is freeing
> >> >> > DMA-coherent memory in irq context which is hitting BUG ON
> >> >> > in ARM platforms. Fix this by moving dma_free out of spin
> >> >> > lock.
> >> >>
> >> >> I hardly see how moving the freeing outside the spinlock is a fix.
> >> >>
[...]
> 
> My thinking was GFP_ given to dma_alloc_coherent could impact
> behaviour of dma_free_coherent (e.g. different kind of pages is
> allocated so different kind of freeing will be involved) but I may be
> wrong.
> 
> Can you give it a try, please?
>
Michal,

Sorry for the delay.. Good catch. It is working after changing the GFP flag to
atomic. Will send the updated version and remove the backtrace from
commit log as well.

Thanks for the review.

-Rajkumar
