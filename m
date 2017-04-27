Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34568 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755227AbdD0IWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Apr 2017 04:22:24 -0400
Message-ID: <1493281332.2529.1.camel@sipsolutions.net> (sfid-20170427_102246_807283_B6EDDD74)
Subject: Re: [PATCH 1/2] wcn36xx: Pass used skb to ieee80211_tx_status()
From: Johannes Berg <johannes@sipsolutions.net>
To: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-soc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, wcn36xx@lists.infradead.org,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>
Date: Thu, 27 Apr 2017 10:22:12 +0200
In-Reply-To: <20170426220444.10539-1-bjorn.andersson@linaro.org> (sfid-20170427_000624_047560_805C9599)
References: <20170426220444.10539-1-bjorn.andersson@linaro.org>
         (sfid-20170427_000624_047560_805C9599)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> @@ -371,7 +371,7 @@ static void reap_tx_dxes(struct wcn36xx *wcn,
> struct wcn36xx_dxe_ch *ch)
>  			info = IEEE80211_SKB_CB(ctl->skb);
>  			if (!(info->flags &
> IEEE80211_TX_CTL_REQ_TX_STATUS)) {
>  				/* Keep frame until TX status comes
> */
> -				ieee80211_free_txskb(wcn->hw, ctl-
> >skb);
> +				ieee80211_tx_status(wcn->hw, ctl-
> >skb);
> 

I don't think this is a good idea. This code intentionally checked if
TX status was requested, and if not then it doesn't go to the effort of
building it.

As it is with your patch, it'll go and report the TX status without any
TX status information - which is handled in wcn36xx_dxe_tx_ack_ind()
for those frames needing it.

johannes
