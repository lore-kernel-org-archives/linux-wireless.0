Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:56810 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbXGGJnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2007 05:43:51 -0400
Received: by nf-out-0910.google.com with SMTP id g13so31595nfb
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jul 2007 02:43:49 -0700 (PDT)
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Multiple interfaces in mac80211
Date: Sat, 7 Jul 2007 11:46:47 +0200
Cc: "Jon Smirl" <jonsmirl@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com> <200707062316.30009.IvDoorn@gmail.com> <1ba2fa240707061533u7db0eda4i2d76576690b33dec@mail.gmail.com>
In-Reply-To: <1ba2fa240707061533u7db0eda4i2d76576690b33dec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707071146.48148.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > > The channel field appears to be uninitialized for beacon frames. When
> > > I booted this time it is displaying channel 9 and I am on channel 10.
> > >
> > > Other frames show channel 10 as expected.
> >
> > Which is quite weird since the beacon frames use the same rx_status structure
> > as the regular frames. No distinction is made within rt2x00 between rx frames...
> >
> > Ivo
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> I'm not sure if this is relevant but:
> It is normal to hear beacons for adjacent channel on 2.4 spectrum as
> channel overlaps. One must read DS information element from the beacon
> to determine on which channel the beacon was really sent.

Well that wouldn't explain why the bug that Jon experiences occurs since that
would mean that beacons from from example coming from channel 9 are reported
to come from channel 10.

But if it should be read from the beacon itself, then it would be the work for mac80211
to do that. Since the drivers will have to do as little as possible with the frame contents.

Ivo

