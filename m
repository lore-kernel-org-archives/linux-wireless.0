Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49600 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934249AbcATJaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 04:30:15 -0500
Message-ID: <1453282207.13263.5.camel@sipsolutions.net> (sfid-20160120_103030_091173_B4F5A9C1)
Subject: Re: [RFC V2 2/3] nl80211: add bss selection attribute to CONNECT
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 20 Jan 2016 10:30:07 +0100
In-Reply-To: <569EB9A6.4030808@broadcom.com>
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
	 <1452678583-20086-3-git-send-email-arend@broadcom.com>
	 <1452769832.2444.14.camel@sipsolutions.net> <569CB190.1000901@broadcom.com>
	 <1453209647.3896.22.camel@sipsolutions.net> <569EB9A6.4030808@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-19 at 23:33 +0100, Arend van Spriel wrote:

> I looked at our firmware and it has a kinda pipeline, but it uses a
> weighted score. So for "band_pref, rssi" the band_pref score would
> have more weight than the rssi score and bss-es are sorted based on
> the score. So not really throwing things away.

Yeah, ok - similar result. It makes sense to keep the next ones too, in
case all the ones on the band you preferred weren't usable or something
(due to later conditions, like garbled beacons or whatever.)

> > But then I understand the whole point of the "primitive" even less,
> > since it should be trivial to check that of multiple attributes
> > only a single one is specified?
> 
> Not really a single one as rssi_adjust needs two attributes, ie. band
> and rssi_delta. Still you are right and we can probably drop the
> primitive.

Fair enough, not really a single attribute, but a single "behaviour"
attribute; the other (band) attribute would just provide data for the
behavioural one.

I think then I really would prefer one of these options:
 * pack two u32 value into a tiny struct in the single "rssi_adjust"
   behavioural attribute, so that it really becomes a single one
 * make the rssi_adjust behavioural attribute nested with band and 
   adjustment inside
 * use a rssi_adjust_band attribute, rather than reusing the band_pref 
   one

I think the first option is perfectly reasonable (and we do this in
other places) and makes for the easiest semantics since we can then
just say "specify exactly one of these attributes"?

johannes
