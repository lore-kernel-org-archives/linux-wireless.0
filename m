Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:50058 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbcGSPxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 11:53:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mateusz Kulikowski <mateusz.kulikowski@gmail.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging/rtl8192e: use s8 instead of char
Date: Tue, 19 Jul 2016 17:53:38 +0200
Message-ID: <3858062.NGQDOLnTj0@wuerfel> (sfid-20160719_175413_805782_8FB75F2C)
In-Reply-To: <wrfjy44xvdfn.fsf@redhat.com>
References: <20160719153403.2967812-1-arnd@arndb.de> <20160719153403.2967812-2-arnd@arndb.de> <wrfjy44xvdfn.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, July 19, 2016 11:46:04 AM CEST Jes Sorensen wrote:
> > diff --git a/drivers/staging/rtl8192e/rtl819x_TSProc.c b/drivers/staging/rtl8192e/rtl819x_TSProc.c
> > index 2c8a526773ed..e0a2fe5e6148 100644
> > --- a/drivers/staging/rtl8192e/rtl819x_TSProc.c
> > +++ b/drivers/staging/rtl8192e/rtl819x_TSProc.c
> > @@ -323,7 +323,7 @@ bool GetTs(struct rtllib_device *ieee, struct ts_common_info **ppTS,
> >       if (ieee->current_network.qos_data.supported == 0) {
> >               UP = 0;
> >       } else {
> > -             if (!IsACValid(TID)) {
> > +             if (!IsACValid((s8)TID)) {
> >                       netdev_warn(ieee->dev, "%s(): TID(%d) is not valid\n",
> >                                   __func__, TID);
> >                       return false;
> 
> TID is a 4-bit field, it should never go negative. The cast to s8 seems
> wrong to me, if anything it should be using u8. I do realize the macro
> IsACValid checks against negative too, but that just looks silly to me.

Ok, I'll remove the extra comparison then to avoid the warning:

staging/rtl8192e/rtl819x_TSProc.c:326:14: error: comparison is always true due to limited range of data type [-Werror=type-limits]

I guess it should be a separate patch. I had just stumbled over the
same thing before resending the patch but decided not to change it
to keep the patch simple.

	Arnd
