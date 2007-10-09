Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:33155 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbXJISCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 14:02:07 -0400
Received: by ug-out-1314.google.com with SMTP id z38so147078ugc
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2007 11:02:06 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Rt2400-devel] Mode selection in mac80211
Date: Tue, 9 Oct 2007 20:18:27 +0200
Cc: rt2400-devel@lists.sourceforge.net,
	Adam Baker <linux@baker-net.org.uk>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <200710052319.10600.linux@baker-net.org.uk> <200710091954.03727.IvDoorn@gmail.com> <1191951652.4013.48.camel@johannes.berg>
In-Reply-To: <1191951652.4013.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710092018.28113.IvDoorn@gmail.com> (sfid-20071009_190215_916089_4743C31B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 09 October 2007, Johannes Berg wrote:
> On Tue, 2007-10-09 at 19:54 +0200, Ivo van Doorn wrote:
> 
> > > Well, it's not too strange that it has two places since there's the SIFS
> > > too which is needed for ACK/CTS timing, these packets aren't sent from
> > > the host so you can't have those timings in a per-packet descriptor.
> > 
> > You mean things like ACK_TIMEOUT, those are all seperate registers in the Ralink hardware.
> 
> No, I'm not talking about the ack timeout, I'm thinking of the short
> interframe space (SIFS) which you wait after receiving a packet before
> sending the ACK.

ok. That means that my previous point regarding the differences between
the legacy drivers remains valid. ;)

> > ButI think I should be more clearer on this, rt2500pci and rt2500usb are
> > basically the same chipset but only the bus type is different.
> > What is notable is that _only_ rt2500usb has this IFS register, none of the
> > other Ralink chipsets (including rt2500pci) have it.
> 
> That is indeed strange.

:)

> > True, but in G mode you are compatible with B. The legacy driver doesn't
> > switch back to B mode when the AP is in B mode. This means that it will
> > be using the G timing values.
> 
> That sounds wrong.

Not really, this would be the same behavior that you suggested earlier,
when you stated that a driver should perhaps not register 802.11B mode
when also registering 802.11G mode since it is backward compatible.

Ivo
