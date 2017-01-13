Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50194 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751363AbdAMKUU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 05:20:20 -0500
Message-ID: <1484302817.27366.2.camel@sipsolutions.net> (sfid-20170113_112023_768697_85997793)
Subject: Re: [PATCH] mac80211: initialize SMPS field in HT capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc: onelektra@gmx.net
Date: Fri, 13 Jan 2017 11:20:17 +0100
In-Reply-To: <ba04d61c-3f80-573f-3108-c94a9c991404@nbd.name>
References: <20170111223322.14698-1-nbd@nbd.name>
         <1484295655.19860.9.camel@sipsolutions.net>
         <ba04d61c-3f80-573f-3108-c94a9c991404@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-13 at 09:54 +0100, Felix Fietkau wrote:

> > Additionally, ath10k appears to be setting this to
> > WLAN_HT_CAP_SM_PS_DYNAMIC already, so apparently it's expecting
> > something to happen with that value? Is it really correct then to
> > be overwriting it?
> 
> Actually, that code seems to leave the value at 
> WLAN_HT_CAP_SM_PS_DISABLED, because it sets that first and doesn't
> mask out the field before trying to set it to
> WLAN_HT_CAP_SM_PS_DYNAMIC.

Hah, that's funny.

> I don't think it even makes sense to set WLAN_HT_CAP_SM_PS_DYNAMIC at
> this point, since it's up to mac80211 to deal with the SMPS state.
> 
> Either way, WLAN_HT_CAP_SM_PS_STATIC is a really bad default to have
> at init time. If you want, I can change the patch to check for that
> value before changing it, but I don't really see the point.

No, I think I agree. But please add a comment that OR'ing in the two
bits will not result in it having strange values - it's a bit
unexpected to see this here and then one has to remember (or look up)
the value of DISABLED to understand the code is fine.

> Additionally, I found this ath10k commit:
> 
> 
> commit e33a99e227e430a788467e5a85dc29f6df16b983
> Author: Peter Oh <poh@qca.qualcomm.com>
> Date:   Thu Dec 31 15:26:20 2015 +0200
> 
>     ath10k: set SM power save disabled to default value
>     
>     Use SMPS disabled as default because FW does not indicate
>     any support of SMPS.
>     
>     This change will help STAs out that don’t support SMPS from
>     sticking on 1SS, since they don’t have method to change it
>     back to multiple chains.
>     
>     This change also should not affect power consumption of STAs
>     supporting SMPS, because they are capable to switch the mode
>     to dynamic or static either at the end of frame sequence or
>     by using SMPS action frame.

Fun. Though I'd argue that this whole thing should then just be removed
from ath10k.

johannes
