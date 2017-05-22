Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0089.outbound.protection.outlook.com ([104.47.41.89]:55808
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935659AbdEVVFA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 17:05:00 -0400
Date: Tue, 23 May 2017 00:04:46 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: Re: [PATCH v6] qtnfmac: introduce new FullMAC driver for Quantenna
 chipsets
Message-ID: <20170522210445.bj3zlyc4stjmojf5@bars> (sfid-20170522_230604_034230_2A24B8F3)
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
 <1495026753.2442.7.camel@sipsolutions.net>
 <20170518200810.pch7tivugqyjmy4d@bars>
 <1495189094.3274.2.camel@sipsolutions.net>
 <20170521170814.d7ljne2pgopymxud@bars>
 <1495434501.2653.7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495434501.2653.7.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > - reply to action frames rejected by userspace tools
> >   in the same way as it is done by mac80211
> 
> I think you're probably thinking of the right thing, but just to
> clarify:
>  * if userspace decides to send a reject frame (0x80|action) then
>    that's just a regular mgmt-TX, nothing special about that
>  * if the cfg80211_rx_mgmt() *function* returns saying it wasn't
>    handled, that's just cfg80211 doing it due to the filters - then
>    there's no userspace code involved
> 
> I think you were thinking of the latter case, and yes, just adding the
> few lines of code to send rejects for action frames would be
> sufficient.
Correct, this is the case.

> 
> > Adding reject code seems to be straightforward. Adding
> > NL80211_RXMGMT_FLAG_ANSWERED flag to firmware is a more involved
> > task. But it can be done gradually, from simple usecases to the
> > complicated ones. Besides, IIUC the support of this flag by userspace
> > tools is still a work in progress. E.g., hostapd is not yet using it,
> > so we keep using 'send_probe_response = 0' config option.
> 
> Yeah, like I said above, this whole thing isn't really fully thought
> out it seems. I'm not sure what you mean by "send_probe_response = 0"
> though.
Hostapd registers for acton frames and probe requests. In our case probe
responses are sent by firmware. However hostapd needs to look at them anyway
in certain usecases. Bug hostapd doesn't try to respond to probe requests
when option 'send_probe_response = 0' is set in hostapd config.

IIRC the idea was to use 'send_probe_response' for now and then to implement
the use of NL80211_RXMGMT_FLAG_ANSWERED flag in hostapd, at least for probe
requests for the start. But it definitely doesn't make sense if you
plan to get rid of this flag in the long run.

> > Does it make sense if I post an RFC patch modifying current interface
> > of mgmt_frame_register in cfg80211_ops to collect feedback ?
> 
> Sure. I think there are some complications, like what happens if you
> just pass this through to the firmware and then the firmware crashes,
> and you need to recover this state? Perhaps cfg80211 should have some
> state accessors ("iterate list of subscriptions") for this purpose. Of
> course that can be added later as well.
Ok

Regards,
Sergey
