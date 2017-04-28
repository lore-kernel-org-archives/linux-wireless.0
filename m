Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33218 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423761AbdD1Xmv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 19:42:51 -0400
Received: by mail-pf0-f174.google.com with SMTP id q20so1158235pfg.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Apr 2017 16:42:51 -0700 (PDT)
Date: Fri, 28 Apr 2017 16:42:47 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-soc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, wcn36xx@lists.infradead.org,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>
Subject: Re: [PATCH 1/2] wcn36xx: Pass used skb to ieee80211_tx_status()
Message-ID: <20170428234247.GQ15143@minitux> (sfid-20170429_014320_894882_4F8BB5AA)
References: <20170426220444.10539-1-bjorn.andersson@linaro.org>
 <1493281332.2529.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1493281332.2529.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu 27 Apr 01:22 PDT 2017, Johannes Berg wrote:

> 
> > @@ -371,7 +371,7 @@ static void reap_tx_dxes(struct wcn36xx *wcn,
> > struct wcn36xx_dxe_ch *ch)
> >  			info = IEEE80211_SKB_CB(ctl->skb);
> >  			if (!(info->flags &
> > IEEE80211_TX_CTL_REQ_TX_STATUS)) {
> >  				/* Keep frame until TX status comes
> > */
> > -				ieee80211_free_txskb(wcn->hw, ctl-
> > >skb);
> > +				ieee80211_tx_status(wcn->hw, ctl-
> > >skb);
> > 
> 
> I don't think this is a good idea.

Thanks for letting me know :)

> This code intentionally checked if TX status was requested, and if not
> then it doesn't go to the effort of building it.
> 

What I'm finding puzzling is the fact that the only caller of
ieee80211_led_tx() is ieee80211_tx_status() and it seems like drivers,
such as ath10k, call this for each packet handled - but I'm likely
missing something.

> As it is with your patch, it'll go and report the TX status without any
> TX status information - which is handled in wcn36xx_dxe_tx_ack_ind()
> for those frames needing it.
> 

Right, it doesn't sound desired. However, during normal operation I'm
not seeing IEEE80211_TX_CTL_REQ_TX_STATUS being set and as such
ieee80211_led_tx() is never called.

Regards,
Bjorn
