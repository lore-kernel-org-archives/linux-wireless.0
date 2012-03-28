Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:53926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab2C1J3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:29:16 -0400
From: Timo Lindhorst <tlnd@online.de>
To: Timo Lindhorst <tlnd@online.de>
Subject: Re: [PATCH] mac80211_hwsim: Report rate info in tx status
Date: Wed, 28 Mar 2012 11:28:27 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Jouni Malinen" <j@w1.fi>
References: <201203281117.53033.tlnd@online.de>
In-Reply-To: <201203281117.53033.tlnd@online.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201203281128.27956.tlnd@online.de> (sfid-20120328_112918_379850_4BB01E9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

> +     if (!ack)
> +             for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> +                     tx_count[i] = txi->control.rates[i].count;
> +
>       ieee80211_tx_info_clear_status(txi);
>       if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && ack)
>               txi->flags |= IEEE80211_TX_STAT_ACK;
> +
> +     if (ack) {
> +             txi->status.rates[0].count = 1;
> +             txi->status.rates[1].idx = -1;
> +     } else {
> +             for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> +                     txi->control.rates[i].count = tx_count[i];
> +     }
> +
>       ieee80211_tx_status_irqsafe(hw, skb);
>  }

I know: backing up the count values, clearing the status, and restoring the
values if necessary is kind of ugly. Would it be better to partly clear the 
status manually instead of using ieee80211_tx_info_clear_status() ?

Regards
Timo
