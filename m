Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.ralinktech.com.tw ([211.75.121.152]:35892 "HELO
	smtp.ralinktech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932741Ab0KQKRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 05:17:11 -0500
From: RA-Jay Hung <Jay_Hung@ralinktech.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: RE: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make
 skb->data two-byte alignment
Date: Wed, 17 Nov 2010 10:16:33 +0000
Message-ID: <B7288B2B5878D747BA031EF4B170D7F6BC5C60@TWHCMBS01.tw.ralinktech.ad>
References: <201011131908.15595.IvDoorn@gmail.com>
 <201011131913.55169.IvDoorn@gmail.com>
 <201011161645.15018.helmut.schaa@googlemail.com>
 <201011170946.04629.helmut.schaa@googlemail.com>
In-Reply-To: <201011170946.04629.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > When inserting the l2pad we're moving the header and thus reduce headroom.
> > This patch modifies the bahavior during l2pad removal to not move the header
> > back into its old position but instead moves the payload. Thus the skb keeps
> > the reduced headroom. If this skb gets requeued into rt2x00 (which can happen
> > when the frame wasn't acked and the according STA is known to e in powersave
> > mode) the header and payload get aligned again further reducing headroom which
> > results in a too small headroom for the TXWI and thus a skb_under_panic.
>
> Hmm, John merged that patch already. However, I would prefer if it would get
> reverted due to the occasional panics in AP mode.
>
> Jay, I didn't notice any performance degradation on MIPS, on which architecture
> did you test?

My test environment as below
Architecture is AMD Athlon 64 X2 Dual Core, and use rt3070 to test throughput.
Before not patch code, the throughput just only 5, 6M, but after patch,
throughput can achieve about 40M on open air. How about your test?

>
> Jay, Ivo, any objections against reverting this one?
I agree to revert this one because this will cause tool small headroom of your mention.
We need to supply another patch when resolve all issue. Thanks.

Jay
CONFIDENTIALITY STATEMENT : The information, attachments and any rights attaching in this e-mail are confidential and privileged; it is intended only for the individual or entity named as the recipient hereof.Any disclosure, copying, distribution, dissemination or use of the contents of this e-mail by persons other than the intended recipient is STRICTLY PROHIBITED and may violate applicable laws.If you have received this e-mail in error, please delete the original message and notify us by return email or collect call immediately. Thank you.
