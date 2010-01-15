Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:42201 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602Ab0AOOTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 09:19:20 -0500
From: Kalle Valo <kalle.valo@iki.fi>
To: "tom.leiming\@gmail.com" <tom.leiming@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes\@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix memory leak in ieee80211_send_probe_req
References: <1263563061-3825-1-git-send-email-tom.leiming@gmail.com>
Date: Fri, 15 Jan 2010 16:19:03 +0200
In-Reply-To: <1263563061-3825-1-git-send-email-tom.leiming@gmail.com> (ext
	tom's message of "Fri, 15 Jan 2010 14:44:21 +0100")
Message-ID: <87fx67qwmg.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ext tom.leiming@gmail.com" <tom.leiming@gmail.com> writes:

> From: Ming Lei <tom.leiming@gmail.com>
>
> This patch fixes memory leak in ieee80211_send_probe_req, which
> is introduced in 7c12ce8b854df346388ea56d684784e3484012cf:
>
> 	mac80211: use Probe Request template when sending a direct scan


Sorry, I introduced this bug. Thank you finding this.

> The patch is against the latest wireless-test tree.

You should add comments like this after the "---" line.

> @@ -1028,6 +1028,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
>  
>  	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
>  	ieee80211_tx_skb(sdata, skb);
> +	kfree(buf);

Better to use dev_kfree_skb() here.

Can you resend, please?

-- 
Kalle Valo
