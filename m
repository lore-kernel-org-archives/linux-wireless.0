Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:36525 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0AOOgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 09:36:45 -0500
Received: by qw-out-2122.google.com with SMTP id 3so156838qwe.37
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2010 06:36:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87fx67qwmg.fsf@nokia.com>
References: <1263563061-3825-1-git-send-email-tom.leiming@gmail.com>
	 <87fx67qwmg.fsf@nokia.com>
Date: Fri, 15 Jan 2010 22:36:44 +0800
Message-ID: <d82e647a1001150636j67d08be6yec310750ccc73ded@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix memory leak in ieee80211_send_probe_req
From: Ming Lei <tom.leiming@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/15 Kalle Valo <kalle.valo@iki.fi>:
> "ext tom.leiming@gmail.com" <tom.leiming@gmail.com> writes:
>
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> This patch fixes memory leak in ieee80211_send_probe_req, which
>> is introduced in 7c12ce8b854df346388ea56d684784e3484012cf:
>>
>>       mac80211: use Probe Request template when sending a direct scan
>
>
> Sorry, I introduced this bug. Thank you finding this.
>
>> The patch is against the latest wireless-test tree.
>
> You should add comments like this after the "---" line.
>
>> @@ -1028,6 +1028,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
>>
>>       IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
>>       ieee80211_tx_skb(sdata, skb);
>> +     kfree(buf);
>
> Better to use dev_kfree_skb() here.

Why is dev_kfree_skb better?
It is 'buf' allocated in ieee80211_send_probe_req to be freed, not skb.

>
> Can you resend, please?

OK.

-- 
Lei Ming
