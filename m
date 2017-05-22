Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46252 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752148AbdEVG2Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 02:28:24 -0400
Message-ID: <1495434501.2653.7.camel@sipsolutions.net> (sfid-20170522_082827_251263_2CCCAEC4)
Subject: Re: [PATCH v6] qtnfmac: introduce new FullMAC driver for Quantenna
 chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 22 May 2017 08:28:21 +0200
In-Reply-To: <20170521170814.d7ljne2pgopymxud@bars>
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
         <1495026753.2442.7.camel@sipsolutions.net>
         <20170518200810.pch7tivugqyjmy4d@bars>
         <1495189094.3274.2.camel@sipsolutions.net>
         <20170521170814.d7ljne2pgopymxud@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sergey,

> Thanks for pointing at mac80211 reject code. In our specific case
> it looks like the issue can be fixed with help of the following
> building blocks:
> - properly set NL80211_RXMGMT_FLAG_ANSWERED flag, since quite a few
>   mgmt frame types are completely handled by firmware

This doesn't really seem to be used or checked at all - not sure I
would recommend that, since wpa_s doesn't handle it and we don't seem
to have a way for it to say it can deal with it?

For those frames that are answered, subscriptions should probably be
rejected unless wpa_s sets some flag saying that it can deal with
frames already having been answered, but I'm not sure that makes a lot
of sense?

I honestly don't even remember why this was added - I see the commit
but it doesn't say why. It's very tempting to revert this since we
don't really have the infrastructure set up to deal with it properly,
and nothing is actually using it.

> - reply to action frames rejected by userspace tools
>   in the same way as it is done by mac80211

I think you're probably thinking of the right thing, but just to
clarify:
 * if userspace decides to send a reject frame (0x80|action) then
   that's just a regular mgmt-TX, nothing special about that
 * if the cfg80211_rx_mgmt() *function* returns saying it wasn't
   handled, that's just cfg80211 doing it due to the filters - then
   there's no userspace code involved

I think you were thinking of the latter case, and yes, just adding the
few lines of code to send rejects for action frames would be
sufficient.

> Adding reject code seems to be straightforward. Adding
> NL80211_RXMGMT_FLAG_ANSWERED flag to firmware is a more involved
> task. But it can be done gradually, from simple usecases to the
> complicated ones. Besides, IIUC the support of this flag by userspace
> tools is still a work in progress. E.g., hostapd is not yet using it,
> so we keep using 'send_probe_response = 0' config option.

Yeah, like I said above, this whole thing isn't really fully thought
out it seems. I'm not sure what you mean by "send_probe_response = 0"
though.

Actually, now I seem to remember a little bit about the flag - there
were some cases like WPS/WSC or so that required seeing the probe
response frame, but not necessarily answering it in userspace.

As far as probe requests are concerned though - if you're able to reply
to them then you can just drop the probe requests and not report them
to the host at all. You just need to filter by higher-level protocols
and not do that for WSC or P2P probe requests or so - and you already
set the flags that you can distinguish that, so you should be able to
implement that?

> In the long run the idea of passing mgmt frame filters to drivers
> looks appealing. It will be up to driver whether to use filters (e.g.
> pass them to firmware for early processing) or not to use them
> (essentially leaving it for cfg80211 subsystem). I did a quick search
> through other users of cfg80211_rx_mgmt among wireless drivers. It
> turns out that none of them is checking its return value. So there
> may be other potential users of this feature :)

:)

> Does it make sense if I post an RFC patch modifying current interface
> of mgmt_frame_register in cfg80211_ops to collect feedback ?

Sure. I think there are some complications, like what happens if you
just pass this through to the firmware and then the firmware crashes,
and you need to recover this state? Perhaps cfg80211 should have some
state accessors ("iterate list of subscriptions") for this purpose. Of
course that can be added later as well.

johannes
