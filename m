Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61104 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab0KVKFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 05:05:15 -0500
Received: by wyb28 with SMTP id 28so6813400wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 02:05:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <B7288B2B5878D747BA031EF4B170D7F6BC824E@TWHCMBS01.tw.ralinktech.ad>
References: <201011131908.15595.IvDoorn@gmail.com>
	<20101117150721.GD2639@tuxdriver.com>
	<AANLkTimCzzgMavoLNhWTE-bZNTMimg++VKKft5f8sDQG@mail.gmail.com>
	<201011171741.15796.helmut.schaa@googlemail.com>
	<4CEA1527.5030502@gmail.com>
	<B7288B2B5878D747BA031EF4B170D7F6BC824E@TWHCMBS01.tw.ralinktech.ad>
Date: Mon, 22 Nov 2010 11:05:14 +0100
Message-ID: <AANLkTimYWLMgQ_RNZJ5B6a-vA68ez1Wcc702MrdS0QzW@mail.gmail.com>
Subject: Re: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make
 skb->data two-byte alignment
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: RA-Jay Hung <Jay_Hung@ralinktech.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 22, 2010 at 9:14 AM, RA-Jay Hung <Jay_Hung@ralinktech.com> wrote:
> Hi,
>> > Jay, could you please run a few more performance tests with and without this
>> > patch to track down if this issue is really the cause for the performance
>> > degradation?
>
> I check sniffer and mac80211 code, I think bad TX throughput should be my environment has a lot APs and more packets will collides because of without protection in TX direction. So the patch is not related to this issue. Helmut,
> We can revert this patch. Sorry for inconvenience.
>
>> >> Basic idea is to no longer work on the original skb that mac80211
>> >> supplied us, but to
>> >> use a copy of that skb. This would prevent us from having to undo any
>> >> changes we did,
>> >> as we can simply return the original skb to mac80211 (which wasn't
>> >> modified in the first
>> >> place).
>> >> I'm not sure how this would impact performance, but it would allow us
>> >> a lot less copying
>> >> around to undo the changes done before uploading to the HW.
>> >
>> > But cloning the skb would double the amount of memory needed to transmit each
>> > frame. Not sure though if that behaves better or not. Might be worth a try.
>> >
>> >> However, I won't be able to look into that opportunity before the weekend.
>> >>
>> >> Helmut, can you wait that long and hold off reverting until then?
>> >
>>
>> OK. Find attached the patch I cooked up. AFAICS the driver still works correctly,
>> but unfortunately I am unable to test performance and throughput of the driver
>> with this patch.
>>
>> Jay and Helmut, can you test this patch before I submit it?
>>
> I think original code should recover the original skb state, so I think we do not need to copy again to send back to mac80211, and one more thing. Could you submit below
> patch you send us before to rt2x00.git. I think it is more correct in payload = 0 case.
>
>  void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length)
>  {
> -       unsigned int l2pad = L2PAD_SIZE(header_length);
> +       unsigned int payload_length = skb->len - header_length;
> +       unsigned int l2pad = payload_length ? L2PAD_SIZE(header_length) : 0;
>
>        if (!l2pad)
>                return;
>

OK. Indeed if you feel we can simply revert the patch then that will
be better. I'll send a patch tonight that reverts it together with the
update update.

---
Gertjan
