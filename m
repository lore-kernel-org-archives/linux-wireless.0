Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49444 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938530AbdEXHLj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 03:11:39 -0400
Message-ID: <1495609897.2665.4.camel@sipsolutions.net> (sfid-20170524_091244_123048_86C0DD32)
Subject: Re: [PATCH v6] qtnfmac: introduce new FullMAC driver for Quantenna
 chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Wed, 24 May 2017 09:11:37 +0200
In-Reply-To: <20170522210445.bj3zlyc4stjmojf5@bars>
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
         <1495026753.2442.7.camel@sipsolutions.net>
         <20170518200810.pch7tivugqyjmy4d@bars>
         <1495189094.3274.2.camel@sipsolutions.net>
         <20170521170814.d7ljne2pgopymxud@bars>
         <1495434501.2653.7.camel@sipsolutions.net>
         <20170522210445.bj3zlyc4stjmojf5@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Hostapd registers for acton frames and probe requests. In our case
> probe responses are sent by firmware. However hostapd needs to look
> at them anyway in certain usecases. Bug hostapd doesn't try to
> respond to probe requests when option 'send_probe_response = 0' is
> set in hostapd config.

Yeah, but this shouldn't really have to be configured, that's awkward.

> IIRC the idea was to use 'send_probe_response' for now and then to
> implement the use of NL80211_RXMGMT_FLAG_ANSWERED flag in hostapd, at
> least for probe requests for the start. But it definitely doesn't
> make sense if you plan to get rid of this flag in the long run.

No no! I'm not saying let's get rid of it if you need it - I was saying
we could get rid of it since it doesn't appear to be used. I think this
is fine for your case, in fact you should probably already set it and
then go and teach hostapd about it.

johannes
