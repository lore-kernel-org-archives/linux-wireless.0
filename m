Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53040 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0KRBr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 20:47:28 -0500
Received: by bwz15 with SMTP id 15so2279472bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 17:47:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201011171741.15796.helmut.schaa@googlemail.com>
References: <201011131908.15595.IvDoorn@gmail.com>
	<20101117150721.GD2639@tuxdriver.com>
	<AANLkTimCzzgMavoLNhWTE-bZNTMimg++VKKft5f8sDQG@mail.gmail.com>
	<201011171741.15796.helmut.schaa@googlemail.com>
Date: Wed, 17 Nov 2010 20:47:26 -0500
Message-ID: <AANLkTi=S7T6vRabhzNKu1Gnqw2Mh03nabatXZJ4n22Kh@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad
 to make skb->data two-byte alignment
From: David Ellingsworth <david@identd.dyndns.org>
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 11:41 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Mittwoch 17 November 2010 schrieb Gertjan van Wingerde:
>> On Wed, Nov 17, 2010 at 4:07 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > On Wed, Nov 17, 2010 at 11:48:04AM +0100, Helmut Schaa wrote:
>> >
>> >> John, should I send a follow-up (with a nice description why it this is needed)
>> >> or are you simply reverting this one?
>> >
>> > Is there no chance for a fix in short order?
>
> I don't have a clever idea on how to fix that without reverting this commit.
> IMO this patch is just not correct as it passes the skb back to mac80211 with
> reduced headroom (due to the header & payload alignment) which causes trouble
> when mac80211 requeues the frame. Of course just requesting 4 additional bytes
> headroom would "fix" the symptoms but sounds like a hack to me.
>
>> I may have an idea on how we can fix this, without incurring the
>> performance penalty.
>
> I'm still not convinced that this is really the root cause for the
> performance issues Jay noticed. AFAIK mac80211 doesn't access the payload
> anymore when reporting the frame back (with some exceptions like monitor
> interfaces).
>
> Jay, could you please run a few more performance tests with and without this
> patch to track down if this issue is really the cause for the performance
> degradation?
>
>> Basic idea is to no longer work on the original skb that mac80211
>> supplied us, but to
>> use a copy of that skb. This would prevent us from having to undo any
>> changes we did,
>> as we can simply return the original skb to mac80211 (which wasn't
>> modified in the first
>> place).
>> I'm not sure how this would impact performance, but it would allow us
>> a lot less copying
>> around to undo the changes done before uploading to the HW.
>
> But cloning the skb would double the amount of memory needed to transmit each
> frame. Not sure though if that behaves better or not. Might be worth a try.

I saw this and the thought of using a circular buffer came to mind.
Any possibility of using one to copy and modify the skbs after
receiving them from mac80211 until passed to the hardware? It seems to
me that this would at least reduce the amount of memory consumed by
the driver needed to duplicate every skb. I honestly don't know much
about network drivers, so I might be completely off the mark here.
What do you think?

Regards,

David Ellingsworth
