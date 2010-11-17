Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33830 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab0KQIrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 03:47:06 -0500
Received: by bwz15 with SMTP id 15so1329379bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 00:47:04 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make skb->data two-byte alignment
Date: Wed, 17 Nov 2010 09:46:04 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	"RA-Jay Hung" <jay_hung@ralinktech.com>
References: <201011131908.15595.IvDoorn@gmail.com> <201011131913.55169.IvDoorn@gmail.com> <201011161645.15018.helmut.schaa@googlemail.com>
In-Reply-To: <201011161645.15018.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011170946.04629.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 16 November 2010 schrieb Helmut Schaa:
> Am Samstag 13 November 2010 schrieb Ivo van Doorn:
> > From: RA-Jay Hung <Jay_Hung@ralinktech.com>
> > 
> > When send out skb data to mac80211, orignal code will cause mac80211
> > unaligned access, so modify code to make mac80211 can natural access.
> 
> And this introduces the same panic again :(
> 
> The problem is the following:
> 
> We don't pass the skb in the same state back to mac80211 as we got it.
> 
> When inserting the l2pad we're moving the header and thus reduce headroom.
> This patch modifies the bahavior during l2pad removal to not move the header
> back into its old position but instead moves the payload. Thus the skb keeps
> the reduced headroom. If this skb gets requeued into rt2x00 (which can happen
> when the frame wasn't acked and the according STA is known to e in powersave
> mode) the header and payload get aligned again further reducing headroom which
> results in a too small headroom for the TXWI and thus a skb_under_panic.

Hmm, John merged that patch already. However, I would prefer if it would get
reverted due to the occasional panics in AP mode.

Jay, I didn't notice any performance degradation on MIPS, on which architecture
did you test?

Jay, Ivo, any objections against reverting this one?

Thanks,
Helmut
