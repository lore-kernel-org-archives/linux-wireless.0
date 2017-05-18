Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:33370 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754354AbdERFFi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 01:05:38 -0400
Received: by mail-qk0-f170.google.com with SMTP id y201so27248369qka.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 May 2017 22:05:38 -0700 (PDT)
Date: Wed, 17 May 2017 22:05:38 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "k.eugene.e@gmail.com" <k.eugene.e@gmail.com>,
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
Subject: Re: [PATCH 1/2] wcn36xx: Pass used skb to ieee80211_tx_status()
Message-ID: <20170518050538.GL12920@tuxbook> (sfid-20170518_070611_915838_D0D0658F)
References: <20170426220444.10539-1-bjorn.andersson@linaro.org>
 <1493281332.2529.1.camel@sipsolutions.net>
 <20170428234247.GQ15143@minitux>
 <87fugkrchl.fsf@kamboji.qca.qualcomm.com>
 <1495026867.2442.9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495026867.2442.9.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed 17 May 06:14 PDT 2017, Johannes Berg wrote:

> On Thu, 2017-05-04 at 13:13 +0000, Kalle Valo wrote:
> > 
> > > > This code intentionally checked if TX status was requested, and
> > > > if not then it doesn't go to the effort of building it.
> > > > 
> > > 
> > > What I'm finding puzzling is the fact that the only caller of
> > > ieee80211_led_tx() is ieee80211_tx_status() and it seems like
> > > drivers, such as ath10k, call this for each packet handled - but
> > > I'm likely missing something.
> 
> Yes, many drivers do call it for each packet, and as such, this
> deficiency was never noted.
> 
> > > > As it is with your patch, it'll go and report the TX status
> > > > without any
> > > > TX status information - which is handled in
> > > > wcn36xx_dxe_tx_ack_ind()
> > > > for those frames needing it.
> > > > 
> > > 
> > > Right, it doesn't sound desired. However, during normal operation
> > > I'm not seeing IEEE80211_TX_CTL_REQ_TX_STATUS being set and as such
> > > ieee80211_led_tx() is never called.
> > 
> > So what's the conclusion? How do we get leds working?
> 
> Well, frankly, I never thought the TX LED was a super good idea - but
> it had been supported by the original code IIRC, so never removed. Some
> people like frantic blinking I guess ;-)
> 

It seems very important to a lot of people...


But if ieee80211_free_txskb() is the counterpart of
ieee80211_tx_status() then we should be able to push the
ieee80211_led_tx() call down into ieee80211_report_used_skb() and handle
both cases.

The ieee80211_free_txskb() seems to be used in various cases where we
discard skbs, but perhaps this is not an issue in reality.

> But I think the problem also applies to the throughput trigger thing,
> so perhaps we need to stick some LED feedback calls into other places,
> like _noskb() or provide an extra way to do it?
> 

Looking around it seems that we either have a call to free_txskb() or
one of the tx_status(); where the _noskb() would need some special
handling. Are there others or would it be reasonable to add a call in
this one "special" case?

Regards,
Bjorn
