Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:51496 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682Ab0AURWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 12:22:31 -0500
Date: Thu, 21 Jan 2010 18:23:55 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: Set/clear WPA keys before the WEP ones
Message-ID: <20100121172354.GC20793@sortiz.org>
References: <20100118231920.GH5176@sortiz.org>
 <1263952092.4481.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1263952092.4481.2.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2010 at 05:48:12PM -0800, Dan Williams wrote:
> On Tue, 2010-01-19 at 00:19 +0100, Samuel Ortiz wrote:
> > With the v10 firmware running on 8688 HW, clearing WPA keys after setting the
> > WEP key prevents us from being able to associate with WEP APs.
> > Swapping the calling order for assoc_helper_wpa_keys() and
> > assoc_helper_wep_keys fixes that issue.
> > 
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> Acked-by: Dan Williams <dcbw@redhat.com>
> 
> Tested on both sd8686 (v9 fw) and usb8388 (v5 OLPC fw).  Switching
> between WEP and WPA-PSK on-the-fly works as expected with this patch.
> 
> Though maybe we want to add a comment about this specific issue that
> says something like:
> 
> /* v10 FW wants WPA keys to be set/cleared after WEP key operations,
>  * otherwise it will fail to correctly associate to WEP networks.
>  * Other firmware versions don't appear to care.
>  */
Yes, I can add these comments. Thanks for testing it, I'll send a new version
of the patch.

Cheers,
Samuel.

 
> > ---
> >  drivers/net/wireless/libertas/assoc.c |   15 ++++++++-------
> >  1 files changed, 8 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
> > index 5e650f3..fb3dff0 100644
> > --- a/drivers/net/wireless/libertas/assoc.c
> > +++ b/drivers/net/wireless/libertas/assoc.c
> > @@ -2052,13 +2052,6 @@ void lbs_association_worker(struct work_struct *work)
> >  			goto out;
> >  	}
> >  
> > -	if (   test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags)
> > -	    || test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags)) {
> > -		ret = assoc_helper_wep_keys(priv, assoc_req);
> > -		if (ret)
> > -			goto out;
> > -	}
> > -
> >  	if (test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
> >  		ret = assoc_helper_secinfo(priv, assoc_req);
> >  		if (ret)
> > @@ -2078,6 +2071,14 @@ void lbs_association_worker(struct work_struct *work)
> >  			goto out;
> >  	}
> >  
> > +	if (   test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags)
> > +	    || test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags)) {
> > +		ret = assoc_helper_wep_keys(priv, assoc_req);
> > +		if (ret)
> > +			goto out;
> > +	}
> > +
> > +
> >  	/* SSID/BSSID should be the _last_ config option set, because they
> >  	 * trigger the association attempt.
> >  	 */
> > -- 
> > 1.6.3.3
> > 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
