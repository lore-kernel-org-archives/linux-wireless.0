Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40710 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751782AbdEQNOa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 09:14:30 -0400
Message-ID: <1495026867.2442.9.camel@sipsolutions.net> (sfid-20170517_151541_511431_706E090D)
Subject: Re: [PATCH 1/2] wcn36xx: Pass used skb to ieee80211_tx_status()
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: "k.eugene.e@gmail.com" <k.eugene.e@gmail.com>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-soc@vger.kernel.org" <linux-soc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        "nicolas.dechesne@linaro.org" <nicolas.dechesne@linaro.org>
Date: Wed, 17 May 2017 15:14:27 +0200
In-Reply-To: <87fugkrchl.fsf@kamboji.qca.qualcomm.com>
References: <20170426220444.10539-1-bjorn.andersson@linaro.org>
         <1493281332.2529.1.camel@sipsolutions.net>     <20170428234247.GQ15143@minitux>
         <87fugkrchl.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-05-04 at 13:13 +0000, Kalle Valo wrote:
> 
> > > This code intentionally checked if TX status was requested, and
> > > if not then it doesn't go to the effort of building it.
> > > 
> > 
> > What I'm finding puzzling is the fact that the only caller of
> > ieee80211_led_tx() is ieee80211_tx_status() and it seems like
> > drivers, such as ath10k, call this for each packet handled - but
> > I'm likely missing something.

Yes, many drivers do call it for each packet, and as such, this
deficiency was never noted.

> > > As it is with your patch, it'll go and report the TX status
> > > without any
> > > TX status information - which is handled in
> > > wcn36xx_dxe_tx_ack_ind()
> > > for those frames needing it.
> > > 
> > 
> > Right, it doesn't sound desired. However, during normal operation
> > I'm not seeing IEEE80211_TX_CTL_REQ_TX_STATUS being set and as such
> > ieee80211_led_tx() is never called.
> 
> So what's the conclusion? How do we get leds working?

Well, frankly, I never thought the TX LED was a super good idea - but
it had been supported by the original code IIRC, so never removed. Some
people like frantic blinking I guess ;-)

But I think the problem also applies to the throughput trigger thing,
so perhaps we need to stick some LED feedback calls into other places,
like _noskb() or provide an extra way to do it?

johannes
