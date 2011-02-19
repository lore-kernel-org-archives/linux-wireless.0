Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39550 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1BSLzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 06:55:00 -0500
Received: by qwd7 with SMTP id 7so981068qwd.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 03:54:59 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1297789820.8664.4.camel@jlt3.sipsolutions.net>
References: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
	<20110215190657.75006zvz1q691rk8@naisho.dyndns.info>
	<1297789820.8664.4.camel@jlt3.sipsolutions.net>
Date: Sat, 19 Feb 2011 12:54:59 +0100
Message-ID: <AANLkTimudqvTM94eNX5cKmJBougPm99beEYFx_ogWPH-@mail.gmail.com>
Subject: Re: [RFC/RFT] mac80211: make tx() operation return void
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 6:10 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-02-15 at 19:06 +0200, Jussi Kivilinna wrote:
>
>> > -static int b43_op_tx(struct ieee80211_hw *hw,
>> > +static void b43_op_tx(struct ieee80211_hw *hw,
>> >                  struct sk_buff *skb)
>> >  {
>> >     struct b43_wl *wl = hw_to_b43_wl(hw);
>> > @@ -3211,14 +3211,11 @@ static int b43_op_tx(struct ieee80211_hw
>> >     if (unlikely(skb->len < 2 + 2 + 6)) {
>> >             /* Too short, this can't be a valid frame. */
>> >             dev_kfree_skb_any(skb);
>> > -           return NETDEV_TX_OK;
>> >     }
>>
>> Return missing.
>
> Right, thanks.
>
> johannes
>

Hi Johannes,

what about a v2 of this patch considering the b43 fix and recent ath5k
(needs a refresh) changes?

ath5k changes introduced by...

commit 12873372fe1f201813f1cc750a8af7d9193f445c
ath5k: move external function definitions to a header file

...in wireless-next-2.6

- Sedat -


[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=12873372fe1f201813f1cc750a8af7d9193f445c
