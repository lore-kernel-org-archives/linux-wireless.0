Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0084.outbound.protection.outlook.com ([104.47.38.84]:16248
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751474AbdEURIa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 May 2017 13:08:30 -0400
Date: Sun, 21 May 2017 20:08:15 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH v6] qtnfmac: introduce new FullMAC driver for Quantenna
 chipsets
Message-ID: <20170521170814.d7ljne2pgopymxud@bars> (sfid-20170521_190835_220130_9C814910)
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
 <1495026753.2442.7.camel@sipsolutions.net>
 <20170518200810.pch7tivugqyjmy4d@bars>
 <1495189094.3274.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495189094.3274.2.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 19, 2017 at 12:18:14PM +0200, Johannes Berg wrote:

> FWIW, regarding the  qtnf_mgmt_frame_register() and
> cfg80211_rx_mgmt() thing, I think we'll have to discuss how to do this,
> and perhaps you need to think about the firmware API for it.
> 
> Right now, I don't see that you can pass filters down, but you probably
> also don't want to implement the reject code in the driver? And
> cfg80211 doesn't give you that data right now either... So somewhere I
> expect we'll need to make changes, unless you just copy (e.g. from
> mac80211) the implementation of what happens when cfg80211_rx_mgmt()
> returns false.

Thanks for pointing at mac80211 reject code. In our specific case
it looks like the issue can be fixed with help of the following
building blocks:
- properly set NL80211_RXMGMT_FLAG_ANSWERED flag, since quite a few
  mgmt frame types are completely handled by firmware
- reply to action frames rejected by userspace tools
  in the same way as it is done by mac80211

Adding reject code seems to be straightforward. Adding NL80211_RXMGMT_FLAG_ANSWERED
flag to firmware is a more involved task. But it can be done gradually, from
simple usecases to the complicated ones. Besides, IIUC the support of this flag
by userspace tools is still a work in progress. E.g., hostapd is not yet using it,
so we keep using 'send_probe_response = 0' config option.

In the long run the idea of passing mgmt frame filters to drivers looks
appealing. It will be up to driver whether to use filters (e.g. pass them
to firmware for early processing) or not to use them (essentially leaving
it for cfg80211 subsystem). I did a quick search through other users of
cfg80211_rx_mgmt among wireless drivers. It turns out that none of them is
checking its return value. So there may be other potential
users of this feature :)

Does it make sense if I post an RFC patch modifying current interface
of mgmt_frame_register in cfg80211_ops to collect feedback ?

Regards,
Sergey
