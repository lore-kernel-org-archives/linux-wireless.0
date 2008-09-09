Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:46936 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYIIIqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 04:46:25 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1075396yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2008 01:46:23 -0700 (PDT)
Message-ID: <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com> (sfid-20080909_104629_131131_AA2FF544)
Date: Tue, 9 Sep 2008 11:46:23 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: HT action frame code
Cc: "Jouni Malinen" <j@w1.fi>,
	"Ron Rindjunsky" <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1220948427.31304.107.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220883730.31304.60.camel@johannes.berg> <48C5868B.8060103@w1.fi>
	 <1220942004.31304.101.camel@johannes.berg>
	 <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com>
	 <1220948427.31304.107.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 11:20 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-09-09 at 11:14 +0300, Tomas Winkler wrote:
>
>> >> The current design assumes that hostapd takes care of all management
>> >> frames, so eyes, these would need to go to hostapd for processing and
>> >> then setup back to mac80211 through some new command..
>> >
>> > Well we can always pick out those action frames in the kernel if we want
>> > to, that's not the problem, is it?
>>
>> We've indeed has kept inside just BA session action frames.
>
> Hmm? I don't think I understand what you're trying to say.

Meaning that other management frames are forward to user space while
BA action frames
are treated inside mac80211.

>
>> > Should the design be changed? It seems that this is more related to the
>> > rate scale algorithm and the "can we support aggregation for this STA"
>> > question, both of which we currently have information about in the
>> > kernel and not hostapd.
>>
>> The decision might come both from RS and hostapd. RS just have more
>> info whether there will be gain from aggregation. When throughput is
>> not high enough it's just an overhead. Though some APs open session
>> immediately uppon association without and RS decision.
>> Our design is that BA can be triggered not only for RS.
>
> Well yeah, but I'm not sure we really want to add API to cfg80211 for
> this. It's not exactly hard to, but right now I don't see how hostapd
> would influence the decision.
>
> Also, I'm not talking about the AP triggering the aggregation session,
> this is entirely done with the rate scaling right now, but about an
> associated STA wanting to start an aggregation session. Aren't
> aggregation sessions always triggered by whoever wants to send? So if a
> STA notices it has lots of upload going on it could want to trigger a BA
> session, which is something we don't currently support afaict.

In iwl-agn-rs.c There is not difference if the peer is STA or AP. So
we support this already.
Thanks
Tomas
