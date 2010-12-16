Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20287 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab0LPBPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 20:15:05 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 17:14:50 -0800
Date: Wed, 15 Dec 2010 17:15:16 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Vipin Mehta <Vipin.Mehta@Atheros.com>,
	"greg@kroah.com" <greg@kroah.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: ath6kl: Fixing device NULL pointer dereference
Message-ID: <20101216011416.GA388@vmehta-desktop>
References: <1292375879-32085-1-git-send-email-vmehta@atheros.com>
 <AANLkTin_fw6aRc5Rs1_BTcapTE9kgPHy7_Gex9wRtkWy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTin_fw6aRc5Rs1_BTcapTE9kgPHy7_Gex9wRtkWy@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 14, 2010 at 08:15:24PM -0800, Luis R. Rodriguez wrote:
> On Tue, Dec 14, 2010 at 5:17 PM, Vipin Mehta <vmehta@atheros.com> wrote:
> > Fixing the device instance being passed to set_wiphy_dev() from
> > NULL to the one being returned by the MMC stack probe callback.
> >
> > Signed-off-by: Vipin Mehta <vmehta@atheros.com>
> > ---
> >  drivers/staging/ath6kl/os/linux/ar6000_drv.c |   19 ++++++++++++-------
> >  1 files changed, 12 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> > index a659f70..9f3e928 100644
> > --- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> > +++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> > @@ -1608,6 +1608,15 @@ ar6000_avail_ev(void *context, void *hif_handle)
> >     struct wireless_dev *wdev;
> >  #endif /* ATH6K_CONFIG_CFG80211 */
> >     A_STATUS init_status = A_OK;
> > +    HIF_DEVICE_OS_DEVICE_INFO osDevInfo;
> > +
> > +    A_MEMZERO(&osDevInfo, sizeof(osDevInfo));
> > +    if ( A_FAILED( HIFConfigureDevice(hif_handle, HIF_DEVICE_GET_OS_DEVICE,
> > +                    &osDevInfo, sizeof(osDevInfo))) )
> 
> while you are adding new code, why not use the direct Linux calls?

I'll change the use of A_MEMZERO(), A_FAILED() macros and A_STATUS
data type given that we have an incoming patch that cleans the rest
of the code for similar usage. Changing the use of HIFConfigureDevice()
will be more useful if we do it across the driver since it will require
significant changes in the data structures defined in the HIF layer.
It qualifies for an entirely separate patch and can be done later in a
systematic way.
