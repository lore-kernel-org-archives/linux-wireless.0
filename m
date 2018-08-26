Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39551 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbeHZLFO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Aug 2018 07:05:14 -0400
Received: by mail-ed1-f65.google.com with SMTP id h4-v6so8361954edi.6
        for <linux-wireless@vger.kernel.org>; Sun, 26 Aug 2018 00:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com>
 <20180823201147.393b1d53@wiggum> <87lg8wjhqe.fsf@kamboji.qca.qualcomm.com> <f9553dfe-d89b-0760-29c6-cdad29b54f6f@lwfinger.net>
In-Reply-To: <f9553dfe-d89b-0760-29c6-cdad29b54f6f@lwfinger.net>
From: prabhu <d.praabhu@gmail.com>
Date: Sun, 26 Aug 2018 12:53:18 +0530
Message-ID: <CAHnrWRp2n7W_Xb5kjT1ykcC0gL3ONc+dmqePAbKEEBHLd1euFA@mail.gmail.com> (sfid-20180826_092336_108724_D4BDAF87)
Subject: Re: [Regression]BCM4312 is broken in kernel 4.18[Root cause found]
To: Larry.Finger@lwfinger.net
Cc: kvalo@codeaurora.org, m@bues.ch, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

Upgrading the firmware didn't fix the issue.

The patch fixes it. My system has been running without any issues
since yesterday.
On Fri, Aug 24, 2018 at 9:45 PM Larry Finger <Larry.Finger@lwfinger.net> wr=
ote:
>
> On 08/24/2018 03:23 AM, Kalle Valo wrote:
> > Michael B=C3=BCsch <m@bues.ch> writes:
> >
> >> On Thu, 23 Aug 2018 23:00:53 +0530
> >> prabhu <d.praabhu@gmail.com> wrote:
> >>
> >>> The following commits introduce this regression in 4.18
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3D66cffd6daab76caebab26eb803b92182414fc182
> >>
> >> Ok. Kalle, can you please revert the commit
> >> 66cffd6daab76caebab26eb803b92182414fc182
> >> ?
> >
> > Please submit a proper patch with an explanation why it needs to be
> > reverted.
>
> Before doing a revert, let's see if we can keep the fix for open firmware=
, the
> situation for which commit 66cffd6daab7 was "needed". I think the followi=
ng
> should do:
>
> diff --git a/drivers/net/wireless/broadcom/b43/dma.c
> b/drivers/net/wireless/broadcom/b43/dma.c
> index 6b0e1ec346cb..2c37366b3592 100644
> --- a/drivers/net/wireless/broadcom/b43/dma.c
> +++ b/drivers/net/wireless/broadcom/b43/dma.c
> @@ -1519,12 +1519,14 @@ void b43_dma_handle_txstatus(struct b43_wldev *de=
v,
>                  } else {
>                          /* More than a single header/data pair were miss=
ed.
>                           * Report this error, and reset the controller t=
o
> -                        * revive operation.
> +                        * revive operation. If running the open-source
> +                        * firmware, then do a restart.
>                           */
>                          b43dbg(dev->wl,
>                                 "Out of order TX status report on DMA rin=
g %d.
> Expected %d, but got %d\n",
>                                 ring->index, firstused, slot);
> -                       b43_controller_restart(dev, "Out of order TX");
> +                       if (dev->fw.opensource)
> +                               b43_controller_restart(dev, "Out of order=
 TX");
>                          return;
>                  }
>          }
>
> At the moment, I am working with prabhu to see if upgrading his firmware =
will
> help his problem with no change in the driver. If not, then I will have h=
im test
> this patch.
>
> Larry
