Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42029 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbcBGNVy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 08:21:54 -0500
Subject: Re: [RFC v2] mac80211: add A-MSDU tx support
To: Emmanuel Grumbach <egrumbach@gmail.com>
References: <1454668864-31777-1-git-send-email-nbd@openwrt.org>
 <CANUX_P3xJBopdHcNjwJ2UcXLPZcNHJtE+mC2=3i8b4p=J8kjXQ@mail.gmail.com>
 <56B70978.3030900@openwrt.org>
 <CANUX_P0VWG78s8fs5Y58n-JwK+bamkLQV=M9aYroDGWrhrrR0g@mail.gmail.com>
 <CANUX_P0QkRhSpdxrd9jAobCX9E=TED55=YaTOJ6QwwuJQHfTqA@mail.gmail.com>
 <56B72115.10709@openwrt.org>
 <CANUX_P3kt90a2xiW=KtS7eA2movyne49OwG2XmJY6vrH7Oy12g@mail.gmail.com>
 <56B72F3E.9090708@openwrt.org>
 <CANUX_P2PG1Syik6jekU0Qif4gxZparoTJ124W15_oMWcu=ZCRw@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56B744EC.7090803@openwrt.org> (sfid-20160207_142209_087602_62F98B5F)
Date: Sun, 7 Feb 2016 14:21:48 +0100
MIME-Version: 1.0
In-Reply-To: <CANUX_P2PG1Syik6jekU0Qif4gxZparoTJ124W15_oMWcu=ZCRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-02-07 12:56, Emmanuel Grumbach wrote:
>>> well.. Yes, you can't assume that you'll have one descriptor for one
>>> MSDU payload  (unless the driver doesn't advertise SG to the
>>> netstack).
>> Okay, please make a suggestion describing the exact kinds of limits you
>> would need for iwlwifi.
> 
> Are athX devices able to handle MPDUs with any number of frags? Say if
> you have 30 different physically contiguous fragments, the DMA would
> be able to load all these into one single packet and send it to the
> air?
I think athX devices have no limitations there. I'm not testing this
with atheros devices though - ath9k does not have mac80211
per-sta-per-tid queueing support yet. I'm working with MediaTek MT76x2
chipsets with my mt76 driver, which I will upstream soon.

> iwlwifi currently has the limitation of 20 Transmit Buffers (BTs)
> which I mentioned earlier. I guess it'd be nice if the driver would be
> able to advertise how many fragments it can handle. Then, you'd need
> to stop the A-MSDU building if you'd cross this boundary?
> 
> You can look at skb_shinfo(skb)->nr_frags to know how many frags you
> have for each skb. On top of that, you need 1 frag for each subframe
> (subframe header).
I implemented all of your suggestions in RFC v3, let me know if
anything's missing.

- Felix
