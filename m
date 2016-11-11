Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44543 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750714AbcKKNGn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 08:06:43 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Xinming Hu <huxinming820@gmail.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Dmitry Torokhov <dtor@google.com>, Cathy Luo <cluo@marvell.com>
Subject: RE: [PATCH RESEND v2 03/11] mwifiex: resolve races between async FW
 init (failure) and device removal
Date: Fri, 11 Nov 2016 13:06:36 +0000
Message-ID: <e7a4031e5bcd4f72be211524e7c298a5@SC-EXCH04.marvell.com> (sfid-20161111_140647_345928_02997D1D)
References: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
 <1478779032-5165-3-git-send-email-huxinming820@marvell.com>
 <20161110183723.GA134624@google.com>
In-Reply-To: <20161110183723.GA134624@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Friday, November 11, 2016 12:07 AM
> To: Xinming Hu
> Cc: Linux Wireless; Kalle Valo; Dmitry Torokhov; Amitkumar Karwar;
> Cathy Luo
> Subject: Re: [PATCH RESEND v2 03/11] mwifiex: resolve races between
> async FW init (failure) and device removal
> 
> Hi,
> 
> On Thu, Nov 10, 2016 at 07:57:04PM +0800, Xinming Hu wrote:
> > From: Brian Norris <briannorris@chromium.org>
> >
> > It's possible for the FW init sequence to fail, which will trigger a
> > device cleanup sequence in mwifiex_fw_dpc(). This sequence can race
> > with device suspend() or remove() (e.g., reboot or unbind), and can
> > trigger use-after-free issues. Currently, this driver attempts
> > (poorly) to synchronize remove() using a semaphore, but it doesn't
> > protect some of the critical sections properly. Particularly, we grab
> > a pointer to the adapter struct (card->adapter) without checking if
> > it's being freed or not. We later do a NULL check on the adapter, but
> > that doesn't work if the adapter was freed.
> >
> > Also note that the PCIe interface driver doesn't ever set
> > card->adapter to NULL, so even if we get the synchronization right,
> we
> > still might try to redo the cleanup in ->remove(), even if the FW
> init
> > failure sequence already did it.
> >
> > This patch replaces the static semaphore with a per-device completion
> > struct, and uses that completion to synchronize the remove() thread
> > with the mwifiex_fw_dpc(). A future patch will utilize this
> completion
> > to synchronize the suspend() thread as well.
> >
> > Signed-off-by: Brian Norris <briannorris@chromium.org>
> > ---
> > v2: Same as v1
> > ---
> >  drivers/net/wireless/marvell/mwifiex/main.c | 46
> > ++++++++++-------------------
> > drivers/net/wireless/marvell/mwifiex/main.h | 13 +++++---
> > drivers/net/wireless/marvell/mwifiex/pcie.c | 18 +++++------
> > drivers/net/wireless/marvell/mwifiex/pcie.h |  2 ++
> > drivers/net/wireless/marvell/mwifiex/sdio.c | 18 +++++------
> > drivers/net/wireless/marvell/mwifiex/sdio.h |  2 ++
> > drivers/net/wireless/marvell/mwifiex/usb.c  | 23 +++++++--------
> > drivers/net/wireless/marvell/mwifiex/usb.h  |  2 ++
> >  8 files changed, 55 insertions(+), 69 deletions(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/main.c
> > b/drivers/net/wireless/marvell/mwifiex/main.c
> > index c710d5e..09d46d6 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/main.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> > @@ -521,7 +521,6 @@ static void mwifiex_fw_dpc(const struct firmware
> *firmware, void *context)
> >  	struct mwifiex_private *priv;
> >  	struct mwifiex_adapter *adapter = context;
> >  	struct mwifiex_fw_image fw;
> > -	struct semaphore *sem = adapter->card_sem;
> >  	bool init_failed = false;
> >  	struct wireless_dev *wdev;
> >
> > @@ -670,7 +669,8 @@ static void mwifiex_fw_dpc(const struct firmware
> *firmware, void *context)
> >  	}
> >  	if (init_failed)
> >  		mwifiex_free_adapter(adapter);
> > -	up(sem);
> > +	/* Tell all current and future waiters we're finished */
> > +	complete_all(adapter->fw_done);
> 
> This part introduces a new use-after-free. We need to dereference
> adapter->fw_done *before* we free the adapter in
> mwifiex_free_adapter().
> So you need a diff that looks something like this:
> 
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -514,6 +514,7 @@ static void mwifiex_fw_dpc(const struct firmware
> *firmware, void *context)
>  	struct mwifiex_fw_image fw;
>  	bool init_failed = false;
>  	struct wireless_dev *wdev;
> +	struct completion *fw_done = adapter->fw_done;
> 
>  	if (!firmware) {
>  		mwifiex_dbg(adapter, ERROR,
> @@ -654,7 +655,7 @@ done:
>  	if (init_failed)
>  		mwifiex_free_adapter(adapter);
>  	/* Tell all current and future waiters we're finished */
> -	complete_all(adapter->fw_done);
> +	complete_all(fw_done);
>  	return;
>  }
> 

Thanks. I will include this change in v3.

Regards,
Amitkumar
