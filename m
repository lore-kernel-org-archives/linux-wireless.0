Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35852 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZIVBqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 21:46:08 -0400
Received: by fxm18 with SMTP id 18so482604fxm.17
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2009 18:46:10 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Andre K <andrekdeen@gmail.com>
Subject: Re: p54spi: dbm_antsignal value, is it RSSI or dbm?
Date: Tue, 22 Sep 2009 03:46:05 +0200
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
References: <76516bfc0909211119i4362ca35k13fc1f87857fb393@mail.gmail.com> <69e28c910909211325o271c471eydb9f37e20b9bd4c3@mail.gmail.com> <76516bfc0909211704iddf2ebcm9a8e12548c50fecd@mail.gmail.com>
In-Reply-To: <76516bfc0909211704iddf2ebcm9a8e12548c50fecd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909220346.05792.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 22 September 2009 02:04:32 Andre K wrote:
> I actually wouldn't mind investing some time to help sort this out,
> but I have no idea where to start.

stlc45xx gives you two clues:

a rough formula:
status.signal = data->rcpi / 2 - 110;
=> a rough formula

/* let's assume that maximum rcpi value is 140 (= -35 dBm) */
=> a _valid_ point (140 rssi => -35 dBm)

more bits can be retrieved from the original cx3110x driver and
maybe by comparing the signal/noise figures with other devices
in the same location.

> For now I think I'll have to revert to stlc45xx v1.3 and the calibration tool.

better start cracking! stlc45xx's end is near...

"stlc45xx Another wireless driver that no one seems to care about.
So sad. I guess no one will miss it when it goes away in .33."

http://www.kroah.com/log/linux/staging-status-09-2009.html

> On 9/21/09, Gábor Stefanik <netrolller.3d@gmail.com> wrote:
> > On Mon, Sep 21, 2009 at 9:04 PM, Christian Lamparter
> >>
> >> stlc45xx has a completely different phy/rf (longbow - rxhw = 5) and
> >> the specs are not a part of the freely available fw iface documentation.
> >>
> >> here's the relevant quote from a Nokia official: "
> >>> If this is so, what's so secret about the values that it needs a
> >>> binary-only tool and hidden storage area? Is there legal issues with
> >>> it (related to the radio device regulations)?
> >>
> >> Yes, this is because regulatory requirements. So thank FCC and ETSI
> >> for all this. This causes much grief for all wireless vendors, for
> >> example Intel had to do major changes in iwl3945 firmware for their
> >> mac80211 driver. "
> >> (ref:
> >> http://www.mail-archive.com/stlc45xx-devel@garage.maemo.org/msg00021.html
> >> )
> >
> > I've actually read somewhere (AFAIK on this list, but I am not sure)
> > that this is actually a misinterpretation of the FCC requirements...
AFAIK, the FCC changed the regulation wording some time ago?
But, other countries regulatory institutions (like ETSI, IC, MKK) 
might have a word, or two as well...

Regards,
	Chr
