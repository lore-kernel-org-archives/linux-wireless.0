Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:40388 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935467AbeEISrG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 14:47:06 -0400
Date: Thu, 10 May 2018 00:14:53 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@Microchip.com>
Subject: Re: [PATCH 30/30] staging: wilc1000: rename s8idxarray to avoid
 datatype in variable name
Message-ID: <20180510001453.347a0882@ajaysk-VirtualBox> (sfid-20180509_204709_932170_2C333A36)
In-Reply-To: <9f4adf70-9c0a-18f7-750d-1dfa8c19f91e@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-31-git-send-email-ajay.kathat@microchip.com>
 <9f4adf70-9c0a-18f7-750d-1dfa8c19f91e@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 9 May 2018 16:42:20 +0300
Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:

> On 07.05.2018 11:43, Ajay Singh wrote:
> > Cleanup patch to have variable names as per linux coding style.
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/host_interface.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/host_interface.c
> > b/drivers/staging/wilc1000/host_interface.c index ad9270e..e27010c
> > 100644 --- a/drivers/staging/wilc1000/host_interface.c
> > +++ b/drivers/staging/wilc1000/host_interface.c
> > @@ -1543,7 +1543,7 @@ static int handle_key(struct wilc_vif *vif,
> > struct key_attr *hif_key) struct wid wid;
> >  	struct wid wid_list[5];
> >  	u8 *key_buf;
> > -	s8 s8idxarray[1];
> > +	s8 idxarray[1];
> >  	struct host_if_drv *hif_drv = vif->hif_drv;
> >  
> >  	switch (hif_key->type) {
> > @@ -1610,8 +1610,8 @@ static int handle_key(struct wilc_vif *vif,
> > struct key_attr *hif_key) wid.id = (u16)WID_REMOVE_WEP_KEY;
> >  			wid.type = WID_STR;
> >  
> > -			s8idxarray[0] =
> > (s8)hif_key->attr.wep.index;
> > -			wid.val = s8idxarray;
> > +			idxarray[0] =
> > (s8)hif_key->attr.wep.index;  
> 
> I think you can get rid of idxarray at all.
> 

Yes, we can remove idxarray variable. I will update and resubmit this
patch.

> > +			wid.val = idxarray;>
> > 			wid.size = 1; 
> >  			result = wilc_send_config_pkt(vif, SET_CFG,
> >   
