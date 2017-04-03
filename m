Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:33843 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbdDCSdv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 14:33:51 -0400
Received: by mail-pg0-f51.google.com with SMTP id 21so128467277pgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 11:33:51 -0700 (PDT)
Date: Mon, 3 Apr 2017 11:33:47 -0700
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Rajat Jain <rajatja@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 1/3] mwifiex: remove unnecessary wakeup interrupt number
 sanity check
Message-ID: <20170403183346.GA116262@google.com> (sfid-20170403_203356_879798_B4CF6C9A)
References: <1490865547-10208-1-git-send-email-huxinming820@gmail.com>
 <CAE_wzQ9x8-dNCEbJw9+XnSK6fPaUa-K29jc0hjB91xUaFvRFhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAE_wzQ9x8-dNCEbJw9+XnSK6fPaUa-K29jc0hjB91xUaFvRFhQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 31, 2017 at 03:37:01PM -0700, Dmitry Torokhov wrote:
> On Thu, Mar 30, 2017 at 2:19 AM, Xinming Hu <huxinming820@gmail.com> wrote:
> > From: Xinming Hu <huxm@marvell.com>
> >
> > Sanity check of interrupt number in interrupt handler is unnecessary and
> > confusion, remove it.
> 
> I'd reworded the explanation a bit: "If wakeup interrupt handler is
> called, we know that the wakeup interrupt number is valid, there is no
> need to check it."

Either way works for me (modulo grammar), though Dmitry's is more
informative. So +1.

> Otherwise:
> 
> Reviewed-by: Dmitry Torokhov <dtor@chromium.org>

Ooh, me too!

Reviewed-by: Brian Norris <briannorris@chromium.org>

I believe this same pattern occurs in btmrvl_sdio. Possibly others.

> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/main.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> > index 30f4994..5e82602 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/main.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> > @@ -1503,11 +1503,9 @@ static irqreturn_t mwifiex_irq_wakeup_handler(int irq, void *priv)
> >  {
> >         struct mwifiex_adapter *adapter = priv;
> >
> > -       if (adapter->irq_wakeup >= 0) {
> > -               dev_dbg(adapter->dev, "%s: wake by wifi", __func__);
> > -               adapter->wake_by_wifi = true;
> > -               disable_irq_nosync(irq);
> > -       }
> > +       dev_dbg(adapter->dev, "%s: wake by wifi", __func__);
> > +       adapter->wake_by_wifi = true;
> > +       disable_irq_nosync(irq);
> >
> >         /* Notify PM core we are wakeup source */
> >         pm_wakeup_event(adapter->dev, 0);
> > --
> > 1.8.1.4
> >
