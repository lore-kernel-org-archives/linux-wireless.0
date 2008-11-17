Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:58482 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYKQTmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 14:42:36 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtl8187: Fix transmission count sent to mac80211
Date: Mon, 17 Nov 2008 17:42:47 -0200
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
References: <492188e5.bIuOh01ilT9fPRTO%Larry.Finger@lwfinger.net>
In-Reply-To: <492188e5.bIuOh01ilT9fPRTO%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811171742.48292.herton@mandriva.com.br> (sfid-20081117_204243_576367_2EF0F338)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 17 November 2008 13:08:21 Larry Finger wrote:
> In the commit entitled "mac80211/drivers: rewrite the rate control API"
> (commit 9ea2c74de0ec971e8ec9fc5aaea9cd5b4fec95b6), the meaning of the
> packet transmit count was changed from the number of retries to the total
> number. In driver rtl8187, this change was missed.

With this change as before, when using pid, rate never go above 1M in testing 
here (minstrel doesn't have the same issue). May be because this in 
rate_control_pid_tx_status (inside rc80211_pid_algo.c)?

        if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
                spinfo->tx_num_failed += 2;
                spinfo->tx_num_xmit++;
        } else if (info->status.rates[0].count) {
                spinfo->tx_num_failed++;
                spinfo->tx_num_xmit++;
        }

as pkt_rc + 1, looks like we always will increment tx_num_failed, and may be 
it's causing this. Well this is only judging by a quick look, I may be wrong.

>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -488,7 +488,7 @@ static void rtl8187b_status_cb(struct ur
>  			__skb_unlink(skb, &priv->b_tx_status.queue);
>  			if (tok)
>  				info->flags |= IEEE80211_TX_STAT_ACK;
> -			info->status.rates[0].count = pkt_rc;
> +			info->status.rates[0].count = pkt_rc + 1;
>
>  			ieee80211_tx_status_irqsafe(hw, skb);
>  		}

--
[]'s
Herton
