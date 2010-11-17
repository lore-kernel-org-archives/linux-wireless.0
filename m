Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37919 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab0KQKtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 05:49:06 -0500
Received: by bwz15 with SMTP id 15so1442757bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 02:49:04 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "RA-Jay Hung" <Jay_Hung@ralinktech.com>
Subject: Re: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make skb->data two-byte alignment
Date: Wed, 17 Nov 2010 11:48:04 +0100
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
References: <201011131908.15595.IvDoorn@gmail.com> <201011170946.04629.helmut.schaa@googlemail.com> <B7288B2B5878D747BA031EF4B170D7F6BC5C60@TWHCMBS01.tw.ralinktech.ad>
In-Reply-To: <B7288B2B5878D747BA031EF4B170D7F6BC5C60@TWHCMBS01.tw.ralinktech.ad>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011171148.04286.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 17 November 2010 schrieb RA-Jay Hung:
> > > When inserting the l2pad we're moving the header and thus reduce headroom.
> > > This patch modifies the bahavior during l2pad removal to not move the header
> > > back into its old position but instead moves the payload. Thus the skb keeps
> > > the reduced headroom. If this skb gets requeued into rt2x00 (which can happen
> > > when the frame wasn't acked and the according STA is known to e in powersave
> > > mode) the header and payload get aligned again further reducing headroom which
> > > results in a too small headroom for the TXWI and thus a skb_under_panic.
> >
> > Hmm, John merged that patch already. However, I would prefer if it would get
> > reverted due to the occasional panics in AP mode.
> >
> > Jay, I didn't notice any performance degradation on MIPS, on which architecture
> > did you test?
> 
> My test environment as below
> Architecture is AMD Athlon 64 X2 Dual Core, and use rt3070 to test throughput.
> Before not patch code, the throughput just only 5, 6M, but after patch,
> throughput can achieve about 40M on open air. How about your test?

I tried with rt2800pci on MIPS32 in AP mode (STA <- eth -> AP <- wifi -> STA2).
An UDP iperf stream (STA -> STA2) was able to achieve up to 90Mbps while a TCP
stream maxed out at around 70Mbps (before and after this patch). STA2 is an
Intel HT20 11n client.

Hmm, you've been testing on USB. Maybe that makes a difference?

Nevertheless, such a performance drop on such a fast machine is likely caused
by something different, no? Did you have any warnings in dmesg (due to
watchdog timeouts for example)? Maybe the rate control algorithm made a wrong
decision and used a low tx rate?

> > Jay, Ivo, any objections against reverting this one?
>
> I agree to revert this one because this will cause tool small headroom of your mention.
> We need to supply another patch when resolve all issue. Thanks.

John, should I send a follow-up (with a nice description why it this is needed)
or are you simply reverting this one?

Thanks,
Helmut
