Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45919 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1IARFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 13:05:07 -0400
Received: by gwaa12 with SMTP id a12so1039345gwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Sep 2011 10:05:06 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: Re: [PATCH] mac80211: Defer tranmission of mesh path errors
Date: Thu,  1 Sep 2011 10:04:44 -0700
Message-Id: <1314896685-2932-1-git-send-email-javier@cozybit.com> (sfid-20110901_190510_650755_E9EE89E5)
In-Reply-To: <1314767494.4161.2.camel@jlt3.sipsolutions.net>
References: <1314767494.4161.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 10:11 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-08-30 at 18:50 -0700, Javier Cardona wrote:
>
>> The stress tests do trigger perrs and, with this change, we see a
>> warning due to missing info->control.vif
>>
>> [14202.988077] ------------[ cut here ]------------
>> [14202.988351] WARNING: at net/mac80211/util.c:358
>> ieee80211_add_pending_skb+0x97/0xa0()
>
> Interesting. Ok, that means we can't just use add_pending_skb(), we need
> to do some setup before, all the setup that ieee80211_tx_skb() and
> ieee80211_xmit() would do up to ieee80211_tx()...
>
> I guess we need a little bit of helper code to enable this.

The patch that follows seems to do it.  Passes our stress test without
warnings.  I increased the headroom on allocation to avoid a resize.  Does it
look correct to you?

Cheers,

Javier

-- 
1.7.6
