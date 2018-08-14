Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727689AbeHNL3t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 07:29:49 -0400
Date: Tue, 14 Aug 2018 10:43:35 +0200
From: gregkh <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: ajay.kathat@microchip.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com,
        driverdevel <devel@driverdev.osuosl.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: wilc1000: revert "fix TODO to compile spi and
 sdio components in single module"
Message-ID: <20180814084335.GB7208@kroah.com> (sfid-20180814_104413_191696_C9F817DF)
References: <20180813212108.2442868-1-arnd@arndb.de>
 <20180814105237.64b01528@ajaysk-VirtualBox>
 <CAK8P3a3bk7urG9zO=F1NtH8hTnGQQ_Hk0qq=o8fmeYY_nEyy5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK8P3a3bk7urG9zO=F1NtH8hTnGQQ_Hk0qq=o8fmeYY_nEyy5w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2018 at 10:34:27AM +0200, Arnd Bergmann wrote:
> On Tue, Aug 14, 2018 at 7:22 AM Ajay Singh <ajay.kathat@microchip.com> wrote:
> >
> > Hi Arnd,
> >
> > On Mon, 13 Aug 2018 23:20:33 +0200
> > Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > > The TODO item named "make spi and sdio components coexist in one
> > > build" was apparently addressed a long time ago, but never removed
> > > from the TODO file. However, the new patch that tries to address it
> > > actually makes it worse again by duplicating the common parts of the
> > > driver into two separate modules rather than sharing them. This also
> > > introduces a build regression when one of the two is built-in while
> > > the other is a loadable module:
> >
> > Thanks for sharing your inputs and submitting patch.
> > I have also submitted a patch to address the compilation error[1].
> > We can ignore my patch and proceed with your changes.
> >
> > [1].https://patchwork.kernel.org/patch/10563873/
> 
> That patch seems useful regardless, as it removes dead code,
> but I'd still prefer to revert the 9abc44ba4e2f ("staging: wilc1000:
> fix TODO to compile spi and sdio components in single module")
> commit for the other reasons I explained.

I agree, I'll queue it up soon, I have other patches to get to Linus
first.

thanks,

greg k-h
