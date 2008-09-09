Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:27882 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYIIIOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 04:14:23 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1069174yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2008 01:14:22 -0700 (PDT)
Message-ID: <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com>
Date: Tue, 9 Sep 2008 11:14:21 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: HT action frame code
Cc: "Jouni Malinen" <j@w1.fi>,
	"Ron Rindjunsky" <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1220942004.31304.101.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220883730.31304.60.camel@johannes.berg> <48C5868B.8060103@w1.fi>
	 <1220942004.31304.101.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 9:33 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-08 at 23:09 +0300, Jouni Malinen wrote:
>> Johannes Berg wrote:
>> > When we're an AP, shouldn't we also in some way honour the block-ack
>> > action frames? Or will that be done in hostapd, which then sets up
>> > block-ack via some unspecified way?
>>
>> The current design assumes that hostapd takes care of all management
>> frames, so eyes, these would need to go to hostapd for processing and
>> then setup back to mac80211 through some new command..
>
> Well we can always pick out those action frames in the kernel if we want
> to, that's not the problem, is it?

We've indeed has kept inside just BA session action frames.
>
> Should the design be changed? It seems that this is more related to the
> rate scale algorithm and the "can we support aggregation for this STA"
> question, both of which we currently have information about in the
> kernel and not hostapd.

The decision might come both from RS and hostapd. RS just have more
info whether there will be gain from aggregation. When throughput is
not high enough it's just an overhead. Though some APs open session
immediately uppon association without and RS decision.
Our design is that BA can be triggered not only for RS.
Tomas


> johannes
>
