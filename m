Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:47379 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbYLQQwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 11:52:39 -0500
Received: by rn-out-0910.google.com with SMTP id k40so3063427rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 08:52:38 -0800 (PST)
Message-ID: <40f31dec0812170852l63c3f2efl5e1bf41252c03c73@mail.gmail.com> (sfid-20081217_175243_871998_15C743C1)
Date: Wed, 17 Dec 2008 18:52:38 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: [RFC]: ath5k: enable TXOK IRQ
Cc: linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>,
	mcgrof@gmail.com, me@bobcopeland.com
In-Reply-To: <493F5010.7030500@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <493F5010.7030500@trash.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/12/10 Patrick McHardy <kaber@trash.net>:
> I tried to use ath5k in AP mode with hostapd, but hostapd never
> added the authenticated and associated stations to the kernel.
> The reason is that ath5k didn't invoke the tx tasklet, so it
> did not call the ieee80211_tx_status() function and userspace
> didn't receive the radiotap message indicating success.
>
> The root cause appears to be that the TXOK interrupt is not
> enabled, so the tasklet is never scheduled. I'm not sure whether
> TXOK is really the correct one to handle ! IEEE80211_TX_CTL_NO_ACK,
> but it fixes the problem for me.
>

Can you put a simple printk on get_isr to see what interrupts are you getting ?

Your patch sets TXOK interrupt on the secondary interrupt mask
register but if you don't enable
TXOK on the primary imr you won't get any...

2236         sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
2237                 AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
2238                 AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;

...so this is weird, you shouldn't get any txok interrupt even with
your patch. Txdesc/txeol should be enough.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
