Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:44821 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbeHNLUx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 07:20:53 -0400
MIME-Version: 1.0
References: <20180813212108.2442868-1-arnd@arndb.de> <20180814105237.64b01528@ajaysk-VirtualBox>
In-Reply-To: <20180814105237.64b01528@ajaysk-VirtualBox>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 14 Aug 2018 10:34:27 +0200
Message-ID: <CAK8P3a3bk7urG9zO=F1NtH8hTnGQQ_Hk0qq=o8fmeYY_nEyy5w@mail.gmail.com> (sfid-20180814_103515_878061_26224BC2)
Subject: Re: [PATCH] staging: wilc1000: revert "fix TODO to compile spi and
 sdio components in single module"
To: ajay.kathat@microchip.com
Cc: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh <gregkh@linuxfoundation.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2018 at 7:22 AM Ajay Singh <ajay.kathat@microchip.com> wrote:
>
> Hi Arnd,
>
> On Mon, 13 Aug 2018 23:20:33 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
>
> > The TODO item named "make spi and sdio components coexist in one
> > build" was apparently addressed a long time ago, but never removed
> > from the TODO file. However, the new patch that tries to address it
> > actually makes it worse again by duplicating the common parts of the
> > driver into two separate modules rather than sharing them. This also
> > introduces a build regression when one of the two is built-in while
> > the other is a loadable module:
>
> Thanks for sharing your inputs and submitting patch.
> I have also submitted a patch to address the compilation error[1].
> We can ignore my patch and proceed with your changes.
>
> [1].https://patchwork.kernel.org/patch/10563873/

That patch seems useful regardless, as it removes dead code,
but I'd still prefer to revert the 9abc44ba4e2f ("staging: wilc1000:
fix TODO to compile spi and sdio components in single module")
commit for the other reasons I explained.

> In my understanding, even when the common part is compiled separately,
> the wilc1000-sdio/wilc1000-spi module still expects separate instance of
> common part for each of them because of use of static variables.
>
> Shouldn't it be correct to compile the components required for SDIO and
> SPI separately and then get rid of use of global variables to support
> running of SDIO/SPI module at same time?

What your patch does is to change the behavior so that for loadable
modules, you get two copies of each global variable and function,
but for built-in drivers, you still only get one. The old behavior was
arguably better here because at least it was consistent and always
shared the common part.

> > In order to have multiple instances working (sdio, spi, or mixed),
> > all such variables need to be dynamically allocated per instance and
> > stored in 'struct wilc' or one of the structures referenced by it.
> >
>
> Actually, I have been locally working on this patch for a while now
> and I will submit a patch to avoid use of most of global and static
> variable soon.

Ok, very nice!

      Arnd
