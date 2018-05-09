Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:29463 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964827AbeEITCE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 15:02:04 -0400
Date: Thu, 10 May 2018 00:29:50 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@Microchip.com>
Subject: Re: [PATCH 05/30] staging: wilc1000: fix line over 80 chars in
 host_int_parse_assoc_resp_info()
Message-ID: <20180510002950.16b475d9@ajaysk-VirtualBox> (sfid-20180509_210207_944466_1AA30254)
In-Reply-To: <e7165eb4-584d-370c-7d5d-cca93ab34fc7@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-6-git-send-email-ajay.kathat@microchip.com>
 <e7165eb4-584d-370c-7d5d-cca93ab34fc7@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 9 May 2018 16:44:38 +0300
Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:

> On 07.05.2018 11:43, Ajay Singh wrote:
> > Fix line over 80 characters issue reported by checkpatch.pl in
> > host_int_parse_assoc_resp_info().
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/host_interface.c | 37
> > ++++++++++++++++++------------- 1 file changed, 21 insertions(+),
> > 16 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/host_interface.c
> > b/drivers/staging/wilc1000/host_interface.c index 55a61d5..a341ff1
> > 100644 --- a/drivers/staging/wilc1000/host_interface.c
> > +++ b/drivers/staging/wilc1000/host_interface.c
> > @@ -1293,6 +1293,23 @@ static inline void
> > host_int_free_user_conn_req(struct host_if_drv *hif_drv)
> > hif_drv->usr_conn_req.ies = NULL; }
> >  
> > +static void host_int_copy_conn_info(struct connect_resp_info
> > *conn_resp_info,
> > +				    struct connect_info *conn_info)
> > +{
> > +	conn_info->status = conn_resp_info->status;
> > +
> > +	if (conn_info->status == SUCCESSFUL_STATUSCODE &&
> > conn_resp_info->ies) {
> > +		conn_info->resp_ies = kmemdup(conn_resp_info->ies,
> > +
> > conn_resp_info->ies_len,
> > +					      GFP_KERNEL);
> > +		if (conn_info->resp_ies)
> > +			conn_info->resp_ies_len =
> > conn_resp_info->ies_len;
> > +	}
> > +
> > +	kfree(conn_resp_info->ies);
> > +	kfree(conn_resp_info);
> > +}
> > +  
> 
> Instead of adding new function why not using
> wilc_parse_assoc_resp_info() to return you the conn_info that you are
> copying it here? The connect_resp_info object that you are passing to
> wilc_parse_assoc_resp_info() is not used anywhere in
> host_int_parse_assoc_resp_info() it is used only to copy again from
> it to conn_info object.

Yes, there are different function because the purpose is different.
Primarily wilc_parse_assoc_resp_info() is to take care of parsing and
filing the response info and later connect_resp_info is used to fill
conn_info values. The elements in conn_info and connect_resp_info are
different, but now most of the fields are not used in connect_resp_info.
Returning 'conn_info' from wilc_parse_assoc_resp_info() might not be
correct. I will check if we can go away with connect_resp_info
structure itself as most of the field are not used in it.

> 
> Also, in wilc_parse_assoc_resp_info() you can get rid of these lines:
> connect_resp_info->capability = get_assoc_resp_cap_info(buffer);
> connect_resp_info->assoc_id = get_asoc_id(buffer);              
> 

With above changes it can be taken care.

> 
> >  static inline void host_int_parse_assoc_resp_info(struct wilc_vif
> > *vif, u8 mac_status)
> >  {
> > @@ -1316,25 +1333,13 @@ static inline void
> > host_int_parse_assoc_resp_info(struct wilc_vif *vif, 
> >  			err =
> > wilc_parse_assoc_resp_info(rcv_assoc_resp,
> > rcvd_assoc_resp_info_len, &connect_resp_info);
> > -			if (err) {
> > +			if (err)
> >  				netdev_err(vif->ndev,
> >  					   "wilc_parse_assoc_resp_info()
> > returned error %d\n", err);
> > -			} else {
> > -				conn_info.status =
> > connect_resp_info->status; -
> > -				if (conn_info.status ==
> > SUCCESSFUL_STATUSCODE &&
> > -				    connect_resp_info->ies) {
> > -					conn_info.resp_ies =
> > kmemdup(connect_resp_info->ies,
> > -
> > connect_resp_info->ies_len,
> > -
> > GFP_KERNEL);
> > -					if (conn_info.resp_ies)
> > -
> > conn_info.resp_ies_len = connect_resp_info->ies_len;
> > -				}
> > -
> > -				kfree(connect_resp_info->ies);
> > -				kfree(connect_resp_info);
> > -			}
> > +			else
> > +
> > host_int_copy_conn_info(connect_resp_info,
> > +
> > &conn_info); }
> >  	}
> >  
> >   
