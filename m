Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:23358 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYIIJwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 05:52:04 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1088387yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2008 02:52:03 -0700 (PDT)
Message-ID: <1ba2fa240809090252u44c5a016m98845379ac213df9@mail.gmail.com> (sfid-20080909_115210_240964_2D6DA7B3)
Date: Tue, 9 Sep 2008 12:52:02 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: HT action frame code
Cc: "Jouni Malinen" <j@w1.fi>,
	"Ron Rindjunsky" <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1220953379.31304.124.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220883730.31304.60.camel@johannes.berg> <48C5868B.8060103@w1.fi>
	 <1220942004.31304.101.camel@johannes.berg>
	 <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com>
	 <1220948427.31304.107.camel@johannes.berg>
	 <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com>
	 <1220950358.31304.112.camel@johannes.berg>
	 <1ba2fa240809090241g2604e3ddhfd39359fd8eb0f8b@mail.gmail.com>
	 <1220953379.31304.124.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 12:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-09-09 at 12:41 +0300, Tomas Winkler wrote:
>
>> >> Meaning that other management frames are forward to user space while
>> >> BA action frames
>> >> are treated inside mac80211.
>> >
>> > Can you point out where? I don't see it.
>> It's should be visible in AP code Yi has posted, unfortunately don't
>> have it open right now. Anyhow since then the rx flow has changed a
>> lot as you know :) so it has to be reinvented.
>
> Ok, so it's not in the current code and I'm not entirely stupid for not
> finding it, heh :) I don't think I even still have the patches on this
> box so I won't look.
>
>> >> > Also, I'm not talking about the AP triggering the aggregation session,
>> >> > this is entirely done with the rate scaling right now, but about an
>> >> > associated STA wanting to start an aggregation session. Aren't
>> >> > aggregation sessions always triggered by whoever wants to send? So if a
>> >> > STA notices it has lots of upload going on it could want to trigger a BA
>> >> > session, which is something we don't currently support afaict.
>> >>
>> >> In iwl-agn-rs.c There is not difference if the peer is STA or AP. So
>> >> we support this already.
>> >
>> > Not sure what this has to do with the Intel RS algorithm?
>>
>> Just the trigger for aggregation is implemented there. Otherwise
>> nothing special.
>
> Well yes, but that just triggers when aggregation on our end, what I'd
> been thinking about was when the remote side wants to start aggregation.

There is some misunderstanding. I hope I'm explaining the problematic
part.  Aggregation is always initialized by TX side it's one direction
only. So if there AP and STA wants to start aggregation. Both will
open a stream. The streams are independent.
Tomas


> johannes
>
