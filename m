Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46195 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0AOOxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 09:53:17 -0500
Received: by bwz27 with SMTP id 27so623291bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2010 06:53:15 -0800 (PST)
To: Ming Lei <tom.leiming@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes\@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix memory leak in ieee80211_send_probe_req
References: <1263563061-3825-1-git-send-email-tom.leiming@gmail.com>
	<87fx67qwmg.fsf@nokia.com>
	<d82e647a1001150636j67d08be6yec310750ccc73ded@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 15 Jan 2010 16:53:13 +0200
In-Reply-To: <d82e647a1001150636j67d08be6yec310750ccc73ded@mail.gmail.com> (Ming Lei's message of "Fri\, 15 Jan 2010 22\:36\:44 +0800")
Message-ID: <87iqb3s9ly.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ming Lei <tom.leiming@gmail.com> writes:

>>>       IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
>>>       ieee80211_tx_skb(sdata, skb);
>>> +     kfree(buf);
>>
>> Better to use dev_kfree_skb() here.
>
> Why is dev_kfree_skb better?
> It is 'buf' allocated in ieee80211_send_probe_req to be freed, not skb.

Yes, I misread your patch first. Please forget that comment :)

-- 
Kalle Valo
