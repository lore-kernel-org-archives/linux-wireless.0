Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57827 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0KVKXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 05:23:12 -0500
Received: by bwz15 with SMTP id 15so5942506bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 02:23:11 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make skb->data two-byte alignment
Date: Mon, 22 Nov 2010 11:22:08 +0100
Cc: "RA-Jay Hung" <Jay_Hung@ralinktech.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
References: <201011131908.15595.IvDoorn@gmail.com> <B7288B2B5878D747BA031EF4B170D7F6BC824E@TWHCMBS01.tw.ralinktech.ad> <AANLkTimYWLMgQ_RNZJ5B6a-vA68ez1Wcc702MrdS0QzW@mail.gmail.com>
In-Reply-To: <AANLkTimYWLMgQ_RNZJ5B6a-vA68ez1Wcc702MrdS0QzW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011221122.08277.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Montag 22 November 2010 schrieb Gertjan van Wingerde:
> On Mon, Nov 22, 2010 at 9:14 AM, RA-Jay Hung <Jay_Hung@ralinktech.com> wrote:
> >> > Jay, could you please run a few more performance tests with and without this
> >> > patch to track down if this issue is really the cause for the performance
> >> > degradation?
> >
> > I check sniffer and mac80211 code, I think bad TX throughput should be my
> > environment has a lot APs and more packets will collides because of without
> > protection in TX direction. So the patch is not related to this issue.
> > Helmut, We can revert this patch. Sorry for inconvenience.

Great, thanks for double-checking Jay.

> >> OK. Find attached the patch I cooked up. AFAICS the driver still works correctly,
> >> but unfortunately I am unable to test performance and throughput of the driver
> >> with this patch.
> >>
> >> Jay and Helmut, can you test this patch before I submit it?
> >>
> > I think original code should recover the original skb state, so I think we do not need to copy again to send back to mac80211, and one more thing. Could you submit below
> > patch you send us before to rt2x00.git. I think it is more correct in payload = 0 case.
> >
> >  void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length)
> >  {
> > -       unsigned int l2pad = L2PAD_SIZE(header_length);
> > +       unsigned int payload_length = skb->len - header_length;
> > +       unsigned int l2pad = payload_length ? L2PAD_SIZE(header_length) : 0;
> >
> >        if (!l2pad)
> >                return;
> >
> 
> OK. Indeed if you feel we can simply revert the patch then that will
> be better. I'll send a patch tonight that reverts it together with the
> update update.

Sounds good to me,
Helmut
