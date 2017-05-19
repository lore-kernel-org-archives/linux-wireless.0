Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36922 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752093AbdESKSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 06:18:17 -0400
Message-ID: <1495189094.3274.2.camel@sipsolutions.net> (sfid-20170519_121820_383894_369A45B2)
Subject: Re: [PATCH v6] qtnfmac: introduce new FullMAC driver for Quantenna
 chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Fri, 19 May 2017 12:18:14 +0200
In-Reply-To: <20170518200810.pch7tivugqyjmy4d@bars>
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
         <1495026753.2442.7.camel@sipsolutions.net>
         <20170518200810.pch7tivugqyjmy4d@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Thanks for the review ! Fixes will be queued to the upcoming patches
> with various cleanups as well as new features.

Great :)

FWIW, regarding the  qtnf_mgmt_frame_register() and
cfg80211_rx_mgmt() thing, I think we'll have to discuss how to do this,
and perhaps you need to think about the firmware API for it.

Right now, I don't see that you can pass filters down, but you probably
also don't want to implement the reject code in the driver? And
cfg80211 doesn't give you that data right now either... So somewhere I
expect we'll need to make changes, unless you just copy (e.g. from
mac80211) the implementation of what happens when cfg80211_rx_mgmt()
returns false.

> BTW, speaking about other backends... During previous reviews of this
> patch we had a question regarding possible support of another
> previous generation SoC connected to host CPU via RGMII interface. Is
> there any legitimate (aka 'upstreamable') way to support such
> wireless cards ?

I'm not really familiar with RGMII, so I can't say how you'd support
this, sorry.

johannes
