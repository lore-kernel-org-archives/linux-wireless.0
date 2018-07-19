Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:3576 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbeGTFPX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 01:15:23 -0400
Date: Fri, 20 Jul 2018 04:35:24 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@driverdev.osuosl.org>, <venkateswara.kaja@microchip.com>,
        <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH 05/23] staging: wilc1000: rename goto to avoid leading
 '_' in label name
Message-ID: <20180720043524.5a8d1c7e@ajaysk-VirtualBox> (sfid-20180720_062943_054074_85BEE2FF)
In-Reply-To: <20180719092744.5gx2ctgj7etvk7uh@mwanda>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
        <1531953919-20804-6-git-send-email-ajay.kathat@microchip.com>
        <20180719092744.5gx2ctgj7etvk7uh@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Thu, 19 Jul 2018 12:27:44 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Thu, Jul 19, 2018 at 04:15:01AM +0530, Ajay Singh wrote:
> > diff --git a/drivers/staging/wilc1000/wilc_wlan.c
> > b/drivers/staging/wilc1000/wilc_wlan.c index 85af365..8e71c28 100644
> > --- a/drivers/staging/wilc1000/wilc_wlan.c
> > +++ b/drivers/staging/wilc1000/wilc_wlan.c
> > @@ -850,13 +850,13 @@ static void wilc_wlan_handle_isr_ext(struct
> > wilc *wilc, u32 int_status) if (wilc->rx_buffer)
> >  			buffer = &wilc->rx_buffer[offset];
> >  		else
> > -			goto _end_;
> > +			goto end;  
> 
> This isn't related to your patch but this goto doesn't appear to make
> any sort of sense.  I have no idea what was intended.
> 

Thanks for pointing it out. I will include these changes in separate
patchset.

Yes, the position of goto label can be moved just before
wilc_wlan_handle_rxq(wilc), as 'ret' will always be '0' when goto
statement is executed.

Actually earlier there were few more goto statement in this function
and single label 'end' was used to handle for different cases. But in
previous cleanup patches those cases were removed.
Now this function can be further refactor by either moving
goto label before wilc_wlan_handle_rxq(wilc) or avoid goto use by
adding the rx_buffer validation along with size check.

i.e 

end:
    wilc_wlan_handle_rxq(wilc)


OR

	if (size > 0 && wilc->rx_buffer) {

	....
	}
    	wilc_wlan_handle_rxq(wilc)

	

> >  
> >  		wilc->hif_func->hif_clear_int_ext(wilc,
> >  					      DATA_INT_CLR |
> > ENABLE_RX_VMM); ret = wilc->hif_func->hif_block_rx_ext(wilc, 0,
> > buffer, size); 
> > -_end_:
> > +end:
> >  		if (ret) {
> >  			offset += size;
> >  			wilc->rx_buffer_offset = offset;  
> 
> regards,
> dan carpenter
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
