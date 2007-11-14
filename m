Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4558 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbXKNVOZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 16:14:25 -0500
Date: Wed, 14 Nov 2007 16:13:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Will Dyson <will.dyson@gmail.com>
Cc: Florian Lohoff <flo@rfc822.org>, Marcus Better <marcus@better.se>,
	linux-wireless@vger.kernel.org
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
Message-ID: <20071114211354.GD6226@tuxdriver.com> (sfid-20071114_211431_722624_BACF86F2)
References: <20071111102315.GC10486@paradigm.rfc822.org> <8e6f94720711121459j56f640abid03cb2a1eca319c2@mail.gmail.com> <20071113192330.GA19601@paradigm.rfc822.org> <fhedc4$5l9$1@ger.gmane.org> <20071114153347.GA3512@paradigm.rfc822.org> <8e6f94720711141057w463d55c4r2be74d0aa8d78918@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8e6f94720711141057w463d55c4r2be74d0aa8d78918@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 14, 2007 at 01:57:52PM -0500, Will Dyson wrote:
> On Nov 14, 2007 10:33 AM, Florian Lohoff <flo@rfc822.org> wrote:
> 
> > Did you actually try setting the rate manually? I just tried
> > when i came home from work. I set it to 36MBit/s and it actually
> > works ... I am now transferring with 2.5MByte/s instead of 30Kbyte/s
> >
> > So i guess the auto rate selection is broken ... Or 1 MBit/s is default
> > or something ...
> 
> Ah, that is probably this isssue:
> 
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=d37cabfb5f60a3bb56585a74fd3f140ba2960fe0
> 
> The patch is in the wireless-2.6/everything tree, but not Linus's tree.

Most of the patch seems like a no-op, except this bit:

 	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
 		__set_bit(ENTRY_TXD_BURST, &desc.flags);
-		if (is_rts_frame(frame_control))
+		if (is_rts_frame(frame_control)) {
 			__set_bit(ENTRY_TXD_RTS_FRAME, &desc.flags);
+			__set_bit(ENTRY_TXD_ACK, &desc.flags);
+		} else
+			__clear_bit(ENTRY_TXD_ACK, &desc.flags);
 		if (control->rts_cts_rate)
 			tx_rate = control->rts_cts_rate;
 	}

Is this correct?  I'm not sure about the actual meaning of TXD_W0_ACK
(which keys off ENTRY_TXD_ACK)...

John
-- 
John W. Linville
linville@tuxdriver.com
