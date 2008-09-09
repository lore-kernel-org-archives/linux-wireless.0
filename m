Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:62190 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYIIKxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 06:53:19 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1100484yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2008 03:53:18 -0700 (PDT)
Message-ID: <1ba2fa240809090353o1ab1340ck82a9208dd364587a@mail.gmail.com> (sfid-20080909_125323_521327_B106C93C)
Date: Tue, 9 Sep 2008 13:53:17 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: HT action frame code
Cc: "Jouni Malinen" <j@w1.fi>,
	"Ron Rindjunsky" <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1220956032.31304.135.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220883730.31304.60.camel@johannes.berg>
	 <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com>
	 <1220950358.31304.112.camel@johannes.berg>
	 <1ba2fa240809090241g2604e3ddhfd39359fd8eb0f8b@mail.gmail.com>
	 <1220953379.31304.124.camel@johannes.berg>
	 <1ba2fa240809090252u44c5a016m98845379ac213df9@mail.gmail.com>
	 <1220954146.31304.127.camel@johannes.berg>
	 <1ba2fa240809090321w4d2f3780g32e9507fac45f95e@mail.gmail.com>
	 <1220955934.31304.133.camel@johannes.berg>
	 <1220956032.31304.135.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 1:27 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2008-09-09 at 12:25 +0200, Johannes Berg wrote:
>> On Tue, 2008-09-09 at 13:21 +0300, Tomas Winkler wrote:
>>
>> > > Right. And if mac80211 is the AP, then I don't see how the STA can start
>> > > aggregation since I couldn't find where the relevant action frames are
>> > > handled. But you said it's not part of the code now, so I couldn't find
>> > > it anyway.
>> >
>> > That's probably the current situation.
>>
>> So back to square one, where should it be handled? Does it really make
>> sense to let hostapd have influence over the decision, or should we just
>> move the code that we have a bit and handle it in the kernel? After all,
>> we do have all the code necessary to handle it, but it's currently
>> restricted to STA mode, and I don't see a fundamental reason for that.

In basic AP mode everything can be handled by hostapd. There are no
performance sensitive management task, therefore the original mac80211
flow  didn't rout management frames withing mac80211 mlme.  But I see
benefit of keeping for example BA handshake, BAR, and MS/MIMO PS (not
implemented yet)  inside mac. BA session requires knowledge of
sequence counters, BAR handles reordering buffer. MS-PS requires
knowledge of number or rx chains. It will expose too much guts to the
users space.

> In fact, what if we're in STA mode with userspace MLME? Do we want to
> handle all that in userspace then? This doesn't seem sensible to me.

Also in this case I would leave this particular features + 11h
(channel switch, TPC) inside mac80211.
Tomas
