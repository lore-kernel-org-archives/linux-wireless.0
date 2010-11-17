Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61417 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934945Ab0KQQmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 11:42:18 -0500
Received: by fxm6 with SMTP id 6so714690fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 08:42:17 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make skb->data two-byte alignment
Date: Wed, 17 Nov 2010 17:41:15 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"RA-Jay Hung" <Jay_Hung@ralinktech.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
References: <201011131908.15595.IvDoorn@gmail.com> <20101117150721.GD2639@tuxdriver.com> <AANLkTimCzzgMavoLNhWTE-bZNTMimg++VKKft5f8sDQG@mail.gmail.com>
In-Reply-To: <AANLkTimCzzgMavoLNhWTE-bZNTMimg++VKKft5f8sDQG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011171741.15796.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 17 November 2010 schrieb Gertjan van Wingerde:
> On Wed, Nov 17, 2010 at 4:07 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Wed, Nov 17, 2010 at 11:48:04AM +0100, Helmut Schaa wrote:
> >
> >> John, should I send a follow-up (with a nice description why it this is needed)
> >> or are you simply reverting this one?
> >
> > Is there no chance for a fix in short order?

I don't have a clever idea on how to fix that without reverting this commit.
IMO this patch is just not correct as it passes the skb back to mac80211 with
reduced headroom (due to the header & payload alignment) which causes trouble
when mac80211 requeues the frame. Of course just requesting 4 additional bytes
headroom would "fix" the symptoms but sounds like a hack to me.

> I may have an idea on how we can fix this, without incurring the
> performance penalty.

I'm still not convinced that this is really the root cause for the
performance issues Jay noticed. AFAIK mac80211 doesn't access the payload
anymore when reporting the frame back (with some exceptions like monitor
interfaces).

Jay, could you please run a few more performance tests with and without this
patch to track down if this issue is really the cause for the performance
degradation?

> Basic idea is to no longer work on the original skb that mac80211
> supplied us, but to
> use a copy of that skb. This would prevent us from having to undo any
> changes we did,
> as we can simply return the original skb to mac80211 (which wasn't
> modified in the first
> place).
> I'm not sure how this would impact performance, but it would allow us
> a lot less copying
> around to undo the changes done before uploading to the HW.

But cloning the skb would double the amount of memory needed to transmit each
frame. Not sure though if that behaves better or not. Might be worth a try.

> However, I won't be able to look into that opportunity before the weekend.
> 
> Helmut, can you wait that long and hold off reverting until then?

Sure.

Thanks,
Helmut
