Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31830 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbbKZMiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:38:10 -0500
Date: Thu, 26 Nov 2015 15:37:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: (bug report) iwlwifi: inconsitent NULL checking
Message-ID: <20151126123756.GF7289@mwanda> (sfid-20151126_133813_805630_08EDDB5B)
References: <20151126120317.GJ10556@mwanda>
 <1448540211.2167.7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1448540211.2167.7.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 26, 2015 at 01:16:51PM +0100, Johannes Berg wrote:
> On Thu, 2015-11-26 at 15:03 +0300, Dan Carpenter wrote:
> > 
> >   2793          if (lq_sta && !lq_sta->pers.drv) {
> >                     ^^^^^^
> > Check.
> > 
> >   2794                  IWL_DEBUG_RATE(mvm, "Rate scaling not
> > initialized yet.\n");
> >   2795                  mvm_sta = NULL;
> >   2796          }
> >   2797  
> >   2798          /* Send management frames and NO_ACK data using
> > lowest rate. */
> >   2799          if (rate_control_send_low(sta, mvm_sta, txrc))
> >   2800                  return;
> >   2801  
> >   2802          iwl_mvm_hwrate_to_tx_rate(lq_sta->last_rate_n_flags,
> >                                           ^^^^^^^^^^^^^^^^^^^^^^^^^
> > Uchecked dereference.
> > 
> 
> Yeah, this is a bit tricky. If you look into rate_control_send_low(),
> I'm sure it'll return true when mvm_sta argument is NULL. Not sure how,
> if at all, we could make that more explicit here.

Ah.  Thanks for looking at this.  Eventually Smatch will be smart enough
to figure this implication out but not yet.  No need to change the code
because the static checker isn't capable enough...

regards,
dan carpenter

