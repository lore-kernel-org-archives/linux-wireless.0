Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exsmtp03.microchip.com ([198.175.253.49]:57840 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935352AbdAIFul (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 00:50:41 -0500
Date: Mon, 9 Jan 2017 11:20:33 +0530
From: Aditya Shankar <aditya.shankar@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: wilc1000: Connect to highest RSSI value for
 required SSID
Message-ID: <20170109112033.6f287e6d@aditya-ubuntu> (sfid-20170109_065045_476160_C6220835)
In-Reply-To: <20170105121450.GF13756@mwanda>
References: <1483601621-27545-1-git-send-email-aditya.shankar@microchip.com>
        <20170105121450.GF13756@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 5 Jan 2017 15:14:50 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Thu, Jan 05, 2017 at 01:03:41PM +0530, Aditya Shankar wrote:
> > Connect to the highest rssi with the required SSID in the shadow
> > table if the connection criteria is based only on the SSID.
> > For the first matching SSID, an index to the table is saved.
> > Later the index is updated if matching SSID has a higher
> > RSSI value than the last saved index.
> > 
> > However if decision is made based on BSSID, there is only one match
> > in the table and corresponding index is used.
> > 
> > Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
> > ---
> >  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 20 ++++++++++++++------
> >  1 file changed, 14 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> > index c1a24f7..32206b8 100644
> > --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> > +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> > @@ -665,6 +665,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
> >  {
> >  	s32 s32Error = 0;
> >  	u32 i;
> > +	u32 sel_bssi_idx = last_scanned_cnt + 1;  
> 
> 
> My understanding from reading the code is that "last_scanned_cnt + 1"
> is a randomly chosen invalid value.  Just saying:
> 
> 	sel_bssi_idx = last_scanned_cnt;
> 
> would  also work because it's also invalid and slightly shorter to type.
> But I suggest that you go with something like UINT_MAX because that's
> more clearly invalid.

Thanks. Will change this.
> 
> >  	u8 u8security = NO_ENCRYPT;
> >  	enum AUTHTYPE tenuAuth_type = ANY;
> >  
> > @@ -688,18 +689,25 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
> >  		    memcmp(last_scanned_shadow[i].ssid,
> >  			   sme->ssid,
> >  			   sme->ssid_len) == 0) {
> > -			if (!sme->bssid)
> > -				break;
> > -			else
> > +			if (!sme->bssid) {
> > +				if (sel_bssi_idx == (last_scanned_cnt + 1))
> > +					sel_bssi_idx = i;
> > +				else if (last_scanned_shadow[i].rssi >
> > +					 last_scanned_shadow[sel_bssi_idx].rssi)
> > +					sel_bssi_idx = i;  
> 
> Combine these with an ||.
> 
> 			if (!sme->bssid) {
> 				if (sel_bssi_idx == UINT_MAX ||
> 				    last_scanned_shadow[i].rssi >
> 				    last_scanned_shadow[sel_bssi_idx].rssi)
> 					sel_bssi_idx = i;
>
>
> 
> In a separate patch, you can reverse the if statement at the start of
> the loop:
> 
> 		if (sme->ssid_len != last_scanned_shadow[i].ssid_len ||
> 		    memcmp(last_scanned_shadow[i].ssid, sme->ssid,
> 			   sme->ssid_len) != 0)
> 			continue;
> 
> That way you can pull these lines in a tab.
> 
> 
> > +			} else {
> >  				if (memcmp(last_scanned_shadow[i].bssid,
> >  					   sme->bssid,
> > -					   ETH_ALEN) == 0)
> > +					   ETH_ALEN) == 0){  
> 
> Add a space before the curly brace.
> 
> regards,
> dan carpenter
> 
> 

I shall send an updated patch with the suggested changes and a separate
patch for the change at the beginning of the loop. 

Thanks for your review!

-- 
adiTya
