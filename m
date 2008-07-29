Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:12169 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbYG2LBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:01:03 -0400
Received: by py-out-1112.google.com with SMTP id p76so3629733pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 04:01:02 -0700 (PDT)
Message-ID: <1ba2fa240807290401w3bf88e61lbcbc2a78f97f4833@mail.gmail.com> (sfid-20080729_130107_659795_BC9FAA46)
Date: Tue, 29 Jul 2008 14:01:01 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217328563.10489.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217323927.10489.9.camel@johannes.berg>
	 <1ba2fa240807290348y58026caag341a7115c0d78083@mail.gmail.com>
	 <1217328563.10489.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 1:49 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-29 at 13:48 +0300, Tomas Winkler wrote:
>> On Tue, Jul 29, 2008 at 12:32 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > This patch fixes mac80211 to not use the skb->cb over the queue step
>> > from virtual interfaces to the master. The patch also, for now,
>> > disables aggregation because that would still require requeuing,
>> > will fix that in a separate patch. There are two other places (software
>> > requeue and powersaving stations) where requeue can happen, but that is
>> > not currently used by any drivers/not possible to use respectively.
>>
>> What about about ieee80211_get_rate(hw, const struct ieee80211_tx_info *c).
>> It's used in tx path in the drivers and info is fetched from cb
>
> So what about it? mac80211 builds the info in skb->cb just fine before
> it passes the frame to the driver.

Sorry my mistake. This is built after the packet get to  master xmit
Tomas
