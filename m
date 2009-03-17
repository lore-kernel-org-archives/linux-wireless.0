Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55717 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbZCQXhM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 19:37:12 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 16:37:11 -0700
Date: Tue, 17 Mar 2009 15:36:32 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Bob Copeland <me@bobcopeland.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@Atheros.com>
Subject: Re: ids missing in ath5k ?
Message-ID: <20090317223632.GN6061@tesla> (sfid-20090318_003716_698448_E95122CB)
References: <49BC0DBE.90209@gmail.com> <49BC6C21.6020807@gmail.com> <49BC7117.1010107@gmail.com> <b6c5339f0903171418h6534a5a8w1ef8354f9571657a@mail.gmail.com> <20090317213639.GF6061@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090317213639.GF6061@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 17, 2009 at 02:36:39PM -0700, Luis Rodriguez wrote:
> On Tue, Mar 17, 2009 at 02:18:45PM -0700, Bob Copeland wrote:
> > On Sat, Mar 14, 2009 at 11:08 PM, Xose Vazquez Perez
> > <xose.vazquez@gmail.com> wrote:
> >
> > > [missing ids: 0x168c: { 0xff1a, 0x0020, 0x101a, 0x9013 } ]
> >
> > Luis, do you know anything about these devices?  Are all of these
> > 802.11abg or are any .11h (I didn't see ath9k claiming any of
> > them either).
> >
> > Should be easy to add support, but would be nice to know if the
> > hardware exists and will work.
> 
> ACK on FF1A -- 802.11abg, NACK on the others, we don't at least have
> them in our own windows driver INF file.

Actually so any 0xFF1x device ID where x is any value would
be the ID if the card has issues reading our EEPROM and in that
case you can expect the card to simply not be operational, so feel
free to add it but be sure to inform the user the card is having
issues reading the EEPROM and simply disable the device.

  Luis
