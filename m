Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:17995 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYIIJlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 05:41:14 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1086314yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2008 02:41:13 -0700 (PDT)
Message-ID: <1ba2fa240809090241g2604e3ddhfd39359fd8eb0f8b@mail.gmail.com> (sfid-20080909_114119_470019_5165195A)
Date: Tue, 9 Sep 2008 12:41:12 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: HT action frame code
Cc: "Jouni Malinen" <j@w1.fi>,
	"Ron Rindjunsky" <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1220950358.31304.112.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220883730.31304.60.camel@johannes.berg> <48C5868B.8060103@w1.fi>
	 <1220942004.31304.101.camel@johannes.berg>
	 <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com>
	 <1220948427.31304.107.camel@johannes.berg>
	 <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com>
	 <1220950358.31304.112.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 11:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-09-09 at 11:46 +0300, Tomas Winkler wrote:
>
>> Meaning that other management frames are forward to user space while
>> BA action frames
>> are treated inside mac80211.
>
> Can you point out where? I don't see it.
It's should be visible in AP code Yi has posted, unfortunately don't
have it open right now. Anyhow since then the rx flow has changed a
lot as you know :) so it has to be reinvented.

>
>
>> > Also, I'm not talking about the AP triggering the aggregation session,
>> > this is entirely done with the rate scaling right now, but about an
>> > associated STA wanting to start an aggregation session. Aren't
>> > aggregation sessions always triggered by whoever wants to send? So if a
>> > STA notices it has lots of upload going on it could want to trigger a BA
>> > session, which is something we don't currently support afaict.
>>
>> In iwl-agn-rs.c There is not difference if the peer is STA or AP. So
>> we support this already.
>
> Not sure what this has to do with the Intel RS algorithm?

Just the trigger for aggregation is implemented there. Otherwise
nothing special.

Tomas
