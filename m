Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:43230 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZHXUTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 16:19:13 -0400
Received: by vws2 with SMTP id 2so2185053vws.4
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2009 13:19:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A92F2F5.6000909@lwfinger.net>
References: <4A92F2F5.6000909@lwfinger.net>
Date: Mon, 24 Aug 2009 16:19:14 -0400
Message-ID: <b6c5339f0908241319s5a72023eu78571a8f1d8f7bab@mail.gmail.com>
Subject: Re: Kernel Panic in __ieee80211_tx with p43usb as AP
From: Bob Copeland <bcopeland@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>, Chr <chunkeey@web.de>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 24, 2009 at 4:07 PM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> static inline int drv_tx(struct ieee80211_local *local, struct sk_buff
> *skb)
> {
>        return local->ops->tx(&local->hw, skb);
> }
>
> Are there any suggest changes that would let me debug this problem
> without crashing the kernel?

Could be a callback into mac80211, e.g. ieee80211_get_tx_rate()
returning null (I haven't looked at any p54 code, I just know I've hit
one there before with ath5k).

-- 
Bob Copeland %% www.bobcopeland.com
