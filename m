Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42510 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbeIVTLJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 15:11:09 -0400
Received: by mail-ed1-f68.google.com with SMTP id l5so12808991edw.9
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 06:17:35 -0700 (PDT)
Date: Sat, 22 Sep 2018 16:17:26 +0300
From: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH] brcmsmac: ap mode: update beacon when TIM changes
Message-ID: <20180922161726.1711e766@manjaro> (sfid-20180922_151929_573729_C511DF84)
In-Reply-To: <6feec186-5137-8827-8ade-6f8988144f78@broadcom.com>
References: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
 <6feec186-5137-8827-8ade-6f8988144f78@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 22 Sep 2018 11:07:36 +0200
Arend van Spriel <arend.vanspriel@broadcom.com> wrote:

> On 9/11/2018 7:26 PM, Ali MJ Al-Nasrawy wrote:
> > Beacons+TIM are created/updated for fw beaconing only when
> > BSS_CHANGED_BEACON. This is not compliant with power-saving
> > stations. Fix it by updating beacon templates on mac80211 set_tim
> > callback. Adresses the issue in:
> > https://marc.info/?i=20180911163534.21312d08%20()%20manjaro  
> 
> A few remarks below but here is my ....
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thank you for your review and I shall submit a second version fixing
the issues below...

> > +static int brcms_ops_beacon_set_tim(struct ieee80211_hw *hw,
> > +				 struct ieee80211_sta *sta, bool
> > set) +{
> > +	/*FIXME: this may be more efficiently handled by delegating
> > +	 beacon upload to the beacon interrupt handler*/  
> 
> No sure what you mean by this remark. The code below looks ok to me,
> ie. same as with bss update. So please drop the remark.

TIM is updated much more frequently than bss updates and scales with
number of client stations and a simple test shows that it takes ~120us
to update the beacon templates on Core i3! So I think it may be more
efficient to split set_tim handler to a fast bottom half that just
schedules an interrupt for the next beacon and delegates the beacon
upload to the interrupt handler so that beacon templates are not
updated several times per beacon interval.

But I agree that this should neither be part of the code nor titled
FIXME-I might have exaggerated a little bit ;)

> > a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h +++
> > b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h @@ -568,6
> > +568,8 @@ struct brcms_c_info { u16 beacon_tim_offset; u16
> > beacon_dtim_period; struct sk_buff *probe_resp;
> > +	  
> 
> Just get rid of the empty line (+TAB) above. I am not keen on storing 
> the vif, but it seems there is no other way to get that.

Okay.
