Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37285 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945Ab2CIJqM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 04:46:12 -0500
Received: by lahj13 with SMTP id j13so1458897lah.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 01:46:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1331281987.3491.0.camel@jlt3.sipsolutions.net>
References: <20120307183103.GB15839@redhat.com>
	<4F59275B.2010309@gmail.com>
	<20120309082216.GA2339@redhat.com>
	<1331281987.3491.0.camel@jlt3.sipsolutions.net>
Date: Fri, 9 Mar 2012 10:46:11 +0100
Message-ID: <CAL1gcdMXOVXmffAq5J1hhRb3C5aYWTo8JPaKsbsJTY0MaVN8Zw@mail.gmail.com> (sfid-20120309_104617_942780_D38F8C2B)
Subject: Re: [rt2x00-users] [PATCH 3.3 v2] rt2x00: fix random stalls
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw, Johannes,

On Fri, Mar 9, 2012 at 9:33 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-03-09 at 09:22 +0100, Stanislaw Gruszka wrote:
>
>> > > + spin_lock(&queue->tx_lock);
>> > >   rt2x00queue_pause_queue(queue);
>> > > + spin_unlock(&queue->tx_lock);
>> > >   exit_free_skb:
>> > >   ieee80211_free_txskb(hw, skb);
>> > >  }
>> >
>> > I'm sorry, but I'm still not convinced that we can use spin_lock_bh in
>> > one place of the code and then spin_lock in another place of the code,
>> > using the *same* spinlock.
>> > I always use the cheat sheet shown in:
>> > http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/c214.html
>> >
>> > which to me shows that by definition we should be using spin_lock_bh in
>> > all cases now, the new ones and the existing cases where we lock tx_lock.
>>
>> We have bh disabled here since ieee80211_xmit is always called with bh
>> disabled (early on dev_queue_xmit() or in ieee80211_tx_skb_tid()). I can
>> add comment about that.

OK. Thanks for the explanation. Now it is clear to me. However, I
think it would be
good to add a comment here, as we are otherwise bound to have the same
discussion
again in a couple of months time.
With that comment added you can add my:
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

to the v3 patch submission.

>
> And in fact if you were to use spin_unlock_bh() in that kind of context
> it would be a bug :-)
>

Thanks for your explanation as well, Johannes. Everything is clear to me now :-)


-- 
---
Gertjan
