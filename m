Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55363 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3K2PiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 10:38:24 -0500
Message-ID: <1385739487.8656.1.camel@jlt4.sipsolutions.net> (sfid-20131129_163856_300692_4E7BA095)
Subject: Re: [PATCH] net: mac80211: tx.c: be sure of 'sdata->vif.type' must
 be NL80211_IFTYPE_AP when be in NL80211_IFTYPE_AP case
From: Johannes Berg <johannes@sipsolutions.net>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	rkuo <rkuo@codeaurora.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Date: Fri, 29 Nov 2013 16:38:07 +0100
In-Reply-To: <52957ADA.2080704@gmail.com> (sfid-20131127_055211_558798_A7DF5684)
References: <528AEFB7.4060301@gmail.com>
	 <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com>
	 <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>
	 <52957ADA.2080704@gmail.com> (sfid-20131127_055211_558798_A7DF5684)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +++ b/net/mac80211/tx.c
> @@ -1814,8 +1814,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  			break;
>  		/* fall through */
>  	case NL80211_IFTYPE_AP:
> -		if (sdata->vif.type == NL80211_IFTYPE_AP)
> -			chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
> +		if (sdata->vif.type != NL80211_IFTYPE_AP)
> +			goto fail_rcu;
> +		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);

This change is completely wrong.

johannes

