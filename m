Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45806 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753405AbcKKNJd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 08:09:33 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Xinming Hu <huxinming820@gmail.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Cathy Luo <cluo@marvell.com>, Shengzhen Li <szli@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH RESEND v2 01/11] mwifiex: check tx_hw_pending before
 downloading sleep confirm
Date: Fri, 11 Nov 2016 13:09:29 +0000
Message-ID: <8c711f44123245f995cc5be54c325d73@SC-EXCH04.marvell.com> (sfid-20161111_140936_025263_B7D33232)
References: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
 <87y40rpgz0.fsf@purkki.adurom.net>
In-Reply-To: <87y40rpgz0.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Kalle Valo
> Sent: Thursday, November 10, 2016 7:36 PM
> To: Xinming Hu
> Cc: Linux Wireless; Brian Norris; Dmitry Torokhov; Amitkumar Karwar;
> Cathy Luo; Shengzhen Li; Xinming Hu
> Subject: Re: [PATCH RESEND v2 01/11] mwifiex: check tx_hw_pending
> before downloading sleep confirm
> 
> Xinming Hu <huxinming820@gmail.com> writes:
> 
> > From: Shengzhen Li <szli@marvell.com>
> >
> > We may get SLEEP event from firmware even if TXDone interrupt for
> last
> > Tx packet is still pending. In this case, we may end up accessing
> PCIe
> > memory for handling TXDone after power save handshake is completed.
> > This causes kernel crash with external abort.
> >
> > This patch will only allow downloading sleep confirm when no tx done
> > interrupt is pending in the hardware.
> >
> > Signed-off-by: Cathy Luo <cluo@marvell.com>
> > Signed-off-by: Shengzhen Li <szli@marvell.com>
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> > v2: address format issues(Brain)
> > RESEND v2(Applicable for complete patch series):
> >     1) Fixed syntax issue "changelog not placed after the  Sign-offs"
> >        pointed by Brian.
> >     2) Dropped "[v2,03/12] mwifiex: don't do unbalanced free()'ing in
> >        cleanup_if()" patch in this series. It was already sent by
> Brian
> >        separately.
> 
> I do not know where this "v2 RESEND" practise is coming from but I very
> much prefer that people would not use it. If you need to resend
> something keep things simple, just increase the version number and
> document in the changelog that nothing changed. I don't care what the
> patchset version number is, I always look at the latest version and
> discard the older ones.
> 
> This is just for the future, no need resend anything because of this.

Got it. We will avoid "RESEND" and increase version number for our future submissions.
There is an improvement pointed out by Brian for "RESEND v2 03/11" patch. I will include it in v3.

Regards,
Amitkumar
