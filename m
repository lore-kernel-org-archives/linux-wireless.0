Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:12342 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbYGIOtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 10:49:08 -0400
Received: by nf-out-0910.google.com with SMTP id d3so916520nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 07:49:05 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 16:57:54 +0200
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807091511.14288.IvDoorn@gmail.com> <200807091604.50199.IvDoorn@gmail.com> <1215611931.3246.8.camel@johannes.berg>
In-Reply-To: <1215611931.3246.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807091657.54657.IvDoorn@gmail.com> (sfid-20080709_164915_782685_F86664CA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008, Johannes Berg wrote:
> On Wed, 2008-07-09 at 16:04 +0200, Ivo van Doorn wrote:
> > On Wednesday 09 July 2008, Michael Buesch wrote:
> > > On Wednesday 09 July 2008 15:11:45 Ivo van Doorn wrote:
> > > > Currently only beacons generated in AP mode have the software
> > > > sequence number inserted. This means IBSS and Mesh mode are broken
> > > > for all hardware that require software sequence numbers.
> > > 
> > > Does software seq numbering even work at all?
> > > What about packets that get sent between the driver requested the
> > > beacon and the driver does actually queue it?
> > 
> > For rt2x00 the beacon is requested and queued within interrupt context
> > or during resume when it doesn't allow mac80211 to send any frames yet.
> 
> Ok, in interrupt context definitely works.
> 
> > The problem would be when the config_interface() is called, if during that
> > call mac80211 also sends out TX frames, then you get problems in the
> > sequence counting.
> 
> Well, if you care about the beacon in config_interface() you're
> implementing hwseq since otherwise you'd only request it when you need
> it, no?

No not really, because from what moment can the driver start requesting beacons?
I would think when mac80211 calls config_interface with the IEEE80211_IFCC_BEACON
flag. ;)

At that moment the first beacon is loaded, and the device will trigger the interrupt
to request a new beacon every x milliseconds.

Ivo
