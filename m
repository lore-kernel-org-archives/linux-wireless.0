Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2564 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752471AbeEOLqI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 07:46:08 -0400
Date: Tue, 15 May 2018 17:16:01 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH 24/30] staging: wilc1000: refactor del_station() to
 avoid parenthesis misalignment
Message-ID: <20180515171601.35125506@ajaysk-VirtualBox> (sfid-20180515_134611_350480_D8C616EC)
In-Reply-To: <20180515090112.fba2zkzsqd7j7ckq@mwanda>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
        <1525682614-3824-25-git-send-email-ajay.kathat@microchip.com>
        <20180515090112.fba2zkzsqd7j7ckq@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Tue, 15 May 2018 12:01:12 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> I feel sort of bad complaining about this patchset when your
> co-workers already nit picked it to death...  :P
> 
> On Mon, May 07, 2018 at 02:13:28PM +0530, Ajay Singh wrote:
> > Refactor the code to fix open parenthesis alignment issue reported
> > by checkpatch.pl script in del_station().  
> 
> I no idea what an "open parenthesis alignment issue" is.  It's sort of
> surprising because I deal with checkpatch patches a lot.

The exact issue description reported by checkpatch.pl was 

"CHECK: Alignment should match open parenthesis"

To resolve that issue tried by reducing the leading tabs before
wilc_del_allstations() call, which helped in resolving checkpatch
issue without introducing line over 80 chars.

> 
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 18
> > ++++++++++-------- 1 file changed, 10 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> > b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c index
> > 4600f4a..7f49d60 100644 ---
> > a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c +++
> > b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c @@ -1997,6
> > +1997,7 @@ static int del_station(struct wiphy *wiphy, struct
> > net_device *dev, s32 ret = 0; struct wilc_priv *priv;
> >  	struct wilc_vif *vif;
> > +	struct sta_info *info;
> >  
> >  	if (!wiphy)
> >  		return -EFAULT;
> > @@ -2004,16 +2005,17 @@ static int del_station(struct wiphy *wiphy,
> > struct net_device *dev, priv = wiphy_priv(wiphy);
> >  	vif = netdev_priv(dev);
> >  
> > -	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
> > -		if (!mac)
> > -			ret = wilc_del_allstation(vif,
> > -
> > priv->assoc_stainfo.sta_associated_bss);
> > +	if (!(vif->iftype == AP_MODE || vif->iftype == GO_MODE))  
> 
> I feel like this is better as:
> 	if (vif->iftype != AP_MODE && vif->iftype != GO_MODE)
> 

Thanks for your suggestion.
Currently the patch is accepted, i will check and try to include it in
future patch as per your inputs.

> > +		return ret;  
> 
> What is "ret" here?  I haven't looked at this patch in context, but
> it's probably zero.  Just return the literal.

The value for 'ret' is zero till this point, only if there is
failure to post the command in wilc_eneque_cmd() then 'ret' receives
-ENOMEM value in below code.



Regards,
Ajay
