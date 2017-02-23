Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36054 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbdBWECz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 23:02:55 -0500
Date: Wed, 22 Feb 2017 22:54:00 -0500
From: Tahia Khan <tahia.khan@gmail.com>
To: arend.vanspriel@broadcom.com, outreachy-kernel@googlegroups.com,
        aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osusl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: wilc1000: renames struct tstrRSSI and its
 members u8Index, u8Full
Message-ID: <20170223035400.GA9378@coolbox> (sfid-20170223_050322_649825_99BF5A7A)
References: <20170222171403.GA20626@coolbox>
 <838d3e67-646d-b2d3-ef7d-5812675db6db@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <838d3e67-646d-b2d3-ef7d-5812675db6db@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 22, 2017 at 08:50:31PM +0100, Arend Van Spriel wrote:
> On 22-2-2017 18:14, Tahia Khan wrote:
> > Fixes multiple camel case checks on struct tstrRSSI from checkpatch.pl:
> > 
> > Avoid CamelCase: <tstrRSSI>
> > Avoid CamelCase: <u8Full>
> > Avoid CamelCase: <u8Index>
> 
> Just a generic remark that may help you with other changes you will be
> making in the linux kernel. Warnings from checkpatch.pl and other tools
> are useful, but try to look further than just fixing a warning.
> Understand what the code is doing is just as important.
> 
> > Signed-off-by: Tahia Khan <tahia.khan@gmail.com>
> > ---
> >  drivers/staging/wilc1000/coreconfigurator.h       |  8 ++++----
> >  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
> > index cff1698..5b65c4f 100644
> > --- a/drivers/staging/wilc1000/coreconfigurator.h
> > +++ b/drivers/staging/wilc1000/coreconfigurator.h
> > @@ -70,9 +70,9 @@ enum connect_status {
> >  	CONNECT_STS_FORCE_16_BIT = 0xFFFF
> >  };
> >  
> > -struct tstrRSSI {
> > -	u8 u8Full;
> > -	u8 u8Index;
> > +struct tstr_RSSI {
> > +	u8 full;
> > +	u8 index;
> >  	s8 as8RSSI[NUM_RSSI];
> 
> So you have a struct here with three members and you choose to only
> change the first two. What do you think about the third one just by
> looking at it. And what about the name of the struct. What does 'tstr' mean?
> 
> >  };
> >  
> > @@ -93,7 +93,7 @@ struct network_info {
> >  	u8 *ies;
> >  	u16 ies_len;
> >  	void *join_params;
> > -	struct tstrRSSI str_rssi;
> > +	struct tstr_RSSI str_rssi;
> >  	u64 tsf_hi;
> >  };
> >  
> > diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> > index f7ce47c..56f133e 100644
> > --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> > +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> > @@ -205,8 +205,8 @@ static u32 get_rssi_avg(struct network_info *network_info)
> >  {
> >  	u8 i;
> >  	int rssi_v = 0;
> > -	u8 num_rssi = (network_info->str_rssi.u8Full) ?
> > -		       NUM_RSSI : (network_info->str_rssi.u8Index);
> > +	u8 num_rssi = (network_info->str_rssi.full) ?
> > +		       NUM_RSSI : (network_info->str_rssi.index);
> 
> so struct tstr_RSSI is really a rssi history buffer so maybe naming it
> as such makes it clearer, ie. struct rssi_history_buffer.
> 
> >  	for (i = 0; i < num_rssi; i++)
> >  		rssi_v += network_info->str_rssi.as8RSSI[i];
> > @@ -346,13 +346,13 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
> >  	} else {
> >  		ap_index = ap_found;
> >  	}
> > -	rssi_index = last_scanned_shadow[ap_index].str_rssi.u8Index;
> > +	rssi_index = last_scanned_shadow[ap_index].str_rssi.index;
> >  	last_scanned_shadow[ap_index].str_rssi.as8RSSI[rssi_index++] = pstrNetworkInfo->rssi;
> >  	if (rssi_index == NUM_RSSI) {
> >  		rssi_index = 0;
> > -		last_scanned_shadow[ap_index].str_rssi.u8Full = 1;
> > +		last_scanned_shadow[ap_index].str_rssi.full = 1;
> 
> So the 'full' member is actually a bool and you might type it as such.
> 
> Hope this helps.
> 
> Regards,
> Arend
> 
> >  	}
> > -	last_scanned_shadow[ap_index].str_rssi.u8Index = rssi_index;
> > +	last_scanned_shadow[ap_index].str_rssi.index = rssi_index;
> >  	last_scanned_shadow[ap_index].rssi = pstrNetworkInfo->rssi;
> >  	last_scanned_shadow[ap_index].cap_info = pstrNetworkInfo->cap_info;
> >  	last_scanned_shadow[ap_index].ssid_len = pstrNetworkInfo->ssid_len;
> > 

Thanks for the feedback Arend, I really appreciate it. I've decided to go with
these changes in my follow-up patch request:

- rename tstrRSSI to 'rssi_history_buffer' as Aren suggested since it makes the
purpose of the struct clear
- remove Hungarian notation from all tstrRSSI members' names
- change type of u8Full to bool since it's only ever 1 or 0
- change name of as8RSSI to 'samples' since this buffer is only ever used to 
compute an average, and the "rssi" prefix is implied by the struct's name
- rename str_rssi to rssi_history in the network_info struct for clarity

Since my reasoning for these changes deviates from just "renaming to 
avoid camel casing" (as in the original checkpatch.pl warning), would it still 
make sense to submit all this in a single patch? I know my commit message
needs to change but I wonder if this is too much detail.

Tahia
