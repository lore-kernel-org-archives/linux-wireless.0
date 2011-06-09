Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53495 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1FIUrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 16:47:20 -0400
Received: by pwi15 with SMTP id 15so922265pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2011 13:47:18 -0700 (PDT)
Date: Thu, 9 Jun 2011 23:46:53 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] ath6kl: cache firmware
Message-ID: <20110609204653.GL4069@shale.localdomain> (sfid-20110609_224723_308828_4539941D)
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
 <20110608115440.32208.75072.stgit@localhost6.localdomain6>
 <20110608194031.GA4069@shale.localdomain>
 <871uz387ut.fsf@purkki.adurom.net>
 <20110609154241.GI4069@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110609154241.GI4069@shale.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 09, 2011 at 06:42:41PM +0300, Dan Carpenter wrote:
> On Thu, Jun 09, 2011 at 04:14:34PM +0300, Kalle Valo wrote:
> > Dan Carpenter <error27@gmail.com> writes:
> > 
> > >> --- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> > >> +++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> > >> @@ -954,9 +954,13 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
> > >>      const char *filename;
> > >>      const struct firmware *fw_entry;
> > >>      u32 fw_entry_size;
> > >> +    u8 **buf;
> > >> +    size_t *buf_len;
> > >
> > > Don't make buf_len a pointer that just makes the code messier.
> > 
> > I need the pointer later so that I can store the length:
> > 
> >             *buf_len = fw_entry->size;
> 
> No.  The normal way to store an int is to do it like this:
> 
> 		buf_len = fw_entry->size;

I miss read what you were doing here.  You code is correct here.  I
appologize for that.

regards,
dan carpenter

