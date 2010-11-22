Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.ralinktech.com.tw ([211.75.121.152]:45691 "HELO
	smtp.ralinktech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750778Ab0KVIOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 03:14:45 -0500
From: RA-Jay Hung <Jay_Hung@ralinktech.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: RE: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make
 skb->data two-byte alignment
Date: Mon, 22 Nov 2010 08:14:03 +0000
Message-ID: <B7288B2B5878D747BA031EF4B170D7F6BC824E@TWHCMBS01.tw.ralinktech.ad>
References: <201011131908.15595.IvDoorn@gmail.com>
 <20101117150721.GD2639@tuxdriver.com>
 <AANLkTimCzzgMavoLNhWTE-bZNTMimg++VKKft5f8sDQG@mail.gmail.com>
 <201011171741.15796.helmut.schaa@googlemail.com> <4CEA1527.5030502@gmail.com>
In-Reply-To: <4CEA1527.5030502@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
> > Jay, could you please run a few more performance tests with and without this
> > patch to track down if this issue is really the cause for the performance
> > degradation?

I check sniffer and mac80211 code, I think bad TX throughput should be my environment has a lot APs and more packets will collides because of without protection in TX direction. So the patch is not related to this issue. Helmut,
We can revert this patch. Sorry for inconvenience.

> >> Basic idea is to no longer work on the original skb that mac80211
> >> supplied us, but to
> >> use a copy of that skb. This would prevent us from having to undo any
> >> changes we did,
> >> as we can simply return the original skb to mac80211 (which wasn't
> >> modified in the first
> >> place).
> >> I'm not sure how this would impact performance, but it would allow us
> >> a lot less copying
> >> around to undo the changes done before uploading to the HW.
> >
> > But cloning the skb would double the amount of memory needed to transmit each
> > frame. Not sure though if that behaves better or not. Might be worth a try.
> >
> >> However, I won't be able to look into that opportunity before the weekend.
> >>
> >> Helmut, can you wait that long and hold off reverting until then?
> >
>
> OK. Find attached the patch I cooked up. AFAICS the driver still works correctly,
> but unfortunately I am unable to test performance and throughput of the driver
> with this patch.
>
> Jay and Helmut, can you test this patch before I submit it?
>
I think original code should recover the original skb state, so I think we do not need to copy again to send back to mac80211, and one more thing. Could you submit below
patch you send us before to rt2x00.git. I think it is more correct in payload = 0 case.

 void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length)
 {
-       unsigned int l2pad = L2PAD_SIZE(header_length);
+       unsigned int payload_length = skb->len - header_length;
+       unsigned int l2pad = payload_length ? L2PAD_SIZE(header_length) : 0;

        if (!l2pad)
                return;

Jay
CONFIDENTIALITY STATEMENT : The information, attachments and any rights attaching in this e-mail are confidential and privileged; it is intended only for the individual or entity named as the recipient hereof.Any disclosure, copying, distribution, dissemination or use of the contents of this e-mail by persons other than the intended recipient is STRICTLY PROHIBITED and may violate applicable laws.If you have received this e-mail in error, please delete the original message and notify us by return email or collect call immediately. Thank you.
