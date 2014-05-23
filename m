Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:43836 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751357AbaEWCuB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 22:50:01 -0400
Message-ID: <1400813392.25946.35.camel@dubbel> (sfid-20140523_045006_086600_695F88A8)
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: michal.kazior@tieto.com, linux-wireless@vger.kernel.org
Date: Fri, 23 May 2014 05:49:52 +0300
In-Reply-To: <1400812703-15685-1-git-send-email-luca@coelho.fi>
References: <1400769938.4174.29.camel@jlt4.sipsolutions.net>
	 <1400812703-15685-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] mac80211: add a single-transaction driver op to switch
 contexts
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 05:38 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> In some cases, when the driver is already using all the channel
> contexts it can handle at once, we have to do an in-place switch
> (ie. we cannot afford using an extra context temporarily for the
> transaction).  But some drivers may not support switching the channel
> context assigned to a vif on the fly (ie. without unassigning and
> assigning it) while others may only work if the context is changed on
> the fly, without unassigning it first.
> 
> To allow these different scenarios, add a new driver operation that
> let's the driver decide how to handle an in-place switch.
> 
> Additionally, remove the IEEE80211_HW_CHANGE_RUNNING_CHANCTX flag,
> since we never change a running context directly anymore.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---

So, this is what I had cooked up.  Sorry Michal, I should have synced
with you.  Actually I tried to ping you on IRC, but you were not there,
and then I forgot to sync by email.

In any case, our patches were very similar, since the whole API
discussion had already been done before.  Some details are different
though, and my version only supports a single vif (obviously).  Also, I
already added a usage of the new op in a new
ieee80211_vif_change_reserved_context() function (which is similar to
Michal's "change incopat" function).

--
Luca.

