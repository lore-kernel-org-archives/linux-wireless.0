Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54684 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759120Ab0KQWNk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 17:13:40 -0500
Date: Wed, 17 Nov 2010 14:11:58 -0800
From: Greg KH <gregkh@suse.de>
To: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Greg KH <greg@kroah.com>, Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] staging: brcm80211: brcmfmac: cleanup
 bcmsdh_(un)register
Message-ID: <20101117221158.GC3851@suse.de>
References: <20101116200438.GA10803@kroah.com>
 <1289980800-28743-1-git-send-email-mike.rapoport@gmail.com>
 <20101117211129.GA31776@kroah.com>
 <AANLkTikkVhc=3ismFX_5jWnzYHQiVXKbWQsFMPwTw6YZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTikkVhc=3ismFX_5jWnzYHQiVXKbWQsFMPwTw6YZ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 12:02:15AM +0200, Mike Rapoport wrote:
> On Wed, Nov 17, 2010 at 11:11 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Nov 17, 2010 at 10:00:00AM +0200, Mike Rapoport wrote:
> >> Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
> >> ---
> >>  drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |   13 +------------
> >>  1 files changed, 1 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
> >> index fd327e1..e3fb7ed 100644
> >> --- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
> >> +++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
> >> @@ -285,28 +285,17 @@ extern int sdio_function_init(void);
> >>
> >>  int bcmsdh_register(bcmsdh_driver_t *driver)
> >>  {
> >> -     int error = 0;
> >> -
> >>       drvinfo = *driver;
> >>
> >> -#if defined(BCMPLATFORM_BUS)
> >> -#if defined(BCMLXSDMMC)
> >>       SDLX_MSG(("Linux Kernel SDIO/MMC Driver\n"));
> >> -     error = sdio_function_init();
> >
> > Same question here, are you sure we can remove this code?
> 
> I'm not removing sdio_function_init here. I've only replaced
>         error = sdio_function_init();
>         return error;
> with
>         return sdio_function_init();

Doh, you are right, sorry about that, I missread the patch.

thanks

greg k-h
