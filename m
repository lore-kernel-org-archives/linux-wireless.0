Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45175 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2IQPPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:15:42 -0400
Received: by pbbrr13 with SMTP id rr13so9155453pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2012 08:15:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347892887.7112.9.camel@sauron.fi.intel.com>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	<1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	<1347631355.5263.19.camel@sauron.fi.intel.com>
	<1347640763.5263.24.camel@sauron.fi.intel.com>
	<1347892887.7112.9.camel@sauron.fi.intel.com>
Date: Mon, 17 Sep 2012 17:15:41 +0200
Message-ID: <CANn89iJymkq8LKcNCFCbQakfEZ+zV4Nbg33wATBD7oc0QCnj6Q@mail.gmail.com> (sfid-20120917_171545_758986_2167CDC2)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Eric Dumazet <edumazet@google.com>
To: artem.bityutskiy@linux.intel.com
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I would say some part of the stack assumes a header (I dont know wich
one ?) is pulled in skb->head/data, and thats a bug.

Always use pskb_may_pull(skb, XXX) to make sure you can access XXX
bytes in skb->data

It would help if you describe the problem, because I have no history (
I am not linux-wireless subscriber).

On Mon, Sep 17, 2012 at 4:41 PM, Artem Bityutskiy
<artem.bityutskiy@linux.intel.com> wrote:
> On Fri, 2012-09-14 at 19:39 +0300, Artem Bityutskiy wrote:
>> On Fri, 2012-09-14 at 17:02 +0300, Artem Bityutskiy wrote:
>> > Hi Johannes,
>> >
>> > We are using iwlwifi driver in Tizen IVI. We were using kernel v3.4 and
>> > wifi tethering worked fine. But after upgrading to v3.5 it stopped
>> > working.
>> >
>> > I am trying to bisect this already many hours - very difficult, because
>> > tethering did not work in kernels around v3.4-rcX for some different
>> > reasons, so just 'git bisect' does not work.
>>
>> OK, my latest finding is:
>>
>>         bad:               3edaf3e Johannes Berg  mac80211: manage AP netdev carrier state
>>         good:              fe40cb6 Ashok Nagarajan  mac80211: Check basic rates when peering
>>
>> However, just reverting in 3.5 does not solve the issue. I am out of
>> ideas how to proceed.
>
> OK, finally I got it. After 3 days of hardcore intelligent bisecting
>         I've found out that tethering in 3.5 works for me if I revert
> these 2
>         patches:
>
>             56138f5 iwlwifi: dont pull too much payload in skb head
>             3edaf3e mac80211: manage AP netdev carrier state
>
>         Johannes, Eric?
>
> --
> Best Regards,
> Artem Bityutskiy
