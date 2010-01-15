Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39561 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab0AOOgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 09:36:52 -0500
Received: by bwz27 with SMTP id 27so605753bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2010 06:36:50 -0800 (PST)
To: "tom.leiming\@gmail.com" <tom.leiming@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes\@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix memory leak in ieee80211_send_probe_req
References: <1263563061-3825-1-git-send-email-tom.leiming@gmail.com>
	<87fx67qwmg.fsf@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 15 Jan 2010 16:36:44 +0200
In-Reply-To: <87fx67qwmg.fsf@nokia.com> (Kalle Valo's message of "Fri\, 15 Jan 2010 16\:19\:03 +0200")
Message-ID: <87my0fsadf.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> "ext tom.leiming@gmail.com" <tom.leiming@gmail.com> writes:
>
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> This patch fixes memory leak in ieee80211_send_probe_req, which
>> is introduced in 7c12ce8b854df346388ea56d684784e3484012cf:
>>
>> 	mac80211: use Probe Request template when sending a direct scan
>

[...]

>> @@ -1028,6 +1028,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
>>  
>>  	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
>>  	ieee80211_tx_skb(sdata, skb);
>> +	kfree(buf);
>
> Better to use dev_kfree_skb() here.

I don't know what I was thinking when I sent the previous email  :)

After second look, this looks good.

Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
