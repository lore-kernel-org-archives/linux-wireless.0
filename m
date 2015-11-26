Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36838 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbbKZMQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:16:55 -0500
Message-ID: <1448540211.2167.7.camel@sipsolutions.net> (sfid-20151126_131659_963793_5EA47994)
Subject: Re: (bug report) iwlwifi: inconsitent NULL checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2015 13:16:51 +0100
In-Reply-To: <20151126120317.GJ10556@mwanda> (sfid-20151126_130328_960203_265EA1F6)
References: <20151126120317.GJ10556@mwanda>
	 (sfid-20151126_130328_960203_265EA1F6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-26 at 15:03 +0300, Dan Carpenter wrote:
> 
>   2793          if (lq_sta && !lq_sta->pers.drv) {
>                     ^^^^^^
> Check.
> 
>   2794                  IWL_DEBUG_RATE(mvm, "Rate scaling not
> initialized yet.\n");
>   2795                  mvm_sta = NULL;
>   2796          }
>   2797  
>   2798          /* Send management frames and NO_ACK data using
> lowest rate. */
>   2799          if (rate_control_send_low(sta, mvm_sta, txrc))
>   2800                  return;
>   2801  
>   2802          iwl_mvm_hwrate_to_tx_rate(lq_sta->last_rate_n_flags,
>                                           ^^^^^^^^^^^^^^^^^^^^^^^^^
> Uchecked dereference.
> 

Yeah, this is a bit tricky. If you look into rate_control_send_low(),
I'm sure it'll return true when mvm_sta argument is NULL. Not sure how,
if at all, we could make that more explicit here.

johannes
