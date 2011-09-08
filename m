Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33241 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab1IHJ3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 05:29:10 -0400
Received: by qyk7 with SMTP id 7so209067qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 02:29:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E688601.2020505@openwrt.org>
References: <1315472282-21051-1-git-send-email-helmut.schaa@googlemail.com>
	<4E688601.2020505@openwrt.org>
Date: Thu, 8 Sep 2011 11:21:00 +0200
Message-ID: <CAGXE3d8Gdjix9dRnAzDSF=D4VUEr8hM2896Pm53Shoi+PMZh-g@mail.gmail.com> (sfid-20110908_112914_713715_50508213)
Subject: Re: [PATCH 1/2] mac80211: Don't aggregate rate probe frames in minstrel_ht
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 8, 2011 at 11:08 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-09-08 10:58 AM, Helmut Schaa wrote:
>>
>> This is already done by rt2x00 and ath9k by checking the
>> IEEE80211_TX_CTL_RATE_CTRL_PROBE flag. Instead we can simply do it in
>> minstrel_ht.
>>
>> Signed-off-by: Helmut Schaa<helmut.schaa@googlemail.com>
>> ---
>>
>> Felix, I didn't have a closer look at the ath9k aggregation code but I
>> guess it
>> can also be simplified with this change.
>>
>> Any objections?
>
> Yes, this probably breaks ath9k. IEEE80211_TX_CTL_AMPDU is used to indicate
> that the packet is part of an aggregation session, so ath9k only does block
> ack window tracking for packets that have this flag set.
> I think the drivers should continue to check for
> IEEE80211_TX_CTL_RATE_CTRL_PROBE

Ok, the flag description is a bit misleading then:

@IEEE80211_TX_CTL_AMPDU: this frame should be sent as part of an A-MPDU

John, please drop this series.

Helmut
