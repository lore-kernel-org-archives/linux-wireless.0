Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:42296 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730984AbeITRFC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 13:05:02 -0400
Date: Thu, 20 Sep 2018 16:51:55 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <aditya.shankar@microchip.com>, <venkateswara.kaja@microchip.com>,
        <claudiu.beznea@microchip.com>, <adham.abozaeid@microchip.com>
Subject: Re: [PATCH v2 28/29] staging: wilc1000: avoid spaces preferred
 around checkpatch issue
Message-ID: <20180920165155.08f72ea0@ajaysk-VirtualBox> (sfid-20180920_132210_517004_C50A9CEF)
In-Reply-To: <6e925b2021d5fbc59f1933d37a1deb1332ede752.camel@perches.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
        <1537424620-6982-29-git-send-email-ajay.kathat@microchip.com>
        <6e925b2021d5fbc59f1933d37a1deb1332ede752.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 20 Sep 2018 02:57:21 -0700
Joe Perches <joe@perches.com> wrote:

> On Thu, 2018-09-20 at 11:53 +0530, Ajay Singh wrote:
> > Cleanup patch to add extra spaces around the '/' to avoid the below
> > checkpatch warning.
> > 
> > 'spaces preferred around that '/' (ctx:VxV)'
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/linux_wlan.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/wilc1000/linux_wlan.c
> > b/drivers/staging/wilc1000/linux_wlan.c index 695d5b2..29c1317
> > 100644 --- a/drivers/staging/wilc1000/linux_wlan.c
> > +++ b/drivers/staging/wilc1000/linux_wlan.c
> > @@ -823,7 +823,7 @@ static void wilc_set_multicast_list(struct
> > net_device *dev) 
> >  	netdev_for_each_mc_addr(ha, dev) {
> >  		memcpy(mc_list + i, ha->addr, ETH_ALEN);
> > -		netdev_dbg(dev, "Entry[%d]: %x:%x:%x:%x:%x:%x\n",
> > i/ETH_ALEN,
> > +		netdev_dbg(dev, "Entry[%d]: %x:%x:%x:%x:%x:%x\n",
> > i / ETH_ALEN, mc_list[i], mc_list[i + 1], mc_list[i + 2],
> >  			   mc_list[i + 3], mc_list[i + 4],
> > mc_list[i + 5]); i += ETH_ALEN;  
> 
> Probably better using the vsprintf %pM extension:
> 
> 	netdev_dbg(dev, Entry[%d]: %pM\n", i / ETH_ALEN, mc_list + i);
> 
> though I would also suggest using another temporary
> pointer instead of an offset and divisions.
> 
> Something like:
> 
> o use kmalloc_array
> o remove unnecessary res
> o add u8 *cur_mc
> o use i as index

Hi Joe,

Thanks for your suggestion and sharing the code changes.
I agree, it looks better with your modification.


Do I need to resend the updated patch series by including your
changes or can this patch be applied from your mail ?

Regards,
Ajay
